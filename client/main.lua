local QBCore = exports['qb-core']:GetCoreObject()
local isLoggedIn = true
local PlayerJob = {}
local onDuty = false

-- List of back engine vehicles
local BackEngineVehicles = {
    'ninef', 'adder', 'vagner', 't20', 'infernus', 'zentorno', 'reaper', 'comet2', 'comet3', 'jester',
    'jester2', 'cheetah', 'cheetah2', 'prototipo', 'turismor', 'pfister811', 'ardent', 'nero', 'nero2',
    'tempesta', 'vacca', 'bullet', 'osiris', 'entityxf', 'turismo2', 'fmj', 're7b', 'tyrus', 'italigtb',
    'penetrator', 'monroe', 'ninef2', 'stingergt', 'surfer', 'surfer2', 'comet3'
}

-- Events for loading player data and updating job information
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.type == Config.Job then
                TriggerServerEvent("QBCore:ToggleDuty")
            end
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

-- Function to save vehicle modifications
local function saveVehicle()
    local veh = QBCore.Functions.GetClosestVehicle()
    local vehicleMods = {
        mods = {
            [11] = GetVehicleMod(veh, 11),
            [12] = GetVehicleMod(veh, 12),
            [13] = GetVehicleMod(veh, 13),
            [15] = GetVehicleMod(veh, 15),
            [18] = IsToggleModOn(veh, 18),
        }
    }
    local myCar = QBCore.Functions.GetVehicleProperties(veh)
    TriggerServerEvent('updateVehicle', myCar)
end

-- Function to check if a vehicle is back engine
local function IsBackEngine(vehModel)
    for _, model in pairs(BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

-- Command to open the mechanic parts menu
RegisterCommand("openmechanicmenu", function()
    TriggerEvent('craft:mechanicparts')
end, false)

RegisterNetEvent('openmechanicmenu')
AddEventHandler('openmechanicmenu', function()
    TriggerEvent('craft:mechanicparts')
end)

-- Generic function for performing crafting
local function performCrafting(action, dict, anim, time, successEvent)
    QBCore.Functions.Progressbar("craft_"..action, "Building "..action.."...", time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = dict,
        anim = anim,
        flags = 16,
    }, {}, {}, function()
        local playerPed = PlayerPedId()
        exports['ps-ui']:Circle(function(success)
            if success then
                StopAnimTask(playerPed, dict, anim, 1.0)
                TriggerServerEvent(successEvent)
                ClearPedTasks(playerPed)
            else
                QBCore.Functions.Notify("Failed!", "error")
                ClearPedTasks(playerPed)
            end
        end, 2, 30)
    end)
end

-- Register events for crafting parts
local parts = {"engine0", "engine1", "engine2", "engine3", "engine4", "brake0", "brake1", "brake2", "brake3", "brake4", "transmission0", "transmission1", "transmission2", "transmission3", "transmission4", "suspension0", "suspension1", "suspension2", "suspension3", "suspension4", "turbo0", "turbo1", "repairkit"}
for _, part in pairs(parts) do
    RegisterNetEvent('craft:'..part)
    AddEventHandler("craft:"..part, function()
        performCrafting(part, "mini@repair", "fixing_a_player", 15000, "craft:"..part)
    end)
end

-- Register menu events
RegisterNetEvent('craft:mechanicparts')
AddEventHandler('craft:mechanicparts', function()
    exports['qb-menu']:openMenu({
        { id = 1, header = "Parts Menu", txt = "", isMenuHeader = true },
        { id = 2, header = "Engine Upgrades", txt = " View engine upgrades for vehicles ", params = { event = "craft:engines" } },
        { id = 3, header = "Brake Modifications", txt = " View brake modifications for vehicles ", params = { event = "craft:brakes" } },
        { id = 4, header = "Transmission Upgrades", txt = " View transmission upgrades for vehicles ", params = { event = "craft:transmissions" } },
        { id = 5, header = "Suspension Modifications", txt = " View suspension modifications for vehicles ", params = { event = "craft:suspensions" } },
        { id = 6, header = "Turbos", txt = " View turbo options for vehicles ", params = { event = "craft:turbos" } },
        { id = 7, header = "Tools & Equipment", txt = " View shop tool options ", params = { event = "craft:repairkit1" } },
        { id = 8, header = "Check Vehicle Status", txt = " View current parts installed ", params = { event = "mechanic:checkVehicleStatus" } },
        { id = 9, header = "Close Menu", txt = "", params = { event = "qb-menu:closeMenu" } }
    })
end)

