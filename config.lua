Config = {}

Config.shopCoords = vector3(-154.10446166992, -2151.0637207031, 16.705057144165)
Config.spawnCoords = vector3(-154.07208251953, -2146.6520996094, 15.837361335754)
Config.spawnHeading = 263.43533325195
Config.start = vector3(-117.96625518799, -2117.7780761719, 15.837563514709)
Config.pedCoords = vector3(-153.77397155762, -2151.7702636719, 16.705057144165)
Config.pedHeading = 15.59645652771
Config.pedHash = 'a_m_y_motox_02'
Config.WebHook = false -- or your webhook

Config.CheckPoints = {
    vector3(-96.983505249023, -2122.6223144531, 15.836974143982),
    vector3(-48.593933105469, -2092.3293457031, 15.837418556213),
    vector3(-104.38787078857, -2056.3569335938, 16.558723449707),
    vector3(-72.033073425293, -2024.5675048828, 17.148984909058),
    vector3(-78.099571228027, -1989.7436523438, 17.148782730103),
    vector3(-116.14757537842, -2022.0540771484, 17.149732589722),
    vector3(-146.63774108887, -2094.4094238281, 15.576974868774),
    vector3(-100.94456481934, -2088.6335449219, 16.558547973633),
    vector3(-100.94456481934, -2088.6335449219, 16.558547973633),
    vector3(-117.90991210938, -2117.8068847656, 15.837255477905)
}

Config.Karts = {
    'Veto moderne',
    'Veto classique'
}

Config.KartsDetails = {
    ['Veto moderne'] = {string = "veto2", price = 80},
    ['Veto classique'] = {string = "veto", price = 30}
}

Config.Times = {   --in minutes
    1,
    10,
    20,
    30,
    60
}

Config.pricePerMinute = 10

Config.Blip = {
    sprite = 748,
    colour = 26,
    scale = 0.9,
    string = 'Karting'
}

Config.Lang = 'fr'

Config.Locales = {
    ['en'] = {
        ['access_shop'] = 'to access shop',
        ['time_rent'] = 'Rent time',
        ['vehicle_choice'] = 'Vehicle',
        ['yes'] = 'Yes',
        ['no'] = 'No',
        ['rent_kart'] = 'Rent a kart',
        ['not_enough_money'] = '~r~You do not have enough money!',
        ['start_trial'] = '~INPUT_CONTEXT~ to start time trial',
        ['your_time'] = 'Your time: ~y~',
        ['seconds'] = ' ~s~seconds',
        ['get_back'] = 'Get back in your karting!',
        ['time_left'] = "Time left(renting)"
    },
    ['fr'] = {
        ['access_shop'] = 'pour accéder au magasin',
        ['time_rent'] = 'Temps de location',
        ['vehicle_choice'] = 'Véhicule',
        ['yes'] = 'Oui',
        ['no'] = 'Non',
        ['rent_kart'] = 'Louer un karting',
        ['not_enough_money'] = "~r~Vous n'avez pas assez d'argent!",
        ['start_trial'] = '~INPUT_CONTEXT~ pour commencer un contre-la-montre',
        ['your_time'] = 'Votre temps: ~y~',
        ['seconds'] = ' ~s~secondes',
        ['get_back'] = 'Retourner dans le karting!',
        ['time_left'] = "Temps restant(location)"
    },
}