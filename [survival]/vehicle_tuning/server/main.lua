local QBX = exports.qbx_core

-- Evento de compra de peça
RegisterNetEvent('vehicle_tuning:server:buyPart', function(part, amount)
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
    Player.Functions.RemoveMoney('cash', totalPrice, 'tuning-parts')
    
    -- Adicionar item ao inventário
    local success = exports.ox_inventory:AddItem(src, part.item, amount)
    
    if success then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Compra Realizada',
            description = 'Você comprou ' .. amount .. 'x ' .. part.label,
            type = 'success'
        })
        
        -- Log
        print(string.format('^2[Vehicle Tuning]^7 %s comprou %dx %s por $%s', 
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

-- Obter inventário de peças de tunning
RegisterNetEvent('vehicle_tuning:server:getInventory', function()
    local src = source
    local Player = QBX:GetPlayer(src)
    
    if not Player then return end
    
    -- Coletar todas as peças de tunning
    local tuningItems = {}
    
    for _, category in pairs(Config.TuningParts) do
        for _, part in pairs(category.parts) do
            local itemCount = exports.ox_inventory:GetItemCount(src, part.item)
            
            if itemCount > 0 then
                table.insert(tuningItems, {
                    name = part.item,
                    label = part.label,
                    count = itemCount
                })
            end
        end
    end
    
    TriggerClientEvent('vehicle_tuning:client:showInventory', src, tuningItems)
end)

-- Remover item após instalação
RegisterNetEvent('vehicle_tuning:server:removeItem', function(itemName)
    local src = source
    local Player = QBX:GetPlayer(src)
    
    if not Player then return end
    
    exports.ox_inventory:RemoveItem(src, itemName, 1)
    
    -- Log
    print(string.format('^2[Vehicle Tuning]^7 %s instalou %s', 
        Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        itemName
    ))
end)