RegisterNetEvent('craft:engines')
AddEventHandler('craft:engines', function()
    exports['qb-menu']:openMenu({
        { id = 1, header = "Engine Modifications", txt = "", isMenuHeader = true },
        { id = 2, header = "Stock Engine", txt = " 3x Metalscrap | 2x Rubber | 1x Iron | 2x Plastic ", params = { event = "craft:engine0" } },
        { id = 3, header = "Engine Upgrade B", txt = " 3x Metalscrap | 2x Rubber | 1x Iron | 2x Plastic ", params = { event = "craft:engine1" } },
        { id = 4, header = "Engine Upgrade C", txt = " 4x Metalscrap | 2x Rubber | 1x Iron | 2x Plastic ", params = { event = "craft:engine2" } },
        { id = 5, header = "Engine Upgrade D", txt = " 4x Metalscrap | 2x Rubber | 1x Iron | 3x Plastic ", params = { event = "craft:engine3" } },
        { id = 6, header = "Engine Upgrade S", txt = " 4x Metalscrap | 2x Rubber | 1x Iron | 3x Plastic | 3x Aluminum ", params = { event = "craft:engine4" } },
        { id = 7, header = "Main Menu", txt = "Back to main menu", params = { event = "craft:mechanicparts" } },
        { id = 8, header = "Close Menu", txt = "", params = { event = "qb-menu:closeMenu" } },
    })
end)

