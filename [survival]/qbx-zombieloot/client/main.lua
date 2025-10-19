local lootEnabled = Config.LootEnabled
local lootedPeds = {}
local nearbyLootablePeds = {}
local PlayerData = {}

-- Função para verificar se o jogador está válido
local function IsPlayerValid()
    return PlayerData and PlayerData.citizenid
end

-- Função para verificar se está em um veículo
local function IsPlayerInVehicle()
    local playerPed = PlayerPedId()
    return IsPedInAnyVehicle(playerPed, false)
end

-- Função para obter ícone do item
local function GetItemIcon(itemName)
    return Config.UI.icons[itemName] or Config.UI.icons.default
end

-- Função para obter imagem do item (compatível com ox_inventory)
local function GetItemImage(itemName)
    if not Config.ShowItemImages then
        return nil
    end
    
    -- Tenta obter a imagem do ox_inventory
    local success, result = pcall(function()
        return exports.ox_inventory:Items(itemName)
    end)
    
    if success and result and result.image then
        -- Se for um caminho completo, usa diretamente
        if string.find(result.image, 'http') or string.find(result.image, 'nui://') then
            return result.image
        else
            -- Constrói o caminho completo
            return Config.ImagePath .. result.image
        end
    end
    
    -- Verifica se há imagem de fallback configurada
    if Config.FallbackImages and Config.FallbackImages[itemName] then
        local fallbackPath = Config.FallbackImages[itemName]
        if string.find(fallbackPath, 'http') or string.find(fallbackPath, 'nui://') then
            return fallbackPath
        else
            return Config.ImagePath .. fallbackPath
        end
    end
    
    -- Fallback genérico baseado no tipo de item
    local itemLower = string.lower(itemName)
    if string.find(itemLower, 'weapon') then
        return Config.ImagePath .. 'weapon_generic.png'
    elseif string.find(itemLower, 'ammo') then
        return Config.ImagePath .. 'ammo_generic.png'
    elseif string.find(itemLower, 'zombie') then
        return Config.ImagePath .. 'zombie_part.png'
    else
        return nil -- Sem imagem disponível
    end
end

-- Evento para atualizar dados do jogador (compatível com qbx_core)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = exports.qbx_core:GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- Alternativa para qbx_core específico
RegisterNetEvent('qbx_core:client:playerLoaded', function()
    PlayerData = exports.qbx_core:GetPlayerData()
end)

RegisterNetEvent('qbx_core:client:playerUnloaded', function()
    PlayerData = {}
end)

-- Inicialização otimizada
CreateThread(function()
    Wait(1000)
    PlayerData = exports.qbx_core:GetPlayerData()
end)

-- Comando para toggle do sistema
RegisterCommand(Config.Command, function()
    lootEnabled = not lootEnabled
    local msg = lootEnabled and Config.Lang.loot_toggled_on or Config.Lang.loot_toggled_off
    lib.notify({
        description = msg,
        type = lootEnabled and 'success' or 'error'
    })
end, false)

-- Função para verificar se um ped pode ser saqueado
local function IsPedLootable(ped)
    if not DoesEntityExist(ped) or not IsPedDeadOrDying(ped, true) then
        return false
    end
    
    local model = GetEntityModel(ped)
    return Config.AllPeds[model] ~= nil
end

-- Função para obter categoria do ped
local function GetPedCategory(ped)
    local model = GetEntityModel(ped)
    return Config.AllPeds[model]
end

