-- Bridge para compatibilidade qb-target com ox_target
-- Autor: Adaptação para qbx_core
-- Este script cria exports do qb-target usando ox_target

local function convertQBOptionsToOx(options)
    local oxOptions = {}
    
    for _, option in ipairs(options) do
        table.insert(oxOptions, {
            name = option.name or option.event or 'option',
            label = option.label or 'Interagir',
            icon = option.icon or 'fa-solid fa-hand',
            onSelect = function(data)
                if option.action then
                    option.action(data)
                elseif option.event then
                    TriggerEvent(option.event, data)
                elseif option.serverEvent then
                    TriggerServerEvent(option.serverEvent, data)
                end
            end,
            canInteract = function(entity, distance, data)
                if option.canInteract then
                    return option.canInteract(entity, distance, data)
                end
                return true
            end,
            distance = option.distance or 2.5
        })
    end
    
    return oxOptions
end

-- Export: AddTargetModel
exports('AddTargetModel', function(models, options)
    if type(models) ~= 'table' then
        models = {models}
    end
    
    local oxOptions = convertQBOptionsToOx(options)
    
    exports.ox_target:addModel(models, oxOptions)
end)

-- Export: RemoveTargetModel
exports('RemoveTargetModel', function(models, optionNames)
    if type(models) ~= 'table' then
        models = {models}
    end
    
    exports.ox_target:removeModel(models, optionNames)
end)

-- Export: AddBoxZone
exports('AddBoxZone', function(name, center, length, width, options, targetoptions)
    local oxOptions = convertQBOptionsToOx(targetoptions)
    
    exports.ox_target:addBoxZone({
        coords = center,
        size = vec3(length, width, options.minZ and (options.maxZ - options.minZ) or 2.0),
        rotation = options.heading or 0,
        debug = options.debugPoly or false,
        options = oxOptions
    })
end)

-- Export: RemoveZone
exports('RemoveZone', function(name)
    exports.ox_target:removeZone(name)
end)

-- Export: AddTargetBone
exports('AddTargetBone', function(bones, options)
    if type(bones) ~= 'table' then
        bones = {bones}
    end
    
    local oxOptions = convertQBOptionsToOx(options)
    
    exports.ox_target:addGlobalVehicle(oxOptions)
end)

-- Export: AddTargetEntity
exports('AddTargetEntity', function(entities, options)
    if type(entities) ~= 'table' then
        entities = {entities}
    end
    
    local oxOptions = convertQBOptionsToOx(options)
    
    for _, entity in ipairs(entities) do
        exports.ox_target:addLocalEntity(entity, oxOptions)
    end
end)

-- Export: RemoveTargetEntity
exports('RemoveTargetEntity', function(entities, optionNames)
    if type(entities) ~= 'table' then
        entities = {entities}
    end
    
    for _, entity in ipairs(entities) do
        exports.ox_target:removeLocalEntity(entity, optionNames)
    end
end)

-- Export: AddGlobalPed
exports('AddGlobalPed', function(options)
    local oxOptions = convertQBOptionsToOx(options)
    exports.ox_target:addGlobalPed(oxOptions)
end)

-- Export: AddGlobalVehicle  
exports('AddGlobalVehicle', function(options)
    local oxOptions = convertQBOptionsToOx(options)
    exports.ox_target:addGlobalVehicle(oxOptions)
end)

-- Export: AddGlobalObject
exports('AddGlobalObject', function(options)
    local oxOptions = convertQBOptionsToOx(options)
    exports.ox_target:addGlobalObject(oxOptions)
end)

-- Export: AddGlobalPlayer
exports('AddGlobalPlayer', function(options)
    local oxOptions = convertQBOptionsToOx(options)
    exports.ox_target:addGlobalPlayer(oxOptions)
end)

print('^2[qb-target-bridge]^7 Carregado com sucesso! Usando ox_target como backend.')

