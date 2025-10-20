Config = {}

-- Configurações Gerais
Config.Enabled = true
Config.Debug = false -- Mostra markers de debug
Config.InteractKey = 38 -- Tecla E
Config.SearchTime = 5000 -- Tempo para procurar (8 segundos)
Config.LootDistance = 2.0 -- Distância para interagir
Config.RespawnTime = 3600000 -- 1 hora (em ms) para loot reaparecer
Config.InstantDrop = true -- Se true, o drop aparece automaticamente sem necessidade de buscar

-- Configurações do drop físico (ox_inventory)
Config.DropSettings = {
    prefix = 'World Loot',
    slots = nil, -- usa o padrão do ox_inventory quando nil
    maxWeight = nil, -- usa o padrão do ox_inventory quando nil
}

-- Comando para admin resetar loot
Config.ResetCommand = 'resetloot' -- /resetloot

-- Marker 3D
Config.Marker = {
    enabled = true,
    type = 2,
    color = {r = 100, g = 200, b = 100, a = 200},
    size = {x = 0.3, y = 0.3, z = 0.3},
    bobUpAndDown = true,
    rotate = true,
    distance = 10.0
}

-- Traduções
Config.Lang = {
    press_search = '[E] Procurar',
    searching = 'Procurando...',
    found_items = 'Você encontrou itens!',
    nothing_found = 'Nada útil aqui...',
    already_looted = 'Já foi saqueado',
    inventory_full = 'Inventário cheio',
    too_far = 'Muito longe',
    drop_created = 'Você encontrou suprimentos! Verifique o chão.',
    drop_failed = 'Não foi possível gerar o drop.',
    loot_disabled = 'Este tipo de loot está desativado.'
}

-- ====================================
-- LOOT POR TIPO DE LOCAL
-- ====================================

-- CASAS RESIDENCIAIS
Config.HouseLoot = {
    enabled = true,
    spawnChance = 60, -- 60% de chance de spawnar loot
    itemsPerSpot = {min = 1, max = 3},
    items = {
        -- Comida (comum)
        {item = 'sandwich', chance = 30, amount = {1, 2}},
        {item = 'water_bottle', chance = 30, amount = {1, 2}},
        {item = 'tosti', chance = 20, amount = {1, 2}},
        
        -- Médico (incomum)
        {item = 'bandage', chance = 25, amount = {1, 3}},
        {item = 'painkillers', chance = 15, amount = {1, 2}},
        
        -- Utilitários (raro)
        {item = 'flashlight', chance = 10, amount = {1, 1}},
        {item = 'phone', chance = 8, amount = {1, 1}},
        {item = 'radio', chance = 5, amount = {1, 1}},
        
        -- Ferramentas (muito raro)
        {item = 'lockpick', chance = 5, amount = {1, 1}},
        {item = 'repairkit', chance = 3, amount = {1, 1}},
        
        -- Armas (extremamente raro)
        {item = 'weapon_knife', chance = 2, amount = {1, 1}},
        {item = 'weapon_bat', chance = 2, amount = {1, 1}},
    }
}

-- LOJAS/COMÉRCIO
Config.StoreLoot = {
    enabled = true,
    spawnChance = 70,
    itemsPerSpot = {min = 2, max = 4},
    items = {
        -- Comida abundante
        {item = 'sandwich', chance = 40, amount = {1, 3}},
        {item = 'water_bottle', chance = 40, amount = {1, 3}},
        {item = 'tosti', chance = 30, amount = {1, 2}},
        {item = 'coffee', chance = 25, amount = {1, 2}},
        
        -- Utilitários
        {item = 'bandage', chance = 20, amount = {1, 2}},
        {item = 'flashlight', chance = 15, amount = {1, 1}},
        {item = 'phone', chance = 10, amount = {1, 1}},
        
        -- Dinheiro
        {item = 'money', chance = 15, amount = {10, 100}},
    }
}

