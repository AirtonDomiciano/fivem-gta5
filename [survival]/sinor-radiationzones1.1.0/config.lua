Config = {}

Config.Core = 'QBCore' --'QBCore', 'ESX'

Config.Debug = false -- Set to false to disable debug prints
Config.Webhook = 'https://discord.com/api/webhooks/1265815042478313526/ydCi4Htg47o4mDhSYGuCZEpqvrHozj_xhlT2NNghKbqDtoSnjXgSprNk338fDPxLcMN1' -- Discord webhook URL

Config.RadiationZones = {
    {
        coords = vector3(100.0, 100.0, 100.0),
        radius = 100.0,
        blipradius = 100.0,
        showblipradius = true,
        blipradiusscale = 0.8,
        blipradiuscolor = 66,
        blipradiusname = "Radioactive Zone",
    },
	
	    {
        coords = vector3(1830.47, 156.76, 171.09),
        radius = 600.0,
        blipradius = 600.0,
        showblipradius = true,
        blipradiusscale = 0.8,
        blipradiuscolor = 66,
        blipradiusname = "Radioactive Zone",
    },

    -- Add more zones as needed
}

Config.BloodLoss = {
    interval = 1000, -- Interval in milliseconds (1000ms = 1s)
    amount = 3      -- Amount of health to lose each interval
}

Config.AntiRadiationMaskItem = 'antiradiationmask' -- Name of the anti-radiation mask item
