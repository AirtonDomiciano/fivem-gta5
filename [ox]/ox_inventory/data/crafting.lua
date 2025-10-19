return {
	{
        name = 'debug_crafting',
		items = {
			{
				name = 'lockpick',
				ingredients = {
					scrapmetal = 5,
					WEAPON_HAMMER = 0.05
				},
				duration = 5000,
				count = 2,
			},
		},
		points = {
			vec3(-1147.083008, -2002.662109, 13.180260),
			vec3(-345.374969, -130.687088, 39.009613)
		},
		zones = {
			{
				coords = vec3(-1146.2, -2002.05, 13.2),
				size = vec3(3.8, 1.05, 0.15),
				distance = 1.5,
				rotation = 315.0,
			},
			{
				coords = vec3(-346.1, -130.45, 39.0),
				size = vec3(3.8, 1.05, 0.15),
				distance = 1.5,
				rotation = 70.0,
			},
		},
		blip = { id = 566, colour = 31, scale = 0.8 },
	},
    {
	items = {
		{
			name = 'armour_vest',
			ingredients = {
				armour_vest = 1,
				armour_plate = 1
			},
			duration = 5000,
			count = 1,
			metadata = { durability = 50 }
		},
		{
			name = 'armour_vest',
			ingredients = {
				armour_vest = 1,
				armour_plate = 2
			},
			duration = 5000,
			count = 1,
			metadata = { durability = 75 }
		},
		{
			name = 'armour_vest',
			ingredients = {
				armour_vest = 1,
				armour_plate = 3
			},
			duration = 5000,
			count = 1,
			metadata = { durability = 100 }
		},

	},
	points = {
		vec3(451.65,-979.84,30.69),
		vec3(21.15,-1106.54,29.69)
		},
	zones = {
		{
			coords = vec3(451.65,-979.84,30.69),
			size = vec3(3.8, 1.05, 0.15),
			distance = 1.5,
			rotation = 175.0,
		},
		{
			coords = vec3(21.15,-1106.54,29.69),
			size = vec3(3.8, 1.05, 0.15),
			distance = 1.5,
			rotation = 175.0,
		},
	},
	-- blip = { id = 566, colour = 31, scale = 0.8 },
    },
}
