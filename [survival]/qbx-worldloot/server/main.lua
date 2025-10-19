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
        return Config.HouseLoot
    end
end

local staticLootSpots = {}
local staticLootState = {}

do
    local configured = Config.StaticLootSpots or {}

    for index = 1, #configured do
        local spot = configured[index]
        local id = spot.id or ('static_' .. index)

        spot.id = id
        spot.lootType = spot.lootType or spot.type or 'house'
        if spot.coords then
            spot.coords = vector3(spot.coords.x, spot.coords.y, spot.coords.z)
        end

        staticLootSpots[id] = spot
    end
end

local function GenerateLoot(lootType, coords, options)
    options = options or {}

    coords = coords and vector3(coords.x, coords.y, coords.z) or vector3(0.0, 0.0, 0.0)

    local lootConfig = options.overrideConfig or GetLootConfig(lootType)

    if not lootConfig then
        return nil, 'invalid'
    end

    if not options.ignoreEnabled and lootConfig.enabled == false then
        return nil, 'disabled'
    end

    local spawnChance = options.spawnChance or lootConfig.spawnChance or 100

    if not options.forceSpawn then
        local roll = math.random(100)

        if roll > spawnChance then
            if Config.Debug then
                print(('[World Loot] Spawn falhou: %s%% (roll: %s%%)'):format(spawnChance, roll))
            end

            return {}, 'chance'
        end
    end

    local baseRange = lootConfig.itemsPerSpot or { min = 1, max = 1 }
    local overrideRange = options.itemsPerSpot or {}
    local minItems = math.floor(overrideRange.min or baseRange.min or 1)
    local maxItems = math.floor(overrideRange.max or baseRange.max or minItems)

    if maxItems < minItems then
        maxItems = minItems
    end

    minItems = math.max(1, minItems)

    local itemPool = options.itemsOverride or lootConfig.items or {}

    if #itemPool == 0 then
        return {}, 'empty'
    end

    local generatedLoot = {}
    local items = exports.ox_inventory:Items()
    local pulls = math.random(minItems, maxItems)

    for _ = 1, pulls do
        local totalChance = 0

        for _, lootItem in ipairs(itemPool) do
            totalChance = totalChance + (lootItem.chance or 0)
        end

        if totalChance <= 0 then
            break
        end

        local roll = math.random() * totalChance
        local currentChance = 0

        for _, lootItem in ipairs(itemPool) do
            currentChance = currentChance + (lootItem.chance or 0)

            if roll <= currentChance then
                local amountRange = lootItem.amount or { 1, 1 }
                local minAmount = amountRange[1] or 1
                local maxAmount = amountRange[2] or minAmount
                local amount = math.random(minAmount, maxAmount)

                local itemData = items[lootItem.item]

                if itemData then
                    generatedLoot[#generatedLoot + 1] = {
                        name = lootItem.item,
                        label = itemData.label or lootItem.item,
                        amount = amount,
                        metadata = lootItem.metadata
                    }
                elseif Config.Debug then
                    print(('[World Loot] Item %s nao existe no ox_inventory'):format(lootItem.item))
                end

                break
            end
        end
    end

    if Config.Debug and #generatedLoot > 0 then
        print(('[World Loot] Gerado %s itens tipo %s em %.1f, %.1f, %.1f'):format(#generatedLoot, lootType, coords.x, coords.y, coords.z))
    end

    if #generatedLoot == 0 then
        return {}, 'empty'
    end

    return generatedLoot, nil
end

lib.callback.register('qbx-worldloot:server:generateLoot', function(_, lootType, coords, options)
    local loot = GenerateLoot(lootType, coords, options)
    return loot or {}
end)

local function buildDropSettings(options)
    local base = Config.DropSettings or {}

    local settings = {
        prefix = base.prefix,
        slots = base.slots,
        maxWeight = base.maxWeight,
        model = base.model
    }

    if options and options.dropSettings then
        local override = options.dropSettings
        settings.prefix = override.prefix or settings.prefix
        settings.slots = override.slots or settings.slots
        settings.maxWeight = override.maxWeight or settings.maxWeight
        settings.model = override.model or settings.model
    end

    if options then
        settings.prefix = options.prefix or settings.prefix
        settings.slots = options.slots or settings.slots
        settings.maxWeight = options.maxWeight or settings.maxWeight
        settings.model = options.model or settings.model
    end

    settings.prefix = settings.prefix or 'World Loot'

    if settings.model and type(settings.model) == 'string' then
        settings.model = joaat(settings.model)
    end

    return settings
end

lib.callback.register('qbx-worldloot:server:createDrop', function(_, lootType, coords, options)
    coords = coords and vector3(coords.x, coords.y, coords.z) or vector3(0.0, 0.0, 0.0)
    options = options or {}

    local loot, reason = GenerateLoot(lootType, coords, options)

    if not loot or #loot == 0 then
        return {
            success = false,
            reason = reason or 'empty'
        }
    end

    local dropItems = {}

    for index = 1, #loot do
        local item = loot[index]
        dropItems[index] = { item.name, item.amount, item.metadata or {} }
    end

    local settings = buildDropSettings(options)

    local dropId = exports.ox_inventory:CustomDrop(settings.prefix, dropItems, coords, settings.slots, settings.maxWeight, nil, settings.model)

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

local function dropExists(dropId)
    if not dropId then
        return false
    end

    local inventory = exports.ox_inventory:GetInventory(dropId)
    return inventory and inventory.type == 'drop'
end

lib.callback.register('qbx-worldloot:server:ensureStaticDrop', function(_, spotId)
    local spot = staticLootSpots[spotId]

    if not spot then
        return {
            success = false,
            reason = 'invalid_spot'
        }
    end

    local state = staticLootState[spotId] or {}
    staticLootState[spotId] = state

    local now = GetGameTimer()

    if state.dropId and dropExists(state.dropId) then
        return {
            success = true,
            dropId = state.dropId,
            coords = spot.coords
        }
    elseif state.dropId then
        state.dropId = nil
    end

    if state.nextAvailable and now < state.nextAvailable then
        return {
            success = false,
            reason = 'cooldown',
            remaining = state.nextAvailable - now
        }
    end

    local options = {
        forceSpawn = true,
        itemsPerSpot = spot.itemsPerSpot,
        itemsOverride = spot.items,
        dropSettings = spot.dropSettings,
        spawnChance = spot.spawnChance
    }

    local loot, reason = GenerateLoot(spot.lootType, spot.coords, options)

    if not loot or #loot == 0 then
        state.nextAvailable = now + (spot.respawn or Config.RespawnTime)

        return {
            success = false,
            reason = reason or 'empty'
        }
    end

    local dropItems = {}

    for index = 1, #loot do
        local item = loot[index]
        dropItems[index] = { item.name, item.amount, item.metadata or {} }
    end

    local settings = buildDropSettings(spot)

    local dropId = exports.ox_inventory:CustomDrop(settings.prefix, dropItems, spot.coords, settings.slots, settings.maxWeight, nil, settings.model)

    if not dropId then
        state.nextAvailable = now + 5000

        return {
            success = false,
            reason = 'failed_drop'
        }
    end

    state.dropId = dropId
    state.nextAvailable = now + (spot.respawn or Config.RespawnTime)

    return {
        success = true,
        dropId = dropId,
        coords = spot.coords
    }
end)

print('[qbx-worldloot] Servidor iniciado com sucesso.')