-- Thread para detectar peds mortos próximos
CreateThread(function()
    while true do
        local sleep = 1000
        
        if lootEnabled then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            nearbyLootablePeds = {}
            
            local peds = GetGamePool('CPed')
            
            for _, ped in ipairs(peds) do
                if ped ~= playerPed and IsPedLootable(ped) then
                    local pedCoords = GetEntityCoords(ped)
                    local dist = #(playerCoords - pedCoords)
                    
                    if dist < Config.MarkerDistance then
                        local pedId = NetworkGetNetworkIdFromEntity(ped)
                        
                        if not lootedPeds[pedId] then
                            table.insert(nearbyLootablePeds, {
                                entity = ped,
                                coords = pedCoords,
                                distance = dist,
                                id = pedId
                            })
                            sleep = 100
                        end
                    end
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Thread para desenhar marcadores e detectar interação
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        if lootEnabled and #nearbyLootablePeds > 0 then
            sleep = 0
            
            for _, pedData in ipairs(nearbyLootablePeds) do
                local coords = pedData.coords
                local dist = pedData.distance
                
                -- Desenha marcador
                if Config.Marker.enabled and dist < Config.MarkerDistance then
                    DrawMarker(
                        Config.Marker.type,
                        coords.x, coords.y, coords.z + 1.2,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        Config.Marker.size.x, Config.Marker.size.y, Config.Marker.size.z,
                        Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a,
                        Config.Marker.bobUpAndDown,
                        false,
                        2,
                        Config.Marker.rotate,
                        nil,
                        nil,
                        false
                    )
                end
                
                -- Mostrar texto de interação
                if dist < Config.LootDistance then
                    -- Só mostra a opção de lootear se não estiver em veículo (se configurado para bloquear)
                    if not Config.BlockLootInVehicle or not IsPlayerInVehicle() then
                        lib.showTextUI(Config.Lang.press_to_loot)
                        
                        if IsControlJustPressed(0, Config.LootKey) then
                            lib.hideTextUI()
                            LootPed(pedData.entity, pedData.id)
                        end
                    end
                elseif dist < Config.LootDistance + 0.5 then
                    lib.hideTextUI()
                end
            end
        else
            lib.hideTextUI()
        end
        
        Wait(sleep)
    end
end)

-- Função CreateLootShop removida - usando apenas ox_lib

-- Função principal de loot
function LootPed(ped, pedId)
    if not IsPlayerValid() then
        lib.notify({description = 'Jogador não está pronto', type = 'error'})
        return
    end
    
    -- Verifica se está em veículo (verificação adicional silenciosa)
    if Config.BlockLootInVehicle and IsPlayerInVehicle() then
        return
    end
    
    if not DoesEntityExist(ped) then
        lib.notify({description = Config.Lang.nothing_found, type = 'error'})
        return
    end
    
    if lootedPeds[pedId] then
        lib.notify({description = Config.Lang.already_looted, type = 'error'})
        return
    end
    
    -- Animação de busca
    local success = lib.progressBar({
        duration = Config.SearchTime,
        label = Config.Lang.searching,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'amb@medic@standing@kneel@base',
            clip = 'base',
            flag = 1
        }
    })
    
    if not success then
        -- Usa notificação customizada se disponível
        if lib.lootNotify then
            lib.lootNotify({
                title = '🔍 Busca Cancelada',
                description = Config.Lang.cancelled,
                type = 'error',
                duration = 3000,
                icon = 'times-circle'
            })
        else
            lib.notify({
                title = '🔍 Busca Cancelada',
                description = Config.Lang.cancelled,
                type = 'error',
                duration = 3000
            })
        end
        return
    end
    
    -- Pega categoria e gera loot
    local category = GetPedCategory(ped)
    if not category then return end
    
    local lootData = lib.callback.await('qbx-zombieloot:server:generateLoot', false, category)
    
    if not lootData or #lootData == 0 then
        lib.notify({
            title = '🔍 Busca Concluída',
            description = Config.Lang.nothing_found,
            type = 'info',
            duration = 4000,
            icon = 'search'
        })
        lootedPeds[pedId] = true
        return
    end
    
    -- Marca todos os itens como disponíveis inicialmente
    for _, item in ipairs(lootData) do
        item.available = true
    end
    
    -- Marca como saqueado
    lootedPeds[pedId] = true
    
    -- Mostra menu de loot - escolhe entre ox_inventory shop ou ox_lib menu
    ShowLootMenu(lootData, pedId)
    
    -- Deleta ped se configurado
    if Config.DeletePedAfterLoot then
        SetTimeout(10000, function() -- 10 segundos para dar tempo de pegar tudo
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end)
    end
