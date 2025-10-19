return {
    updateInterval = 5, -- com que frequência atualizar dados do jogador em minutos

    money = {
        ---@alias MoneyType 'cash' | 'bank' | 'crypto'
        ---@alias Money {cash: number, bank: number, crypto: number}
        ---@type Money
        moneyTypes = { cash = 0, bank = 0, crypto = 0 }, -- tipo = valor inicial - Adicionar ou remover tipos de dinheiro para seu servidor (ex. blackmoney = 0), lembre-se que uma vez adicionado não será removido do banco de dados!
        dontAllowMinus = { 'cash', 'crypto' }, -- Dinheiro que não é permitido ficar negativo
        paycheckTimeout = 9999, -- O tempo em minutos que dará o salário
        paycheckSociety = false -- Se verdadeiro, o salário virá da conta da sociedade onde o jogador está empregado
    },

    player = {
        hungerRate = 1.5, -- Taxa em que a fome diminui (configuração para sobrevivência zumbi)
        thirstRate = 1.8, -- Taxa em que a sede diminui (configuração para sobrevivência zumbi)

        ---@enum BloodType
        bloodTypes = {
            'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
        },

        ---@alias UniqueIdType 'citizenid' | 'AccountNumber' | 'PhoneNumber' | 'FingerId' | 'WalletId' | 'SerialNumber'
        ---@type table<UniqueIdType, {valueFunction: function}>
        identifierTypes = {
            citizenid = {
                valueFunction = function()
                    return lib.string.random('A.......')
                end,
            },
            AccountNumber = {
                valueFunction = function()
                    return 'US0' .. math.random(1, 9) .. 'QBX' .. math.random(1111, 9999) .. math.random(1111, 9999) .. math.random(11, 99)
                end,
            },
            PhoneNumber = {
                valueFunction = function()
                    return math.random(100,999) .. math.random(1000000,9999999)
                end,
            },
            FingerId = {
                valueFunction = function()
                    return lib.string.random('...............')
                end,
            },
            WalletId = {
                valueFunction = function()
                    return 'QB-' .. math.random(11111111, 99999999)
                end,
            },
            SerialNumber = {
                valueFunction = function()
                    return math.random(11111111, 99999999)
                end,
            },
        }
    },

    ---@alias TableName string
    ---@alias ColumnName string
    ---@type [TableName, ColumnName][]
    characterDataTables = {
        {'properties', 'owner'},
        {'bank_accounts_new', 'id'},
        {'playerskins', 'citizenid'},
        {'player_mails', 'citizenid'},
        {'player_outfits', 'citizenid'},
        {'player_vehicles', 'citizenid'},
        {'player_groups', 'citizenid'},
        {'players', 'citizenid'},
        {'npwd_calls', 'identifier'},
        {'npwd_darkchat_channel_members', 'user_identifier'},
        {'npwd_marketplace_listings', 'identifier'},
        {'npwd_messages_participants', 'participant'},
        {'npwd_notes', 'identifier'},
        {'npwd_phone_contacts', 'identifier'},
        {'npwd_phone_gallery', 'identifier'},
        {'npwd_twitter_profiles', 'identifier'},
        {'npwd_match_profiles', 'identifier'},
    }, -- Linhas a serem deletadas quando o personagem for deletado

    server = {
        pvp = true, -- Ativar ou desativar PvP no servidor (capacidade de atirar em outros jogadores)
        closed = false, -- Definir servidor fechado (ninguém pode entrar exceto pessoas com permissão ace 'qbadmin.join')
        closedReason = 'Servidor Fechado', -- Mensagem de motivo para exibir quando pessoas não podem entrar no servidor
        whitelist = false, -- Ativar ou desativar whitelist no servidor (configuração para sobrevivência zumbi)
        whitelistPermission = 'admin', -- Permissão que pode entrar no servidor quando a whitelist estiver ativa
        discord = 'https://discord.gg/3RRBhjfugy', -- Link de convite do Discord
        checkDuplicateLicense = true, -- Verificar licença rockstar duplicada ao entrar
        ---@deprecated use cfg ACE system instead
        permissions = { 'god', 'admin', 'mod' }, -- Adicionar quantos grupos quiser aqui após criá-los no seu server.cfg
    },

    characters = {
        playersNumberOfCharacters = { -- Definir quantidade máxima de personagens do jogador por licença rockstar (você pode encontrar esta licença no banco de dados do seu servidor na tabela player)
            ['license2:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = 5,
        },

        defaultNumberOfCharacters = 3, -- Definir quantidade máxima de personagens padrão (máximo 3 personagens definidos por padrão)
    },

    -- esta configuração é apenas para eventos principais. colocar outros webhooks aqui não terá efeito
    logging = {
        webhook = {
            ['default'] = nil, -- padrão
            ['joinleave'] = nil, -- padrão
            ['ooc'] = nil, -- padrão
            ['anticheat'] = nil, -- padrão
            ['playermoney'] = nil, -- padrão
        },
        role = {} -- Função para marcar logs de alta prioridade. Funções usam <@%roleid> e usuários/canais são <@userid/channelid>
    },

    persistence = {
        lockState = 'lock', -- 'lock' : veículo será trancado quando spawnado, 'unlock' : veículo será destrancado quando spawnado
    },

    giveVehicleKeys = function(src, plate, vehicle)
        return exports.qbx_vehiclekeys:GiveKeys(src, vehicle)
    end,

    setVehicleLock = function(vehicle, state)
        exports.qbx_vehiclekeys:SetLockState(vehicle, state)
    end,

    getSocietyAccount = function(accountName)
        return exports['Renewed-Banking']:getAccountMoney(accountName)
    end,

    removeSocietyMoney = function(accountName, payment)
        return exports['Renewed-Banking']:removeAccountMoney(accountName, payment)
    end,

    ---Paycheck function
    ---@param player Player Player object
    ---@param payment number Payment amount
    sendPaycheck = function (player, payment)
        player.Functions.AddMoney('bank', payment)
        Notify(player.PlayerData.source, locale('info.received_paycheck', payment))
    end,
}