-- VEÍCULOS ABANDONADOS
Config.VehicleLoot = {
    enabled = false,
    spawnChance = 40, -- Menos comum
    itemsPerSpot = {min = 1, max = 2},
    items = {
        -- Ferramentas automotivas
        {item = 'repairkit', chance = 25, amount = {1, 1}},
        {item = 'advancedrepairkit', chance = 10, amount = {1, 1}},
        
        -- Combustível
        {item = 'jerry_can', chance = 15, amount = {1, 1}},
        
        -- Diversos
        {item = 'water_bottle', chance = 20, amount = {1, 1}},
        {item = 'lockpick', chance = 10, amount = {1, 2}},
        {item = 'phone', chance = 8, amount = {1, 1}},
        
        -- Armas (raro em carros civis)
        {item = 'pistol_ammo', chance = 8, amount = {5, 15}},
        {item = 'weapon_pistol', chance = 3, amount = {1, 1}},
    }
}

-- VEÍCULOS POLICIAIS
Config.PoliceLoot = {
    enabled = false,
    spawnChance = 80, -- Alto pois são raros
    itemsPerSpot = {min = 2, max = 4},
    items = {
        -- Armas e munição
        {item = 'pistol_ammo', chance = 50, amount = {10, 30}},
        {item = 'shotgun_ammo', chance = 30, amount = {5, 15}},
        {item = 'weapon_pistol', chance = 25, amount = {1, 1}},
        {item = 'weapon_pumpshotgun', chance = 15, amount = {1, 1}},
        
        -- Equipamento
        {item = 'armor', chance = 30, amount = {1, 1}},
        {item = 'radio', chance = 40, amount = {1, 1}},
        {item = 'flashlight', chance = 35, amount = {1, 1}},
        
        -- Médico
        {item = 'bandage', chance = 30, amount = {2, 5}},
        {item = 'medkit', chance = 20, amount = {1, 2}},
    }
}

-- HOSPITAL/MÉDICO
Config.MedicalLoot = {
    enabled = true,
    spawnChance = 75,
    itemsPerSpot = {min = 2, max = 4},
    items = {
        -- Médico abundante
        {item = 'bandage', chance = 50, amount = {2, 5}},
        {item = 'medkit', chance = 40, amount = {1, 3}},
        {item = 'painkillers', chance = 35, amount = {1, 3}},
        {item = 'firstaid', chance = 30, amount = {1, 2}},
        
        -- Equipamento
        {item = 'phone', chance = 15, amount = {1, 1}},
        {item = 'radio', chance = 10, amount = {1, 1}},
    }
}

-- MILITAR/QUARTEL
Config.MilitaryLoot = {
    enabled = true,
    spawnChance = 90, -- Muito alto pois são zonas de perigo
    itemsPerSpot = {min = 3, max = 5},
    items = {
        -- Armas premium
        {item = 'weapon_carbinerifle', chance = 20, amount = {1, 1}},
        {item = 'weapon_pumpshotgun', chance = 25, amount = {1, 1}},
        {item = 'weapon_smg', chance = 20, amount = {1, 1}},
        {item = 'weapon_pistol', chance = 30, amount = {1, 1}},
        
        -- Munição abundante
        {item = 'rifle_ammo', chance = 40, amount = {30, 60}},
        {item = 'shotgun_ammo', chance = 35, amount = {15, 30}},
        {item = 'smg_ammo', chance = 35, amount = {30, 60}},
        {item = 'pistol_ammo', chance = 40, amount = {20, 50}},
        
        -- Equipamento tático
        {item = 'armor', chance = 45, amount = {1, 2}},
        {item = 'radio', chance = 30, amount = {1, 1}},
        {item = 'binoculars', chance = 25, amount = {1, 1}},
        
        -- Médico militar
        {item = 'medkit', chance = 30, amount = {1, 2}},
        {item = 'bandage', chance = 35, amount = {2, 4}},
    }
}

-- PROPS (Lixeiras, Caixas, etc)
Config.PropLoot = {
    enabled = true,
    spawnChance = 30, -- Baixo pois tem muitos props
    itemsPerSpot = {min = 1, max = 2},
    items = {
        -- Lixo/Sucata
        {item = 'plastic', chance = 30, amount = {1, 3}},
        {item = 'metalscrap', chance = 25, amount = {1, 2}},
        {item = 'rubber', chance = 20, amount = {1, 2}},
        
        -- Ocasionalmente útil
        {item = 'water_bottle', chance = 15, amount = {1, 1}},
        {item = 'sandwich', chance = 10, amount = {1, 1}},
        {item = 'lockpick', chance = 5, amount = {1, 1}},
        
        -- Dinheiro (raro)
        {item = 'money', chance = 8, amount = {5, 50}},
    }
}

