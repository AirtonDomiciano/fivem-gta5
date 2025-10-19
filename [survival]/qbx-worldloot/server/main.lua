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

local function GenerateLoot(lootType, coords)
    coords = coords and vector3(coords.x, coords.y, coords.z) or vector3(0.0, 0.0, 0.0)

    local lootConfig = GetLootConfig(lootType)

    if not lootConfig then
        return nil, 'invalid'
    end

    if not lootConfig.enabled then
        return nil, 'disabled'
    end

    local spawnRoll = math.random(100)
    if spawnRoll > lootConfig.spawnChance then
        if Config.Debug then
            print(string.format('[World Loot] Spawn falhou: %s%% (roll: %s%%)', lootConfig.spawnChance, spawnRoll))
        end
        return {}, 'chance'
    end

    local itemCount = math.random(lootConfig.itemsPerSpot.min, lootConfig.itemsPerSpot.max)
    local generatedLoot = {}
    local items = exports.ox_inventory:Items()

    for _ = 1, itemCount do
        local totalChance = 0

        for _, lootItem in ipairs(lootConfig.items) do
            totalChance = totalChance + lootItem.chance
        end

        local roll = math.random() * totalChance
        local currentChance = 0

        for _, lootItem in ipairs(lootConfig.items) do
            currentChance = currentChance + lootItem.chance

            if roll <= currentChance then
                local amount = math.random(lootItem.amount[1], lootItem.amount[2])

                if items[lootItem.item] then
                    generatedLoot[#generatedLoot + 1] = {
                        name = lootItem.item,
                        label = items[lootItem.item].label or lootItem.item,
                        amount = amount,
                        available = true
                    }
                elseif Config.Debug then
                    print(string.format('^3[World Loot] Item %s não existe no ox_inventory^0', lootItem.item))
                end

                break
            end
        end
    end

    if Config.Debug and #generatedLoot > 0 then
        print(string.format('[World Loot] Gerado %s itens tipo %s em %.1f, %.1f, %.1f', #generatedLoot, lootType, coords.x, coords.y, coords.z))
    end

    if #generatedLoot == 0 then
        return {}, 'empty'
    end

    return generatedLoot, nil
end

lib.callback.register('qbx-worldloot:server:generateLoot', function(source, lootType, coords)
    local loot = GenerateLoot(lootType, coords)
    return loot or {}
end)

lib.callback.register('qbx-worldloot:server:createDrop', function(source, lootType, coords)
    coords = coords and vector3(coords.x, coords.y, coords.z) or vector3(0.0, 0.0, 0.0)

    local loot, reason = GenerateLoot(lootType, coords)

    if not loot or #loot == 0 then
        return {
            success = false,
            reason = reason or 'empty'
        }
    end

    local dropItems = {}

    for i = 1, #loot do
        local item = loot[i]
        dropItems[i] = { item.name, item.amount, item.metadata or {} }
    end

    local settings = Config.DropSettings or {}
    local prefix = settings.prefix or 'World Loot'
    local slots = settings.slots
    local maxWeight = settings.maxWeight
    local model = settings.model

    local dropId = exports.ox_inventory:CustomDrop(prefix, dropItems, coords, slots, maxWeight, nil, model)

    if not dropId then
        if Config.Debug then
            print('[World Loot] Falha ao criar drop via ox_inventory')
        end

        return {
            success = false,
            reason = 'failed_drop'
        }
    end

    return {
        success = true,
        dropId = dropId,
        coords = coords
    }
end)

print('^2═══════════════════════════════════════^0')
print('^2║  QBX-WorldLoot carregado! ✅        ║^0')
print('^2║  Sistema de loot dinâmico ativo    ║^0')
print('^2║  Props, Casas, Veículos e Zonas    ║^0')
print('^2═══════════════════════════════════════^0')
