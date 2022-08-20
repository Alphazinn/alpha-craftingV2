-- Locals
local QBCore = exports["qb-core"]:GetCoreObject()
local InMenu = false
local PlayerInfo = {}
local RefundBackup = nil

-- Functions
local function HasValue (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function OpenUI(CraftingStationID)
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(0)
    SendNUIMessage({
        action = "OpenCraftingStation",
        data = CraftingStationID
    })
    InMenu = true
end

local function CloseUI()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)
    InMenu = false
end

local function RefreshPlayerData()
    local PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.TriggerCallback("alpha-craftingV2:Server:GetPlayerLevelStatus", function(cb)
        if cb then
            PlayerInfo.PlayerLevel = cb.PlayerLevel
            PlayerInfo.PlayerXP = cb.PlayerXP
        end
    end, PlayerData.citizenid)
    PlayerInfo.PlayerJob = PlayerData.job.name
end

local function CheckForCraft(data)
    local ItemCategory = string.match(data.data, ":(.*)")
    local ItemsInfo = Config.CraftingStations[string.lower(ItemCategory)]
    local ItemName = string.match(data.data, "(.*):")
    local ItemNameLower = string.lower(ItemName)
    local ItemInfo = {}

    for index, value in ipairs(ItemsInfo.Crafts) do
        if value.Item == ItemNameLower then
            ItemInfo = value
        end
    end

    if PlayerInfo.PlayerLevel >= ItemInfo.Level then
        if #ItemInfo.Jobs > 0 then
            if HasValue(ItemInfo.Jobs, PlayerInfo.PlayerJob) then
                TriggerServerEvent("alpha-craftingV2:Server:CraftItemFinal", ItemInfo)
            else
                QBCore.Functions.Notify("Your Job Isn't Suitable For This Item", "error", 2000)
            end
        else
            TriggerServerEvent("alpha-craftingV2:Server:CraftItemFinal", ItemInfo)
        end
    else
        QBCore.Functions.Notify("Your Level Isn't Enough For This Item", "error", 2000)
    end
end

-- Callbacks
RegisterNUICallback("CloseCSUI", function()
    CloseUI()
end)

RegisterNUICallback("GetMenuData", function(StationID)
    SendNUIMessage({
        action = "SetMenuData",
        data = Config.CraftingStations[StationID.data]
    })
end)

RegisterNUICallback("CheckCraft", function(data)
    CheckForCraft(data)
end)

RegisterNUICallback("GetPlayerInventory", function()
    SendNUIMessage({
        action = "SetUserInventory",
        data = QBCore.Functions.GetPlayerData().items
    })
end)

RegisterNUICallback("GetLevelData", function()
    SendNUIMessage({
        action = "SetLevelData",
        data = {Config.UseLevelSystem, PlayerInfo.PlayerLevel, PlayerInfo.PlayerXP, Config.LevelSystem}
    })
end)

RegisterNUICallback("TakeItemsFromPlayer", function(data)
    TriggerServerEvent("alpha-craftingV2:Server:TakeItemsFromPlayer", data.data)
end)

RegisterNUICallback("GiveItemToPlayer", function(data)
    local PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent("alpha-craftingV2:Server:GiveItemToPlayer", data.data, data.TempMaxXP, PlayerInfo, PlayerData.citizenid)
end)

RegisterNUICallback("RefundItems", function()
    TriggerServerEvent("alpha-craftingV2:Server:RefundItems", RefundBackup)
end)

-- Events
RegisterNetEvent("alpha-craftingV2:Client:OpenCraftingStation")
AddEventHandler("alpha-craftingV2:Client:OpenCraftingStation", function(CraftingStationID)
    OpenUI(CraftingStationID)
end)

RegisterNetEvent("alpha-craftingV2:Client:StartCraftItem")
AddEventHandler("alpha-craftingV2:Client:StartCraftItem", function(ItemInfo)
    SendNUIMessage({
        action = "StartCraftItem",
        data = ItemInfo
    })
end)

RegisterNetEvent("alpha-craftingV2:Client:PlayCraftSFX")
AddEventHandler("alpha-craftingV2:Client:PlayCraftSFX", function(data)
    SendNUIMessage({
        action = "PlayCraftSFX",
        data = data
    })
end)

RegisterNetEvent("alpha-craftingV2:Client:RefreshPlayerData")
AddEventHandler("alpha-craftingV2:Client:RefreshPlayerData", function()
    RefreshPlayerData()
end)

RegisterNetEvent("alpha-craftingV2:Client:UpdateLevelArea")
AddEventHandler("alpha-craftingV2:Client:UpdateLevelArea", function(data, dataTwo)
    SendNUIMessage({
        action = "UpdateLevelArea",
        data = {data, dataTwo}
    })
end)

RegisterNetEvent("alpha-craftingV2:Client:SetCraftBackup")
AddEventHandler("alpha-craftingV2:Client:SetCraftBackup", function(data)
    RefundBackup = data
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.TriggerCallback("alpha-craftingV2:Server:GetPlayerLevelStatus", function(cb)
        if cb then
            PlayerInfo.PlayerLevel = cb.PlayerLevel
            PlayerInfo.PlayerXP = cb.PlayerXP
        end
    end, PlayerData.citizenid)
    PlayerInfo.PlayerJob = PlayerData.job.name
end)

-- Threads
Citizen.CreateThread(function()
    if Config.UseTarget == true then
        for k, v in pairs(Config.CraftingStations) do
            exports["qb-target"]:AddBoxZone(v.Target.Name, v.Target.Vector3, v.Target.Vector3One, v.Target.Vector3Two, {
                name = v.Target.Name,
                heading = v.Target.Heading,
                minZ = v.Target.MinZ,
                maxZ = v.Target.MaxZ
            },
            {
                options = {
                    {
                        type = "client",
                        event = "alpha-craftingV2:Client:OpenCraftingStation", v.CraftingStationID,
                        icon = v.Target.FAIcon,
                        label = v.Title
                    }
                },
                distance = 1.5
            })
        end
    else
        CreateThread(function()
            while true do
                local WaitTime = 2000
                local Position = GetEntityCoords(PlayerPedId())
                local InRange = false

                for k, v in pairs(Config.CraftingStations) do
                    local Distance = #(Position - v.Coords)
                    if Distance < 1.0 then
                        if InMenu == false then
                            InRange = true
                            WaitTime = 0
                            DrawMarker(Config.FloorBlip.Marker, v.Coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.FloorBlip.Width, Config.FloorBlip.Thickness, Config.FloorBlip.Height, Config.FloorBlip.rgbR, Config.FloorBlip.rgbG, Config.FloorBlip.rgbB, Config.FloorBlip.rgbA, 0, 0, 0, Config.FloorBlip.Rotate, 0, 0, 0)
                            exports["qb-core"]:DrawText("[" .. Config.KeyName .. "] " .. v.Title, v.Coords)
                            if IsControlJustReleased(0, Config.Key) then
                                exports["qb-core"]:HideText()
                                TriggerEvent("alpha-craftingV2:Client:OpenCraftingStation", v.CraftingStationID)
                            end
                        end
                    end
                end

                if InRange == false then
                    exports["qb-core"]:HideText()
                end

                Wait(WaitTime)
            end
        end)
    end
end)
