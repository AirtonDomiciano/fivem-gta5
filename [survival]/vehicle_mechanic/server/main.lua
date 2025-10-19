local QBX = exports.qbx_core

-- Evento de reparo
RegisterNetEvent('vehicle_mechanic:server:repair', function(service)
    local src = source
    local Player = QBX:GetPlayer(src)
    
    if not Player then return end
    
    local playerCash = Player.PlayerData.money['cash'] or 0
    
    if playerCash < service.price then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Dinheiro Insuficiente',
            description = 'Você precisa de $' .. (service.price - playerCash) .. ' a mais em dinheiro físico!',
            type = 'error'
        })
        return
    end
    
    -- Remover dinheiro
    Player.Functions.RemoveMoney('cash', service.price, 'vehicle-repair')
    
    -- Executar reparo no cliente
    TriggerClientEvent('vehicle_mechanic:client:performRepair', src, service)
    
    -- Log
    print(string.format('^2[Vehicle Mechanic]^7 %s realizou %s por $%s', 
        Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        service.label,
        service.price
    ))
end)

-- Evento de compra de peças
RegisterNetEvent('vehicle_mechanic:server:buyPart', function(part, amount)
    local src = source
    local Player = QBX:GetPlayer(src)
    
    if not Player then return end
    
    local totalPrice = part.price * amount
    local playerCash = Player.PlayerData.money['cash'] or 0
    
    if playerCash < totalPrice then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Dinheiro Insuficiente',
            description = 'Você precisa de $' .. (totalPrice - playerCash) .. ' a mais em dinheiro físico!',
            type = 'error'
        })
        return
    end
    
    -- Remover dinheiro
    Player.Functions.RemoveMoney('cash', totalPrice, 'vehicle-parts')
    
    -- Adicionar item ao inventário
    local success = exports.ox_inventory:AddItem(src, part.item, amount)
    
    if success then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Compra Realizada',
            description = 'Você comprou ' .. amount .. 'x ' .. part.label,
            type = 'success'
        })
        
        -- Log
        print(string.format('^2[Vehicle Mechanic]^7 %s comprou %dx %s por $%s', 
            Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
            amount,
            part.label,
            totalPrice
        ))
    else
        -- Devolver dinheiro se falhar
        Player.Functions.AddMoney('cash', totalPrice)
        
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Erro',
            description = 'Não foi possível adicionar o item ao inventário!',
            type = 'error'
        })
    end
end)