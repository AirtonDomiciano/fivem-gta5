Config = {}

-- Sistema de pagamento (apenas dinheiro físico)
Config.PaymentType = 'cash' -- 'cash' para dinheiro físico

-- Configuração do ox_target
Config.Target = {
    distance = 2.0, -- Distância máxima para interação
    useKey = true,  -- Usar tecla E para interagir
}

-- Configuração de NPCs
Config.NPCs = {
    {
        name = 'Vendedor de Veículos - Observatório',
        model = 'a_m_y_business_01',
        coords = vec4(-423.29, 1196.17, 324.64, 222.32), -- Ajuste as coordenadas
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        blip = {
            enabled = true,
            sprite = 326,
            color = 3,
            scale = 0.8,
            label = 'Loja de Veículos'
        }
    },
    -- Adicione mais locais aqui se necessário
    -- {
    --     name = 'Vendedor de Veículos - Centro',
    --     model = 'a_m_y_business_02',
    --     coords = vector4(x, y, z, heading),
    --     scenario = 'WORLD_HUMAN_CLIPBOARD',
    --     blip = { enabled = true, sprite = 326, color = 3, scale = 0.8, label = 'Loja de Veículos' }
    -- }
}

-- Veículos disponíveis para venda
Config.Vehicles = {
    -- Carros Compactos
    {
        category = 'Compactos',
        vehicles = {
            {
                model = 'blista',
                name = 'Blista',
                price = 15000,
                image = 'nui://qbx_core/html/img/blista.png' -- ou seu caminho de imagem
            },
            {
                model = 'issi2',
                name = 'Weeny Issi',
                price = 12000,
                image = 'nui://qbx_core/html/img/issi2.png'
            },
        }
    },
    -- Sedans
    {
        category = 'Sedans',
        vehicles = {
            {
                model = 'asea',
                name = 'Declasse Asea',
                price = 25000,
                image = 'nui://qbx_core/html/img/asea.png'
            },
            {
                model = 'premier',
                name = 'Declasse Premier',
                price = 35000,
                image = 'nui://qbx_core/html/img/premier.png'
            },
            {
                model = 'fugitive',
                name = 'Cheval Fugitive',
                price = 45000,
                image = 'nui://qbx_core/html/img/fugitive.png'
            },
        }
    },
    -- SUVs
    {
        category = 'SUVs',
        vehicles = {
            {
                model = 'baller',
                name = 'Gallivanter Baller',
                price = 75000,
                image = 'nui://qbx_core/html/img/baller.png'
            },
            {
                model = 'cavalcade',
                name = 'Albany Cavalcade',
                price = 65000,
                image = 'nui://qbx_core/html/img/cavalcade.png'
            },
        }
    },
    -- Esportivos
    {
        category = 'Esportivos',
        vehicles = {
            {
                model = 'comet2',
                name = 'Pfister Comet',
                price = 150000,
                image = 'nui://qbx_core/html/img/comet2.png'
            },
            {
                model = 'futo',
                name = 'Karin Futo',
                price = 85000,
                image = 'nui://qbx_core/html/img/futo.png'
            },
        }
    },
}

-- Configurações de teste de direção
Config.TestDrive = {
    enabled = true,
    duration = 60, -- segundos
    spawnOffset = vector3(5.0, 0.0, 0.0) -- offset do spawn do veículo
}