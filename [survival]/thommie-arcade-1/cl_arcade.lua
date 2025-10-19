MenuCore = 'ox' -- manter
TargetCore = 'ox' -- manter

local arcades = {
    'prop_arcade_01',
    'ch_prop_arcade_degenatron_01a',
    'ch_prop_arcade_monkey_01a',
    'ch_prop_arcade_penetrator_01a',
    'ch_prop_arcade_space_01a',
    'ch_prop_arcade_invade_01a',
    'ch_prop_arcade_street_01a',
    'ch_prop_arcade_street_01b',
    'ch_prop_arcade_street_01c',
    'ch_prop_arcade_street_01d',
    'ch_prop_arcade_street_02b',
    'ch_prop_arcade_wizard_01a',
    'sum_prop_arcade_qub3d_01a',
}

-- Alvo (ox_target)
exports.ox_target:addModel(arcades, {
    {
        name = 'arcade_machine',
        icon = 'fas fa-gamepad',
        label = 'Jogar Fliperama',
        onSelect = function()
            TriggerEvent('arcade:menu')
        end,
    },
})

-- Menu de seleção
RegisterNetEvent('arcade:menu', function()
    lib.registerContext({
        id = 'arcade_menu',
        title = 'Fliperama',
        options = {
            {
                title = 'Thermite (€250)',
                description = 'Memorize todos os blocos!',
                icon = 'dice-d6',
                event = 'arcade:startGame',
                args = {game = 'thermite', price = 250},
            },
            {
                title = 'Numbermaze (€300)',
                description = 'Caminhe do ponto A até o ponto B.',
                icon = 'puzzle-piece',
                event = 'arcade:startGame',
                args = {game = 'numbermaze', price = 300},
            },
            {
                title = 'VAR (€350)',
                description = 'Lembre a sequência correta.',
                icon = 'hashtag',
                event = 'arcade:startGame',
                args = {game = 'var', price = 350},
            },
            {
                title = 'Scrambler (€400)',
                description = 'Acerte os caracteres certos!',
                icon = 'magnifying-glass',
                event = 'arcade:startGame',
                args = {game = 'scrambler', price = 400},
            },
        }
    })
    lib.showContext('arcade_menu')
end)

-- Lógica dos minigames
RegisterNetEvent('arcade:startGame', function(data)
    local result = lib.callback.await('arcade:playGame', false, data.price)
    if not result then
        lib.notify({description = 'Dinheiro insuficiente!', type = 'error'})
        return
    end

    if data.game == 'thermite' then
        exports['ps-ui']:Thermite(function(success)
            if success then
                lib.notify({description = 'Você completou o minigame!', type = 'success'})
            else
                lib.notify({description = 'Falhou, tente novamente!', type = 'error'})
            end
        end, 10, 5, 3)
    elseif data.game == 'numbermaze' then
        exports['ps-ui']:Maze(function(success)
            if success then
                lib.notify({description = 'Você completou o minigame!', type = 'success'})
            else
                lib.notify({description = 'Falhou, tente novamente!', type = 'error'})
            end
        end, 20)
    elseif data.game == 'scrambler' then
        local types = {'alphabet', 'numeric', 'alphanumeric', 'greek', 'braille', 'runes'}
        local currentType = types[math.random(1, #types)]
        exports['ps-ui']:Scrambler(function(success)
            if success then
                lib.notify({description = 'Você completou o minigame!', type = 'success'})
            else
                lib.notify({description = 'Falhou, tente novamente!', type = 'error'})
            end
        end, currentType, math.random(20, 50), 0)
    elseif data.game == 'var' then
        exports['ps-ui']:VarHack(function(success)
            if success then
                lib.notify({description = 'Você completou o minigame!', type = 'success'})
            else
                lib.notify({description = 'Falhou, tente novamente!', type = 'error'})
            end
        end, math.random(3, 8), math.random(3, 12))
    end
end)
