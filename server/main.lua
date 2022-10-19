-- Locals
local QBCore = exports["qb-core"]:GetCoreObject()

-- Callbacks
QBCore.Functions.CreateCallback("alpha-craftingV2:Server:GetPlayerLevelStatus", function(source, cb, citizenid)
    local LevelInfo = {}
    local PlayerLevelDB = exports.oxmysql:scalarSync("SELECT crafting_level FROM players WHERE citizenid = @citizenid", {
        ["@citizenid"] = citizenid
    })

    if PlayerLevelDB then
        LevelInfo.PlayerLevel = PlayerLevelDB
    end

    local PlayerXPDB = exports.oxmysql:scalarSync("SELECT crafting_xp FROM players WHERE citizenid = @citizenid", {
        ["@citizenid"] = citizenid
    })

    if PlayerXPDB then
        LevelInfo.PlayerXP = PlayerXPDB
    end

    cb(LevelInfo)
end)

-- Events
RegisterServerEvent("alpha-craftingV2:Server:CraftItemFinal")
AddEventHandler("alpha-craftingV2:Server:CraftItemFinal", function(ItemInfo)

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local NeededAmount = 0
    local CanCraft = true
    local ControlItems = {}

    for d, v in pairs(ItemInfo.Requirements) do
        ControlItems[v.ItemName] = 0
    end

    for a, l in pairs(Player.PlayerData.items) do
        for p, h in pairs(ItemInfo.Requirements) do
            if l.name == h.ItemName then
                ControlItems[h.ItemName] = ControlItems[h.ItemName] + l.amount
            end
        end
    end

    for p, n in pairs(ControlItems) do
        for z, x in pairs(ItemInfo.Requirements) do
            if ControlItems[x.ItemName] >= x.Amount then goto alphacn end
            CanCraft = false
            ::alphacn::
        end
    end

    if CanCraft then
        TriggerClientEvent("alpha-craftingV2:Client:StartCraftItem", src, ItemInfo)
    else
        TriggerClientEvent("QBCore:Notify", src, "You Don't Have All Requirements")
    end

end)

RegisterServerEvent("alpha-craftingV2:Server:TakeItemsFromPlayer")
AddEventHandler("alpha-craftingV2:Server:TakeItemsFromPlayer", function(data)

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    print("server", json.encode(data))
    TriggerClientEvent("alpha-craftingV2:Client:SetCraftBackup", src, data)
    for a, l in pairs(data) do
        if l.RemoveOnCraft == true then
            Player.Functions.RemoveItem(l.ItemName, l.Amount)
        end
    end

end)

RegisterServerEvent("alpha-craftingV2:Server:GiveItemToPlayer")
AddEventHandler("alpha-craftingV2:Server:GiveItemToPlayer", function(data, dataTwo, PlayerInfo, citizenid)

    local src = source
    TriggerClientEvent("alpha-craftingV2:Client:RefreshPlayerData", src)
    local Player = QBCore.Functions.GetPlayer(src)
    local XPFinal = nil
    local LevelFinal = nil
    if PlayerInfo.PlayerXP + data.XP >= dataTwo then
        XPFinal = PlayerInfo.PlayerXP + data.XP - dataTwo
        LevelFinal = PlayerInfo.PlayerLevel + 1
    else
        XPFinal = PlayerInfo.PlayerXP + data.XP
    end

    if (math.random(1, 100) <= data.SuccessRate) then
        Player.Functions.AddItem(data.Item, data.Quantity)
        TriggerClientEvent("alpha-craftingV2:Client:PlayCraftSFX", src, "success")

        if Config.UseLevelSystem then
            if PlayerInfo.PlayerLevel == Config.LevelSystem.MaxLevel then
                return
            end
            exports.oxmysql:update("UPDATE players SET crafting_xp = ? WHERE citizenid = ?", {XPFinal, citizenid})
            if LevelFinal then
                exports.oxmysql:update("UPDATE players SET crafting_level = ? WHERE citizenid = ?", {LevelFinal, citizenid})
            end
            TriggerClientEvent("alpha-craftingV2:Client:UpdateLevelArea", src, XPFinal, LevelFinal)
        end

    else
        TriggerClientEvent("alpha-craftingV2:Client:PlayCraftSFX", src, "failed")

        if Config.UseLevelSystem then
            if Config.LevelSystem.GiveXPWhenCraftFails then
                exports.oxmysql:update("UPDATE players SET crafting_xp = ? WHERE citizenid = ?", {XPFinal, citizenid})
                if LevelFinal then
                    exports.oxmysql:update("UPDATE players SET crafting_level = ? WHERE citizenid = ?", {LevelFinal, citizenid})
                end
                TriggerClientEvent("alpha-craftingV2:Client:UpdateLevelArea", src, XPFinal, LevelFinal)
            end
        end

    end

end)

RegisterServerEvent("alpha-craftingV2:Server:RefundItems")
AddEventHandler("alpha-craftingV2:Server:RefundItems", function(data)

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    for a, l in pairs(data) do
        if l.RemoveOnCraft == true then
            Player.Functions.AddItem(l.ItemName, l.Amount)
        end
    end

end)

-- Functions
