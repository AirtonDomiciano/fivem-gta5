local QBX = exports.qbx_core

-- Evento de compra de veículo
RegisterNetEvent('vehicle_shop:server:purchaseVehicle', function(vehicle, plate)
    local src = source
    local Player = QBX:GetPlayer(src)
    
    if not Player then return end
    
    -- Verificar se a placa já existe
    local result = MySQL.single.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    
    if result then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Erro',
            description = 'Esta placa já está em uso!',
            type = 'error'
        })
        return
    end
    
    -- Verificar se o jogador tem dinheiro físico suficiente
    local playerCash = Player.PlayerData.money['cash'] or 0
    
    if playerCash < vehicle.price then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Dinheiro Insuficiente',
            description = 'Você precisa de $' .. (vehicle.price - playerCash) .. ' a mais em dinheiro físico!',
            type = 'error'
        })
        return
    end
    
    -- Remover dinheiro
    Player.Functions.RemoveMoney('cash', vehicle.price, 'vehicle-purchase')
    
    -- Adicionar veículo ao banco de dados
    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.license,
        Player.PlayerData.citizenid,
        vehicle.model,
        GetHashKey(vehicle.model),
        '{}',
        plate,
        'pillboxgarage', -- Garagem padrão, ajuste conforme necessário
        0 -- 0 = fora, 1 = dentro
    })
    
    -- Notificar cliente
    TriggerClientEvent('vehicle_shop:client:vehiclePurchased', src, vehicle, plate)
    
    -- Log da compra
    print(string.format('^2[Vehicle Shop]^7 %s (%s) comprou %s por $%s', 
        Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        Player.PlayerData.citizenid,
        vehicle.name,
        vehicle.price
    ))
end)