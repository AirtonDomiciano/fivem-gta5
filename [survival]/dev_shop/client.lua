-- client.lua do dev_shop convertido para ox_lib apenas

local shopPed = nil
local allItems = {}
local currentCategory = 'all'
local currentFilteredItems = {}
local currentPage = 1
local itemsPerPage = 20
local isLoading = false

-- Remove emojis duplicados das categorias
local function GetCategoryTitleWithEmoji(category)
    local cleaned = category
    
    -- Detecta e remove emojis duplicados específicos baseados na imagem
    cleaned = cleaned:gsub("^📦📦", "📦") -- Remove duplicação de caixas
    cleaned = cleaned:gsub("^🧟🧟", "🧟") -- Remove duplicação de zumbis
    cleaned = cleaned:gsub("^💎💎", "💎") -- Remove duplicação de diamantes
    cleaned = cleaned:gsub("^🏥💊", "🏥") -- Remove duplicação médico + pílula, fica só hospital
    cleaned = cleaned:gsub("^🔫🔫", "🔫") -- Remove duplicação de armas
    cleaned = cleaned:gsub("^🍔🌭", "🍔") -- Remove duplicação de comida, fica só hambúrguer
    
    return cleaned
end

-- Função para obter ícone da categoria (retorna nil para não mostrar ícone separado)
local function GetCategoryIcon(category)
    return nil -- Remove ícones, usa apenas emojis no título
end

-- Função para obter imagem do item
local function GetItemImage(itemName)
    -- Tenta usar imagem do ox_inventory primeiro
    local success, result = pcall(function()
        return exports.ox_inventory:Items(itemName)
    end)
    
    if success and result and result.image then
        if string.find(result.image, 'http') or string.find(result.image, 'nui://') then
            return result.image
        else
            return Config.IconPath .. result.image
        end
    end
    
    -- Fallback: tenta construir o caminho da imagem baseado no nome do item
    local fallbackPath = Config.ImagePath and (Config.ImagePath .. itemName .. '.png') or (Config.IconPath .. itemName .. '.png')
    return fallbackPath
end

