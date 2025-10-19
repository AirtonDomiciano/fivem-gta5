local lootedSpots = {}
local nearbyLootSpots = {}
local isSearching = false

-- Verifica se um local foi saqueado
local function IsLocationLooted(coords)
    local key = string.format("%.1f_%.1f_%.1f", coords.x, coords.y, coords.z)
    return lootedSpots[key] ~= nil
end

-- Marca local como saqueado
local function MarkLocationLooted(coords)
    local key = string.format("%.1f_%.1f_%.1f", coords.x, coords.y, coords.z)
    lootedSpots[key] = true
    
    -- Remove após o tempo de respawn
    SetTimeout(Config.RespawnTime, function()
        lootedSpots[key] = nil
    end)
end

-- Verifica tipo de zona especial
local function GetZoneType(coords)
    for _, zone in ipairs(Config.SpecialZones) do
        local dist = #(coords - zone.coords)
        if dist < zone.radius then
            return zone.lootType
        end
    end
    return nil
end

-- Determina tipo de loot baseado no contexto
local function DetermineLootType(entity, entityType)
    local coords = GetEntityCoords(entity)
    
    -- Verifica se está em zona especial primeiro
    local zoneType = GetZoneType(coords)
    if zoneType then
        return zoneType
    end
    
    -- Se for veículo, verifica o modelo
    if entityType == 'vehicle' then
        local model = GetEntityModel(entity)
        local className = GetVehicleClass(entity)
        
        -- Veículos policiais
        if className == 18 then -- Emergency vehicles
            return 'police'
        end
        
        return 'vehicle'
    end
    
    -- Props sempre usam loot de prop
    if entityType == 'prop' then
        return 'prop'
    end
    
    -- Padrão para casas/edificios
    return 'house'
end

-- Thread para detectar loot próximo
CreateThread(function()
    while true do
        local sleep = 1000
        
        if Config.Enabled then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            nearbyLootSpots = {}
            
            -- Procura por props lootáveis
            if Config.PropLoot.enabled then
                for _, propModel in ipairs(Config.LootableProps) do
                    local propHash = GetHashKey(propModel)
                    local prop = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, Config.Marker.distance, propHash, false, false, false)
                    
                    if DoesEntityExist(prop) then
                        local propCoords = GetEntityCoords(prop)
                        local dist = #(playerCoords - propCoords)
                        
                        if dist < Config.Marker.distance and not IsLocationLooted(propCoords) then
                            table.insert(nearbyLootSpots, {
                                entity = prop,
                                coords = propCoords,
                                distance = dist,
                                type = 'prop'
                            })
                            sleep = 100
                        end
                    end
                end
            end
            
            -- Procura por veículos
            if Config.VehicleLoot.enabled then
                local vehicles = GetGamePool('CVehicle')
                for _, vehicle in ipairs(vehicles) do
                    if vehicle ~= GetVehiclePedIsIn(playerPed, false) then
                        local vehCoords = GetEntityCoords(vehicle)
                        local dist = #(playerCoords - vehCoords)
                        
                        if dist < Config.Marker.distance and not IsLocationLooted(vehCoords) then
                            -- Verifica se está abandonado (sem motorista)
                            if IsVehicleSeatFree(vehicle, -1) then
                                table.insert(nearbyLootSpots, {
                                    entity = vehicle,
                                    coords = vehCoords,
                                    distance = dist,
                                    type = 'vehicle'
                                })
                                sleep = 100
                            end
                        end
                    end
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Thread para desenhar markers e interação
CreateThread(function()
    while true do
        local sleep = 1000
        
        if Config.Enabled and #nearbyLootSpots > 0 then
            sleep = 0
            local playerCoords = GetEntityCoords(PlayerPedId())
            
            for _, spot in ipairs(nearbyLootSpots) do
                local coords = spot.coords
                local dist = #(playerCoords - coords)
                
                -- Desenha marker
                if Config.Marker.enabled and dist < Config.Marker.distance then
                    DrawMarker(
                        Config.Marker.type,
                        coords.x, coords.y, coords.z + 0.5,
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
                
                -- Interação
                if dist < Config.LootDistance and not isSearching then
                    lib.showTextUI(Config.Lang.press_search)
                    
                    if IsControlJustPressed(0, Config.InteractKey) then
                        lib.hideTextUI()
                        SearchLocation(spot)
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

-- Função para procurar em um local
function SearchLocation(spot)
    if isSearching then return end
    isSearching = true
    
    -- Verifica se já foi saqueado
    if IsLocationLooted(spot.coords) then
        lib.notify({
            description = Config.Lang.already_looted,
            type = 'error'
        })
        isSearching = false
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
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer',
            flag = 1
        }
    })
    
    if not success then
        isSearching = false
        return
    end
    
    -- Verifica se ainda está próximo
    local playerCoords = GetEntityCoords(PlayerPedId())
    if #(playerCoords - spot.coords) > Config.LootDistance + 1.0 then
        lib.notify({
            description = Config.Lang.too_far,
            type = 'error'
        })
        isSearching = false
        return
    end
    
    -- Determina tipo de loot
    local lootType = DetermineLootType(spot.entity, spot.type)
    
    -- Pede loot ao servidor
    local lootData = lib.callback.await('qbx-worldloot:server:generateLoot', false, lootType, spot.coords)
    
    if lootData and #lootData > 0 then
        -- Marca como saqueado
        MarkLocationLooted(spot.coords)
        
        -- Mostra menu de loot
        ShowLootMenu(lootData, spot.coords)
    else
        lib.notify({
            description = Config.Lang.nothing_found,
            type = 'error'
        })
    end
    
    isSearching = false
