Config = {}

-- Configurações gerais
Config.LootEnabled = true -- Sistema ativo por padrão
Config.Command = 'toggleloot' -- Comando para ativar/desativar
Config.LootKey = 38 -- Tecla E para saquear
Config.SearchTime = 5000 -- Tempo de busca em ms (5 segundos)
Config.LootDistance = 2.0 -- Distância para interagir
Config.MarkerDistance = 10.0 -- Distância para ver o marcador
Config.CooldownTime = 300000 -- 5 minutos para resetar loot (em ms)
Config.DeletePedAfterLoot = false -- Deletar NPC após saquear?

-- Bloquear loot enquanto dirigindo
Config.BlockLootInVehicle = true -- Bloqueia saque quando em veículo

-- Mostrar imagens dos itens no menu
Config.ShowItemImages = true -- Mostra imagens dos itens no menu de loot
Config.ImagePath = 'https://cfx-nui-ox_inventory/web/images/' -- Caminho base para imagens (ox_inventory padrão)

-- Sistema de Menu - Usa apenas ox_lib context menu
Config.UseInventoryShop = false -- Desabilitado (mantido para compatibilidade)
-- NOTA: Sistema simplificado usando apenas ox_lib para melhor performance
Config.FallbackImages = {
    -- Imagens de fallback para itens específicos
    ['zombie_brain'] = 'zombie_brain.png',
    ['zombie_heart'] = 'zombie_heart.png',
    ['zombie_lungs'] = 'zombie_lungs.png',
    ['weapon_knife'] = 'weapon_knife.png',
    ['weapon_bat'] = 'weapon_bat.png',
    ['bandage'] = 'bandage.png',
    ['water'] = 'water.png'
}

-- Marcador 3D sobre o corpo
Config.Marker = {
    enabled = false,
    type = 2, -- Tipo do marcador (2 = seta para baixo)
    color = {r = 255, g = 50, b = 50, a = 200},
    size = {x = 0.5, y = 0.5, z = 0.5},
    bobUpAndDown = true,
    rotate = true
}

-- Textos/Traduções
Config.Lang = {
    press_to_loot = '[E] Saquear Corpo',
    searching = 'Procurando...',
    cancelled = 'Busca cancelada',
    already_looted = 'Este corpo já foi saqueado',
    nothing_found = 'Você não encontrou nada útil',
    received_item = 'Você encontrou %sx %s',
    loot_menu_title = '🎒 Loot Encontrado',
    take_item = 'Pegar Item',
    take_all = '🎒 Pegar Tudo',
    inventory_full = 'Inventário cheio!',
    loot_toggled_on = 'Sistema de loot ativado',
    loot_toggled_off = 'Sistema de loot desativado'
}

-- Configurações visuais do menu
Config.UI = {
    icons = {
        -- Ícones mais expressivos para diferentes tipos de itens
        zombie_brain = '🧠',
        zombie_heart = '❤️',
        zombie_lungs = '🫁',
        zombie_arm = '🦾',
        zombie_foot = '🦶',
        bandage = '🩹',
        water = '💧',
        sandwich = '🥪',
        weapon_knife = '🔪',
        weapon_bat = '🏏',
        lockpick = '🔓',
        radio = '📻',
        ammo_generic = '🔫',
        default = '📦'
    }
}

