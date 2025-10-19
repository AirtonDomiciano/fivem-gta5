-- Abrir menu principal
RegisterNetEvent('vehicle_tuning:client:openMenu', function()
    local options = {}
    
    for _, category in pairs(Config.TuningParts) do
        table.insert(options, {
            title = category.category,
            description = #category.parts .. ' peças disponíveis',
            icon = 'car',
            onSelect = function()
                OpenCategoryMenu(category)
            end
        })
    end
    
    -- Adicionar opção para instalar peças
    table.insert(options, {
        title = '🔧 Instalar Peças',
        description = 'Instalar peças de tunning que você possui',
        icon = 'wrench',
        onSelect = function()
            OpenInstallMenu()
        end
    })
    
    lib.registerContext({
        id = 'vehicle_tuning_main',
        title = '🎨 Loja de Tunning',
        options = options
    })
    
    lib.showContext('vehicle_tuning_main')
end)

-- Abrir menu de categoria
function OpenCategoryMenu(category)
    local options = {}
    
    for _, part in pairs(category.parts) do
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
        id = 'vehicle_tuning_category',
        title = category.category,
        menu = 'vehicle_tuning_main',
        options = options
    })
    
    lib.showContext('vehicle_tuning_category')
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
            max = 10,
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
        TriggerServerEvent('vehicle_tuning:server:buyPart', part, amount)
    end
end

-- Menu de instalação
function OpenInstallMenu()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        lib.notify({
            title = 'Erro',
            description = 'Você precisa estar em um veículo para instalar peças!',
            type = 'error'
        })
        return
    end
    
    -- Pegar inventário do jogador
    TriggerServerEvent('vehicle_tuning:server:getInventory')
end

-- Mostrar peças disponíveis para instalação
RegisterNetEvent('vehicle_tuning:client:showInventory', function(items)
    if #items == 0 then
        lib.notify({
            title = 'Sem Peças',
            description = 'Você não possui peças de tunning para instalar!',
            type = 'error'
        })
        return
    end
    
    local options = {}
    
    for _, item in pairs(items) do
        table.insert(options, {
            title = item.label,
            description = 'Quantidade: ' .. item.count,
            icon = 'wrench',
            onSelect = function()
                InstallPart(item)
            end
        })
    end
    
    lib.registerContext({
        id = 'vehicle_tuning_install',
        title = '🔧 Instalar Peças',
        menu = 'vehicle_tuning_main',
        options = options
    })
    
    lib.showContext('vehicle_tuning_install')
end)

-- Instalar peça
function InstallPart(item)
    local alert = lib.alertDialog({
        header = 'Instalar Peça',
        content = 'Deseja instalar **' .. item.label .. '**?  \n  \nA peça será consumida do seu inventário.',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Instalar',
            cancel = 'Cancelar'
        }
    })
    
    if alert == 'confirm' then
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
        
        -- Animação de instalação
        lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        TaskPlayAnim(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, -8.0, -1, 1, 0, false, false, false)
        
        if lib.progressBar({
            duration = Config.InstallationTime * 1000,
            label = 'Instalando ' .. item.label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            }
        }) then
            StopAnimTask(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1.0)
            
            -- Aplicar modificações no veículo baseado no item
            ApplyModification(vehicle, item.name)
            
            -- Remover item do inventário
            TriggerServerEvent('vehicle_tuning:server:removeItem', item.name)
            
            lib.notify({
                title = 'Instalação Completa',
                description = item.label .. ' instalado com sucesso!',
                type = 'success'
            })
        else
            StopAnimTask(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1.0)
            lib.notify({
                title = 'Cancelado',
                description = 'Instalação cancelada!',
                type = 'error'
            })
        end
    end
end

-- Aplicar modificações no veículo
function ApplyModification(vehicle, itemName)
    -- Performance
    if itemName == 'turbo' then
        ToggleVehicleMod(vehicle, 18, true)
    elseif itemName == 'engine_upgrade' then
        SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false)
    elseif itemName == 'transmission' then
        SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13) - 1, false)
    elseif itemName == 'suspension' then
        SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15) - 1, false)
    elseif itemName == 'brakes' then
        SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false)
    
    -- Visual
    elseif itemName == 'spoiler' then
        SetVehicleMod(vehicle, 0, math.random(0, GetNumVehicleMods(vehicle, 0) - 1), false)
    elseif itemName == 'hood' then
        SetVehicleMod(vehicle, 7, math.random(0, GetNumVehicleMods(vehicle, 7) - 1), false)
    elseif itemName == 'bumper' then
        SetVehicleMod(vehicle, 1, math.random(0, GetNumVehicleMods(vehicle, 1) - 1), false)
    elseif itemName == 'side_skirt' then
        SetVehicleMod(vehicle, 3, math.random(0, GetNumVehicleMods(vehicle, 3) - 1), false)
    
    -- Rodas
    elseif itemName == 'custom_wheels' then
        SetVehicleMod(vehicle, 23, math.random(0, GetNumVehicleMods(vehicle, 23) - 1), false)
    elseif itemName == 'wheel_smoke' then
        SetVehicleModColor_2(vehicle, math.random(0, 12), 0)
        ToggleVehicleMod(vehicle, 20, true)
    
    -- Iluminação
    elseif itemName == 'xenon_lights' then
        ToggleVehicleMod(vehicle, 22, true)
        SetVehicleXenonLightsColour(vehicle, math.random(0, 12))
    elseif itemName == 'neon_kit' then
        SetVehicleNeonLightEnabled(vehicle, 0, true)
        SetVehicleNeonLightEnabled(vehicle, 1, true)
        SetVehicleNeonLightEnabled(vehicle, 2, true)
        SetVehicleNeonLightEnabled(vehicle, 3, true)
        SetVehicleNeonLightsColour(vehicle, math.random(0, 255), math.random(0, 255), math.random(0, 255))
    
    -- Som
    elseif itemName == 'horn_upgrade' then
        -- Buzina customizada já funciona com veículo modificado
    end
end