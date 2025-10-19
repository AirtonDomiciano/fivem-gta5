-- Static loot zones to surface visible high-value drops inside key interiors.

local activeZoneLoot = {}
local staticLootSpots = {}

do
    local configured = Config.StaticLootSpots or {}

    for index = 1, #configured do
        local spot = configured[index]
        local id = spot.id or ('static_' .. index)

        spot.id = id
        spot.lootType = spot.lootType or spot.type or 'house'
        spot.activateRange = spot.activateRange or 80.0
        spot.deactivateRange = spot.deactivateRange or (spot.activateRange + 40.0)
        spot.spawnDistance = spot.spawnDistance or 15.0
        spot.despawnDistance = spot.despawnDistance or (spot.spawnDistance + 10.0)
        spot.markerDistance = spot.markerDistance or Config.Marker.distance or 10.0

        staticLootSpots[index] = spot
    end
end

local function ensureModelLoaded(hash)
    if HasModelLoaded(hash) then return end

    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

local function spawnPropsForSpot(index, spot)
    local zoneData = activeZoneLoot[index]

    if not zoneData or zoneData.propsSpawned or not spot.props then
        return
    end

    zoneData.spawnedProps = {}

    for _, prop in ipairs(spot.props) do
        local model = prop.model

        if model then
            local hash = type(model) == 'number' and model or joaat(model)
            ensureModelLoaded(hash)

            local offset = prop.offset or vector3(0.0, 0.0, 0.0)
            local coords = vector3(
                spot.coords.x + offset.x,
                spot.coords.y + offset.y,
                spot.coords.z + offset.z
            )

            local entity = CreateObject(hash, coords.x, coords.y, coords.z, false, false, false)

            if prop.heading then
                SetEntityHeading(entity, prop.heading)
            end

            if prop.rotation then
                SetEntityRotation(
                    entity,
                    prop.rotation.x or 0.0,
                    prop.rotation.y or 0.0,
                    prop.rotation.z or 0.0,
                    2,
                    true
                )
            end

            FreezeEntityPosition(entity, true)
            SetEntityCollision(entity, false, false)
            SetEntityAsMissionEntity(entity, true, false)

            zoneData.spawnedProps[#zoneData.spawnedProps + 1] = { entity = entity, model = hash }
        end
    end

    zoneData.propsSpawned = true
end

local function removePropsForSpot(index)
    local zoneData = activeZoneLoot[index]

    if not zoneData or not zoneData.spawnedProps then
        return
    end

    for _, prop in ipairs(zoneData.spawnedProps) do
        if prop.entity and DoesEntityExist(prop.entity) then
            DeleteEntity(prop.entity)
        end

        if prop.model then
            SetModelAsNoLongerNeeded(prop.model)
        end
    end

    zoneData.spawnedProps = nil
    zoneData.propsSpawned = false
end

local function requestStaticDrop(index, spot)
    local zoneData = activeZoneLoot[index]

    if not zoneData or zoneData.pending then
        return
    end

    zoneData.pending = true

    CreateThread(function()
        local result = lib.callback.await('qbx-worldloot:server:ensureStaticDrop', false, spot.id)

        zoneData.pending = false

        if not activeZoneLoot[index] then
            return
        end

        if result and result.success then
            zoneData.dropActive = true
            spawnPropsForSpot(index, spot)

            local respawn = spot.respawn or Config.RespawnTime
            zoneData.nextAvailable = GetGameTimer() + respawn
        else
            if result and result.reason == 'cooldown' and result.remaining then
                zoneData.nextAvailable = GetGameTimer() + result.remaining
            else
                zoneData.nextAvailable = GetGameTimer() + 10000
            end

            zoneData.dropActive = result and result.success or false

            if not zoneData.dropActive then
                removePropsForSpot(index)
            end
        end
    end)
end

CreateThread(function()
    Wait(5000)

    while true do
        Wait(1000)

        if not Config.Enabled then
            goto continue
        end

        local playerCoords = GetEntityCoords(PlayerPedId())

        for index, spot in ipairs(staticLootSpots) do
            local zoneData = activeZoneLoot[index]
            local dist = #(playerCoords - spot.coords)

            if dist < spot.activateRange then
                if not zoneData then
                    activeZoneLoot[index] = {
                        id = spot.id,
                        coords = spot.coords,
                        label = spot.name or spot.label,
                        lootType = spot.lootType,
                        active = true,
                        nextAvailable = 0
                    }
                else
                    zoneData.active = true
                end
            elseif zoneData and dist > spot.deactivateRange then
                removePropsForSpot(index)
                activeZoneLoot[index] = nil
            end
        end

        ::continue::
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if Config.Enabled then
            local playerCoords = GetEntityCoords(PlayerPedId())

            for index, spot in ipairs(staticLootSpots) do
                local zoneData = activeZoneLoot[index]

                if zoneData and zoneData.active then
                    local dist = #(playerCoords - spot.coords)

                    if zoneData.dropActive and zoneData.nextAvailable and GetGameTimer() >= zoneData.nextAvailable then
                        zoneData.dropActive = false
                        removePropsForSpot(index)
                        zoneData.nextAvailable = GetGameTimer()
                    end

                    local shouldSpawn = spot.instant

                    if shouldSpawn == nil then
                        shouldSpawn = Config.InstantDrop
                    end

                    if shouldSpawn and dist < spot.spawnDistance then
                        if not zoneData.dropActive then
                            if not zoneData.nextAvailable or GetGameTimer() >= zoneData.nextAvailable then
                                requestStaticDrop(index, spot)
                                sleep = 0
                            end
                        elseif spot.props and not zoneData.propsSpawned then
                            spawnPropsForSpot(index, spot)
                        end
                    elseif zoneData.propsSpawned and dist > spot.despawnDistance then
                        removePropsForSpot(index)
                    end

                    if Config.Marker.enabled and dist < spot.markerDistance then
                        sleep = 0

                        local color = spot.markerColor or Config.Marker.color

                        DrawMarker(
                            Config.Marker.type,
                            spot.coords.x,
                            spot.coords.y,
                            spot.coords.z + 0.3,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            Config.Marker.size.x,
                            Config.Marker.size.y,
                            Config.Marker.size.z,
                            color.r,
                            color.g,
                            color.b,
                            color.a or Config.Marker.color.a,
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

exports('GetActiveZoneLoot', function()
    return activeZoneLoot
end)

exports('GetLootSpots', function()
    return staticLootSpots
end)
