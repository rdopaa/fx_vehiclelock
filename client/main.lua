local isRunningWorkaround = false

ESX = exports['es_extended']:getSharedObject()

function StartWorkaroundTask()
	if isRunningWorkaround then
		return
	end
	local timer = 0
	local playerPed = PlayerPedId()
	isRunningWorkaround = true

	while timer < 100 do
		Citizen.Wait(0)
		timer = timer + 1

		local vehicle = GetVehiclePedIsTryingToEnter(playerPed)

		if DoesEntityExist(vehicle) then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)

			if lockStatus == 4 then
				ClearPedTasks(playerPed)
			end
		end
	end
	isRunningWorkaround = false
end

function ToggleVehicleLock()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle
	local dict = "anim@mp_player_intmenu@key_fob@"

	Citizen.CreateThread(function()
		StartWorkaroundTask()
	end)
  		RequestAnimDict(dict)
  	while not HasAnimDictLoaded(dict) do
      Citizen.Wait(5)
  	end

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords, 8.0, 0, 71)
	end

	if not DoesEntityExist(vehicle) then
		return
	end

	ESX.TriggerServerCallback('fx_vehiclelock:Cars', function(isOwnedVehicle)
		if isOwnedVehicle then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)
			local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
			vehicleLabel = GetLabelText(vehicleLabel)
			if lockStatus == 1 then -- unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				StartVehicleHorn(vehicle, "NORMAL")
				ESX.ShowNotification('~r~Cerraste~s~ tu ~b~'..vehicleLabel..'~b~.')
				if not IsPedInAnyVehicle(PlayerPedId(), true) then
					TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				end
			elseif lockStatus == 2 then -- locked
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				StartVehicleHorn(vehicle, "NORMAL")
				ESX.ShowNotification('~g~Abriste~s~ tu ~b~'..vehicleLabel..'~b~.')
				if not IsPedInAnyVehicle(PlayerPedId(), true) then
					TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				end
			end
		end
	end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 244) and IsInputDisabled(0) then
			ToggleVehicleLock()
			Citizen.Wait(300)
	
		-- D-pad down on controllers works, too!
		elseif IsControlJustReleased(0, 173) and not IsInputDisabled(0) then
			ToggleVehicleLock()
			Citizen.Wait(300)
		end
	end
end)