-- ====================================
-- PROPS LOOTÁVEIS
-- ====================================

Config.LootableProps = {
    -- Lixeiras
    'prop_bin_01a',
    'prop_bin_02a', 
    'prop_bin_03a',
    'prop_bin_04a',
    'prop_bin_05a',
    'prop_bin_07a',
    'prop_bin_08a',
    'prop_dumpster_01a',
    'prop_dumpster_02a',
    'prop_dumpster_02b',
    'prop_dumpster_4a',
    'prop_dumpster_4b',
    
    -- Caixas
    'prop_boxpile_07d',
    'prop_box_wood01a',
    'prop_box_wood02a',
    'prop_box_wood05a',
    'prop_box_wood08a',
    'hei_prop_heist_box',
    'ex_prop_crate_closed_bc',
    'ex_prop_crate_closed_ms',
    'prop_cardbordbox_01a',
    'prop_cardbordbox_02a',
    'prop_cardbordbox_03a',
    'prop_cardbordbox_04a',
    
    -- Malas/Bagagem
    'prop_suitcase_01',
    'prop_suitcase_01b',
    'prop_suitcase_01c',
    'prop_suitcase_03',
    
    -- Sacos
    'prop_poly_bag_01',
    'prop_poly_bag_money',
    'prop_cs_heist_bag_01',
    'prop_cs_heist_bag_02',
}

-- ====================================
-- ZONAS ESPECIAIS (Definidas manualmente)
-- ====================================

Config.SpecialZones = {
    -- Hospital Principal (Pillbox)
    {
        name = "Hospital Pillbox",
        coords = vector3(298.57, -584.42, 43.26),
        radius = 80.0,
        lootType = 'medical',
        markerColor = {r = 255, g = 50, b = 50}
    },
    
    -- Base Militar Fort Zancudo
    {
        name = "Fort Zancudo",
        coords = vector3(-2047.63, 3132.48, 32.81),
        radius = 400.0,
        lootType = 'military',
        markerColor = {r = 255, g = 0, b = 0}
    },

    -- Base militar adicional (Humane Labs)
    {
        name = "Humane Labs Military Stash",
        coords = vector3(3519.97, 3705.55, 36.64),
        radius = 120.0,
        lootType = 'military',
        markerColor = {r = 50, g = 200, b = 120}
    },

    -- Delegacia Mission Row
    {
        name = "Mission Row PD",
        coords = vector3(441.68, -982.07, 30.69),
        radius = 50.0,
        lootType = 'police',
        markerColor = {r = 50, g = 50, b = 255}
    },
    
    -- Sandy Shores PD
    {
        name = "Sandy Shores PD",
        coords = vector3(1853.24, 3689.93, 34.27),
        radius = 40.0,
        lootType = 'police',
        markerColor = {r = 50, g = 50, b = 255}
    },
    
    -- Paleto Bay PD
    {
        name = "Paleto Bay PD",
        coords = vector3(-448.04, 6008.37, 31.72),
        radius = 35.0,
        lootType = 'police',
        markerColor = {r = 50, g = 50, b = 255}
    },
}

-- ====================================
-- STATIC HIGH VALUE LOOT
-- ====================================

