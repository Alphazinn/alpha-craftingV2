Config = {} -- Don't Remove This

Config.UseTarget = true -- Compatible with qb-target (If you set the value to true, the menu will be opened with qb-target. If you set the value to false, there will be a blip when you go near it and you will have to press the specified key)
Config.Key = 38 -- Change this if you don't wanna use qb-target (38 = [E]) https://docs.fivem.net/docs/game-references/controls/#controls
Config.KeyName = "E" -- 38 = E

Config.FloorBlip = { -- The blip will be disappear in front of crafting station if you set Config.UseTarget to false

    Marker = 2, -- https://docs.fivem.net/docs/game-references/markers/#markers
    Width = 0.3,
    Height = 0.2,
    Thickness = 0.3,
    -- RGB (Recommended => Hex Color Picker)
    rgbR = 255, -- Red
    rgbG = 255, -- Green
    rgbB = 255, -- Blue
    rgbA = 255, -- (Opacity) (RGB Alpha, Max 255)
    Rotate = 1, -- (1 = True (Rotate Marker), 0 = False (Don't Rotate Marker))

}

Config.UseLevelSystem = true -- If you want level system or not
Config.LevelSystem = { -- Level system config

    MaxLevel = 30, -- Max Level (Don't Make Above 127)
    XPMultiplier = 1.1, -- Each time you level up, it determines the amount of xp needed to reach to another level (Example: Level 1 = 100 XP, Level 2 = 220 XP, Level 3 = 330 XP...)
    GiveXPWhenCraftFails = true -- Even if the player fails to craft the item, give experience to the player?

}

Config.CraftingStations = { -- All crafting stations config

    weaponcrafting = {

        Title = "Weapon Crafting Station", -- Crafting station title
        CraftingStationID = "weaponcrafting", -- Crafting station id (Must be unique)

        Coords = vector3(2195.64, 5594.35, 53.77), -- Crafting station coords

        MapBlipStatus = true, -- If you want a blip will be disappear in map or not
        MapBlip = { -- The blip will be disappear in minimap if you keep Config.MapBlipStatus as true

            Sprite = 402, -- https://docs.fivem.net/docs/game-references/blips/#blips
            Color = 3, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
            Display = 4, -- 0 = Doesn't show up, ever, anywhere | 2 = Shows on both main map and minimap (Selectable on map) | 3 = Shows on main map only (Selectable on map) | 4 = Shows on main map only (Selectable on map) | 5 = Shows on minimap only | 8 = Shows on both main map and minimap (Not selectable on map)
            Scale = 0.8, -- Blip scale
            Text = "Crafting Station", -- Blip text
            Vector3 = vector3(2195.64, 5594.35, 53.77) -- Crafting station coords

        },

        Target = {

            Vector3 = vector3(2196.69, 5594.06, 53.76),
            Vector3One = 1.35,
            Vector3Two = 2.2,
            Name = "weaponcrafting", -- Must be same as CraftingStationID
            Heading = 254,
            MinZ = 50.56,
            MaxZ = 54.56,

            FAIcon = "fa-solid fa-gun" -- https://fontawesome.com/icons

            --[[
                --Name: weaponcrafting | 2022-06-19T13:10:02Z
                BoxZone:Create(vector3(2196.69, 5594.06, 53.76), 1.35, 2.2, {
                name="weaponcrafting",
                heading=254,
                --debugPoly=true,
                minZ=50.56,
                maxZ=54.56
                })
            ]]--

        },

        Crafts = {

            { -- 1

                Item = "weapon_heavypistol", -- Item ID
                Label = "Entreprise Arms Wide Body 1911", -- Item's label
                Description = "A hefty firearm designed to be held in one hand (or attempted)", -- Item's description
                Category = "weaponcrafting", -- Item's category, must be same as CraftingStationID
                Icon = "../../assets/img/weapon/heavypistol.png", -- Item's icon

                Quantity = 1, -- Quantity to be given when crafted
                SuccessRate = 90, -- Probability of successful item production ( 90 = %90... )
                Time = 300, -- Craft time as seconds
                Level = 3, -- Level required to craft the item
                XP = 40, -- Amount of xp to be awarded after item crafting
                Jobs = { -- Jobs can craft this item (Leave empty if you want everyone to be able to craft)

                },
                Requirements = {

                    {
                        Label = "Heavy Pistol Blueprint",
                        ItemName = "bp_weapon_pistol",
                        Icon = "../../assets/img/blueprint/bp_weapon_pistol.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    },

                    {
                        Label = "Weapon Barrel",
                        ItemName = "weapon_barrel",
                        Icon = "../../assets/img/material/weapon_barrel.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    },

                    {
                        Label = "Weapon Trigger",
                        ItemName = "weapon_trigger",
                        Icon = "../../assets/img/material/weapon_trigger.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    },

                    {
                        Label = "Weapon Grip",
                        ItemName = "weapon_grip",
                        Icon = "../../assets/img/material/weapon_grip.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    },

                    {
                        Label = "Metal Spring",
                        ItemName = "metal_spring",
                        Icon = "../../assets/img/material/metal_spring.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    }

                }

            },

            { -- 2

                Item = "weapon_pistol", -- Item ID
                Label = "Taurus PT92AF", -- Item's label
                Description = "A small firearm designed to be held with one hand", -- Item's description
                Category = "weaponcrafting", -- Item's category, must be same as CraftingStationID
                Icon = "../../assets/img/weapon/pistol.png", -- Item's icon

                Quantity = 1, -- Quantity to be given when crafted
                SuccessRate = 95, -- Probability of successful item production ( 90 = %90... )
                Time = 300, -- Craft time as seconds
                Level = 2, -- Level required to craft the item
                XP = 30, -- Amount of xp to be awarded after item crafting
                Jobs = { -- Jobs can craft this item (Leave empty if you want everyone to be able to craft)

                },
                Requirements = {

                    {
                        Label = "Pistol Blueprint",
                        ItemName = "bp_weapon_pistol",
                        Icon = "../../assets/img/blueprint/bp_weapon_pistol.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    },

                    {
                        Label = "Weapon Barrel",
                        ItemName = "weapon_barrel",
                        Icon = "../../assets/img/material/weapon_barrel.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    },

                    {
                        Label = "Weapon Trigger",
                        ItemName = "weapon_trigger",
                        Icon = "../../assets/img/material/weapon_trigger.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    },

                    {
                        Label = "Weapon Grip",
                        ItemName = "weapon_grip",
                        Icon = "../../assets/img/material/weapon_grip.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    },

                    {
                        Label = "Metal Spring",
                        ItemName = "metal_spring",
                        Icon = "../../assets/img/material/metal_spring.png",
                        Amount = 1,
                        RemoveOnCraft = true
                    },

                }

            },

        }

    },

    --------------------------------------------------------------------------------------------------------------------------------

    medicalcrafting = {

        Title = "Medical Crafting Station", -- Crafting station title
        CraftingStationID = "medicalcrafting", -- Crafting station id (Must be unique)

        Coords = vector3(3559.86, 3674.71, 28.12), -- Crafting station coords

        MapBlipStatus = true, -- If you want a blip will be disappear in map or not
        MapBlip = { -- The blip will be disappear in minimap if you keep Config.MapBlipStatus as true

            Sprite = 402, -- https://docs.fivem.net/docs/game-references/blips/#blips
            Color = 3, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
            Display = 4, -- 0 = Doesn't show up, ever, anywhere | 2 = Shows on both main map and minimap (Selectable on map) | 3 = Shows on main map only (Selectable on map) | 4 = Shows on main map only (Selectable on map) | 5 = Shows on minimap only | 8 = Shows on both main map and minimap (Not selectable on map)
            Scale = 0.8, -- Blip scale
            Text = "Crafting Station", -- Blip text
            Vector3 = vector3(3559.86, 3674.71, 28.12) -- Crafting station coords

        },

        Target = {

            Vector3 = vector3(3559.72, 3673.39, 28.12),
            Vector3One = 1.65,
            Vector3Two = 2.45,
            Name = "medicalcrafting", -- Must be same as CraftingStationID
            Heading = 350,
            MinZ = 24.72,
            MaxZ = 28.72,

            FAIcon = "fa-solid fa-kit-medical" -- https://fontawesome.com/icons

            --[[
                --Name: medicalcrafting | 2022-06-19T13:05:31Z
                BoxZone:Create(vector3(3559.72, 3673.39, 28.12), 1.65, 2.45, {
                name="medicalcrafting",
                heading=350,
                --debugPoly=true,
                minZ=24.72,
                maxZ=28.72
                })
            ]]--

        },

        Crafts = {

            { -- 1

                Item = "firstaid", -- Item ID
                Label = "Medkit", -- Item's label
                Description = "A small bag or case containing medical supplies", -- Item's description
                Category = "medicalcrafting", -- Item's category, must be same as CraftingStationID
                Icon = "../../assets/img/medical/medkit.png", -- Item's icon

                Quantity = 1, -- Quantity to be given when crafted
                SuccessRate = 100, -- Probability of successful item production ( 90 = %90... )
                Time = 60, -- Craft time as seconds
                Level = 1, -- Level required to craft the item
                XP = 10, -- Amount of xp to be awarded after item crafting
                Jobs = { -- Jobs can craft this item (Leave empty if you want everyone to be able to craft)
                    "Ambulance"
                },
                Requirements = {

                    {
                        Label = "Bandage",
                        ItemName = "bandage",
                        Icon = "../../assets/img/material/bandage.png",
                        Amount = 5,
                        RemoveOnCraft = true
                    },

                }

            },

        }

    },

    --------------------------------------------------------------------------------------------------------------------------------

    misccrafting = {

        Title = "Misc Crafting Station", -- Crafting station title
        CraftingStationID = "misccrafting", -- Crafting station id (Must be unique)

        Coords = vector3(1443.22, 6332.29, 23.98), -- Crafting station coords

        MapBlipStatus = true, -- If you want a blip will be disappear in map or not
        MapBlip = { -- The blip will be disappear in minimap if you keep Config.MapBlipStatus as true

            Sprite = 402, -- https://docs.fivem.net/docs/game-references/blips/#blips
            Color = 3, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
            Display = 4, -- 0 = Doesn't show up, ever, anywhere | 2 = Shows on both main map and minimap (Selectable on map) | 3 = Shows on main map only (Selectable on map) | 4 = Shows on main map only (Selectable on map) | 5 = Shows on minimap only | 8 = Shows on both main map and minimap (Not selectable on map)
            Scale = 0.8, -- Blip scale
            Text = "Crafting Station", -- Blip text
            Vector3 = vector3(1443.22, 6332.29, 23.98) -- Crafting station coords

        },

        Target = {

            Vector3 = vector3(1443.31, 6331.18, 23.84),
            Vector3One = 0.85,
            Vector3Two = 2.6,
            Name = "misccrafting", -- Must be same as CraftingStationID
            Heading = 359,
            MinZ = 20.84,
            MaxZ = 24.84,

            FAIcon = "fa-solid fa-arrow-down-a-z" -- https://fontawesome.com/icons

            --[[
                --Name: misccrafting | 2022-06-19T13:12:02Z
                BoxZone:Create(vector3(1443.31, 6331.18, 23.84), 0.85, 2.6, {
                name="misccrafting",
                heading=359,
                --debugPoly=true,
                minZ=20.84,
                maxZ=24.84
                })
            ]]--

        },

        Crafts = {

            { -- 1

                Item = "lockpick", -- Item ID
                Label = "Lockpick", -- Item's label
                Description = "A device that enables a burglar to open a lock", -- Item's description
                Category = "misccrafting", -- Item's category, must be same as CraftingStationID
                Icon = "../../assets/img/misc/lockpick.png", -- Item's icon

                Quantity = 3, -- Quantity to be given when crafted
                SuccessRate = 100, -- Probability of successful item production ( 90 = %90... )
                Time = 20, -- Craft time as seconds
                Level = 0, -- Level required to craft the item
                XP = 6, -- Amount of xp to be awarded after item crafting
                Jobs = { -- Jobs can craft this item (Leave empty if you want everyone to be able to craft)

                },
                Requirements = {

                    {
                        Label = "Iron",
                        ItemName = "iron",
                        Icon = "../../assets/img/material/iron.png",
                        Amount = 3,
                        RemoveOnCraft = true
                    },

                }

            },

        }

    },

}