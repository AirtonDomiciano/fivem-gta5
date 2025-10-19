Config = {}

-- Sistema de pagamento (apenas dinheiro físico)
Config.PaymentType = 'cash'

-- Configuração do ox_target
Config.Target = {
    distance = 2.0, -- Distância máxima para interação
    useKey = true,  -- Usar tecla E para interagir
}

-- Configuração de NPCsvec4(218.13, 2776.8, 45.66, 342.15)
Config.NPCs = {
    {
        name = 'Mecânico - Observatório',
        model = 's_m_y_xmech_01',
        coords = vec4(-410.39, 1234.56, 324.64, 252.64), -- Ajuste as coordenadas
        scenario = 'WORLD_HUMAN_WELDING',
        blip = {
            enabled = true,
            sprite = 446,
            color = 17,
            scale = 0.8,
            label = 'Mecânico'
        }
    },
	{
        name = 'Mecânico - harmony',
        model = 's_m_y_xmech_02',
        coords = vec4(218.13, 2776.8, 44.66, 342.15), -- Ajuste as coordenadas
        scenario = 'WORLD_HUMAN_WELDING',
        blip = {
            enabled = true,
            sprite = 446,
            color = 17,
            scale = 0.8,
            label = 'Mecânico'
        }
    }
}

-- Serviços de manutenção
Config.RepairServices = {
    {
        label = 'Reparar Veículo Completo',
        description = 'Repara todos os danos do veículo',
        price = 500,
        icon = 'wrench',
        type = 'full_repair'
    },
    {
        label = 'Reparar Motor',
        description = 'Repara apenas o motor do veículo',
        price = 250,
        icon = 'cog',
        type = 'engine'
    },
    {
        label = 'Reparar Carroceria',
        description = 'Repara apenas a carroceria',
        price = 200,
        icon = 'car-crash',
        type = 'body'
    },
    {
        label = 'Limpar Veículo',
        description = 'Limpa completamente o veículo',
        price = 50,
        icon = 'soap',
        type = 'clean'
    }
}

-- Peças de reparo disponíveis para compra
Config.RepairParts = {
    {
        item = 'repair_kit',
        label = 'Kit de Reparo',
        description = 'Kit completo para reparos básicos',
        price = 150,
        icon = 'toolbox'
    },
    {
        item = 'engine_oil',
        label = 'Óleo de Motor',
        description = 'Óleo para manutenção do motor',
        price = 50,
        icon = 'oil-can'
    },
    {
        item = 'tire',
        label = 'Pneu',
        description = 'Pneu sobressalente',
        price = 80,
        icon = 'circle'
    },
    {
        item = 'battery',
        label = 'Bateria',
        description = 'Bateria automotiva',
        price = 120,
        icon = 'car-battery'
    },
    {
        item = 'sparkplug',
        label = 'Vela de Ignição',
        description = 'Vela de ignição para motor',
        price = 30,
        icon = 'bolt'
    },
    {
        item = 'brake_pad',
        label = 'Pastilha de Freio',
        description = 'Pastilha de freio',
        price = 60,
        icon = 'stop'
    }
}

-- Tempo de reparo (em segundos)
Config.RepairTime = {
    full_repair = 10,
    engine = 7,
    body = 5,
    clean = 3
}