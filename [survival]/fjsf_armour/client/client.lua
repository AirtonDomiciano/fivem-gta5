local PlayerArmour = 0
local isVestOn = false
local IsLoaded

if Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(playerData)
        Wait(1500)
        TriggerServerEvent("dp_armour:getArmour")
        IsLoaded = true
    end)

    IsPlayerLoaded = ESX.IsPlayerLoaded()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        Wait(1500)
        TriggerServerEvent("dp_armour:getArmour")
        IsLoaded = true
    end)

    IsPlayerLoaded = QBCore.Functions.GetPlayerData().citizenid ~= nil
end

TriggerServerEvent("dp_armour:getArmour")

RegisterNetEvent('dp_armour:getData_client')
AddEventHandler('dp_armour:getData_client', function(armour)
    PlayerArmour = armour
end)

RegisterNetEvent('dp_armour:isWearingVest')
AddEventHandler('dp_armour:isWearingVest', function()
    if Config.UseVestModel then
        SetPedComponentVariation(PlayerPedId(), 9, Config.VestModel, Config.VestColor, 2)
    end
    isVestOn = true
end)

Citizen.CreateThread(function()
    while true do
        if IsLoaded or IsPlayerLoaded then
            local playerped = PlayerPedId()
            TriggerServerEvent("dp_armour:getData")
            local getArmour = GetPedArmour(playerped)
            if isVestOn and getArmour ~= PlayerArmour then
                TriggerServerEvent("dp_armour:saveDataTo", getArmour)
            end
            if getArmour == 0 and isVestOn and not IsPedDeadOrDying(playerped) then
                TriggerServerEvent("dp_armour:remarmour", getArmour)
                lib.notify({title = 'Armour', description = 'Armour has been removed', type = 'info'})
                if Config.UseVestModel then
                    SetPedComponentVariation(playerped, 9, 0, 0, 0)
                end
                isVestOn = false
            end
        end
        Wait(Config.RefreshTime)
    end
end)

RegisterNetEvent("dp_armour:addArmour")
AddEventHandler("dp_armour:addArmour", function(amount)
    local playerped = PlayerPedId()
    SetPedArmour(playerped, amount)
end)

RegisterCommand(Config.RemoveCommand, function()
    local playerped = PlayerPedId()
    local getArmour = GetPedArmour(playerped)
    if isVestOn and not IsPedDeadOrDying(playerped) then
        TriggerServerEvent("dp_armour:remarmour", getArmour)
        TriggerEvent("dp_armour:addArmour", 0)
        lib.notify({title = 'Armour', description = 'Armour has been removed', type = 'info'})
        isVestOn = false
    end
    if Config.UseVestModel then
        SetPedComponentVariation(playerped, 9, 0, 0, 0)
    end

end)