-- Sistema de carregamento otimizado
function StartOptimizedLoading()
    if isLoading then return end
    isLoading = true
    
    lib.notify({
        description = 'Carregando itens...',
        type = 'info',
        duration = 1000
    })
    
    CreateThread(function()
        allItems = lib.callback.await('qbx-debugshop:server:getAllItems', false)
        
        if allItems and #allItems > 0 then
            lib.notify({
                description = string.format('✅ %s itens prontos!', #allItems),
                type = 'success',
                duration = 1500
            })
        else
            lib.notify({
                description = 'Erro ao carregar itens',
                type = 'error'
            })
        end
        
        isLoading = false
    end)
end

-- Cria o NPC
CreateThread(function()
    local model = GetHashKey(Config.PedModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    
    shopPed = CreatePed(0, model, Config.ShopLocation.coords.x, Config.ShopLocation.coords.y, Config.ShopLocation.coords.z - 1.0, Config.ShopLocation.coords.w, false, true)
    
    SetEntityAsMissionEntity(shopPed, true, true)
    SetPedFleeAttributes(shopPed, 0, false)
    SetBlockingOfNonTemporaryEvents(shopPed, true)
    SetEntityInvincible(shopPed, true)
    FreezeEntityPosition(shopPed, true)
    
    TaskStartScenarioInPlace(shopPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
    
    if Config.ShopLocation.blip.enabled then
        local blip = AddBlipForCoord(Config.ShopLocation.coords.x, Config.ShopLocation.coords.y, Config.ShopLocation.coords.z)
        SetBlipSprite(blip, Config.ShopLocation.blip.sprite)
        SetBlipColour(blip, Config.ShopLocation.blip.color)
        SetBlipScale(blip, Config.ShopLocation.blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.ShopLocation.blip.name)
        EndTextCommandSetBlipName(blip)
    end
    
    StartOptimizedLoading()
end)

-- Interação com NPC
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        if shopPed and DoesEntityExist(shopPed) then
            local pedCoords = GetEntityCoords(shopPed)
            local dist = #(playerCoords - pedCoords)
            
            if dist < Config.InteractDistance then
                sleep = 0
                lib.showTextUI('[E] Abrir Debug Shop')
                
                if IsControlJustPressed(0, 38) then
                    lib.hideTextUI()
                    OpenMainMenu()
                end
            elseif dist < Config.InteractDistance + 0.5 then
                lib.hideTextUI()
            end
        end
        
        Wait(sleep)
    end
end)

-- Comando
RegisterCommand(Config.Command, function()
    if isLoading then
        lib.notify({description = 'Aguardando carregamento...', type = 'info'})
        return
    end
    
    if not allItems or #allItems == 0 then
        isLoading = true
        CreateThread(function()
            allItems = lib.callback.await('qbx-debugshop:server:getAllItems', false)
            isLoading = false
            if allItems and #allItems > 0 then
                OpenMainMenu()
            end
        end)
    else
        OpenMainMenu()
    end
end, false)

-- Menu Principal
function OpenMainMenu()
    if isLoading then
        lib.notify({description = 'Aguardando carregamento...', type = 'info'})
        return
    end
    
    if not allItems or #allItems == 0 then
        lib.notify({description = 'Itens não carregados', type = 'error'})
        return
    end
    
    -- Organiza por categorias
    local categories = {}
    for _, item in ipairs(allItems) do
        local cat = item.category or 'Outros'
        if not categories[cat] then
            categories[cat] = 0
        end
        categories[cat] = categories[cat] + 1
    end
    
    local options = {
        {
            title = '🔍 Buscar Item',
            description = 'Procurar item por nome',
            iconColor = 'blue',
            onSelect = function()
                SearchItems()
            end
        },
        {
            title = '📋 Todos os Itens',
            description = string.format('Visualizar todos os %d itens', #allItems),
            iconColor = 'green',
            onSelect = function()
                ShowCategoryItems('all', allItems)
            end
        },
        {
            title = '🔄 Recarregar Itens',
            description = 'Atualizar lista de itens',
            iconColor = 'orange',
            onSelect = function()
                ReloadItems()
            end
        }
    }
    
    -- Adiciona categorias (sem ícones, apenas emojis no título)
    for category, count in pairs(categories) do
        local categoryTitle = GetCategoryTitleWithEmoji(category)
        table.insert(options, {
            title = categoryTitle,
            description = string.format('%s itens', count),
            iconColor = 'purple',
            onSelect = function()
                local filteredItems = {}
                for _, item in ipairs(allItems) do
                    if item.category == category then
                        table.insert(filteredItems, item)
                    end
                end
                ShowCategoryItems(category, filteredItems)
            end
        })
    end
    
    lib.registerContext({
        id = 'debugshop_main_menu',
        title = '🔧 Debug Shop',
        description = string.format('Total de %d itens disponíveis', #allItems),
        options = options
    })
    
    lib.showContext('debugshop_main_menu')
end

-- Mostra itens de uma categoria
function ShowCategoryItems(category, items)
    currentCategory = category
    currentFilteredItems = items
    currentPage = 1
    ShowItemsPage(items, 1)
end

-- Mostra página de itens
function ShowItemsPage(items, page)
    local totalPages = math.ceil(#items / itemsPerPage)
    local startIndex = (page - 1) * itemsPerPage + 1
    local endIndex = math.min(page * itemsPerPage, #items)
    
    local options = {}
    
    -- Adiciona itens da página
    for i = startIndex, endIndex do
        local item = items[i]
        local itemImage = GetItemImage(item.name)
        
        local optionData = {
            title = item.label,
            description = string.format('[%s] | Peso: %sg', item.name, item.weight or 0),
            onSelect = function()
                SelectItem(item)
            end
        }
        
        -- Usa imagem do item se disponível, removendo ícones padrão azuis
        if itemImage then
            optionData.icon = itemImage
            -- Remove iconColor para não aplicar cor padrão azul
            -- A imagem será exibida no tamanho padrão do ox_lib
        end
        -- Se não há imagem, não adiciona ícone para evitar ícone azul padrão
        
        table.insert(options, optionData)
    end
    
    -- Navegação de páginas
    if totalPages > 1 then
        if page > 1 then
            table.insert(options, {
                title = '⬅️ Página Anterior',
                description = string.format('Ir para página %s', page - 1),
                iconColor = 'orange',
                onSelect = function()
                    ShowItemsPage(items, page - 1)
                end
            })
        end
        
        if page < totalPages then
            table.insert(options, {
                title = 'Próxima Página ➡️',
                description = string.format('Ir para página %s', page + 1),
                iconColor = 'orange',
                onSelect = function()
                    ShowItemsPage(items, page + 1)
                end
            })
        end
    end
    
    lib.registerContext({
        id = 'debugshop_items_menu',
        title = string.format('📦 %s (%s total)', 
            currentCategory == 'all' and 'Todos os Itens' or currentCategory, 
            #items),
        description = string.format('Página %s de %s', page, totalPages),
        menu = 'debugshop_main_menu',
        onBack = function()
            OpenMainMenu()
        end,
        options = options
    })
    
    lib.showContext('debugshop_items_menu')
end

-- Seleciona item para dar quantidade
function SelectItem(item)
    local options = {}
    
    -- Quantidades rápidas
    for _, amount in ipairs(Config.QuickAmounts) do
        table.insert(options, {
            title = string.format('✅ Pegar %sx', amount),
            description = string.format('%s | Peso total: %.1fkg', item.label, ((item.weight or 0) * amount) / 1000),
            iconColor = 'green',
            onSelect = function()
                GiveItem(item.name, amount)
            end
        })
    end
    
    -- Quantidade custom
    table.insert(options, {
        title = '✏️ Quantidade Personalizada',
        description = 'Digite a quantidade (1-999)',
        iconColor = 'blue',
        onSelect = function()
            CustomAmount(item.name)
        end
    })
    
    lib.registerContext({
        id = 'debugshop_item_menu',
        title = item.label,
        description = string.format('[%s] | Peso: %sg', item.name, item.weight or 0),
        menu = 'debugshop_items_menu',
        onBack = function()
            ShowItemsPage(currentFilteredItems, currentPage)
        end,
        options = options
    })
    
    lib.showContext('debugshop_item_menu')
end

-- Funções auxiliares
function SearchItems()
    local input = lib.inputDialog('🔍 Buscar Item', {
        {
            type = 'input',
            label = 'Nome do Item',
            description = 'Digite parte do nome',
            required = true,
            placeholder = 'Ex: water, pistol...'
        }
    })
    
    if input and input[1] then
        local searchTerm = input[1]:lower()
        local results = {}
        
        for _, item in ipairs(allItems) do
            if item.name:lower():find(searchTerm) or item.label:lower():find(searchTerm) then
                table.insert(results, item)
            end
        end
        
        if #results > 0 then
            lib.notify({description = string.format('Encontrados %s itens', #results), type = 'success'})
            ShowCategoryItems('search_results', results)
        else
            lib.notify({description = 'Nenhum item encontrado', type = 'error'})
            OpenMainMenu()
        end
    else
        OpenMainMenu()
    end
end

function ReloadItems()
    if isLoading then
        lib.notify({description = 'Ainda carregando...', type = 'info'})
        return
    end
    
    isLoading = true
    
    lib.notify({
        description = 'Recarregando itens...',
        type = 'info',
        duration = 800
    })
    
    CreateThread(function()
        allItems = lib.callback.await('qbx-debugshop:server:getAllItems', false)
        
        isLoading = false
        
        if allItems and #allItems > 0 then
            lib.notify({
                description = string.format('✅ %s itens atualizados!', #allItems),
                type = 'success',
                duration = 1500
            })
            Wait(100)
            OpenMainMenu()
        else
            lib.notify({
                description = 'Erro ao recarregar itens',
                type = 'error'
            })
        end
    end)
end

function GiveItem(itemName, amount)
    TriggerServerEvent('qbx-debugshop:server:giveItem', itemName, amount)
end

function CustomAmount(itemName)
    local input = lib.inputDialog('Digite a Quantidade', {
        {
            type = 'number',
            label = 'Quantidade',
            description = 'Entre 1 e 999',
            required = true,
            min = 1,
            max = 999,
            default = 1
        }
    })
    
    if input and input[1] then
        TriggerServerEvent('qbx-debugshop:server:giveItem', itemName, tonumber(input[1]))
    end
end