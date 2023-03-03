Config = {}

Config.Mosley = {
    BlipPos = vector3(-25.57423, -1656.101, 29.47976), 
    BlipSprite = 641, 
    BlipColour = 47,
    BlipScale = 0.7,
    BlipCategory = 12,
    BlipName = 'Mosley\'s',
    
    MessageOuverture = "Le Mosley ~g~ouvre~s~ ses portes venez vendre vos vehicules !",
    MessageFermeture = "Le Mosley ~r~ferme~s~ ses portes a bientot !",

    Positions = { -- Positions des différents menus, à toi de les placer où tu veux : https://docs.fivem.net/docs/game-references/markers/ !
        vestiaires = {Pos = vector3(1.12772, -1658.981, 28.49974), MarkerType = 23, MarkerColor = {r = 125, g = 125, b = 125}, Size = {x = 0.7, y = 0.7, z = 0.7}},
        menuboss = {Pos = vector3(-22.42151, -1662.032, 29.47974), MarkerType = 20, MarkerColor = {r = 125, g = 125, b = 125}, Size = {x = 0.7, y = 0.7, z = 0.7}},
        garage = {Pos = vector3(-55.27015, -1684.624, 29.49183), MarkerType = 36, MarkerColor = {r = 125, g = 125, b = 125}, Size = {x = 0.7, y = 0.7, z = 0.7}},
        gestionGarage = {Pos = vector3(-31.37683, -1665.446, 29.47974), MarkerType = 36, MarkerColor = {r = 125, g = 125, b = 125}, Size = {x = 0.7, y = 0.7, z = 0.7}},
        AjouterDansStock = {Pos = vector3(-9.48357, -1667.807, 29.47973), MarkerType = 36, MarkerColor = {r = 0, g = 125, b = 70}, Size = {x = 0.7, y = 0.7, z = 0.7}},
    },

    Vehicules = {
		[1] = {model = "schafter2", label = "Schafter"},
        [2] = {model = "schafter4", label = "Schafter V12"},
	},

    places = {
        [1] = {pos = vector3(-25.62889, -1646.871, 29.47973), heading = 234.84},
        [2] = {pos = vector3(-31.11055, -1653.49, 29.47974), heading = 231.63},
        [3] = {pos = vector3(-34.01595, -1656.91, 29.47969), heading = 233.73},
    },

    SpawnCoords = vector3(-55.27015, -1684.624, 29.49183), 

    TenuesJob = {
        [1] = {
            label = 'Vendeur',
            male = {
                tshirt_1 = 59,  tshirt_2 = 1,
                torso_1 = 55,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 41,
                pants_1 = 25,   pants_2 = 0,
                shoes_1 = 25,   shoes_2 = 0,
                helmet_1 = 46,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            },
            female = {
                tshirt_1 = 36,  tshirt_2 = 1,
                torso_1 = 48,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 44,
                pants_1 = 34,   pants_2 = 0,
                shoes_1 = 27,   shoes_2 = 0,
                helmet_1 = 45,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            } 
        },

        [2] = {
            label = 'Patron',
            male = {
                tshirt_1 = 59,  tshirt_2 = 1,
                torso_1 = 55,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 41,
                pants_1 = 25,   pants_2 = 0,
                shoes_1 = 25,   shoes_2 = 0,
                helmet_1 = 46,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            },
            female = {
                tshirt_1 = 36,  tshirt_2 = 1,
                torso_1 = 48,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 44,
                pants_1 = 34,   pants_2 = 0,
                shoes_1 = 27,   shoes_2 = 0,
                helmet_1 = 45,  helmet_2 = 0,
                chain_1 = 0,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            } 
        },
    },

}
  


