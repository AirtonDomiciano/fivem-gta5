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

local dynamicZones = {}
local dynamicZoneState = {}

do
    local configuredZones = Config.SpecialZones or {}

    for index = 1, #configuredZones do
        local zone = configuredZones[index]
        local id = zone.id or ('zone_' .. index)

        zone.id = id

        if zone.coords then
            zone.coords = vector3(zone.coords.x, zone.coords.y, zone.coords.z)
        else
            zone.coords = vector3(0.0, 0.0, 0.0)
        end

        zone.radius = zone.radius or 50.0

        local dynamic = zone.dynamicDrops

        if dynamic and dynamic.enabled ~= false then
            dynamic.minDrops = math.max(1, math.floor(dynamic.minDrops or dynamic.min or 1))
            dynamic.maxDrops = math.max(dynamic.minDrops,
                math.floor(dynamic.maxDrops or dynamic.max or dynamic.minDrops))
            dynamic.randomRadius = dynamic.randomRadius or zone.radius
            dynamic.randomAttempts = dynamic.randomAttempts or 6
            dynamic.groundOffset = dynamic.groundOffset or 0.0
            dynamic.spawnChance = dynamic.spawnChance or 100

            if dynamic.spawnPoints then
                for pointIndex = 1, #dynamic.spawnPoints do
                    local point = dynamic.spawnPoints[pointIndex]

                    if point.coords then
                        point.coords = vector3(point.coords.x, point.coords.y, point.coords.z)
                    else
                        dynamic.spawnPoints[pointIndex] = vector3(point.x, point.y, point.z)
                    end
                end
            end

            dynamicZones[id] = zone
            dynamicZoneState[id] = {
                dropIds = {},
                positions = {},
                nextAvailable = 0,
                lastSignature = nil
            }
        end
    end
end

local function shuffleTable(list)
    for index = #list, 2, -1 do
        local swapIndex = math.random(index)
        list[index], list[swapIndex] = list[swapIndex], list[index]
    end
end

