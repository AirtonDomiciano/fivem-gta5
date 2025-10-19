local spawnedNPCs = {}
local currentNPCLabel = nil
local showingText = false

-- Função para spawnar NPCs
local function SpawnNPC(npcData)
    local hash = GetHashKey(npcData.model)
    
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(100)
    end
    
    local npc = CreatePed(4, hash, npcData.coords.x, npcData.coords.y, npcData.coords.z, npcData.coords.w, false, true)
    
    SetEntityAsMissionEntity(npc, true, true)
    SetPedFleeAttributes(npc, 0, 0)
    SetPedDiesWhenInjured(npc, false)
    SetPedKeepTask(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    
    -- Aplicar cenário se configurado
    if npcData.scenario then
        TaskStartScenarioInPlace(npc, npcData.scenario, 0, true)
    end
    
    -- Armazenar dados do NPC para sistema de interação por tecla E
    table.insert(spawnedNPCs, {
        ped = npc, 
        coords = vector3(npcData.coords.x, npcData.coords.y, npcData.coords.z),
        label = 'Comprar Veículo',
        blip = nil
    })
    
    -- Criar blip se habilitado
    if npcData.blip and npcData.blip.enabled then
        local blip = AddBlipForCoord(npcData.coords.x, npcData.coords.y, npcData.coords.z)
        SetBlipSprite(blip, npcData.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, npcData.blip.scale)
        SetBlipColour(blip, npcData.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(npcData.blip.label)
        EndTextCommandSetBlipName(blip)
        
        -- Atualizar o último NPC adicionado com o blip
        local lastNPC = spawnedNPCs[#spawnedNPCs]
        if lastNPC then
            lastNPC.blip = blip
        end
    end
    
    SetModelAsNoLongerNeeded(hash)
end

-- Sistema de detecção de proximidade e interação por tecla E
CreateThread(function()
    Wait(3000) -- Aguardar NPCs spawnarem completamente
    
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = 500
        local inRange = false
        local currentNPC = nil
        
        for i, npcData in pairs(spawnedNPCs) do
            if DoesEntityExist(npcData.ped) and npcData.coords then
                local distance = #(playerCoords - npcData.coords)
                
                if distance <= Config.Target.distance then
                    inRange = true
                    currentNPC = npcData
                    sleep = 0
                    break -- Sair do loop quando encontrar o primeiro NPC próximo
                end
            end
        end
        
        if inRange and currentNPC then
            local newLabel = '[E] ' .. currentNPC.label
            
            -- Sempre mostrar/atualizar o texto quando próximo
            if not showingText then
                lib.showTextUI(newLabel)
                showingText = true
                currentNPCLabel = newLabel
            elseif currentNPCLabel ~= newLabel then
                lib.hideTextUI()
                Wait(100)
                lib.showTextUI(newLabel)
                currentNPCLabel = newLabel
            end
            
            -- Verificar se a tecla E foi pressionada
            if IsControlJustPressed(0, 38) then -- 38 é a tecla E
                TriggerEvent('vehicle_shop:client:openMenu')
            end
        else
            -- Não está próximo de nenhum NPC
            if showingText then
                lib.hideTextUI()
                showingText = false
                currentNPCLabel = nil
            end
        end
        
        Wait(sleep)
    end
end)

-- Spawnar todos os NPCs ao iniciar
CreateThread(function()
    Wait(1000) -- Aguardar o jogo carregar
    
    for _, npcData in pairs(Config.NPCs) do
        SpawnNPC(npcData)
    end
    
    print('^2[Vehicle Shop]^7 ' .. #Config.NPCs .. ' NPCs spawnados com sucesso!')
end)

-- Limpar NPCs ao sair
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Esconder texto se estiver mostrando
    if showingText then
        lib.hideTextUI()
        showingText = false
        currentNPCLabel = nil
    end
    
    for _, npcData in pairs(spawnedNPCs) do
        if DoesEntityExist(npcData.ped) then
            DeleteEntity(npcData.ped)
        end
        if npcData.blip then
            RemoveBlip(npcData.blip)
        end
    end
end)