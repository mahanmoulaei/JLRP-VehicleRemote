Config = {}
Config.Debug = false
Config.Locale = 'en'
Config.LockState = 2 --2 or 4 => 4 locks the players inside and avoid getting them out of the vehivle which is more realistic but it's better to use 2 because a thread/loop doesn't need to run(more optimized) and also it syncs with q-target by default(if used). If you plan to use 4, make sure to modify the related code in q-target for more realsitic result.
Config.OnlyRegisteredCars = false 	-- If true only cars in owned_vehicles table could be searched for key
Config.UseProgressBar = true
Config.AllowSomeKeyboardAndMouseInputs = true
Config.SetMouseCursorNearRemote = true
Config.MaxRemoteRange = 25.0 --Max distance for the remote to interact with vehicle. P.S : Vehicle Alarm max distance is set to Config.MaxRemoteRange + 20.0
--TODO
Config.UseNUI = false               -- false to press keyboard keys to interact with vehicles, true to only use the car key through inventory.useItem and NUI