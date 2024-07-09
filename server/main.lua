local QBCore = exports['qb-core']:GetCoreObject()

local function createUseableItem(item, event)
    QBCore.Functions.CreateUseableItem(item, function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.GetItemBySlot(item.slot) ~= nil then
            print("Item used: ", item.name)
            print("Triggering event: ", event)
            TriggerClientEvent(event, source)
        else
            print("Unknown error: item not found in slot")
            TriggerClientEvent('QBCore:Notify', source, "Unknown Error", "error")
        end
    end)
end

local parts = {
    { item = "engine0", event = "qb-mechanicparts:E0" },
    { item = "engine1", event = "qb-mechanicparts:E1" },
    { item = "engine2", event = "qb-mechanicparts:E2" },
    { item = "engine3", event = "qb-mechanicparts:E3" },
    { item = "engine4", event = "qb-mechanicparts:E4" },
    { item = "brake0", event = "qb-mechanicparts:B0" },
    { item = "brake1", event = "qb-mechanicparts:B1" },
    { item = "brake2", event = "qb-mechanicparts:B2" },
    { item = "brake3", event = "qb-mechanicparts:B3" },
    { item = "transmission0", event = "qb-mechanicparts:T0" },
    { item = "transmission1", event = "qb-mechanicparts:T1" },
    { item = "transmission2", event = "qb-mechanicparts:T2" },
    { item = "transmission3", event = "qb-mechanicparts:T3" },
    { item = "suspension0", event = "qb-mechanicparts:S0" },
    { item = "suspension1", event = "qb-mechanicparts:S1" },
    { item = "suspension2", event = "qb-mechanicparts:S2" },
    { item = "suspension3", event = "qb-mechanicparts:S3" },
    { item = "suspension4", event = "qb-mechanicparts:S4" },
    { item = "turbo0", event = "qb-mechanicparts:Turbo0" },
    { item = "turbo1", event = "qb-mechanicparts:Turbo1" },
    { item = "repairkit", event = "qb-mechanicparts:repairkit" },
}

for _, part in pairs(parts) do
    createUseableItem(part.item, part.event)
end

RegisterServerEvent("updateVehicle")
AddEventHandler("updateVehicle", function(myCar)
    local src = source
    print("Updating vehicle with plate:", myCar.plate)
    if IsVehicleOwned(myCar.plate) then
        MySQL.Async.execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?', { json.encode(myCar), myCar.plate })
        print("Vehicle updated in database:", myCar.plate)
    else
        print("Vehicle not owned:", myCar.plate)
    end
end)

function IsVehicleOwned(plate)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    print("Vehicle owned check for plate:", plate, "result:", result)
    return result ~= nil
end

local function craftPart(source, items, part)
    local Player = QBCore.Functions.GetPlayer(source)
    print("Starting crafting part:", part)
    for item, amount in pairs(items) do
        if item ~= "time" then -- Exclude 'time' from item checks
            local playerItem = Player.Functions.GetItemByName(item)
            print("Checking item:", item, "required amount:", amount, "player has:", playerItem and playerItem.amount or 0)
            if not playerItem or playerItem.amount < amount then
                print("Missing item:", item)
                TriggerClientEvent('QBCore:Notify', source, 'You are missing '..item..'...', 'error')
                return
            end
        end
    end

    for item, amount in pairs(items) do
        if item ~= "time" then -- Exclude 'time' from item removal
            Player.Functions.RemoveItem(item, amount)
            print("Removed item:", item, "amount:", amount)
        end
    end

    Player.Functions.AddItem(part, 1)
    print("Added crafted part:", part)
    TriggerClientEvent('QBCore:Notify', source, 'You built a '..part..'.', 'success')
end

for part, materials in pairs(Config.CraftingMaterials) do
    RegisterServerEvent("craft:"..part)
    AddEventHandler("craft:"..part, function()
        craftPart(source, materials, part)
    end)
end

RegisterServerEvent("qb-mechanicparts:installPart", function(item, oldModIndex, modType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Remove the used item
    if item then
        Player.Functions.RemoveItem(item, 1)
    end

    -- Add the old part back to the player's inventory
    local oldPart = nil
    if modType == 11 then
        oldPart = "engine" .. (oldModIndex + 1)
    elseif modType == 12 then
        oldPart = "brake" .. (oldModIndex + 1)
    elseif modType == 13 then
        oldPart = "transmission" .. (oldModIndex + 1)
    elseif modType == 15 then
        oldPart = "suspension" .. (oldModIndex + 1)
    elseif modType == 18 then
        oldPart = oldModIndex == 1 and "turbo1" or "turbo0"
    end

    if oldPart then
        Player.Functions.AddItem(oldPart, 1)
        print("Old Vehicle part added to inventory: " .. oldPart)
    end
end)

QBCore.Commands.Add("mechanicmenu", "Open the Mechanic Parts Menu", {}, false, function(source, args)
    TriggerClientEvent('openmechanicmenu', source)
end, "admin")
