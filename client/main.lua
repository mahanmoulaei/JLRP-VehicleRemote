local searchedVehicles = {}
local startedEngines = {}
local isUIOpen = false
local mainThread = nil
local lockThread = nil
local disableKeyThread = nil
local isKeyDisabled = false
local bulletin = exports.bulletin
local rprogress = exports.rprogress

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	TriggerServerEvent('JLRP-VehicleRemote:Sync')
end)

CreateThread(function()
    RegisterCommand('search', Search)
end)

mainThread = SetInterval(function()
	local PlayerPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(PlayerPed, true)
    local plate = GetVehicleNumberPlateText(veh)
    local isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
    if not isInVehicle then SetInterval(mainThread, 500) end

    if isInVehicle and GetPedInVehicleSeat(veh, -1) == PlayerPed then
        if startedEngines[plate] == true then
            if not GetIsVehicleEngineRunning(veh) then
				SetVehicleEngineOn(veh, true, true, false)
                SetInterval(mainThread, 500)
			end			
        else
			SetInterval(mainThread, 0)
            SetVehicleEngineOn(veh, false, false, true)
        end
    end
end, 250)

if Config.LockState == 4 then
    lockThread = SetInterval(function()
        local PlayerPed = PlayerPedId()
        local veh = GetVehiclePedIsTryingToEnter(PlayerPed)
        if DoesEntityExist(veh) then    
            if GetVehicleDoorLockStatus(veh) == Config.LockState then
                ClearPedTasks(PlayerPed)
            end
        end
    end, 100)
end

disableKeyThread = SetInterval(function()
	if isUIOpen then
        isKeyDisabled = true
        SetInterval(disableKeyThread, 0)
        DisableAllControlActions(0)
		DisableAllControlActions(1)
		DisableAllControlActions(2)
		EnableControlAction(0, 21, true) 	-- INPUT_SPRINT
		EnableControlAction(0, 21, true) 	-- INPUT_SPRINT
		EnableControlAction(0, 21, true) 	-- INPUT_SPRINT
		EnableControlAction(0, 21, true) 	-- INPUT_SPRINT
		EnableControlAction(0, 22, true) 	-- INPUT_JUMP
		EnableControlAction(0, 23, true) 	-- INPUT_ENTER --F
		EnableControlAction(0, 26, true) 	-- INPUT_LOOK_BEHIND --C
		EnableControlAction(0, 58, true) 	-- INPUT_THROW_GRENADE --G
		EnableControlAction(0, 71, true) 	-- INPUT_VEH_ACCELERATE --W
		EnableControlAction(0, 72, true) 	-- INPUT_VEH_BRAKE --S
		EnableControlAction(0, 73, true) 	-- INPUT_VEH_DUCK -- X
		EnableControlAction(0, 75, true) 	-- INPUT_VEH_EXIT -- F
		EnableControlAction(0, 47, true) 	--G
		EnableControlAction(0, 245, true)	--T
		EnableControlAction(0, 38, true) 	--E
		EnableControlAction(0, 51, true) 	--E
		EnableControlAction(0, 177, true) 	--Backspace
		EnableControlAction(0, 249, true) 	--N Let Speak
		EnableControlAction(0, 96, true) 	--N Let Speak
		EnableControlAction(0, 97, true) 	--N Let Speak
		EnableControlAction(0, 20, true) 	--Z

		EnableControlAction(0, 32, true) 	--W
		EnableControlAction(0, 33, true)	--S
		EnableControlAction(0, 34, true) 	--A
		EnableControlAction(0, 35, true)	--D
		EnableControlAction(0, 9, true) 	--D
		EnableControlAction(0, 266, true) 	--D
		EnableControlAction(0, 267, true) 	--D
		EnableControlAction(0, 8, true) 	--S
		EnableControlAction(0, 268, true) 	--S
		EnableControlAction(0, 269, true) 	--S
			
		EnableControlAction(0, 0, true)		--? INPUT_MOVE
		EnableControlAction(0, 1, true)		--? Mouse LookLeftRight
		EnableControlAction(0, 2, true)		--? Mouse LookUpDown
		EnableControlAction(0, 30, true) 	--? INPUT_MOVE
		EnableControlAction(0, 31, true) 	--? INPUT_MOVE

    elseif not isUIOpen and isKeyDisabled then
        SetInterval(disableKeyThread, 500)
        isKeyDisabled = false
    end
end, 500)

