return {
    autoRespawn = false, -- True == auto respawn cars that are outside into your garage on script restart, false == does not put them into your garage and players have to go to the impound
    warpInVehicle = false, -- If false, player will no longer warp into vehicle upon taking the vehicle out.
    doorsLocked = true, -- If true, the doors will be locked upon taking the vehicle out.
    distanceCheck = 5.0, -- The distance that needs to bee clear to let the vehicle spawn, this prevents vehicles stacking on top of each other
	dropDistance = 10.0,
	---calculates the automatic impound fee.
    ---@param vehicleId integer
    ---@param modelName string
    ---@return integer fee
    calculateImpoundFee = function(vehicleId, modelName)
        local vehCost = VEHICLES[modelName].price
        return qbx.math.round(vehCost * 0.02) or 0
    end,

    ---@class GarageBlip
    ---@field name? string -- Name of the blip. Defaults to garage label.
    ---@field sprite? number -- Sprite for the blip. Defaults to 357
    ---@field color? number -- Color for the blip. Defaults to 3.

    ---The place where the player can access the garage and spawn a car
    ---@class AccessPoint
    ---@field coords vector4 where the garage menu can be accessed from
    ---@field blip? GarageBlip
    ---@field spawn? vector4 where the vehicle will spawn. Defaults to coords
    ---@field dropPoint? vector3 where a vehicle can be stored, Defaults to spawn or coords

    ---@class GarageConfig
    ---@field label string -- Label for the garage
    ---@field type? GarageType -- Optional special type of garage. Currently only used to mark DEPOT garages.
    ---@field vehicleType VehicleType -- Vehicle type
    ---@field groups? string | string[] | table<string, number> job/gangs that can access the garage
    ---@field shared? boolean defaults to false. Shared garages give all players with access to the garage access to all vehicles in it. If shared is off, the garage will only give access to player's vehicles which they own.
    ---@field states? VehicleState | VehicleState[] if set, only vehicles in the given states will be retrievable from the garage. Defaults to GARAGED.
    ---@field skipGarageCheck? boolean if true, returns vehicles for retrieval regardless of if that vehicle's garage matches this garage's name
    ---@field canAccess? fun(source: number): boolean checks access as an additional guard clause. Other filter fields still need to pass in addition to this function.
    ---@field accessPoints AccessPoint[]

    ---@type table<string, GarageConfig>
    garages = {
        -- Public Garages
        harmonygarage = {
            label = 'Harmony',
            vehicleType = VehicleType.CAR,
            shared = false,
            skipGarageCheck = true,
			accessPoints = {
                {
                    blip = {
                        name = 'Harmony',
                        sprite = 357,
                        color = 3,
                    },
                    coords = vec4(197.67, 2801.18, 45.92, 256.62),
                    spawn = vec4(203.24, 2795.58, 45.66, 128.27),
                }
            },
        },
        observatoriogarage = {
            label = 'Observatorio',
            vehicleType = VehicleType.CAR,
            shared = false,
			skipGarageCheck = true,
            accessPoints = {
                {
                    blip = {
                        name = 'Observatório',
                        sprite = 357,
                        color = 3,
                    },
                    coords = vec4(-389.2, 1194.18, 325.92, 62.72),
                    spawn = vec4(-387.34, 1198.47, 325.64, 98.22),
                }
            },
        },
    },
}
