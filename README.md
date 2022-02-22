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

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
</td></tr>
<tr><td>
This resource is a highly modified derivative of <a href='https://github.com/boostless/Boost-Locksystem'>Boost-Locksystem</a> (<a href='https://forum.cfx.re/t/release-esx-boosts-lock-system-with-metadata/4531012'>FiveM forum post</a>).
</td></td></table>