function Search()
	local PlayerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    local plate = GetVehicleNumberPlateText(vehicle)
    local isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
    ESX.TriggerServerCallback('JLRP-VehicleRemote:HasKeys', function(hasKeys) 
        if hasKeys then
            Notification('info', _('has_key'))
            return
        end
        if isInVehicle then
            if searchedVehicles[plate] then
                Notification('error', _('no_key_veh'))
            else
			
                if Config.OnlyRegisteredCars then
                    ESX.TriggerServerCallback('JLRP-VehicleRemote:IsCarRegistered', function(isRegistered) 
                        if isRegistered then
                            searchedVehicles[plate] = true
                            Notification('success', _('found_key'))
                            TriggerServerEvent('JLRP-VehicleRemote:AddKeys', plate)
                        else
                            Notification('error', _('not_registered'))
                        end
                    end, plate)
                else
                    searchedVehicles[plate] = true
                    Notification('success', _('found_key'))
                    TriggerServerEvent('JLRP-VehicleRemote:AddKeys', plate)
                end
            end
        end
    end, plate)
end

exports('LockUnlock', function(data, slot)
    if not slot.metadata.plate then Notification('error', 'The key has no metadata !') return end
    OpenUi(slot.metadata.plate)
end)

RegisterNUICallback('Close', function(data)
    CloseUi()
end)

RegisterNUICallback('Lock', function(data)
	local PlayerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(PlayerPed)
    local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, Config.MaxRemoteRange)
    local veh = nil
    local plate = nil
    local vehLockStatus = nil
    local isInVehicle = nil
    if next(vehicles) ~= nil then
        for _, vehicle in pairs(vehicles) do
            plate = GetVehicleNumberPlateText(vehicle)
            if plate == data.plate then
                veh = vehicle
                vehLockStatus = GetVehicleDoorLockStatus(veh)
                isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
                break
            end
        end
    else
        Notification('error', _('no_veh_nearby'))
        return
    end

    if veh == nil then    
        Notification('error', _('key_not_owned_car'))
        return
    end

    if isInVehicle then
        if vehLockStatus == Config.LockState then
            Notification('error', _('locked'))
        else           
            CloseAllDoors(veh)
            BlinkVehicleLight(veh)
            SetVehicleDoorsLocked(veh, Config.LockState)
            Notification('success', _('lock_veh'))
        end
    else
        if vehLockStatus == Config.LockState then
            Notification('error', _('locked'))
        else      
            Progress(_('pr_lock'), 1500)
			CloseAllDoors(veh)
			BlinkVehicleLight(veh)
            SetVehicleDoorsLocked(veh, Config.LockState)
            Notification('success', _('lock_veh'))
        end
    end
end)

RegisterNUICallback('Unlock', function(data)
	local PlayerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(PlayerPed)
    local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, Config.MaxRemoteRange)
    local veh = nil
    local plate = nil
    local vehLockStatus = nil
    local isInVehicle = nil
    if next(vehicles) ~= nil then
        for _, vehicle in pairs(vehicles) do
            plate = GetVehicleNumberPlateText(vehicle)
            if plate == data.plate then
                veh = vehicle
                vehLockStatus = GetVehicleDoorLockStatus(veh)
                isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
                break
            end
        end
    else
        Notification('error', _('no_veh_nearby'))
        return
    end

    if veh == nil then    
        Notification('error', _('key_not_owned_car'))
        return
    end

    if isInVehicle then
        if vehLockStatus == Config.LockState then
            BlinkVehicleLight(veh)
            SetVehicleDoorsLocked(veh, 1)
            Notification('success', _('unlock_veh'))
        else
            Notification('error', _('unlocked'))
        end
    else
        if vehLockStatus == Config.LockState then
			Progress(_('pr_unlock'), 1500)
			BlinkVehicleLight(veh)
            SetVehicleDoorsLocked(veh, 1)
            Notification('success', _('unlock_veh'))
        else
            Notification('error', _('unlocked'))
        end
    end
end)

