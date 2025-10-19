return {
    ['testburger'] = {
        label = 'Test Burger',
        weight = 220,
        degrade = 60,
        client = {
            image = 'burger_chicken.png',
            status = { hunger = 200000 },
            anim = 'eating',
            prop = 'burger',
            usetime = 2500,
            export = 'ox_inventory_examples.testburger'
        },
        server = {
            export = 'ox_inventory_examples.testburger',
            test = 'what an amazingly delicious burger, amirite?'
        },
        buttons = {
            {
                label = 'Lick it',
                action = function(slot)
                    print('You licked the burger')
                end
            },
            {
                label = 'Squeeze it',
                action = function(slot)
                    print('You squeezed the burger :(')
                end
            },
            {
                label = 'What do you call a vegan burger?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('A misteak.')
                end
            },
            {
                label = 'What do frogs like to eat with their hamburgers?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('French flies.')
                end
            },
            {
                label = 'Why were the burger and fries running?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('Because they\'re fast food.')
                end
            }
        },
        consume = 0.3
    },

    ['bandage'] = {
        label = 'Bandage',
        weight = 115,
    },

    ['burger'] = {
        label = 'Burger',
        weight = 220,
        client = {
            status = { hunger = 200000 },
            anim = 'eating',
            prop = 'burger',
            usetime = 2500,
            notification = 'You ate a delicious burger'
        },
    },

    ['sprunk'] = {
        label = 'Sprunk',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a sprunk'
        }
    },

    ['parachute'] = {
        label = 'Parachute',
        weight = 8000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 1500
        }
    },

    ['garbage'] = {
        label = 'Garbage',
    },

    ['paperbag'] = {
        label = 'Paper Bag',
        weight = 1,
        stack = false,
        close = false,
        consume = 0
    },

    ['panties'] = {
        label = 'Knickers',
        weight = 10,
        consume = 0,
        client = {
            status = { thirst = -100000, stress = -25000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
            usetime = 2500,
        }
    },

    ['lockpick'] = {
        label = 'Lockpick',
        weight = 160,
    },

    ['phone'] = {
        label = 'Phone',
        weight = 190,
        stack = false,
        consume = 0,
        client = {
            add = function(total)
                if total > 0 then
                    pcall(function() return exports.npwd:setPhoneDisabled(false) end)
                end
            end,

            remove = function(total)
                if total < 1 then
                    pcall(function() return exports.npwd:setPhoneDisabled(true) end)
                end
            end
        }
    },

    ['mustard'] = {
        label = 'Mustard',
        weight = 500,
        client = {
            status = { hunger = 25000, thirst = 25000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
            usetime = 2500,
            notification = 'You... drank mustard'
        }
    },

    ['water'] = {
        label = 'Water',
        weight = 500,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
            usetime = 2500,
            cancel = true,
            notification = 'You drank some refreshing water'
        }
    },

    ['armour'] = {
        label = 'Bulletproof Vest',
        weight = 3000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 3500
        }
    },

    ['clothing'] = {
        label = 'Clothing',
        consume = 0,
    },

    ['money'] = {
        label = 'Money',
    },

    ['black_money'] = {
        label = 'Dirty Money',
    },

    ['id_card'] = {
        label = 'Identification Card',
    },

    ['driver_license'] = {
        label = 'Drivers License',
    },

    ['weaponlicense'] = {
        label = 'Weapon License',
    },

    ['lawyerpass'] = {
        label = 'Lawyer Pass',
    },

    ['radio'] = {
        label = 'Radio',
        weight = 1000,
        allowArmed = true,
        consume = 0,
        client = {
            event = 'mm_radio:client:use'
        }
    },

    ['jammer'] = {
        label = 'Radio Jammer',
        weight = 10000,
        allowArmed = true,
        client = {
            event = 'mm_radio:client:usejammer'
        }
    },

    ['radiocell'] = {
        label = 'AAA Cells',
        weight = 1000,
        stack = true,
        allowArmed = true,
        client = {
            event = 'mm_radio:client:recharge'
        }
    },

    ['advancedlockpick'] = {
        label = 'Advanced Lockpick',
        weight = 500,
    },

    ['screwdriverset'] = {
        label = 'Screwdriver Set',
        weight = 500,
    },

    ['electronickit'] = {
        label = 'Electronic Kit',
        weight = 500,
    },

    ['cleaningkit'] = {
        label = 'Cleaning Kit',
        weight = 500,
    },

    ['repairkit'] = {
        label = 'Repair Kit',
        weight = 2500,
    },

    ['advancedrepairkit'] = {
        label = 'Advanced Repair Kit',
        weight = 4000,
    },

    ['diamond_ring'] = {
        label = 'Diamond',
        weight = 1500,
    },

    ['rolex'] = {
        label = 'Golden Watch',
        weight = 1500,
    },

    ['goldbar'] = {
        label = 'Gold Bar',
        weight = 1500,
    },

    ['goldchain'] = {
        label = 'Golden Chain',
        weight = 1500,
    },

    ['crack_baggy'] = {
        label = 'Crack Baggy',
        weight = 100,
    },

    ['cokebaggy'] = {
        label = 'Bag of Coke',
        weight = 100,
    },

    ['coke_brick'] = {
        label = 'Coke Brick',
        weight = 2000,
    },

    ['coke_small_brick'] = {
        label = 'Coke Package',
        weight = 1000,
    },

    ['xtcbaggy'] = {
        label = 'Bag of Ecstasy',
        weight = 100,
    },

    ['meth'] = {
        label = 'Methamphetamine',
        weight = 100,
    },

    ['oxy'] = {
        label = 'Oxycodone',
        weight = 100,
    },

    ['weed_ak47'] = {
        label = 'AK47 2g',
        weight = 200,
    },

    ['weed_ak47_seed'] = {
        label = 'AK47 Seed',
        weight = 1,
    },

    ['weed_skunk'] = {
        label = 'Skunk 2g',
        weight = 200,
    },

    ['weed_skunk_seed'] = {
        label = 'Skunk Seed',
        weight = 1,
    },

    ['weed_amnesia'] = {
        label = 'Amnesia 2g',
        weight = 200,
    },

    ['weed_amnesia_seed'] = {
        label = 'Amnesia Seed',
        weight = 1,
    },

    ['weed_og-kush'] = {
        label = 'OGKush 2g',
        weight = 200,
    },

    ['weed_og-kush_seed'] = {
        label = 'OGKush Seed',
        weight = 1,
    },

    ['weed_white-widow'] = {
        label = 'OGKush 2g',
        weight = 200,
    },

    ['weed_white-widow_seed'] = {
        label = 'White Widow Seed',
        weight = 1,
    },

    ['weed_purple-haze'] = {
        label = 'Purple Haze 2g',
        weight = 200,
    },

    ['weed_purple-haze_seed'] = {
        label = 'Purple Haze Seed',
        weight = 1,
    },

    ['weed_brick'] = {
        label = 'Weed Brick',
        weight = 2000,
    },

    ['weed_nutrition'] = {
        label = 'Plant Fertilizer',
        weight = 2000,
    },

    ['joint'] = {
        label = 'Joint',
        weight = 200,
    },

    ['rolling_paper'] = {
        label = 'Rolling Paper',
        weight = 0,
    },

    ['empty_weed_bag'] = {
        label = 'Empty Weed Bag',
        weight = 0,
    },

    ['firstaid'] = {
        label = 'First Aid',
        weight = 2500,
    },

    ['ifaks'] = {
        label = 'Individual First Aid Kit',
        weight = 2500,
    },

    ['painkillers'] = {
        label = 'Painkillers',
        weight = 400,
    },

    ['firework1'] = {
        label = '2Brothers',
        weight = 1000,
    },

    ['firework2'] = {
        label = 'Poppelers',
        weight = 1000,
    },

    ['firework3'] = {
        label = 'WipeOut',
        weight = 1000,
    },

    ['firework4'] = {
        label = 'Weeping Willow',
        weight = 1000,
    },

    ['steel'] = {
        label = 'Steel',
        weight = 100,
    },

    ['rubber'] = {
        label = 'Rubber',
        weight = 100,
    },

    ['metalscrap'] = {
        label = 'Metal Scrap',
        weight = 100,
    },

    ['iron'] = {
        label = 'Iron',
        weight = 100,
    },

    ['copper'] = {
        label = 'Copper',
        weight = 100,
    },

    ['aluminum'] = {
        label = 'Aluminium',
        weight = 100,
    },

    ['plastic'] = {
        label = 'Plastic',
        weight = 100,
    },

    ['glass'] = {
        label = 'Glass',
        weight = 100,
    },

    ['gatecrack'] = {
        label = 'Gatecrack',
        weight = 1000,
    },

    ['cryptostick'] = {
        label = 'Crypto Stick',
        weight = 100,
    },

    ['trojan_usb'] = {
        label = 'Trojan USB',
        weight = 100,
    },

    ['toaster'] = {
        label = 'Toaster',
        weight = 5000,
    },

    ['small_tv'] = {
        label = 'Small TV',
        weight = 100,
    },

    ['security_card_01'] = {
        label = 'Security Card A',
        weight = 100,
    },

    ['security_card_02'] = {
        label = 'Security Card B',
        weight = 100,
    },

    ['drill'] = {
        label = 'Drill',
        weight = 5000,
    },

    ['thermite'] = {
        label = 'Thermite',
        weight = 1000,
    },

    ['diving_gear'] = {
        label = 'Diving Gear',
        weight = 30000,
    },

    ['diving_fill'] = {
        label = 'Diving Tube',
        weight = 3000,
    },

    ['antipatharia_coral'] = {
        label = 'Antipatharia',
        weight = 1000,
    },

    ['dendrogyra_coral'] = {
        label = 'Dendrogyra',
        weight = 1000,
    },

    ['jerry_can'] = {
        label = 'Jerrycan',
        weight = 3000,
    },

    ['nitrous'] = {
        label = 'Nitrous',
        weight = 1000,
    },

    ['wine'] = {
        label = 'Wine',
        weight = 500,
    },

    ['grape'] = {
        label = 'Grape',
        weight = 10,
    },

    ['grapejuice'] = {
        label = 'Grape Juice',
        weight = 200,
    },

    ['coffee'] = {
        label = 'Coffee',
        weight = 200,
    },

    ['vodka'] = {
        label = 'Vodka',
        weight = 500,
    },

    ['whiskey'] = {
        label = 'Whiskey',
        weight = 200,
    },

    ['beer'] = {
        label = 'Beer',
        weight = 200,
    },

    ['sandwich'] = {
        label = 'Sandwich',
        weight = 200,
    },

    ['walking_stick'] = {
        label = 'Walking Stick',
        weight = 1000,
    },

    ['lighter'] = {
        label = 'Lighter',
        weight = 200,
    },

    ['binoculars'] = {
        label = 'Binoculars',
        weight = 800,
    },

    ['stickynote'] = {
        label = 'Sticky Note',
        weight = 0,
    },

    ['empty_evidence_bag'] = {
        label = 'Empty Evidence Bag',
        weight = 200,
    },

    ['filled_evidence_bag'] = {
        label = 'Filled Evidence Bag',
        weight = 200,
    },

    ['harness'] = {
        label = 'Harness',
        weight = 200,
    },

    ['handcuffs'] = {
        label = 'Handcuffs',
        weight = 200,
    },
    -- ÓRGÃOS DE ZUMBI
    ['zombie_brain'] = {
        label = 'Cérebro de Zumbi',
        weight = 500,
        stack = true,
        close = true,
        description = 'Um cérebro podre de zumbi. Pode ser usado para algo...'
    },
    
    ['zombie_heart'] = {
        label = 'Coração de Zumbi',
        weight = 400,
        stack = true,
        close = true,
        description = 'Um coração ainda pulsante. Assustador.'
    },
    
    ['zombie_lungs'] = {
        label = 'Pulmões de Zumbi',
        weight = 450,
        stack = true,
        close = true,
        description = 'Pulmões danificados de um zumbi.'
    },
    
    ['zombie_arm'] = {
        label = 'Braço de Zumbi',
        weight = 800,
        stack = true,
        close = true,
        description = 'Um braço decepado. Nojento.'
    },
    
    ['zombie_foot'] = {
        label = 'Pé de Zumbi',
        weight = 600,
        stack = true,
        close = true,
        description = 'Um pé podre de zumbi.'
    },
    
    -- ITENS DE ANIMAIS
    ['raw_meat'] = {
        label = 'Carne Crua',
        weight = 300,
        stack = true,
        close = true,
        description = 'Carne crua de animal. Precisa ser cozinhada.'
    },
    
    ['animal_skin'] = {
        label = 'Pele de Animal',
        weight = 500,
        stack = true,
        close = true,
        description = 'Pele de animal. Pode ser vendida ou usada.'
    },
    
    ['bone_fragment'] = {
        label = 'Fragmento de Osso',
        weight = 200,
        stack = true,
        close = true,
        description = 'Pedaços de ossos de animal.'
    },
    -- Peças de Reparo (vehicle_mechanic)
    ['repair_kit'] = {
        label = 'Kit de Reparo',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Kit completo para reparos básicos'
    },
    ['engine_oil'] = {
        label = 'Óleo de Motor',
        weight = 500,
        stack = true,
        close = true,
        description = 'Óleo para manutenção do motor'
    },
    ['tire'] = {
        label = 'Pneu',
        weight = 5000,
        stack = true,
        close = true,
        description = 'Pneu sobressalente'
    },
    ['battery'] = {
        label = 'Bateria',
        weight = 3000,
        stack = true,
        close = true,
        description = 'Bateria automotiva'
    },
    ['sparkplug'] = {
        label = 'Vela de Ignição',
        weight = 100,
        stack = true,
        close = true,
        description = 'Vela de ignição para motor'
    },
    ['brake_pad'] = {
        label = 'Pastilha de Freio',
        weight = 500,
        stack = true,
        close = true,
        description = 'Pastilha de freio'
    },
    
    -- Peças de Performance (vehicle_tuning)
    ['turbo'] = {
        label = 'Turbo',
        weight = 5000,
        stack = true,
        close = true,
        description = 'Aumenta significativamente a velocidade máxima'
    },
    ['engine_upgrade'] = {
        label = 'Upgrade de Motor',
        weight = 8000,
        stack = true,
        close = true,
        description = 'Melhora a aceleração e potência'
    },
    ['transmission'] = {
        label = 'Transmissão Esportiva',
        weight = 6000,
        stack = true,
        close = true,
        description = 'Melhora a troca de marchas'
    },
    ['suspension'] = {
        label = 'Suspensão Esportiva',
        weight = 4000,
        stack = true,
        close = true,
        description = 'Melhora o controle e estabilidade'
    },
    ['brakes'] = {
        label = 'Freios de Performance',
        weight = 3000,
        stack = true,
        close = true,
        description = 'Reduz a distância de frenagem'
    },
    
    -- Peças Visuais
    ['body_kit'] = {
        label = 'Kit de Carroceria',
        weight = 10000,
        stack = true,
        close = true,
        description = 'Kit completo de modificação visual'
    },
    ['spoiler'] = {
        label = 'Spoiler',
        weight = 2000,
        stack = true,
        close = true,
        description = 'Spoiler traseiro esportivo'
    },
    ['hood'] = {
        label = 'Capô Esportivo',
        weight = 3000,
        stack = true,
        close = true,
        description = 'Capô modificado'
    },
    ['bumper'] = {
        label = 'Para-choque Modificado',
        weight = 2500,
        stack = true,
        close = true,
        description = 'Para-choque frontal ou traseiro'
    },
    ['side_skirt'] = {
        label = 'Saias Laterais',
        weight = 2000,
        stack = true,
        close = true,
        description = 'Modificação lateral do veículo'
    },
    
    -- Rodas
    ['custom_wheels'] = {
        label = 'Rodas Customizadas',
        weight = 8000,
        stack = true,
        close = true,
        description = 'Jogo de rodas esportivas'
    },
    ['performance_tires'] = {
        label = 'Pneus de Performance',
        weight = 6000,
        stack = true,
        close = true,
        description = 'Pneus de alta aderência'
    },
    ['wheel_smoke'] = {
        label = 'Fumaça de Rodas Colorida',
        weight = 500,
        stack = true,
        close = true,
        description = 'Adiciona cor à fumaça dos pneus'
    },
    
    -- Iluminação
    ['xenon_lights'] = {
        label = 'Faróis Xenon',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Faróis de xenon coloridos'
    },
    ['neon_kit'] = {
        label = 'Kit Neon',
        weight = 2000,
        stack = true,
        close = true,
        description = 'Luzes neon embaixo do carro'
    },
    ['interior_lights'] = {
        label = 'Luzes Internas',
        weight = 500,
        stack = true,
        close = true,
        description = 'Iluminação interna customizada'
    },
    
    -- Som
    ['sound_system'] = {
        label = 'Sistema de Som',
        weight = 5000,
        stack = true,
        close = true,
        description = 'Sistema de som de alta qualidade'
    },
    ['subwoofer'] = {
        label = 'Subwoofer',
        weight = 3000,
        stack = true,
        close = true,
        description = 'Subwoofer potente'
    },
    ['horn_upgrade'] = {
        label = 'Buzina Customizada',
        weight = 500,
        stack = true,
        close = true,
        description = 'Buzina personalizada'
    },
    
    -- Pintura
    ['paint_primary'] = {
        label = 'Tinta Primária',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Tinta para cor primária do veículo'
    },
    ['paint_secondary'] = {
        label = 'Tinta Secundária',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Tinta para cor secundária'
    },
    ['chrome_paint'] = {
        label = 'Pintura Cromada',
        weight = 2000,
        stack = true,
        close = true,
        description = 'Pintura cromada especial'
    },
    ['matte_paint'] = {
        label = 'Pintura Fosca',
        weight = 1500,
        stack = true,
        close = true,
        description = 'Pintura com acabamento fosco'
    },
    ['antiradiationmask'] = {
    name = 'antiradiationmask',
    label = 'Radiation Mask',
    weight = 10,
    type = 'item',
    image = 'antiradiationmask.png',
    unique = false,
    useable = true,
    shouldClose = true,
    description = 'Always use protection',
    },
    
	-- vehicle craft
    ['pneu'] = {
        label = 'Pneu',
        weight = 10,
        client = {
            status = {},
            anim = {},
            prop = {},
            usetime = 1500,
            notification = 'Você usou um pneu'
        },
    },
    
    ['bateria_veiculo'] = {
        label = 'Bateria de Veículo',
        weight = 10,
        client = {
            status = {},
            anim = {},
            prop = {},
            usetime = 1500,
            notification = 'Você usou uma bateria de veículo'
        },
    },
    
    ['transmissao'] = {
        label = 'Transmissão',
        weight = 10,
        client = {
            status = {},
            anim = {},
            prop = {},
            usetime = 1500,
            notification = 'Você usou uma transmissão'
        },
    },
    
    ['velas_ignicao'] = {
        label = 'Velas de Ignição',
        weight = 10,
        client = {
            status = {},
            anim = {},
            prop = {},
            usetime = 1500,
            notification = 'Você usou velas de ignição'
        },
    },
    
    ['roda'] = {
        label = 'Roda',
        weight = 10,
        client = {
            status = {},
            anim = {},
            prop = {},
            usetime = 1500,
            notification = 'Você usou uma roda'
        },
    },
    
    ['motor_veiculo'] = {
        label = 'Motor de Veículo',
        weight = 10,
        client = {
            status = {},
            anim = {},
            prop = {},
            usetime = 1500,
            notification = 'Você usou um motor de veículo'
        },
    },
    
    ['electronicscrap'] = {
        label = 'Sucata Eletrônica',
        weight = 10,
        client = {
            status = {},
            anim = {},
            prop = {},
            usetime = 1500,
            notification = 'Você usou sucata eletrônica'
        },
    },
    
    ['chassi_moto'] = {
        label = 'Chassi de Moto',
        weight = 10,
        client = {
            status = {},
            anim = {},
            prop = {},
            usetime = 1500,
            notification = 'Você usou um chassi de moto'
        },
    },
    
    ['chassi_veiculo'] = {
        label = 'Chassi de Veículo',
        weight = 10,
        client = {
            status = {},
            anim = {},
            prop = {},
            usetime = 1500,
            notification = 'Você usou um chassi de veículo'
        },
    },
    -- Coletes   
	['armour_vest'] = {
    	label = 'Bulletproof Vest',
    	weight = 5000,
    	stack = false,
    	durability = 0.1,
    	client = {
    		anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
    		usetime = 3500
    	}
    },
    
    ['armour_plate'] = {
    	label = 'Bulletproof Plate',
    	weight = 400,
    	stack = true,
    },
}