end

-- Menu de loot (similar ao do zombieloot)
function ShowLootMenu(lootData, location)
    CreateLootMenuOptions(lootData, location)
end

local isProcessingLoot = false

function CreateLootMenuOptions(lootData, location)
    local options = {}
    local availableItems = {}
    
    for _, item in ipairs(lootData) do
        if item.available then
            table.insert(availableItems, item)
        end
    end
    
    if #availableItems == 0 then
        lib.notify({description = 'Todos os itens foram coletados', type = 'success'})
        isProcessingLoot = false
        return
    end
    
    -- Pegar Tudo
    table.insert(options, {
        title = 'Pegar Tudo',
        icon = 'hand-holding',
        iconColor = 'green',
        onSelect = function()
            if isProcessingLoot then return end
            isProcessingLoot = true
            
            TriggerServerEvent('qbx-worldloot:server:takeAll', availableItems)
            
            for _, item in ipairs(lootData) do
                item.available = false
            end
            
            Wait(500)
            isProcessingLoot = false
        end
    })
    
    table.insert(options, {
        title = '─────────────',
        disabled = true
    })
    
    -- Items individuais
    for _, item in ipairs(availableItems) do
        table.insert(options, {
            title = item.label,
            description = string.format('Quantidade: %s', item.amount),
            icon = 'box',
            onSelect = function()
                if isProcessingLoot then return end
                isProcessingLoot = true
                
                local success = lib.callback.await('qbx-worldloot:server:takeItemWithCheck', false, item.name, item.amount)
                
                if success then
                    item.available = false
                end
                
                Wait(200)
                isProcessingLoot = false
                CreateLootMenuOptions(lootData, location)
            end
        })
    end
    
    lib.registerContext({
        id = 'worldloot_menu',
        title = Config.Lang.found_items,
        options = options,
        onExit = function()
            isProcessingLoot = false
        end
    })
    
    lib.showContext('worldloot_menu')
end

-- Comando admin para resetar loot
RegisterCommand(Config.ResetCommand, function()
    lootedSpots = {}
    lib.notify({description = 'Todo o loot foi resetado!', type = 'success'})
end, false)