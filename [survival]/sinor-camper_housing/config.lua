Config = {}

Config.Framework = 'QBCore'  -- "ESX" or "QBCore"
Config.CoreObject = 'qb-core' -- 'qb-core' for QBCore, 'es_extended' for ESX
Config.Target_script = 'ox_target' -- "qb-target" or "ox_target"
Config.inventory = "ox" -- options "qb", "new-qb", or "ox"
Config.clothing_event = 'illenium-appearance:client:openClothingShopMenu'-- clothing event
Config.ExitVanCommand = 'exitvan' -- Command to exit van "if player dont load the interior and fall to the ground"
Config.translation = {
    --notify
    Camper = "Van de Camping",
    already_inside = 'Você já está dentro da van',
    No_vehicle = 'Nenhum veículo encontrado próximo.',
    Invalid_vehicle = 'Configuração de veículo inválida.',
    not_correct_type = 'Este não é o tipo correto de veículo.',
    not_owner = 'Você não é o proprietário deste veículo',
    entered = 'Você entrou na sua van de camping.',
    exited = 'Você saiu da van',
    not_inside = 'Você não está dentro de uma van.',
    -- label
    Enter = "Entrar na Van",
    Exit = "Sair da Van",
    Stash = "Abrir Compartimento da Van",
    Clothing = "Trocar de Roupa"
}

Config.Vans = {
    ['camper1'] = { 
        Vehicle = "journey",
        Enter_coords = vector3(656.13, 1328.0, 244.38),
        Clothing = vector3(656.41, 1332.06, 244.38),
        Stash = vector3(656.55, 1324.62, 244.38),
        Exit = vector3(656.13, 1328.0, 244.38),
        stash_options = { maxweight = 20000, slots = 25 }
    },
    ['camper2'] = { 
        Vehicle = "camper",
        Enter_coords = vector3(648.18, 1328.96, 242.85),
        Clothing = vector3(647.46, 1326.1, 242.85),
        Stash = vector3(647.16, 1328.59, 242.85),
        Exit = vector3(648.67, 1328.95, 242.85),
        stash_options = { maxweight = 20000, slots = 25 }
    },
    ['camper3'] = { 
        Vehicle = "brickade",
        Enter_coords = vector3(696.52, 1323.45, 243.97),
        Clothing = vector3(697.13, 1329.77, 243.97),
        Stash = vector3(697.9, 1327.68, 244.02),
        Exit = vector3(696.52, 1323.45, 243.97),
        stash_options = { maxweight = 40000, slots = 35 }
    },
    ['camper4'] = { 
        Vehicle = "brickade2",
        Enter_coords = vector3(715.98, 1324.05, 243.97),
        Clothing = vector3(716.14, 1329.83, 243.97),
        Stash = vector3(717.24, 1324.55, 243.97),
        Exit = vector3(715.75, 1323.41, 243.97),
        stash_options = { maxweight = 50000, slots = 50 }
    },
    -- Add More if Needed
}