local function signaturePositions(list)
    local keys = {}

    for index = 1, #list do
        local coords = list[index]
        keys[#keys + 1] = string.format('%.2f_%.2f_%.2f', coords.x, coords.y, coords.z)
    end

    table.sort(keys)

    return table.concat(keys, '|')
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
        print(('[World Loot] Gerado %s itens tipo %s em %.1f, %.1f, %.1f'):format(#generatedLoot, lootType, coords.x,
            coords.y, coords.z))
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

    local dropId = exports.ox_inventory:CustomDrop(settings.prefix, dropItems, coords, settings.slots, settings
        .maxWeight, nil, settings.model)

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

local function cleanupZoneDrops(zoneId)
    local state = dynamicZoneState[zoneId]

    if not state or not state.dropIds or #state.dropIds == 0 then
        return
    end

    local active = {}

    for index = 1, #state.dropIds do
        local dropId = state.dropIds[index]

        if dropExists(dropId) then
            active[#active + 1] = dropId
        end
    end

    if #active ~= #state.dropIds then
        state.dropIds = active

        if #active == 0 then
            state.positions = {}
        end
    end
end

local function spawnDynamicZoneDrops(zoneId, positions)
    local zone = dynamicZones[zoneId]

    if not zone then
        return nil, 'invalid_zone'
    end

    local dynamic = zone.dynamicDrops
    local state = dynamicZoneState[zoneId]

    cleanupZoneDrops(zoneId)

    local now = GetGameTimer()

    if state.dropIds and #state.dropIds > 0 then
        return state
    end

    if state.nextAvailable and now < state.nextAvailable then
        return nil, 'cooldown', state.nextAvailable - now
    end

    local dropIds = {}
    local storedPositions = {}
    local settings = buildDropSettings(dynamic)

    print(('[World Loot] Iniciando geração de drops dinâmicos para %s (%d posições)'):format(
        zoneId,
        type(positions) == 'table' and #positions or 0
    ))

    for index = 1, #positions do
        local coords = positions[index]
        local adjustedCoords = vector3(coords.x, coords.y, coords.z + (dynamic.groundOffset or 0.0))

        local lootOptions = {
            forceSpawn = true,
            spawnChance = dynamic.spawnChance,
            itemsPerSpot = dynamic.itemsPerSpot,
            itemsOverride = dynamic.items,
            overrideConfig = dynamic.overrideConfig
        }

        local loot, reason = GenerateLoot(zone.lootType or 'house', adjustedCoords, lootOptions)

        if loot and #loot > 0 then
            local dropItems = {}

            for lootIndex = 1, #loot do
                local item = loot[lootIndex]
                dropItems[lootIndex] = { item.name, item.amount, item.metadata or {} }
            end

            local dropId = exports.ox_inventory:CustomDrop(settings.prefix, dropItems, adjustedCoords, settings.slots,
                settings.maxWeight, nil, settings.model)

            if dropId then
                dropIds[#dropIds + 1] = dropId
                storedPositions[#storedPositions + 1] = adjustedCoords
            elseif Config.Debug then
                print(('[World Loot] Falha ao criar drop dinâmico em %s'):format(zoneId))
            end
        elseif Config.Debug then
            print(('[World Loot] Loot vazio para zona %s (motivo: %s)'):format(zoneId, reason or 'empty'))
        end
    end

    if #dropIds == 0 then
        return nil, 'failed_drop'
    end

    state.dropIds = dropIds
    state.positions = storedPositions
    state.nextAvailable = now + (dynamic.respawn or Config.RespawnTime)
    state.lastSignature = signaturePositions(storedPositions)

    return state
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

    local dropId = exports.ox_inventory:CustomDrop(settings.prefix, dropItems, spot.coords, settings.slots,
        settings.maxWeight, nil, settings.model)

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

lib.callback.register('qbx-worldloot:server:spawnZoneDrops', function(source, zoneId, requestedPositions)
    if type(zoneId) ~= 'string' then
        return {
            success = false,
            reason = 'invalid_zone'
        }
    end

    local zone = dynamicZones[zoneId]

    if not zone then
        return {
            success = false,
            reason = 'invalid_zone'
        }
    end

    local dynamic = zone.dynamicDrops

    if not dynamic or dynamic.enabled == false then
        return {
            success = false,
            reason = 'disabled'
        }
    end

    local state = dynamicZoneState[zoneId]

    if not state then
        state = {
            dropIds = {},
            positions = {},
            nextAvailable = 0,
            lastSignature = nil
        }
        dynamicZoneState[zoneId] = state
    end

    cleanupZoneDrops(zoneId)

    if state.dropIds and #state.dropIds > 0 then
        return {
            success = true,
            active = true,
            dropIds = state.dropIds,
            positions = state.positions,
            remaining = state.nextAvailable and math.max(0, state.nextAvailable - GetGameTimer()) or nil
        }
    end

    local now = GetGameTimer()

    if state.nextAvailable and now < state.nextAvailable then
        return {
            success = false,
            reason = 'cooldown',
            remaining = state.nextAvailable - now
        }
    end

    if type(requestedPositions) ~= 'table' or #requestedPositions == 0 then
        return {
            success = false,
            reason = 'invalid_payload'
        }
    end

    local validatedPositions = {}
    local maxRadius = (dynamic.randomRadius or zone.radius or 0.0) + 10.0

    for index = 1, #requestedPositions do
        local pos = requestedPositions[index]

        if type(pos) ~= 'table' or type(pos.x) ~= 'number' or type(pos.y) ~= 'number' or type(pos.z) ~= 'number' then
            return {
                success = false,
                reason = 'invalid_position'
            }
        end

        local coords = vector3(pos.x, pos.y, pos.z)
        local dist = #(coords - zone.coords)

        if dist > maxRadius then
            return {
                success = false,
                reason = 'out_of_bounds'
            }
        end

        validatedPositions[#validatedPositions + 1] = coords
    end

    if #validatedPositions < (dynamic.minDrops or 1) then
        return {
            success = false,
            reason = 'insufficient_positions',
            required = dynamic.minDrops
        }
    end

    local spawnableMax = math.min(#validatedPositions, dynamic.maxDrops or #validatedPositions)

    if spawnableMax < dynamic.minDrops then
        return {
            success = false,
            reason = 'insufficient_positions',
            required = dynamic.minDrops
        }
    end

    local attempts = 0
    local selection
    local selectionSignature
    local lastSignature = state.lastSignature

    repeat
        shuffleTable(validatedPositions)

        local spawnCount = math.random(dynamic.minDrops or 1, spawnableMax)
        selection = {}

        for index = 1, spawnCount do
            selection[index] = validatedPositions[index]
        end

        selectionSignature = signaturePositions(selection)
        attempts = attempts + 1
    until not lastSignature or selectionSignature ~= lastSignature or attempts >= 4 or spawnableMax == dynamic.minDrops

    local result, err, remaining = spawnDynamicZoneDrops(zoneId, selection)

    if not result then
        if err == 'cooldown' then
            return {
                success = false,
                reason = 'cooldown',
                remaining = remaining
            }
        end

        return {
            success = false,
            reason = err or 'failed_drop'
        }
    end

    return {
        success = true,
        active = true,
        dropIds = result.dropIds,
        positions = result.positions,
        remaining = result.nextAvailable and math.max(0, result.nextAvailable - GetGameTimer()) or nil
    }
end)

-- Sistema de logging melhorado
local function LogInfo(message)
    print('^2[QBX-ZombieLoot] ' .. message .. '^0')
end


RegisterCommand('checkdrop', function(source)
    Wait(1000)
    if source ~= 0 then
        print('[World Loot] Comando disponivel apenas no console do servidor.')
        return
    end

    local value = GetConvarInt('inventory:dropprops', 1)
    LogInfo('[World Loot] inventory:dropprops = %s'):format(value)
end, true)

CreateThread(function()
    Wait(1000)
    local value = GetConvarInt('inventory:dropprops', 1)
    LogInfo(('[World Loot] Convar inventory:dropprops carregado como %s'):format(value))
end)

print('[qbx-worldloot] Servidor iniciado com sucesso xtetinha.')
