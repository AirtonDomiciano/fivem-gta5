local testDriveVehicle = nil
local testDriveActive = false

-- Função para abrir menu principal
RegisterNetEvent('vehicle_shop:client:openMenu', function()
    local categories = {}
    
    -- Construir menu de categorias
    for _, category in pairs(Config.Vehicles) do
        table.insert(categories, {
            title = category.category,
            description = #category.vehicles .. ' veículos disponíveis',
            icon = 'car',
            onSelect = function()
                OpenVehicleList(category)
            end
        })
    end
    
    lib.registerContext({
        id = 'vehicle_shop_main',
        title = '🚗 Loja de Veículos',
        options = categories
    })
    
    lib.showContext('vehicle_shop_main')
end)

-- Função para abrir lista de veículos
function OpenVehicleList(category)
    local vehicles = {}
    
    for _, vehicle in pairs(category.vehicles) do
        table.insert(vehicles, {
            title = vehicle.name,
            description = 'Preço: $' .. lib.math.groupdigits(vehicle.price),
            icon = 'car-side',
            image = vehicle.image,
            onSelect = function()
                OpenVehicleOptions(vehicle)
            end
        })
    end
    
    lib.registerContext({
        id = 'vehicle_shop_list',
        title = category.category,
        menu = 'vehicle_shop_main',
        options = vehicles
    })
    
    lib.showContext('vehicle_shop_list')
end

-- Função para abrir opções do veículo
function OpenVehicleOptions(vehicle)
    local options = {}
    
    -- Opção de Test Drive
    if Config.TestDrive.enabled then
        table.insert(options, {
            title = '🔑 Test Drive',
            description = 'Testar o veículo por ' .. Config.TestDrive.duration .. ' segundos',
            icon = 'key',
            onSelect = function()
                StartTestDrive(vehicle)
            end
        })
    end
    
    -- Opção de Comprar
    table.insert(options, {
        title = '💵 Comprar Veículo',
        description = 'Comprar por $' .. lib.math.groupdigits(vehicle.price),
        icon = 'dollar-sign',
        onSelect = function()
            PurchaseVehicle(vehicle)
        end
    })
    
    lib.registerContext({
        id = 'vehicle_shop_options',
        title = vehicle.name,
        menu = 'vehicle_shop_list',
        options = options
    })
    
    lib.showContext('vehicle_shop_options')
end

-- Função de Test Drive
function StartTestDrive(vehicle)
    if testDriveActive then
        lib.notify({
            title = 'Test Drive',
            description = 'Você já está em um test drive!',
            type = 'error'
        })
        return
    end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    
    -- Calcular posição de spawn
    local spawnCoords = playerCoords + GetEntityForwardVector(playerPed) * Config.TestDrive.spawnOffset.x
    
    -- Spawnar veículo
    lib.requestModel(vehicle.model)
    
    testDriveVehicle = CreateVehicle(GetHashKey(vehicle.model), spawnCoords.x, spawnCoords.y, spawnCoords.z, playerHeading, true, false)
    
    SetVehicleOnGroundProperly(testDriveVehicle)
    SetVehicleNumberPlateText(testDriveVehicle, 'TEST')
    SetEntityAsMissionEntity(testDriveVehicle, true, true)
    SetModelAsNoLongerNeeded(GetHashKey(vehicle.model))
    
    -- Colocar jogador no veículo
    TaskWarpPedIntoVehicle(playerPed, testDriveVehicle, -1)
    
    testDriveActive = true
    
    lib.notify({
        title = 'Test Drive',
        description = 'Test drive iniciado! Você tem ' .. Config.TestDrive.duration .. ' segundos.',
        type = 'success'
    })
    
    -- Timer para remover veículo
    SetTimeout(Config.TestDrive.duration * 1000, function()
        EndTestDrive()
    end)
end

-- Função para terminar Test Drive
function EndTestDrive()
    if not testDriveActive then return end
    
    local playerPed = PlayerPedId()
    
    if testDriveVehicle and DoesEntityExist(testDriveVehicle) then
        TaskLeaveVehicle(playerPed, testDriveVehicle, 0)
        Wait(2000)
        DeleteVehicle(testDriveVehicle)
    end
    
    testDriveVehicle = nil
    testDriveActive = false
    
    lib.notify({
        title = 'Test Drive',
        description = 'Test drive finalizado!',
        type = 'info'
    })
end

-- Função de compra
function PurchaseVehicle(vehicle)
    local input = lib.inputDialog('Comprar Veículo', {
        {
            type = 'input',
            label = 'Placa do Veículo',
            description = 'Digite a placa desejada (8 caracteres)',
            required = true,
            min = 2,
            max = 8
        }
    })
    
    if not input then return end
    
    local plate = string.upper(input[1])
    
    -- Confirmar compra
    local alert = lib.alertDialog({
        header = 'Confirmar Compra',
        content = 'Deseja comprar **' .. vehicle.name .. '** por **$' .. lib.math.groupdigits(vehicle.price) .. '**?  \n  \n**Placa:** ' .. plate,
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Comprar',
            cancel = 'Cancelar'
        }
    })
    
    if alert == 'confirm' then
        TriggerServerEvent('vehicle_shop:server:purchaseVehicle', vehicle, plate)
    end
end

-- Callback de compra bem-sucedida
RegisterNetEvent('vehicle_shop:client:vehiclePurchased', function(vehicle, plate)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    
    -- Spawnar veículo comprado
    local spawnCoords = playerCoords + GetEntityForwardVector(playerPed) * 5.0
    
    lib.requestModel(vehicle.model)
    
    local veh = CreateVehicle(GetHashKey(vehicle.model), spawnCoords.x, spawnCoords.y, spawnCoords.z, playerHeading, true, false)
    
    SetVehicleOnGroundProperly(veh)
    SetVehicleNumberPlateText(veh, plate)
    SetEntityAsMissionEntity(veh, true, true)
    SetModelAsNoLongerNeeded(GetHashKey(vehicle.model))
    
    TaskWarpPedIntoVehicle(playerPed, veh, -1)
    
    -- Dar as chaves (se usar sistema de chaves)
    TriggerEvent('vehiclekeys:client:SetOwner', plate)
    
    lib.notify({
        title = 'Compra Realizada',
        description = 'Você comprou um ' .. vehicle.name .. '!',
        type = 'success',
        duration = 5000
    })
end)