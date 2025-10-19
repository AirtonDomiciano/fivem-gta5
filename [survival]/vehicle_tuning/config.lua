Config = {}

-- Sistema de pagamento (apenas dinheiro físico)
Config.PaymentType = 'cash'

-- Configuração do ox_target
Config.Target = {
    distance = 2.0, -- Distância máxima para interação
    useKey = true,  -- Usar tecla E para interagir
}

-- Configuração de NPCs
Config.NPCs = {
    {
        name = 'Vendedor de Tunning - Observatório',
        model = 'ig_car3guy1',
        coords = vec4(-401.12, 1236.68, 324.67, 129.22), -- Ajuste as coordenadas
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        blip = {
            enabled = true,
            sprite = 72,
            color = 46,
            scale = 0.8,
            label = 'Loja de Tunning'
        }
    }
}

-- Peças de tunning disponíveis
Config.TuningParts = {
    -- Performance
    {
        category = 'Performance',
        parts = {
            {
                item = 'turbo',
                label = 'Turbo',
                description = 'Aumenta significativamente a velocidade máxima',
                price = 5000,
                icon = 'gauge-high'
            },
            {
                item = 'engine_upgrade',
                label = 'Upgrade de Motor',
                description = 'Melhora a aceleração e potência',
                price = 3000,
                icon = 'cog'
            },
            {
                item = 'transmission',
                label = 'Transmissão Esportiva',
                description = 'Melhora a troca de marchas',
                price = 2500,
                icon = 'gears'
            },
            {
                item = 'suspension',
                label = 'Suspensão Esportiva',
                description = 'Melhora o controle e estabilidade',
                price = 2000,
                icon = 'car'
            },
            {
                item = 'brakes',
                label = 'Freios de Performance',
                description = 'Reduz a distância de frenagem',
                price = 1500,
                icon = 'brake-warning'
            }
        }
    },
    -- Visual
    {
        category = 'Visual',
        parts = {
            {
                item = 'body_kit',
                label = 'Kit de Carroceria',
                description = 'Kit completo de modificação visual',
                price = 4000,
                icon = 'car-side'
            },
            {
                item = 'spoiler',
                label = 'Spoiler',
                description = 'Spoiler traseiro esportivo',
                price = 800,
                icon = 'arrow-up'
            },
            {
                item = 'hood',
                label = 'Capô Esportivo',
                description = 'Capô modificado',
                price = 1200,
                icon = 'car-burst'
            },
            {
                item = 'bumper',
                label = 'Para-choque Modificado',
                description = 'Para-choque frontal ou traseiro',
                price = 1000,
                icon = 'shield'
            },
            {
                item = 'side_skirt',
                label = 'Saias Laterais',
                description = 'Modificação lateral do veículo',
                price = 900,
                icon = 'minus'
            }
        }
    },
    -- Rodas e Pneus
    {
        category = 'Rodas e Pneus',
        parts = {
            {
                item = 'custom_wheels',
                label = 'Rodas Customizadas',
                description = 'Jogo de rodas esportivas',
                price = 2000,
                icon = 'circle-notch'
            },
            {
                item = 'performance_tires',
                label = 'Pneus de Performance',
                description = 'Pneus de alta aderência',
                price = 1200,
                icon = 'certificate'
            },
            {
                item = 'wheel_smoke',
                label = 'Fumaça de Rodas Colorida',
                description = 'Adiciona cor à fumaça dos pneus',
                price = 500,
                icon = 'cloud'
            }
        }
    },
    -- Iluminação
    {
        category = 'Iluminação',
        parts = {
            {
                item = 'xenon_lights',
                label = 'Faróis Xenon',
                description = 'Faróis de xenon coloridos',
                price = 800,
                icon = 'lightbulb'
            },
            {
                item = 'neon_kit',
                label = 'Kit Neon',
                description = 'Luzes neon embaixo do carro',
                price = 1500,
                icon = 'bolt'
            },
            {
                item = 'interior_lights',
                label = 'Luzes Internas',
                description = 'Iluminação interna customizada',
                price = 400,
                icon = 'sun'
            }
        }
    },
    -- Som
    {
        category = 'Som',
        parts = {
            {
                item = 'sound_system',
                label = 'Sistema de Som',
                description = 'Sistema de som de alta qualidade',
                price = 2500,
                icon = 'music'
            },
            {
                item = 'subwoofer',
                label = 'Subwoofer',
                description = 'Subwoofer potente',
                price = 1000,
                icon = 'volume-high'
            },
            {
                item = 'horn_upgrade',
                label = 'Buzina Customizada',
                description = 'Buzina personalizada',
                price = 300,
                icon = 'bell'
            }
        }
    },
    -- Pintura
    {
        category = 'Pintura',
        parts = {
            {
                item = 'paint_primary',
                label = 'Tinta Primária',
                description = 'Tinta para cor primária do veículo',
                price = 500,
                icon = 'palette'
            },
            {
                item = 'paint_secondary',
                label = 'Tinta Secundária',
                description = 'Tinta para cor secundária',
                price = 500,
                icon = 'palette'
            },
            {
                item = 'chrome_paint',
                label = 'Pintura Cromada',
                description = 'Pintura cromada especial',
                price = 3000,
                icon = 'gem'
            },
            {
                item = 'matte_paint',
                label = 'Pintura Fosca',
                description = 'Pintura com acabamento fosco',
                price = 1500,
                icon = 'square'
            }
        }
    }
}

-- Tempo de instalação (em segundos)
Config.InstallationTime = 15