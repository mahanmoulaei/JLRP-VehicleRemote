<h1 align='center'>JLRP-VehicleRemote</h1></br>
<h2 align='center'>A server-side synced vehicle remote and engine system to be used in FiveM</h2>
<p align='center'><a href='https://github.com/mahanmoulaei/JLRP-VehicleRemote'>Showcase</a> (Coming soon...) | <a href='https://github.com/mahanmoulaei/JLRP-VehicleRemote'>Installation Guide</a> (Coming soon...)</p>

<p align="center"><img src="https://github.com/mahanmoulaei/JLRP-VehicleRemote/blob/main/html/images/keyfob.png"/></p>
	
## What's changed?
### This information concerns the initial release of JLRP-VehicleRemote
* <h4>List of changes and enhancements will be added soon...</h4>
<!--
* 1
* 2
* 3
-->
<hr>

* If you are a mechanic and want to make a copy of the keys use this trigger
```lua
TriggerServerEvent('JLRP-VehicleRemote:CreateKeyCopy', plate)
```
* If you want to auto add key on purchase use this trigger
```lua
TriggerServerEvent('JLRP-VehicleRemote:AddKeys', plate)
--OR
TriggerClientEvent('JLRP-VehicleRemote:AddKeysOfTheVehiclePedIsIn', source) --This will add the key for the vehicle ped is in
```
* If you want to remove the key use this trigger
```lua
TriggerServerEvent('JLRP-VehicleRemote:RemoveKey', plate)
```


<br><br><br><h3 align='center'>Legal Notices</h3>
<table><tr><td>
Vehicle Key System for <a href='https://github.com/esx-framework/esx-legacy'>ESX-Legacy</a> and <a href='https://github.com/overextended/ox_inventory'>OX_Inventory</a>
 
MIT License

Copyright (C) 2021-2022 boostless

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.  


This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.  


You should have received a copy of the GNU General Public License
along with this program.  
If not, see <https://www.gnu.org/licenses/>
</td></tr>
<tr><td>
This resource is a highly modified derivative of <a href='https://github.com/boostless/Boost-Locksystem'>Boost-Locksystem</a> (<a href='https://forum.cfx.re/t/release-esx-boosts-lock-system-with-metadata/4531012'>FiveM forum post</a>).
</td></tr></table>
