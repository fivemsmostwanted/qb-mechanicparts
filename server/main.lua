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
    { item = "brake4", event = "qb-mechanicparts:B4" },
    { item = "transmission0", event = "qb-mechanicparts:T0" },
    { item = "transmission1", event = "qb-mechanicparts:T1" },
    { item = "transmission2", event = "qb-mechanicparts:T2" },
    { item = "transmission3", event = "qb-mechanicparts:T3" },
    { item = "transmission4", event = "qb-mechanicparts:T4" },
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
        local playerItem = Player.Functions.GetItemByName(item)
        print("Checking item:", item, "required amount:", amount, "player has:", playerItem and playerItem.amount or 0)
        if not playerItem or playerItem.amount < amount then
            print("Missing item:", item)
            TriggerClientEvent('QBCore:Notify', source, 'You are missing '..item..'...', 'error')
            return
        end
    end

    for item, amount in pairs(items) do
        Player.Functions.RemoveItem(item, amount)
        print("Removed item:", item, "amount:", amount)
    end

    Player.Functions.AddItem(part, 1)
    print("Added crafted part:", part)
    TriggerClientEvent('QBCore:Notify', source, 'You built a '..part..'.', 'success')
end

RegisterServerEvent("craft:engine0")
AddEventHandler("craft:engine0", function() craftPart(source, { metalscrap = 3, rubber = 2, iron = 1, plastic = 2 }, "engine0") end)

RegisterServerEvent("craft:engine1")
AddEventHandler("craft:engine1", function() craftPart(source, { metalscrap = 3, rubber = 2, iron = 1, plastic = 2 }, "engine1") end)

RegisterServerEvent("craft:engine2")
AddEventHandler("craft:engine2", function() craftPart(source, { metalscrap = 4, rubber = 2, iron = 1, plastic = 2 }, "engine2") end)

RegisterServerEvent("craft:engine3")
AddEventHandler("craft:engine3", function() craftPart(source, { metalscrap = 4, rubber = 2, iron = 1, plastic = 3 }, "engine3") end)

RegisterServerEvent("craft:engine4")
AddEventHandler("craft:engine4", function() craftPart(source, { metalscrap = 4, rubber = 2, iron = 1, plastic = 3, aluminum = 3 }, "engine4") end)

RegisterServerEvent("craft:brake0")
AddEventHandler("craft:brake0", function() craftPart(source, { rubber = 2, iron = 1, metalscrap = 2 }, "brake0") end)

RegisterServerEvent("craft:brake1")
AddEventHandler("craft:brake1", function() craftPart(source, { rubber = 2, iron = 1, metalscrap = 2 }, "brake1") end)

RegisterServerEvent("craft:brake2")
AddEventHandler("craft:brake2", function() craftPart(source, { rubber = 2, iron = 1, metalscrap = 2 }, "brake2") end)

RegisterServerEvent("craft:brake3")
AddEventHandler("craft:brake3", function() craftPart(source, { rubber = 3, iron = 2, metalscrap = 2 }, "brake3") end)

RegisterServerEvent("craft:brake4")
AddEventHandler("craft:brake4", function() craftPart(source, { rubber = 3, iron = 2, metalscrap = 2 }, "brake4") end)

RegisterServerEvent("craft:transmission0")
AddEventHandler("craft:transmission0", function() craftPart(source, { rubber = 2, iron = 1, metalscrap = 2 }, "transmission0") end)

RegisterServerEvent("craft:transmission1")
AddEventHandler("craft:transmission1", function() craftPart(source, { rubber = 2, iron = 1, metalscrap = 2 }, "transmission1") end)

RegisterServerEvent("craft:transmission2")
AddEventHandler("craft:transmission2", function() craftPart(source, { rubber = 2, iron = 1, metalscrap = 2 }, "transmission2") end)

RegisterServerEvent("craft:transmission3")
AddEventHandler("craft:transmission3", function() craftPart(source, { rubber = 3, iron = 2, metalscrap = 2 }, "transmission3") end)

RegisterServerEvent("craft:transmission4")
AddEventHandler("craft:transmission4", function() craftPart(source, { rubber = 3, iron = 2, metalscrap = 2 }, "transmission4") end)

RegisterServerEvent("craft:suspension0")
AddEventHandler("craft:suspension0", function() craftPart(source, { rubber = 2, iron = 1, metalscrap = 2 }, "suspension0") end)

RegisterServerEvent("craft:suspension1")
AddEventHandler("craft:suspension1", function() craftPart(source, { rubber = 2, iron = 1, metalscrap = 2 }, "suspension1") end)

RegisterServerEvent("craft:suspension2")
AddEventHandler("craft:suspension2", function() craftPart(source, { rubber = 2, iron = 1, metalscrap = 2 }, "suspension2") end)

RegisterServerEvent("craft:suspension3")
AddEventHandler("craft:suspension3", function() craftPart(source, { rubber = 3, iron = 2, metalscrap = 2 }, "suspension3") end)

RegisterServerEvent("craft:suspension4")
AddEventHandler("craft:suspension4", function() craftPart(source, { rubber = 3, iron = 2, metalscrap = 2 }, "suspension4") end)

RegisterServerEvent("craft:turbo0")
AddEventHandler("craft:turbo0", function() craftPart(source, { rubber = 3, iron = 2, metalscrap = 2 }, "turbo0") end)

RegisterServerEvent("craft:turbo1")
AddEventHandler("craft:turbo1", function() craftPart(source, { rubber = 3, iron = 2, metalscrap = 2 }, "turbo1") end)

RegisterServerEvent("craft:repairkit")
AddEventHandler("craft:repairkit", function() craftPart(source, { metalscrap = 4, rubber = 2, plastic = 3, aluminum = 2, steel = 2 }, "repairkit") end)

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
        oldPart = oldModIndex and "turbo1" or "turbo0"
    end

    if oldPart then
        Player.Functions.AddItem(oldPart, 1)
        print("Old Vehicle part added to inventory: " .. oldPart)
    end
end)

QBCore.Commands.Add("mechanicmenu", "Open the Mechanic Parts Menu", {}, false, function(source, args)
    TriggerClientEvent('openmechanicmenu', source)
end, "admin")
