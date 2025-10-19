return {
    statusIntervalSeconds = 5, -- com que frequência verificar status de fome/sede para remover saúde se 0.
    loadingModelsTimeout = 30000, -- Tempo de espera para ox_lib carregar os modelos antes de lançar um erro, para PC de baixa especificação

    pauseMapText = 'Cria de Pato', -- Texto mostrado acima do mapa quando ESC é pressionado. Se deixado vazio 'FiveM' aparecerá

    characters = {
        useExternalCharacters = false, -- Se você tem um recurso de gerenciamento de personagens externo. (Se verdadeiro, desabilita o gerenciamento de personagens dentro do core)
        enableDeleteButton = true, -- Se os jogadores devem poder deletar personagens eles mesmos.
        startingApartment = false, -- Se definido como falso, pula a escolha de apartamento no início (requer qbx_spawn se verdadeiro)

        dateFormat = 'YYYY-MM-DD',
        dateMin = '1900-01-01', -- Deve estar no mesmo formato que o dateFormat config
        dateMax = '2006-12-31', -- Deve estar no mesmo formato que o dateFormat config

        limitNationalities = true, -- Definir isso como falso permitirá que as pessoas digam o que quiserem no campo nacionalidade (Para editar a lista de nacionalidades, vá para data/nationalities.lua)

        profanityWords = {
            ['bad word'] = true
        },

        locations = { -- Localizações de spawn para multichar, estas são escolhidas aleatoriamente
            {
                pedCoords = vec4(969.25, 72.61, 116.18, 276.55),
                camCoords = vec4(972.2, 72.9, 116.68, 97.27),
            },
            {
                pedCoords = vec4(1104.49, 195.9, -49.44, 44.22),
                camCoords = vec4(1102.29, 198.14, -48.86, 225.07),
            },
            {
                pedCoords = vec4(-2163.87, 1134.51, -24.37, 310.05),
                camCoords = vec4(-2161.7, 1136.4, -23.77, 131.52),
            },
            {
                pedCoords = vec4(-996.71, -68.07, -99.0, 57.61),
                camCoords = vec4(-999.90, -66.30, -98.45, 241.68),
            },
            {
                pedCoords = vec4(-1023.45, -418.42, 67.66, 205.69),
                camCoords = vec4(-1021.8, -421.7, 68.14, 27.11),
            },
            {
                pedCoords = vec4(2265.27, 2925.02, -84.8, 267.77),
                camCoords = vec4(2268.24, 2925.02, -84.36, 90.88),
            },
            {
                pedCoords = vec4(-1004.5, -478.51, 50.03, 28.19),
                camCoords = vec4(-1006.36, -476.19, 50.50, 210.38),
            }
        },
    },

    discord = {
        enabled = true, -- Isso habilitará ou desabilitará o discord rich presence integrado.

        appId = '1428212745517531177', -- Este é o ID da Aplicação (Substitua por seu próprio)

        largeIcon = { -- Para configurar isso, visite https://forum.cfx.re/t/how-to-updated-discord-rich-presence-custom-image/157686
            icon = 'duck', -- Aqui você terá que colocar o nome da imagem para o ícone 'grande'.
            text = 'Qbox Ducky', -- Aqui você pode adicionar texto de hover para o ícone 'grande'.
        },

        smallIcon = {
            icon = 'logo_name', -- Aqui você terá que colocar o nome da imagem para o ícone 'pequeno'.
            text = 'Este é um pequeno ícone com texto', -- Aqui você pode adicionar texto de hover para o ícone 'pequeno'.
        },

        firstButton = {
            text = 'Qbox Discord',
            link = 'https://discord.gg/Z6Whda5hHA',
        },

        secondButton = {
            text = 'Site Principal',
            link = 'https://www.qbox.re/',
        }
    },

    --- Usado apenas pela ponte QB
    hasKeys = function(plate, vehicle)
        return exports.qbx_vehiclekeys:HasKeys(vehicle)
    end,
}
