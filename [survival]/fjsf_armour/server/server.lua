lib.versionCheck('Dannyfjsff/fjsf_armour')

if Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()

    function GetPlayerFromId(source)
        return ESX.GetPlayerFromId(source)
    end

    function GetIdentifier(xPlayer)
        return xPlayer.identifier
    end

elseif Config.Framework == 'qbcore' then
    QBCore = exports["qb-core"]:GetCoreObject()

    function GetPlayerFromId(source)
        return QBCore.Functions.GetPlayer(source)
    end

    function GetIdentifier(xPlayer)
        return xPlayer.PlayerData.citizenid
    end

end

RegisterNetEvent("dp_armour:getArmour")
AddEventHandler("dp_armour:getArmour", function()
    local xPlayer = GetPlayerFromId(source)
    if xPlayer then
        local identifier = GetIdentifier(xPlayer)
        local a = source
        MySQL.ready(function()
            MySQL.prepare('SELECT amount FROM player_armour WHERE identifier = ?', {identifier}, function(response)
                if response ~= -1 and response ~= nil then
                    TriggerClientEvent("dp_armour:addArmour", a, response)
                    TriggerClientEvent("dp_armour:isWearingVest", a)
                end
            end)
        end)
    end
end)

function SaveData(source, getArmour)
    local xPlayer = GetPlayerFromId(source)
    if xPlayer then
        MySQL.ready(function()
            local identifier = GetIdentifier(xPlayer)
            MySQL.prepare(
                'INSERT INTO player_armour (identifier, amount) VALUES (?, ?) ON DUPLICATE KEY UPDATE amount = VALUES(amount)',
                {identifier, getArmour})
        end)
        TriggerClientEvent("dp_armour:addArmour", source, getArmour)
    end
end

RegisterNetEvent('dp_armour:saveData')
AddEventHandler('dp_armour:saveData', function(getArmour)
    SaveData(source, getArmour)
    TriggerClientEvent("dp_armour:isWearingVest", source)
end)

RegisterNetEvent('dp_armour:saveDataTo')
AddEventHandler('dp_armour:saveDataTo', function(getArmour)
    SaveData(source, getArmour)
end)

RegisterNetEvent('dp_armour:getData')
AddEventHandler('dp_armour:getData', function()
    local xPlayer = GetPlayerFromId(source)
    if xPlayer then
        local identifier = GetIdentifier(xPlayer)
        local response
        local a = source
        MySQL.ready(function()
            MySQL.prepare('SELECT amount FROM player_armour WHERE identifier = ?', {identifier}, function(response)
                TriggerClientEvent("dp_armour:getData_client", a, response)
            end)
        end)
    end
end)

RegisterNetEvent('dp_armour:deleteData')
AddEventHandler('dp_armour:deleteData', function(source)
    local xPlayer = GetPlayerFromId(source)
    if xPlayer then
        MySQL.ready(function()
            local identifier = GetIdentifier(xPlayer)
            local amount = -1
            MySQL.prepare(
                'INSERT INTO player_armour (identifier, amount) VALUES (?, ?) ON DUPLICATE KEY UPDATE amount = VALUES(amount)',
                {identifier, amount})
        end)
    end
end)

RegisterNetEvent('dp_armour:remarmour')
AddEventHandler('dp_armour:remarmour', function(getArmour)
    local success, response = exports.ox_inventory:AddItem(source, 'armour_vest', 1, {durability = getArmour})
    TriggerEvent("dp_armour:deleteData", source)
end)