end

-- Menu de loot (apenas ox_lib)
function ShowLootMenu(lootData, pedId)
    -- Usa apenas sistema ox_lib para melhor performance e consistência
    CreateLootMenuOptions(lootData, pedId)
end

local isProcessingLoot = false

-- Cria as opções do menu (recursivo para reabrir)
function CreateLootMenuOptions(lootData, pedId)
    local options = {}
    local availableItems = {}
    
    -- Filtra itens ainda disponíveis
    for _, item in ipairs(lootData) do
        if item.available then
            table.insert(availableItems, item)
        end
    end
    
    -- Se não há mais itens, fecha o menu
    if #availableItems == 0 then
        lib.notify({
            title = '🎒 Loot Completo',
            description = 'Todos os itens foram coletados com sucesso!',
            type = 'success',
            duration = 3000,
            icon = 'check-circle'
        })
        isProcessingLoot = false
        return
    end
    
    -- Opção "Pegar Tudo"
    table.insert(options, {
        title = Config.Lang.take_all,
        description = string.format('Coletar todos os %d itens encontrados', #availableItems),
        icon = 'hand-holding',
        iconColor = 'green',
        onSelect = function()
            if isProcessingLoot then return end
            isProcessingLoot = true
            
            TriggerServerEvent('qbx-zombieloot:server:takeAll', availableItems)
            
            -- Marca todos como indisponíveis
            for _, item in ipairs(lootData) do
                item.available = false
            end
            
            -- Fecha o menu após pegar tudo
            Wait(500)
            isProcessingLoot = false
        end
    })
    
    -- Separador visual melhorado
    table.insert(options, {
        title = '━━━━━━━━━━━━━━━━━',
        description = 'Itens individuais',
        disabled = true,
        icon = 'grip-lines'
    })
    
    -- Items individuais otimizados
    for _, item in ipairs(availableItems) do
        local itemIcon = GetItemIcon(item.name)
        local itemImage = GetItemImage(item.name)
        
        local optionData = {
            title = string.format('%s %s', itemIcon, item.label),
            description = string.format('📦 Quantidade: %s', item.amount),
            onSelect = function()
                if isProcessingLoot then return end
                isProcessingLoot = true
                
                local success = lib.callback.await('qbx-zombieloot:server:takeItemWithCheck', false, item.name, item.amount)
                
                if success then
                    item.available = false
                    Wait(200)
                    CreateLootMenuOptions(lootData, pedId)
                end
                
                isProcessingLoot = false
            end
        }
        
        -- Adiciona imagem se disponível, senão remove ícone padrão se emoji estiver no título
        if itemImage then
            optionData.icon = itemImage
        elseif itemIcon ~= Config.UI.icons.default then
            optionData.icon = nil -- Remove ícone padrão quando emoji está no título
        else
            optionData.icon = 'box-open'
            optionData.iconColor = 'lightblue'
        end
        
        table.insert(options, optionData)
    end
    
    -- Cria um título mais completo que inclui a informação
    local menuTitle = string.format('%s\n💀 %d itens encontrados no corpo', Config.Lang.loot_menu_title, #availableItems)
    
    -- Registra o contexto do menu
    lib.registerContext({
        id = 'zombieloot_menu',
        title = menuTitle,
        options = options,
        onBack = function()
            isProcessingLoot = false
        end,
        onExit = function()
            isProcessingLoot = false
        end
    })
    
    lib.showContext('zombieloot_menu')
end

-- Função FontAwesome removida - usando apenas ox_lib com emojis

-- Funções sinor-menu removidas - usando apenas ox_lib para melhor performance

-- Limpa cache periodicamente
CreateThread(function()
    while true do
        Wait(Config.CooldownTime)
        
        -- Limpa peds que não existem mais
        for id, _ in pairs(lootedPeds) do
            local entity = NetworkGetEntityFromNetworkId(id)
            if not DoesEntityExist(entity) then
                lootedPeds[id] = nil
            end
        end
    end
end)