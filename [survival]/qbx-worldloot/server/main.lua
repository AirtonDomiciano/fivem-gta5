-- Pega configuração de loot baseado no tipo
local function GetLootConfig(lootType)
    if lootType == 'house' then
        return Config.HouseLoot
    elseif lootType == 'store' then
        return Config.StoreLoot
    elseif lootType == 'vehicle' then
        return Config.VehicleLoot
    elseif lootType == 'police' then
        return Config.PoliceLoot
    elseif lootType == 'medical' then
        return Config.MedicalLoot
    elseif lootType == 'military' then
        return Config.MilitaryLoot
    elseif lootType == 'prop' then
        return Config.PropLoot
    else
        return Config.HouseLoot -- Padrão
    end
end

-- Callback para gerar loot
lib.callback.register('qbx-worldloot:server:generateLoot', function(source, lootType, coords)
    local lootConfig = GetLootConfig(lootType)
    
    if not lootConfig or not lootConfig.enabled then
        return {}
    end
    
    -- Verifica chance de spawn
    local spawnRoll = math.random(100)
    if spawnRoll > lootConfig.spawnChance then
        if Config.Debug then
            print(string.format('[World Loot] Spawn falhou: %s%% (roll: %s%%)', lootConfig.spawnChance, spawnRoll))
        end
        return {}
    end
    
    -- Gera quantidade de itens
    local itemCount = math.random(lootConfig.itemsPerSpot.min, lootConfig.itemsPerSpot.max)
    local generatedLoot = {}
    
    for i = 1, itemCount do
        -- Calcula chance total
        local totalChance = 0
        for _, lootItem in ipairs(lootConfig.items) do
            totalChance = totalChance + lootItem.chance
        end
        
        -- Rola item
        local roll = math.random() * totalChance
        local currentChance = 0
        
        for _, lootItem in ipairs(lootConfig.items) do
            currentChance = currentChance + lootItem.chance
            if roll <= currentChance then
                local amount = math.random(lootItem.amount[1], lootItem.amount[2])
                
                -- Verifica se o item existe no inventário
                local items = exports.ox_inventory:Items()
                if items[lootItem.item] then
                    table.insert(generatedLoot, {
                        name = lootItem.item,
                        label = items[lootItem.item].label or lootItem.item,
                        amount = amount,
                        available = true
                    })
                else
                    if Config.Debug then
                        print(string.format('^3[World Loot] Item %s não existe no ox_inventory^0', lootItem.item))
                    end
                end
                
                break
            end
        end
    end
    
    if Config.Debug and #generatedLoot > 0 then
        print(string.format('[World Loot] Gerado %s itens tipo %s em %.1f, %.1f, %.1f', #generatedLoot, lootType, coords.x, coords.y, coords.z))
    end
    
    return generatedLoot
end)

-- Callback para pegar item com verificação
lib.callback.register('qbx-worldloot:server:takeItemWithCheck', function(source, itemName, amount)
    local src = source
    
    local canCarry = exports.ox_inventory:CanCarryItem(src, itemName, amount)
    
    if not canCarry then
        lib.notify(src, {
            description = Config.Lang.inventory_full,
            type = 'error'
        })
        return false
    end
    
    local success = exports.ox_inventory:AddItem(src, itemName, amount)
    
    if success then
        lib.notify(src, {
            description = string.format('Você encontrou %sx %s', amount, itemName),
            type = 'success'
        })
        
        -- Log
        if Config.Debug then
            local player = exports.qbx_core:GetPlayer(src)
            if player then
                local playerName = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
                print(string.format('[World Loot] %s pegou %sx %s', playerName, amount, itemName))
            end
        end
        
        return true
    else
        lib.notify(src, {
            description = 'Erro ao adicionar item',
            type = 'error'
        })
        return false
    end
end)

-- Evento para pegar todos os itens
RegisterNetEvent('qbx-worldloot:server:takeAll', function(lootData)
    local src = source
    local itemsReceived = 0
    local itemsFailed = 0
    
    for _, item in ipairs(lootData) do
        local canCarry = exports.ox_inventory:CanCarryItem(src, item.name, item.amount)
        
        if canCarry then
            local success = exports.ox_inventory:AddItem(src, item.name, item.amount)
            
            if success then
                itemsReceived = itemsReceived + 1
            else
                itemsFailed = itemsFailed + 1
            end
        else
            itemsFailed = itemsFailed + 1
        end
        
        Wait(50)
    end
    
    if itemsReceived > 0 then
        lib.notify(src, {
            description = string.format('Você coletou %s itens', itemsReceived),
            type = 'success'
        })
    end
    
    if itemsFailed > 0 then
        lib.notify(src, {
            description = string.format('%s itens não couberam', itemsFailed),
            type = 'warning'
        })
    end
    
    -- Log
    if Config.Debug then
        local player = exports.qbx_core:GetPlayer(src)
        if player then
            local playerName = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
            print(string.format('[World Loot] %s pegou %s itens (falhou: %s)', playerName, itemsReceived, itemsFailed))
        end
    end
end)

print('^2═══════════════════════════════════════^0')
print('^2║  QBX-WorldLoot carregado! ✅        ║^0')
print('^2║  Sistema de loot dinâmico ativo    ║^0')
print('^2║  Props, Casas, Veículos e Zonas    ║^0')
print('^2═══════════════════════════════════════^0')