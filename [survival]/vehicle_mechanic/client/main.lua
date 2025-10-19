-- Abrir menu principal
RegisterNetEvent('vehicle_mechanic:client:openMenu', function()
    local options = {
        {
            title = '🔧 Serviços de Manutenção',
            description = 'Reparar seu veículo',
            icon = 'wrench',
            onSelect = function()
                OpenRepairMenu()
            end
        },
        {
            title = '🛒 Comprar Peças',
            description = 'Comprar peças de reparo',
            icon = 'shopping-cart',
            onSelect = function()
                OpenPartsShop()
            end
        }
    }
    
    lib.registerContext({
        id = 'vehicle_mechanic_main',
        title = '🔧 Mecânico',
        options = options
    })
    
    lib.showContext('vehicle_mechanic_main')
end)

-- Menu de reparos
function OpenRepairMenu()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        lib.notify({
            title = 'Erro',
            description = 'Você precisa estar em um veículo!',
            type = 'error'
        })
        return
    end
    
    local options = {}
    
    for _, service in pairs(Config.RepairServices) do
        table.insert(options, {
            title = service.label,
            description = service.description .. ' - $' .. lib.math.groupdigits(service.price),
            icon = service.icon,
            onSelect = function()
                RequestRepair(service, vehicle)
            end
        })
    end
    
    lib.registerContext({
        id = 'vehicle_mechanic_repair',
        title = '🔧 Serviços de Manutenção',
        menu = 'vehicle_mechanic_main',
        options = options
    })
    
    lib.showContext('vehicle_mechanic_repair')
end

-- Requisitar reparo
function RequestRepair(service, vehicle)
    local alert = lib.alertDialog({
        header = 'Confirmar Reparo',
        content = 'Deseja realizar **' .. service.label .. '** por **$' .. lib.math.groupdigits(service.price) .. '**?',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Confirmar',
            cancel = 'Cancelar'
        }
    })
    
    if alert == 'confirm' then
        TriggerServerEvent('vehicle_mechanic:server:repair', service)
    end
end

-- Executar reparo
RegisterNetEvent('vehicle_mechanic:client:performRepair', function(service)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then return end
    
    -- Animação de reparo
    if lib.progressBar({
        duration = Config.RepairTime[service.type] * 1000,
        label = 'Realizando ' .. service.label,
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    }) then
        -- Aplicar reparo
        if service.type == 'full_repair' then
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, false)
        elseif service.type == 'engine' then
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetVehicleUndriveable(vehicle, false)
        elseif service.type == 'body' then
            SetVehicleBodyHealth(vehicle, 1000.0)
            SetVehicleDeformationFixed(vehicle)
        elseif service.type == 'clean' then
            SetVehicleDirtLevel(vehicle, 0.0)
            WashDecalsFromVehicle(vehicle, 1.0)
        end
        
        lib.notify({
            title = 'Reparo Concluído',
            description = service.label .. ' realizado com sucesso!',
            type = 'success'
        })
    end
end)

-- Menu de loja de peças
function OpenPartsShop()
    local options = {}
    
    for _, part in pairs(Config.RepairParts) do
        table.insert(options, {
            title = part.label,
            description = part.description .. ' - $' .. lib.math.groupdigits(part.price),
            icon = part.icon,
            onSelect = function()
                PurchasePart(part)
            end
        })
    end
    
    lib.registerContext({
        id = 'vehicle_mechanic_parts',
        title = '🛒 Loja de Peças',
        menu = 'vehicle_mechanic_main',
        options = options
    })
    
    lib.showContext('vehicle_mechanic_parts')
end

-- Comprar peça
function PurchasePart(part)
    local input = lib.inputDialog('Comprar Peça', {
        {
            type = 'number',
            label = 'Quantidade',
            description = 'Quantas unidades deseja comprar?',
            required = true,
            min = 1,
            max = 50,
            default = 1
        }
    })
    
    if not input then return end
    
    local amount = tonumber(input[1])
    local totalPrice = part.price * amount
    
    local alert = lib.alertDialog({
        header = 'Confirmar Compra',
        content = 'Comprar **' .. amount .. 'x ' .. part.label .. '** por **$' .. lib.math.groupdigits(totalPrice) .. '**?',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Comprar',
            cancel = 'Cancelar'
        }
    })
    
    if alert == 'confirm' then
        TriggerServerEvent('vehicle_mechanic:server:buyPart', part, amount)
    end
end