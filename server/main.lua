local interactedVehicles, interactedEngines = {}, {}
local ox_inventory = exports.ox_inventory
local GetCurrentResourceName = GetCurrentResourceName()

ESX.RegisterServerCallback('JLRP-VehicleRemote:HasKeys', function(source, cb, _plate)
    if HasKeys(source, _plate) then
		if not interactedVehicles[_plate] or interactedVehicles[_plate] == false then
			interactedVehicles[_plate] = true
			Sync()
		end
		cb(true)
	else
		cb(false)
	end    
end)

ESX.RegisterServerCallback('JLRP-VehicleRemote:IsCarRegistered', function(source, cb, _plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', 
    {['@plate'] = _plate}, 
    function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('JLRP-VehicleRemote:AddKeys', function(_plate)
    local _source = source
    if HasKeys(_source, _plate) then
		interactedVehicles[_plate] = true
        return
    end
    
	interactedVehicles[_plate] = true
    Sync()
	
    if ox_inventory:CanCarryItem(_source, 'car_key', 1) then
        ox_inventory:AddItem(_source, 'car_key', 1, {plate = _plate, description = _U('key_description',_plate)})
    end
end)

RegisterServerEvent('JLRP-VehicleRemote:RemoveKey', function(_plate)
	if interactedVehicles[_plate] or interactedVehicles[_plate] == true then
		interactedVehicles[_plate] = false
		TriggerEvent('JLRP-VehicleRemote:SyncEngine', _plate, false)
	end
    HasKeys(source, _plate, true)
end)

RegisterServerEvent('JLRP-VehicleRemote:CreateKeyCopy', function(_plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name ~= 'mechanic' then
        DropPlayer(xPlayer.source, 'kunet bezaram chaghal?')
        return
    end
    if ox_inventory:CanCarryItem(xPlayer.source, 'car_key', 1) then
        ox_inventory:AddItem(xPlayer.source, 'car_key', 1, {plate = _plate, description = _U('key_description',_plate)})
    end
end)

RegisterServerEvent('JLRP-VehicleRemote:Sync', function()
    Sync()
end)

RegisterServerEvent('JLRP-VehicleRemote:SyncEngine', function(_plate, state)
	if _plate ~= nil and state ~= nil then	
		interactedEngines[_plate] = state
	end
    Sync()
end)

function Sync()
	if Config.Debug then
		SyncVehicles()
		SyncEngines()
	end
	TriggerClientEvent('JLRP-VehicleRemote:Sync', -1, interactedVehicles, interactedEngines)
end

function SyncEngines()	
	local numberOfInteractedEngines = length(interactedEngines)
	if numberOfInteractedEngines > 0 then     
		print('[^6JLRP-VehicleRemote^0] Synced '..numberOfInteractedEngines..' Interacted Engines !')
    end
end

function SyncVehicles()
	local numberOfInteractedVehicles = length(interactedVehicles)
	if numberOfInteractedVehicles > 0 then     
		print('[^6JLRP-VehicleRemote^0] Synced '..numberOfInteractedVehicles..' Interacted Vehicles !')
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName == resourceName then
		resetTheTables()
		Sync()
    end
end)

function HasKeys(source, plate, remove)
    local keys = ox_inventory:Search(source, 'slots', 'car_key')
	if keys then
		for k,v in pairs(keys) do
			if v.metadata.plate == plate then
				if remove then
					ox_inventory:RemoveItem(source, 'car_key', v.slot)
					return true
				else
					return true
				end
			end
		end
	end
  
    return false
end
  
function length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function resetTheTables()
	interactedEngines = {}
	interactedVehicles = {}
	Sync()
end

ESX.RegisterCommand('resetCarKeysAndEngines', 'developer', function(xPlayer, args, showError) 
	resetTheTables()
	xPlayer.showNotification('All Car Key And Engine Tables Have Been Resetted!')
end, true, {help = 'Reset The Car Key And Car Engine Tables', validate = false})