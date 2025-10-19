local QBX = exports.qbx_core

lib.callback.register('arcade:playGame', function(source, price)
    local player = QBX:GetPlayer(source)
    if not player then return false end

    if player.Functions.RemoveMoney('cash', price, 'arcade-minigame') then
        return true
    end

    return false
end)