Config.StaticLootSpots = {
    {
        id = 'mrpd_armory',
        name = 'Armeria MRPD',
        coords = vector3(451.92, -992.62, 30.69),
        lootType = 'police',
        respawn = 1800000, -- 30 minutes
        instant = true,
        itemsPerSpot = {min = 3, max = 5},
        items = {
            {item = 'weapon_carbinerifle', chance = 35, amount = {1, 1}},
            {item = 'weapon_pumpshotgun', chance = 30, amount = {1, 1}},
            {item = 'weapon_pistol', chance = 60, amount = {1, 1}},
            {item = 'pistol_ammo', chance = 90, amount = {20, 40}},
            {item = 'shotgun_ammo', chance = 70, amount = {6, 12}},
            {item = 'armour', chance = 80, amount = {1, 1}},
            {item = 'clothing', chance = 65, amount = {1, 2}},
            {item = 'radio', chance = 50, amount = {1, 1}}
        },
        dropSettings = {
            prefix = 'Arsenal Policial'
        },
        markerColor = {r = 50, g = 50, b = 255, a = 200},
        props = {
            {model = 'w_ar_carbinerifle', offset = vector3(0.0, 0.0, -0.05), heading = 90.0},
            {model = 'prop_cs_heist_bag_02', offset = vector3(0.22, -0.08, -0.05), heading = 20.0}
        }
    },
    {
        id = 'mrpd_locker',
        name = 'Vestiario MRPD',
        coords = vector3(461.28, -994.28, 30.69),
        lootType = 'police',
        respawn = 1800000,
        instant = true,
        itemsPerSpot = {min = 2, max = 4},
        items = {
            {item = 'clothing', chance = 80, amount = {1, 2}},
            {item = 'armour', chance = 60, amount = {1, 1}},
            {item = 'weapon_pistol', chance = 35, amount = {1, 1}},
            {item = 'pistol_ammo', chance = 85, amount = {20, 40}},
            {item = 'radio', chance = 55, amount = {1, 1}}
        },
        dropSettings = {
            prefix = 'Equipamento Policial'
        },
        markerColor = {r = 50, g = 50, b = 255, a = 200},
        props = {
            {model = 'prop_cs_heist_bag_02', offset = vector3(0.0, 0.0, -0.05), heading = 0.0},
            {model = 'prop_armour_pickup', offset = vector3(-0.15, 0.18, -0.05), heading = 0.0}
        }
    },
    {
        id = 'sandy_pd_storage',
        name = 'Delegacia Sandy',
        coords = vector3(1851.29, 3686.42, 34.27),
        lootType = 'police',
        respawn = 1800000,
        instant = true,
        itemsPerSpot = {min = 3, max = 4},
        items = {
            {item = 'weapon_pumpshotgun', chance = 40, amount = {1, 1}},
            {item = 'weapon_smg', chance = 30, amount = {1, 1}},
            {item = 'pistol_ammo', chance = 90, amount = {20, 40}},
            {item = 'smg_ammo', chance = 75, amount = {30, 60}},
            {item = 'armour', chance = 65, amount = {1, 1}},
            {item = 'clothing', chance = 55, amount = {1, 2}}
        },
        dropSettings = {
            prefix = 'Suprimentos Sandy PD'
        },
        markerColor = {r = 50, g = 50, b = 255, a = 200},
        props = {
            {model = 'w_sb_microsmg', offset = vector3(0.0, 0.0, -0.05), heading = 180.0},
            {model = 'prop_armour_pickup', offset = vector3(0.18, 0.12, -0.05), heading = 0.0}
        }
    },
    {
        id = 'paleto_pd_storage',
        name = 'Delegacia Paleto',
        coords = vector3(-448.54, 6006.51, 31.72),
        lootType = 'police',
        respawn = 1800000,
        instant = true,
        itemsPerSpot = {min = 3, max = 5},
        items = {
            {item = 'weapon_carbinerifle', chance = 30, amount = {1, 1}},
            {item = 'weapon_smg', chance = 35, amount = {1, 1}},
            {item = 'pistol_ammo', chance = 85, amount = {20, 40}},
            {item = 'rifle_ammo', chance = 70, amount = {30, 60}},
            {item = 'armour', chance = 75, amount = {1, 1}},
            {item = 'clothing', chance = 60, amount = {1, 2}},
            {item = 'radio', chance = 50, amount = {1, 1}}
        },
        dropSettings = {
            prefix = 'Suprimentos Paleto PD'
        },
        markerColor = {r = 50, g = 50, b = 255, a = 200},
        props = {
            {model = 'w_ar_carbinerifle', offset = vector3(0.0, 0.0, -0.05), heading = 270.0},
            {model = 'prop_cs_heist_bag_02', offset = vector3(0.2, 0.18, -0.05), heading = 200.0}
        }
    }
}
