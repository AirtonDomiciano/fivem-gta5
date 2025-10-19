Config = {}
Config.Framework = 'QBCore' -- Options: 'QBCore', 'ESX'
Config.CoreGetCoreObject = {
    QBCore = 'qb-core', -- Default core name for QBCore
    ESX = 'es_extended' -- Default core name for ESX
}
Config.Print = false
Config.MenuSystem = "ox_lib" -- Options: 'qb-menu', 'ox_lib'
Config.TargetSystem = "ox_target" -- Options: 'qb-target', 'ox_target'
Config.progressCraftTime = 20000 -- 20s to craft
Config.progressCheckItemsTime = 3000 -- 3s to check parts 'added it for anti spam'
Config.WebhookURL = "Webhook_Here" -- discord logs
Config.QBgarege = "qbx_garages" -- this is only for qbcore
Config.Translations = {
-- labels
 OpenCrafting = "Abrir Mesa de Crafting", 
 Checkingprogress = "Verificando peças necessárias!",
 Craftingprogress = "Craftando Veículo",
 Crafting = "Craftando ",
 Open = "Abrir ",
 Crafting = " Craftando",
 Materials = "Materiais: ",
 PartsRequired = "Peças necessárias: ",
 MenuTitle = " Crafting de Veículos",
-- notify
 RequiredMaterials = "Você não tem todos os materiais necessários!",
 success = "craftado com sucesso!",
 error = "Você não tem todas as peças necessárias!",
-- parts labels (legacy mapping for backwards compatibility)
 sparkplugs = "Velas de Ignição",
 gear = "Transmissão",
 rim = "Roda",
 carengine = "Motor de Veículo",
 cycleframe = "Chassi de Moto",
 vehicleframe = "Chassi de Veículo",
 tire = "Pneu",
 battery = "Bateria de Veículo",
-- new portuguese names
 velas_ignicao = "Velas de Ignição",
 transmissao = "Transmissão",
 roda = "Roda",
 motor_veiculo = "Motor de Veículo",
 chassi_moto = "Chassi de Moto",
 chassi_veiculo = "Chassi de Veículo",
 pneu = "Pneu",
 bateria_veiculo = "Bateria de Veículo",
}
-------------------------------
---------crafting Table--------
------------------------------- 
Config.craftingTableProp = "gr_prop_gr_bench_04b" -- Name of the crafting table prop
Config.tableLocations = {
    { coords = vec3(-414.43, 1215.87, 324.67), heading = 71.99, spawnProp = true },
    -- add as more as needed
}
Config.parts = {
    motor_veiculo = {
        items = { name = "motor_veiculo", label = "Motor de Veículo" },
        materials = {iron = 120,steel = 32,rubber = 24,plastic = 32,electronicscrap = 200}
    },
    pneu = {
        items = { name = "pneu", label = "Pneu" }, 
        materials = {rubber = 50,steel = 22,}
    },
    roda = {
        items = { name = "roda", label = "Roda" }, 
        materials = {steel = 80,plastic = 20}
    },
    bateria_veiculo = {
        items = { name = "bateria_veiculo", label = "Bateria de Veículo" }, 
        materials = {copper = 12,rubber = 20,plastic = 30, electronicscrap = 82}
    },
    transmissao = {
        items = { name = "transmissao", label = "Transmissão" }, 
        materials = {rubber = 12,plastic = 30,steel = 42,iron = 90}
    },
    velas_ignicao = {
        items = { name = "velas_ignicao", label = "Velas de Ignição" }, 
        materials = {rubber = 4,steel = 12,plastic = 3,electronicscrap = 11}
    },
    chassi_moto = {
        items = { name = "chassi_moto", label = "Chassi de Moto" }, 
        materials = {steel = 120,iron = 200,metalscrap = 82,aluminum = 40,plastic = 70,glass = 30}
    },
    chassi_veiculo = {
        items = { name = "chassi_veiculo", label = "Chassi de Veículo" },
        materials = {steel = 370,iron = 600,metalscrap = 220,aluminum = 340,plastic = 100,glass = 300}
    }
    -- add as more as needed
}
-------------------------------
---------crafting Vehicle------
------------------------------- 
Config.craftingProps = {
    land = {
        prop = "prop_parkingpay",
        locations = {
            { coords = vec4(-417.15, 1211.37, 324.64, 342.45), spawnCoords = vec4(-419.34, 1206.62, 324.64, 225.07), spawnProp = true }
        }
    },
    sea = {
        prop = "prop_parkingpay",
        locations = {
            { coords = vector4(-774.46, -1432.39, 0.6, 51.75), spawnCoords = vector4(-785.25, -1424.46, -0.51, 47.41), spawnProp = true }
        }
    },
    air = {
        prop = "prop_parkingpay",
        locations = {
            { coords = vector4(-730.37, -1450.53, 4.0, 318.86), spawnCoords = vector4(-724.81, -1443.99, 5.0, 318.46), spawnProp = true }
        }
    }
}
Config.craftableVehicles = {
    land = {
        ["dune"] = {
            displayName = "Buggy de Areia",
            image = "nui://sinor-VehicleCraft/images/dune.png",
            parts = { pneu = 4, bateria_veiculo = 1, transmissao = 1, velas_ignicao = 6, roda = 4, motor_veiculo = 1, chassi_veiculo = 1}
        },
        ["ratloader"] = {
            displayName = "Carregador Velho",
            image = "nui://sinor-VehicleCraft/images/ratloader.png",
            parts = { pneu = 5, bateria_veiculo = 2, transmissao = 2, velas_ignicao = 12, roda = 5, motor_veiculo = 2, chassi_veiculo = 1 }
        },
        ["ratbike"] = {
            displayName = "Moto Velha",
            image = "nui://sinor-VehicleCraft/images/ratbike.png",
            parts = { pneu = 2, bateria_veiculo = 1, transmissao = 1, velas_ignicao = 2, roda = 2, motor_veiculo = 1, chassi_moto = 1 }
        }
        -- add as more as needed
    },
    sea = {
        ["dinghy"] = {
            displayName = "Bote",
            image = "nui://sinor-VehicleCraft/images/dinghy.png",
            parts = { bateria_veiculo = 2 ,plastic = 100, transmissao = 2,bateria_veiculo = 2 ,glass = 135, steel = 100,iron = 300,metalscrap = 320, aluminum = 500}
        }
        -- add as more as needed
    },
    air = {
        ["seasparrow"] = {
            displayName = "Helicóptero do Mar",
            image = "nui://sinor-VehicleCraft/images/seasparrow.png",
            parts = { bateria_veiculo = 4 ,plastic = 90, transmissao = 2,bateria_veiculo = 2 ,glass = 237,steel = 370,iron = 600,metalscrap = 220,aluminum = 340}
        }
        -- add as more as needed
    }
}

-- Helper function to get part labels in Portuguese
Config.GetPartLabel = function(partName)
    if Config.parts[partName] and Config.parts[partName].items and Config.parts[partName].items.label then
        return Config.parts[partName].items.label
    elseif Config.Translations[partName] then
        return Config.Translations[partName]
    else
        return partName -- fallback to original name
    end
end