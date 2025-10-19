local npcModel = `s_m_y_marine_01`
local npcCoords = vector3(188.74, 2782.77, 45.66)
local npcHeading = 192.4
local npcName = "Sargento Oliveira - Kit Inicial"
local npc = nil
local interactionDistance = 4.0

----------------------------------------------------------
-- 🪖 Spawn do NPC
----------------------------------------------------------
CreateThread(function()
    RequestModel(npcModel)
    local waited = 0
    while not HasModelLoaded(npcModel) do
        Wait(10)
        waited = waited + 10
        if waited > 5000 then
            print("^1[starter_crate] ERRO: modelo do NPC não carregou.^7")
            return
        end
    end

    npc = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, npcCoords.z - 1.0, npcHeading, false, true)
    if not DoesEntityExist(npc) then
        print("^1[starter_crate] ERRO: falha ao criar o NPC.^7")
        return
    end

    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)

    -- animação de guarda
    RequestAnimDict("amb@world_human_guard_stand@male@idle_a")
    while not HasAnimDictLoaded("amb@world_human_guard_stand@male@idle_a") do Wait(10) end
    TaskPlayAnim(npc, "amb@world_human_guard_stand@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false)

    print('[starter_crate] NPC militar "' .. npcName .. '" criado.')
end)

----------------------------------------------------------
-- 🎯 Interação com Tecla E
----------------------------------------------------------
CreateThread(function()
    local showing3DText = false
    
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        
        if npc and DoesEntityExist(npc) then
            local npcPos = GetEntityCoords(npc)
            local dist = #(pedCoords - npcPos)
            
            if dist <= interactionDistance then
                sleep = 0
                showing3DText = true
                
                -- Desenha o texto 3D
                DrawText3D(npcPos.x, npcPos.y, npcPos.z + 1.0, '[~g~E~w~] Falar com ' .. npcName)
                
                -- Verifica se pressionou E
                if IsControlJustReleased(0, 38) then -- 38 = E
                    TriggerServerEvent('starter_crate:tryKit')
                end
            else
                if showing3DText then
                    showing3DText = false
                end
            end
        end
        
        Wait(sleep)
    end
end)

----------------------------------------------------------
-- 🗣️ Fala e continência militar
----------------------------------------------------------
RegisterNetEvent('starter_crate:npcVoice', function()
    if npc and DoesEntityExist(npc) then
        local ped = PlayerPedId()
        TaskLookAtEntity(npc, ped, 3000, 2048, 3)

        -- animação de continência
        RequestAnimDict("anim@mp_player_intincarsalutestd@ps@")
        while not HasAnimDictLoaded("anim@mp_player_intincarsalutestd@ps@") do Wait(10) end
        TaskPlayAnim(npc, "anim@mp_player_intincarsalutestd@ps@", "idle_a", 8.0, -8.0, 3000, 48, 0, false, false, false)

        -- fala
        PlayAmbientSpeech1(npc, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
    end

    exports.qbx_core:Notify("Boa sorte, recruta!", "primary", 4000)
end)

----------------------------------------------------------
-- 🏍️ Moto do jogador
----------------------------------------------------------
RegisterNetEvent('starter_crate:spawnBike', function()
    local ped = PlayerPedId()
    local vehicleModel = `faggio2`
    
    -- Coordenada fixa para spawn da moto
    local spawnCoords = vector4(188.38, 2786.69, 45.6, 276.51)
    
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do Wait(10) end

    local veh = CreateVehicle(vehicleModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)
    
    if not DoesEntityExist(veh) then
        exports.qbx_core:Notify("Falha ao criar veículo, tente novamente.", "error")
        return
    end

    SetVehicleOnGroundProperly(veh)
    local plate = GetVehicleNumberPlateText(veh)
    
    -- QBX usa ox_fuel por padrão
    Entity(veh).state.fuel = 100
    
    FreezeEntityPosition(veh, true)
    Wait(500)
    FreezeEntityPosition(veh, false)

    -- Envia a placa para o servidor dar as chaves
    TriggerServerEvent('starter_crate:giveKeys', plate, NetworkGetNetworkIdFromEntity(veh))
    
    -- Aguarda um pouco e coloca o jogador na moto
    Wait(500)
    SetPedIntoVehicle(ped, veh, -1)
    
    exports.qbx_core:Notify("Você recebeu uma motinha de sobrevivência!", "success", 5000)
end)

----------------------------------------------------------
-- 🏷️ Nome flutuante (com distância e escala dinâmica)
----------------------------------------------------------
CreateThread(function()
    local drawDistance = 15.0

    while true do
        if npc and DoesEntityExist(npc) then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local npcCoords = GetEntityCoords(npc)
            local dist = #(playerCoords - npcCoords)

            if dist <= drawDistance then
                local onScreen, _x, _y = World3dToScreen2d(npcCoords.x, npcCoords.y, npcCoords.z + 1.2)
                if onScreen then
                    local scale = 0.45 - (dist / drawDistance) * 0.25
                    if scale < 0.25 then scale = 0.25 end

                    SetTextFont(4)
                    SetTextProportional(1)
                    SetTextScale(scale, scale)
                    SetTextColour(255, 255, 255, math.floor(255 - (dist / drawDistance) * 200))
                    SetTextCentre(1)
                    SetTextEntry("STRING")
                    AddTextComponentString(npcName)
                    DrawText(_x, _y)
                end
            end
        end
        Wait(0)
    end
end)

----------------------------------------------------------
-- 📝 Função auxiliar para desenhar texto 3D
----------------------------------------------------------
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end