RegisterNetEvent('craft:brakes')
AddEventHandler('craft:brakes', function()
    exports['qb-menu']:openMenu({
        { id = 1, header = "Brake Modifications", txt = "", isMenuHeader = true },
        { id = 2, header = "Stock Brakes", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:brake0" } },
        { id = 3, header = "Brake Upgrade B", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:brake1" } },
        { id = 4, header = "Brake Upgrade C", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:brake2" } },
        { id = 5, header = "Brake Upgrade D", txt = "3x Rubber | 2x Iron | 2x Metalscrap", params = { event = "craft:brake3" } },
        { id = 6, header = "Brake Upgrade S", txt = "3x Rubber | 2x Iron | 2x Metalscrap", params = { event = "craft:brake4" } },
        { id = 7, header = "Main Menu", txt = "Back to main menu", params = { event = "craft:mechanicparts" } },
        { id = 8, header = "Close Menu", txt = "", params = { event = "qb-menu:closeMenu" } },
    })
end)

RegisterNetEvent('craft:transmissions')
AddEventHandler('craft:transmissions', function()
    exports['qb-menu']:openMenu({
        { id = 1, header = "Transmission Modifications", txt = "", isMenuHeader = true },
        { id = 2, header = "Stock Transmission", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:transmission0" } },
        { id = 3, header = "Transmission Upgrade B", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:transmission1" } },
        { id = 4, header = "Transmission Upgrade C", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:transmission2" } },
        { id = 5, header = "Transmission Upgrade D", txt = "3x Rubber | 2x Iron | 2x Metalscrap", params = { event = "craft:transmission3" } },
        { id = 6, header = "Transmission Upgrade S", txt = "3x Rubber | 2x Iron | 2x Metalscrap", params = { event = "craft:transmission4" } },
        { id = 7, header = "Main Menu", txt = "Back to main menu", params = { event = "craft:mechanicparts" } },
        { id = 8, header = "Close Menu", txt = "", params = { event = "qb-menu:closeMenu" } },
    })
end)

RegisterNetEvent('craft:suspensions')
AddEventHandler('craft:suspensions', function()
    exports['qb-menu']:openMenu({
        { id = 1, header = "Suspension Modifications", txt = "", isMenuHeader = true },
        { id = 2, header = "Stock Suspension", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:suspension0" } },
        { id = 3, header = "Suspension Upgrade B", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:suspension1" } },
        { id = 4, header = "Suspension Upgrade C", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:suspension2" } },
        { id = 5, header = "Suspension Upgrade D", txt = "3x Rubber | 2x Iron | 2x Metalscrap", params = { event = "craft:suspension3" } },
        { id = 6, header = "Suspension Upgrade S", txt = "3x Rubber | 2x Iron | 2x Metalscrap", params = { event = "craft:suspension4" } },
        { id = 7, header = "Main Menu", txt = "Back to main menu", params = { event = "craft:mechanicparts" } },
        { id = 8, header = "Close Menu", txt = "", params = { event = "qb-menu:closeMenu" } },
    })
end)

RegisterNetEvent('craft:turbos')
AddEventHandler('craft:turbos', function()
    exports['qb-menu']:openMenu({
        { id = 1, header = "Turbos", txt = "", isMenuHeader = true },
        { id = 2, header = "Stock (N/A)", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:turbo0" } },
        { id = 3, header = "Turbo", txt = "2x Rubber | 1x Iron | 2x Metalscrap", params = { event = "craft:turbo1" } },
        { id = 4, header = "Parts Menu", txt = "Build Parts Menu", params = { event = "craft:mechanicparts" } },
        { id = 5, header = "Close Menu", txt = "", params = { event = "qb-menu:closeMenu" } },
    })
end)

RegisterNetEvent('craft:repairkit1')
AddEventHandler('craft:repairkit1', function()
    exports['qb-menu']:openMenu({
        { id = 1, header = "Tools & Equipment", txt = "", isMenuHeader = true },
        { id = 2, header = "Repair Kit", txt = "4x MetalScrap | 2x Rubber | 3x Plastic | 2x aluminum | 2x Steel", params = { event = "craft:repairkit" } },
        { id = 3, header = "Main Menu", txt = "Back to main menu", params = { event = "craft:mechanicparts" } },
        { id = 4, header = "Close Menu", txt = "", params = { event = "qb-menu:closeMenu" } },
    })
end)

-- Function to install vehicle parts
local function installPart(modType, modIndex, item, notify)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    local PlayerJob = QBCore.Functions.GetPlayerData().job

    if PlayerJob.name == Config.Job then
        if onDuty then
            if vehicle ~= nil and vehicle ~= 0 then
                local vehModel = GetEntityModel(vehicle)
                local doorIndex = IsBackEngine(vehModel) and 5 or 4
                SetVehicleDoorOpen(vehicle, doorIndex, false, false)
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local vehpos = GetEntityCoords(vehicle)
                local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, IsBackEngine(vehModel) and -2.5 or 2.5, 0)

                if #(pos - vehpos) < 4.0 and #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                    QBCore.Functions.Progressbar("Installing", "Installing "..item.."...", 10000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "mini@repair",
                        anim = "fixing_a_player",
                        flags = 16,
                    }, {}, {}, function()
                        ClearPedTasksImmediately(PlayerPedId())
                        SetVehicleModKit(vehicle, 0)
                        local oldModIndex = GetVehicleMod(vehicle, modType)
                        SetVehicleMod(vehicle, modType, modIndex, true)
                        saveVehicle()
                        TriggerServerEvent("qb-mechanicparts:installPart", item, oldModIndex, modType)
                        QBCore.Functions.Notify(notify, "success")
                    end)
                end
            else
                QBCore.Functions.Notify("No vehicle nearby", "error")
            end
        else
            QBCore.Functions.Notify("You need to sign on duty!", "error")
        end
    else
        QBCore.Functions.Notify("You are not allowed to complete this action", "error")
    end
end

-- Register events for part installation
local partMods = {
    E0 = {modType = 11, modIndex = -1, item = "engine0", notify = "Stock Engine Successfully installed"},
    E1 = {modType = 11, modIndex = 0, item = "engine1", notify = "Engine Upgrade B Successfully installed"},
    E2 = {modType = 11, modIndex = 1, item = "engine2", notify = "Engine Upgrade C Successfully installed"},
    E3 = {modType = 11, modIndex = 2, item = "engine3", notify = "Engine Upgrade D Successfully installed"},
    E4 = {modType = 11, modIndex = 3, item = "engine4", notify = "Engine Upgrade S Successfully installed"},
    B0 = {modType = 12, modIndex = -1, item = "brake0", notify = "Stock Brakes Successfully installed"},
    B1 = {modType = 12, modIndex = 0, item = "brake1", notify = "Brake Upgrade B Successfully installed"},
    B2 = {modType = 12, modIndex = 1, item = "brake2", notify = "Brake Upgrade C Successfully installed"},
    B3 = {modType = 12, modIndex = 2, item = "brake3", notify = "Brake Upgrade D Successfully installed"},
    B4 = {modType = 12, modIndex = 3, item = "brake4", notify = "Brake Upgrade S Successfully installed"},
    T0 = {modType = 13, modIndex = -1, item = "transmission0", notify = "Stock Transmission Successfully installed"},
    T1 = {modType = 13, modIndex = 0, item = "transmission1", notify = "Transmission Upgrade B Successfully installed"},
    T2 = {modType = 13, modIndex = 1, item = "transmission2", notify = "Transmission Upgrade C Successfully installed"},
    T3 = {modType = 13, modIndex = 2, item = "transmission3", notify = "Transmission Upgrade D Successfully installed"},
    T4 = {modType = 13, modIndex = 3, item = "transmission4", notify = "Transmission Upgrade S Successfully installed"},
    S0 = {modType = 15, modIndex = -1, item = "suspension0", notify = "Stock Suspension Successfully installed"},
    S1 = {modType = 15, modIndex = 0, item = "suspension1", notify = "Suspension Upgrade B Successfully installed"},
    S2 = {modType = 15, modIndex = 1, item = "suspension2", notify = "Suspension Upgrade C Successfully installed"},
    S3 = {modType = 15, modIndex = 2, item = "suspension3", notify = "Suspension Upgrade D Successfully installed"},
    S4 = {modType = 15, modIndex = 3, item = "suspension4", notify = "Suspension Upgrade S Successfully installed"},
    Turbo0 = {modType = 18, modIndex = false, item = "turbo0", notify = "Turbo Successfully removed"},
    Turbo1 = {modType = 18, modIndex = true, item = "turbo1", notify = "Turbo Successfully installed"},
}

for event, data in pairs(partMods) do
    RegisterNetEvent('qb-mechanicparts:'..event)
    AddEventHandler('qb-mechanicparts:'..event, function()
        installPart(data.modType, data.modIndex, data.item, data.notify)
    end)
end

RegisterNetEvent('mechanic:checkVehicleStatus', function()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    if vehicle ~= nil and vehicle ~= 0 then
        local engine = GetVehicleMod(vehicle, 11)
        local brakes = GetVehicleMod(vehicle, 12)
        local transmission = GetVehicleMod(vehicle, 13)
        local suspension = GetVehicleMod(vehicle, 15)
        local turbo = IsToggleModOn(vehicle, 18) and "Installed" or "Not Installed"

        exports['qb-menu']:openMenu({
            { id = 1, header = "Vehicle Status", txt = "", isMenuHeader = true },
            { id = 2, header = "Engine", txt = "Current: "..engine },
            { id = 3, header = "Brakes", txt = "Current: "..brakes },
            { id = 4, header = "Transmission", txt = "Current: "..transmission },
            { id = 5, header = "Suspension", txt = "Current: "..suspension },
            { id = 6, header = "Turbo", txt = "Current: "..turbo },
            { id = 7, header = "Close Menu", txt = "", params = { event = "qb-menu:closeMenu" } },
        })
    else
        QBCore.Functions.Notify("No vehicle nearby", "error")
    end
end)