-- Categorias de NPCs e seus loots
Config.Categories = {
    -- ZUMBIS/NPCS BÁSICOS
    ['basic'] = {
        peds = {
            "a_f_y_juggalo_01",
            "a_m_m_beach_01",
            "a_m_m_eastsa_02",
            "a_m_m_hillbilly_01",
            "a_m_m_malibu_01",
            "a_m_m_mexlabor_01",
            "a_m_m_polynesian_01",
            "a_m_m_rurmeth_01",
            "a_m_m_salton_02",
            "a_m_m_skater_01",
            "a_m_m_skidrow_01",
            "a_m_m_soucent_04",
            "a_m_y_genstreet_01",
            "a_m_y_genstreet_02",
            "a_m_y_methhead_01",
            "a_m_y_salton_01",
            "a_m_y_stlat_01"
        },
        loot = {
            -- Órgãos de zumbi (mais comuns)
            {item = 'zombie_brain', label = 'Cérebro de Zumbi', chance = 45, amount = {1, 1}},
            {item = 'zombie_heart', label = 'Coração de Zumbi', chance = 45, amount = {1, 1}},
            {item = 'zombie_lungs', label = 'Pulmões de Zumbi', chance = 40, amount = {1, 1}},
            {item = 'zombie_arm', label = 'Braço de Zumbi', chance = 35, amount = {1, 1}},
            {item = 'zombie_foot', label = 'Pé de Zumbi', chance = 35, amount = {1, 1}},
            
            -- Itens de sobrevivência
            {item = 'bandage', label = 'Bandagem', chance = 30, amount = {1, 3}},
            {item = 'water', label = 'Garrafa de Água', chance = 25, amount = {1, 2}},
            {item = 'sandwich', label = 'Sanduíche', chance = 20, amount = {1, 2}},
            
            -- Utilitários (raros)
            {item = 'lockpick', label = 'Lockpick', chance = 10, amount = {1, 2}},
            {item = 'radio', label = 'Rádio Velho', chance = 8, amount = {1, 1}},
            
            -- Munição (muito rara)
            {item = 'ammo-9', label = 'Munição de Pistola', chance = 5, amount = {5, 15}},
            
            -- Armas (extremamente raro)
            {item = 'weapon_knife', label = 'Faca', chance = 3, amount = {1, 1}},
            {item = 'weapon_bat', label = 'Bastão', chance = 2, amount = {1, 1}}
        },
        minItems = 1,
        maxItems = 3
    },

    -- ANIMAIS
    ['animal'] = {
        peds = {
            'a_c_deer',
            'a_c_boar',
            'a_c_cow',
            'a_c_coyote',
            'a_c_mtlion',
            'a_c_pig'
        },
        loot = {
            {item = 'raw_meat', label = 'Carne Crua', chance = 90, amount = {2, 5}},
            {item = 'animal_skin', label = 'Pele de Animal', chance = 60, amount = {1, 3}},
            {item = 'bone_fragment', label = 'Fragmento de Osso', chance = 40, amount = {1, 2}}
        },
        minItems = 1,
        maxItems = 2
    },

    -- NPCS ESPECIAIS (policiais, gangsters, etc)
    ['special'] = {
        peds = {
            "a_m_m_farmer_01",
            "a_m_m_fatlatin_01",
            "a_m_m_og_boss_01",
            "s_m_y_cop_01",
            "s_m_y_prismuscl_01"
        },
        loot = {
            -- Recursos valiosos
            {item = 'metalscrap', label = 'Sucata de Metal', chance = 30, amount = {1, 3}},
            {item = 'electronickit', label = 'Eletrônicos', chance = 20, amount = {1, 2}},
            {item = 'money', label = 'Dinheiro', chance = 25, amount = {50, 300}},
            
            -- Munições
            {item = 'ammo-9', label = 'Munição de Pistola', chance = 35, amount = {10, 30}},
            {item = 'ammo-rifle', label = 'Munição SMG', chance = 20, amount = {10, 25}},
            {item = 'ammo-shotgun', label = 'Munição Shotgun', chance = 15, amount = {5, 15}},
            
            -- Armas (raras)
            {item = 'weapon_tecpistol', label = 'Pistola', chance = 8, amount = {1, 1}},
            {item = 'weapon_pumpshotgun', label = 'Shotgun', chance = 5, amount = {1, 1}},
            {item = 'weapon_machete', label = 'Machete', chance = 10, amount = {1, 1}},
            
            -- Equipamentos
            {item = 'armour_vest', label = 'Colete', chance = 12, amount = {1, 1}},
            {item = 'armour_plate', label = 'Kit de Reparo', chance = 8, amount = {1, 1}}
        },
        minItems = 2,
        maxItems = 4
    }
}

-- Lista de todos os peds (gerada automaticamente, não editar)
Config.AllPeds = {}
for category, data in pairs(Config.Categories) do
    for _, ped in ipairs(data.peds) do
        Config.AllPeds[GetHashKey(ped)] = category
    end
end