RegisterNUICallback('Engine', function(data)
	local PlayerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(PlayerPed)
    local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, Config.MaxRemoteRange)
    local veh = nil
    local plate = nil
    local vehLockStatus = nil
    local isInVehicle = nil
    if next(vehicles) ~= nil then
        for _, vehicle in pairs(vehicles) do
            plate = GetVehicleNumberPlateText(vehicle)
            if plate == data.plate then
                veh = vehicle
                vehLockStatus = GetVehicleDoorLockStatus(veh)
                isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
                break
            end
        end
    else
        Notification('error', _('no_veh_nearby'))
        return
    end

    if veh == nil then    
        Notification('error', _('key_not_owned_car'))
        return
    end

    if isInVehicle then
        if GetVehiclePedIsIn(PlayerPed, true) ~= veh then
            Notification('error', _('not_this_vehicle_engine'))
            return
        end
        if not startedEngines[plate] then
            Progress(_('pr_engine_on'), 1000)
            TriggerServerEvent('JLRP-VehicleRemote:SyncEngine', plate, true)
        else
            Progress(_('pr_engine_off'), 1000)
            TriggerServerEvent('JLRP-VehicleRemote:SyncEngine', plate, false)
        end
    else
        Notification('error', _('not_in_vehicle'))
    end
end)

RegisterNUICallback('Trunk', function(data)
	local PlayerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(PlayerPed)
    local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, Config.MaxRemoteRange)
    local veh = nil
    local plate = nil
    local vehLockStatus = nil
    local isInVehicle = nil
    if next(vehicles) ~= nil then
        for _, vehicle in pairs(vehicles) do
            plate = GetVehicleNumberPlateText(vehicle)
            if plate == data.plate then
                veh = vehicle
                vehLockStatus = GetVehicleDoorLockStatus(veh)
                isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
                break
            end
        end
    else
        Notification('error', _('no_veh_nearby'))
        return
    end

    if veh == nil then    
        Notification('error', _('key_not_owned_car'))
        return
    end

    if isInVehicle then
        if vehLockStatus == Config.LockState then
            Notification('error', _('veh_is_locked'))
        else
            if GetVehicleDoorAngleRatio(veh, 5) > 0.0 then
                Progress(_('pr_close_trunk'), 1000)
                SetVehicleDoorShut(veh, 5, false)
            else
                Progress(_('pr_open_trunk'), 1000)
                SetVehicleDoorOpen(veh, 5, false)
            end
        end
    else
        if vehLockStatus == Config.LockState then
            Notification('error', _('veh_is_locked'))
        else
            if GetVehicleDoorAngleRatio(veh, 5) > 0.0 then
                Progress(_('pr_close_trunk'), 1000)
                SetVehicleDoorShut(veh, 5, false)
            else
                Progress(_('pr_open_trunk'), 1000)
                SetVehicleDoorOpen(veh, 5, false)
            end
        end
    end
    
end)

RegisterNUICallback('Alarm', function(data)
	local PlayerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(PlayerPed)
    local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, Config.MaxRemoteRange + 20.0)
    local veh = nil
    local plate = nil
    local vehLockStatus = nil
    local isInVehicle = nil
    if next(vehicles) ~= nil then
        for _, vehicle in pairs(vehicles) do
            plate = GetVehicleNumberPlateText(vehicle)
            if plate == data.plate then
                veh = vehicle
                vehLockStatus = GetVehicleDoorLockStatus(veh)
                isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
                break
            end
        end
    else
        Notification('error', _('no_veh_nearby'))
        return
    end

    if veh == nil then    
        Notification('error', _('key_not_owned_car'))
        return
    end

    if not IsVehicleAlarmActivated(veh) then
        Progress(_('pr_alarm_on'), 1000)
        SetVehicleAlarm(veh, 1)
        StartVehicleAlarm(veh)
        SetVehicleAlarmTimeLeft(veh, 180000)
    else
        Progress(_('pr_alarm_off'), 1000)
        SetVehicleAlarm(veh, 0)
    end
end)

loadAnimDict = function(anim)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Wait(0)
    end
end


RegisterNetEvent('JLRP-VehicleRemote:Sync')
AddEventHandler('JLRP-VehicleRemote:Sync', function(interactedVehicles, interactedEngines)
	searchedVehicles = interactedVehicles
    startedEngines = interactedEngines
end)

