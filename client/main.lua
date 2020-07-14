local inCar = false
local kmToAdd = 0

Citizen.CreateThread(function()
    while true do
        local pPed = GetPlayerPed(-1)
        local inCar = IsPlayerInCar(pPed)
        if inCar then
            local pVeh = GetVehiclePedIsIn(pPed, false)
            local plate = GetVehicleNumberPlateText(pVeh)
            local LastPos = GetEntityCoords(pVeh)
            while inCar do
                inCar = IsPlayerInCar(pPed)
                local newPos = GetEntityCoords(pVeh)
                local km = #(LastPos - newPos)
                if km > 0.1 then
                    kmToAdd = kmToAdd + km
                end
                LastPos = newPos
                Wait(500)
            end
            TriggerServerEvent(config.prefix .. config.AddMileageEvent, plate, Round(kmToAdd / 1000, 3))
            kmToAdd = 0
        end
        Wait(500)
    end
end)


function IsPlayerInCar(ped)
    if IsPedInAnyVehicle(ped, false) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped then
            return true
        else
            return false
        end
    else
        return false
    end
end

-- Taken from https://github.com/esx-framework/es_extended/blob/legacy/common/modules/math.lua
function Round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end