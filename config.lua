Config = {}
Config.versionESX = "newESX"
Config.price = 1000

Config.Locations = {
    vector3(72.3, -1399.1, 28.4),
	vector3(-703.8, -152.3, 36.4),
	vector3(-167.9, -299.0, 38.7),
	vector3(428.7, -800.1, 28.5),
	vector3(-829.4, -1073.7, 10.3),
	vector3(-1447.8, -242.5, 48.8),
	vector3(11.6, 6514.2, 30.9),
	vector3(123.6, -219.4, 53.6),
	vector3(1696.3, 4829.3, 41.1),
	vector3(618.1, 2759.6, 41.1),
	vector3(1190.6, 2713.4, 37.2),
	vector3(-1193.4, -772.3, 16.3),
	vector3(-3172.5, 1048.1, 19.9),
	vector3(-1108.4, 2708.9, 18.1)
}

Config.DefaultCategories = {
	{label = "Bras", id = 3, type = "variation", name = "arms"}, --
	{label = "Pantalons", id = 4, type = "variation", name = "pants"},
	{label = "Sacs et parachutes", id = 5, type = "variation", name = "bags"},
	{label = "Chaussures", id = 6, type = "variation", name = "shoes"},
	{label = "Accesoires", id = 7, type = "variation", name = "chain"}, --
	{label = "T-Shirt", id = 8, type = "variation", name = "tshirt"},
	{label = "Decals", id = 10, type = "variation", name = "decals"},
	{label = "Torses", id = 11, type = "variation", name = "torso"},
	{label = "Chapeaux", id = 0, type = "prop", name = "helmet"},
	{label = "Lunettes", id = 1, type = "prop", name = "glasses"},
	{label = "Accesoires oreille", id = 2, type = "prop", name = "ears"},
}

Config.JobsCategories = {
	['hayes'] = {
		{label = "Gilet par balle", id = 9, type = "variation", name = "bproof"},
	},
}

Config.Markers = {
    color = {255, 255, 255},
    id = 27,
	opacity = 70,
    size = 1.5,
    animate = false,
    turn = true
}

Config.Blips = {
	text = "Magasin de vêtements",
	sprite = 73,
	color = 47,
	scale = 0.8
}