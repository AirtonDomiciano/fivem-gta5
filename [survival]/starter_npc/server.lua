local playerCooldowns = {}
local cooldownTime = 600 -- 10 minutos

RegisterNetEvent('starter_crate:tryKit', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    local license = Player.PlayerData.license
    local now = os.time()

    -- verifica cooldown
    if playerCooldowns[license] and (now - playerCooldowns[license]) < cooldownTime then
        local remaining = math.floor(cooldownTime - (now - playerCooldowns[license]))
        local minutes = math.floor(remaining / 60)
        local seconds = remaining % 60
        
        local timeText = minutes > 0 and 
            string.format("%d minuto(s) e %d segundo(s)", minutes, seconds) or 
            string.format("%d segundo(s)", seconds)
            
        exports.qbx_core:Notify(src, "Aguarde " .. timeText .. " antes de pegar outro kit.", "error", 5000)
        return
    end

    -- salva horário do último kit
    playerCooldowns[license] = now

    -- entrega o kit usando o sistema QBX
    exports.ox_inventory:AddItem(src, 'sandwich', 3)
    exports.ox_inventory:AddItem(src, 'water', 3)
    exports.ox_inventory:AddItem(src, 'bandage', 2)
    exports.ox_inventory:AddItem(src, 'weapon_knife', 1)

    exports.qbx_core:Notify(src, "Você pegou o kit de sobrevivência!", "success", 5000)
    
    TriggerClientEvent('starter_crate:npcVoice', src)
    
    -- Spawna a moto
    TriggerClientEvent('starter_crate:spawnBike', src)
end)

-- Evento para dar as chaves do veículo
RegisterNetEvent('starter_crate:giveKeys', function(plate, netId)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Tenta múltiplos métodos para garantir que as chaves sejam dadas
    
    -- Método 1: qbx_vehiclekeys padrão
    TriggerEvent('qbx_vehiclekeys:server:AcquireVehicleKeys', src, plate)
    
    -- Método 2: Alternativo caso use outro sistema
    TriggerClientEvent('qbx_vehiclekeys:client:AddKeys', src, plate)
    
    -- Método 3: Se usar qb-vehiclekeys legado
    TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
    
    print(string.format('[starter_crate] Chaves dadas ao jogador %s para veículo placa: %s', Player.PlayerData.name, plate))
end)