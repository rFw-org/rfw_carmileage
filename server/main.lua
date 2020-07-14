local debug = true
local MileageCache = {}

Citizen.CreateThread(function()
    while true do
        if GetTableCount(MileageCache) > 0 then
            SaveMileage()
        end
        Wait(5*1000)
    end
end)

function GetTableCount(table)
    local count = 0
    for k,v in pairs(table) do
        count = count + 1
    end
    return count
end

function SaveMileage()
    local count = 0
    local requests = {}
    for k,v in pairs(MileageCache) do
        requests[#requests + 1] = "UPDATE `players_veh` SET mileage = mileage + "..v.count.." WHERE players_veh.plate = '"..k.."'"
        count = count + 1
    end

    if count == GetTableCount(MileageCache) and count > 0 then
        MySQL.Async.transaction(requests, {}, function(success)
            if success then
                print("^2SAVED: ^7"..count.." veh mileage.")
            else
                print("^1ERROR: ^7Could not save"..count.." veh mileage.")
            end
            MileageCache = {}
            count = 0
            requests = {}
        end)  
    end
end

RegisterNetEvent(config.prefix .. config.AddMileageEvent)
AddEventHandler(config.prefix .. config.AddMileageEvent, function(plate, km)
    if MileageCache[plate] == nil then
        MileageCache[plate] = {}
        MileageCache[plate].count = 0
    end

    MileageCache[plate].count = MileageCache[plate].count + km

    -- Debug
    if debug then
        print("^2MILEAGE: ^7Added "..km.." km to ["..plate.."] - Total mileage: "..MileageCache[plate].count)
    end
end)