function OpenUi(plate)
    if not isUIOpen then
        SetNuiFocus(true, true)
        if Config.AllowSomeKeyboardAndMouseInputs then
            SetNuiFocusKeepInput(true)
        end
        SendNUIMessage({
            type = 'OpenUI',
            show = true,
            plate = plate
        })
        if Config.SetMouseCursorNearRemote then
            SetCursorLocation(0.9, 0.85)
        end
        isUIOpen = true
    end
end

function CloseUi()
    if isUIOpen then
        SetNuiFocus(false, false)
        if Config.AllowSomeKeyboardAndMouseInputs then
            SetNuiFocusKeepInput(true)
        end
        SendNUIMessage({
            type = 'CloseUI',
            show = false,
            plate = ''
        })
        isUIOpen = false
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
		CloseUi()
    end  
end)

function BlinkVehicleLight(vehicle)
	Wait(500)
	SetVehicleLights(vehicle, 2)
	Wait(100)
	SetVehicleLights(vehicle, 0)
	Wait(200)
	SetVehicleLights(vehicle, 2)
	Wait(100)
	SetVehicleLights(vehicle, 0)
	Wait(200)
	SetVehicleLights(vehicle, 2)
	Wait(100)
	SetVehicleLights(vehicle, 0)
end

function CloseAllDoors(veh)
	for i = 0, 5 do
		SetVehicleDoorShut(veh, i, false) -- will close all doors from 0-5
	end
end


RegisterNetEvent('JLRP-VehicleRemote:AddKeysOfTheVehiclePedIsIn', function()
    local PlayerPed = PlayerPedId()
    local veh
	local timeout = 1000
	repeat
		Wait(0)
		timeout = timeout - 1
		veh = GetVehiclePedIsIn(PlayerPed, true)
	until veh ~= 0 or timeout < 1
	
	local plate = GetVehicleNumberPlateText(veh)
	if plate and plate ~= nil and plate ~= "" and plate ~= " " then
		TriggerServerEvent('JLRP-VehicleRemote:AddKeys', plate)
	end
end)

function Notification(type, text)
    if type == 'success' then
        bulletin:SendSuccess(text, 3000, 'bottomleft', true)
    elseif type == 'error' then
        bulletin:SendError(text, 3000, 'bottomleft', true)
    elseif type == 'info' then
        bulletin:SendInfo(text, 3000, 'bottomleft', true)
    end
end

function Progress(text, time)
    if Config.UseProgressBar then
		local PlayerPed = PlayerPedId()
		if IsPedInAnyVehicle(PlayerPed, true) then
			rprogress:Start(text, time)
		else
			rprogress:Custom({
                Async = true,
				Duration = time,
				Label = text,
                DisableControls = {
                    Mouse = false,
                    Player = false,
                    Vehicle = false
                },
				Animation = {
					animationDictionary = "anim@mp_player_intmenu@key_fob@",
					animationName = "fob_click",
				},   
				onStart = function()			
					local keyFob = CreateObject(GetHashKey("p_car_keys_01"), 0, 0, 0, true, true, true)
					AttachEntityToEntity(keyFob, PlayerPed, GetPedBoneIndex(PlayerPed, 57005), 0.08, 0.0, -0.02, 0.0, -25.0, 130.0, true, true, false, true, 1, true)
					Wait(time)
					DeleteEntity(keyFob)		
				end	
			})
		end
        
    else
		local PlayerPed = PlayerPedId()
		if not IsPedInAnyVehicle(PlayerPed, true) then
			local animationDictionary = "anim@mp_player_intmenu@key_fob@"
			local animationName = "fob_click"
			local keyFob = CreateObject(GetHashKey("p_car_keys_01"), 0, 0, 0, true, true, true)
			AttachEntityToEntity(keyFob, PlayerPed, GetPedBoneIndex(PlayerPed, 57005), 0.08, 0.0, -0.02, 0.0, -25.0, 130.0, true, true, false, true, 1, true)
			ESX.Streaming.RequestAnimDict(animationDictionary, function()
				TaskPlayAnim(PlayerPed, animationDictionary, animationName, 8.0, -8.0, -1, 0, 0, false, false, false)
				Wait(time)
			end)
			DeleteEntity(keyFob)
		end
	end
end