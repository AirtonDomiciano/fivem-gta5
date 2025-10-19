-- Sistema para spawnar loot em zonas específicas (casas, lojas, etc)

local activeZoneLoot = {}

-- Locais fixos de loot em interiores/zonas populares
local LootSpots = {
    -- HOSPITAL PILLBOX
    {coords = vector3(307.71, -595.14, 43.28), type = 'medical', label = 'Consultório'},
    {coords = vector3(311.41, -584.31, 43.28), type = 'medical', label = 'Sala de Cirurgia'},
    {coords = vector3(324.45, -582.48, 43.28), type = 'medical', label = 'Emergência'},
    {coords = vector3(301.62, -581.45, 43.28), type = 'medical', label = 'Farmácia'},
    
    -- DELEGACIA MISSION ROW
    {coords = vector3(451.92, -992.62, 30.69), type = 'police', label = 'Armeria PD'},
    {coords = vector3(461.28, -994.28, 30.69), type = 'police', label = 'Vestiário PD'},
    {coords = vector3(441.39, -996.66, 30.69), type = 'police', label = 'Escritório PD'},
    
    -- LOJAS DE CONVENIÊNCIA (24/7)
    {coords = vector3(24.47, -1347.37, 29.50), type = 'store', label = '24/7 Centro'},
    {coords = vector3(-3038.71, 585.95, 7.91), type = 'store', label = '24/7 Praia'},
    {coords = vector3(-3241.10, 1001.23, 12.83), type = 'store', label = '24/7 Highway'},
    {coords = vector3(1728.78, 6414.41, 35.04), type = 'store', label = '24/7 Paleto'},
    {coords = vector3(1697.23, 4924.15, 42.06), type = 'store', label = '24/7 Grapeseed'},
    {coords = vector3(1961.17, 3740.01, 32.34), type = 'store', label = '24/7 Sandy'},
    {coords = vector3(547.79, 2671.31, 42.16), type = 'store', label = '24/7 Harmony'},
    {coords = vector3(2557.94, 382.05, 108.62), type = 'store', label = '24/7 Palomino'},
    {coords = vector3(373.55, 325.56, 103.57), type = 'store', label = '24/7 Vinewood'},
    
    -- POSTOS DE GASOLINA
    {coords = vector3(49.42, -1750.53, 29.62), type = 'store', label = 'Posto Grove'},
    {coords = vector3(1163.71, -323.92, 69.21), type = 'store', label = 'Posto Mirror Park'},
    {coords = vector3(-1820.82, 792.52, 138.12), type = 'store', label = 'Posto Richman'},
    {coords = vector3(1702.84, 4933.59, 42.08), type = 'store', label = 'Posto Grapeseed'},
    
    -- CASAS EXEMPLO (adicione mais conforme seu mapa)
    {coords = vector3(-14.35, -1441.27, 31.10), type = 'house', label = 'Casa 1'},
    {coords = vector3(5.14, -1884.09, 23.70), type = 'house', label = 'Casa 2'},
    {coords = vector3(57.58, -1927.01, 21.91), type = 'house', label = 'Casa 3'},
    {coords = vector3(-679.67, -1013.29, 12.98), type = 'house', label = 'Casa 4'},
    
    -- MOTEL
    {coords = vector3(327.56, -229.54, 54.22), type = 'house', label = 'Motel Quarto 1'},
    {coords = vector3(311.25, -225.42, 54.22), type = 'house', label = 'Motel Quarto 2'},
    
    -- SANDY SHORES
    {coords = vector3(1961.95, 3742.88, 32.34), type = 'store', label = 'Loja Sandy'},
    {coords = vector3(1851.29, 3686.42, 34.27), type = 'police', label = 'Delegacia Sandy'},
    
    -- PALETO BAY
    {coords = vector3(-448.54, 6006.51, 31.72), type = 'police', label = 'Delegacia Paleto'},
    {coords = vector3(-378.13, 6045.86, 31.50), type = 'medical', label = 'Clínica Paleto'},
}

-- Thread para spawnar loot fixo nas zonas
CreateThread(function()
    Wait(5000) -- Espera o jogo carregar
    
    while true do
        Wait(1000)
        
        if Config.Enabled then
            local playerCoords = GetEntityCoords(PlayerPedId())
            
            for i, spot in ipairs(LootSpots) do
                local dist = #(playerCoords - spot.coords)
                
                -- Só processa se estiver próximo
                if dist < 50.0 then
                    -- Verifica se já tem loot ativo neste spot
                    if not activeZoneLoot[i] then
                        -- Cria "zona" de loot invisível
                        activeZoneLoot[i] = {
                            coords = spot.coords,
                            type = spot.type,
                            label = spot.label,
                            active = true
                        }
                    end
                elseif activeZoneLoot[i] then
                    -- Remove se o player se afastou muito
                    if dist > 100.0 then
                        activeZoneLoot[i] = nil
                    end
                end
            end
        end
    end
end)

-- Thread para desenhar markers nas zonas fixas
CreateThread(function()
    while true do
        local sleep = 1000
        
        if Config.Enabled and Config.Marker.enabled then
            local playerCoords = GetEntityCoords(PlayerPedId())
            
            for _, spot in pairs(activeZoneLoot) do
                if spot and spot.active then
                    local dist = #(playerCoords - spot.coords)
                    
                    if dist < Config.Marker.distance then
                        sleep = 0
                        
                        -- Cor baseada no tipo
                        local color = Config.Marker.color
                        if spot.type == 'medical' then
                            color = {r = 255, g = 50, b = 50, a = 200}
                        elseif spot.type == 'police' then
                            color = {r = 50, g = 50, b = 255, a = 200}
                        elseif spot.type == 'military' then
                            color = {r = 255, g = 0, b = 0, a = 200}
                        end
                        
                        DrawMarker(
                            Config.Marker.type,
                            spot.coords.x, spot.coords.y, spot.coords.z + 0.3,
                            0.0, 0.0, 0.0,
                            0.0, 0.0, 0.0,
                            Config.Marker.size.x, Config.Marker.size.y, Config.Marker.size.z,
                            color.r, color.g, color.b, color.a,
                            Config.Marker.bobUpAndDown,
                            false,
                            2,
                            Config.Marker.rotate,
                            nil,
                            nil,
                            false
                        )
                    end
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Exporta zonas para uso em outros scripts
exports('GetActiveZoneLoot', function()
    return activeZoneLoot
end)

exports('GetLootSpots', function()
    return LootSpots
end)