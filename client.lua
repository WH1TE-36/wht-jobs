ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Pedler) do
		RequestModel(v.model)
		while not HasModelLoaded(v.model) do Citizen.Wait(1) end
		v.handle = CreatePed(4, v.model, v.coords.x, v.coords.y, v.coords.z-1.0, v.heading, false, false)
		GiveWeaponToPed(v.handle, v.weapon, 10, 1, 1)
		SetPedFleeAttributes(v.handle, 0, 0)
		SetPedDropsWeaponsWhenDead(v.handle, false)
		SetPedDiesWhenInjured(v.handle, false)
		SetEntityInvincible(v.handle , true)
		FreezeEntityPosition(v.handle, true)
		SetBlockingOfNonTemporaryEvents(v.handle, true)
		if v.anim.type == 1 then
			TaskStartScenarioInPlace(v.handle, v.anim.name, 0, true)
		elseif v.anim.type == 2 then
			RequestAnimDict(v.anim.dict)
			while not HasAnimDictLoaded(v.anim.dict) do Citizen.Wait(1) end
			TaskPlayAnim(v.handle, v.anim.dict, v.anim.name, 8.0, 1, -1, 49, 0, false, false, false)
		end
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Blips) do
		local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
		SetBlipSprite(blip, v.id)
		SetBlipColour(blip, v.color)
		--SetBlipDisplay(blip, 1)
		SetBlipScale(blip, 0.6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
    	AddTextComponentString(v.title)
    	EndTextCommandSetBlipName(blip)
	end
end)

local took = false
local pressed = false

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
       -- if not took then
		for k,v in pairs(Config.IsAl) do
        local player = PlayerPedId()
        local playercoords = GetEntityCoords(player)
        local dst = GetDistanceBetweenCoords(playercoords, v.coords.x, v.coords.y, v.coords.z, true)
        local dst2 = GetDistanceBetweenCoords(playercoords, v.coords.x, v.coords.y, v.coords.z, true)
		if dst < 2 then
            DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.1, 0.1, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
            if dst < 5 then
            sleep = 1
                DrawText3D(v.coords.x, v.coords.y, v.coords.z + 0.2, v.text)
                if IsControlJustReleased(0, 38) then
                    menuac()
                end
            end
     --   end
        end
    end
    Citizen.Wait(sleep)
end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if took then
		for k,v in pairs(Config.Markers) do
        local player = PlayerPedId()
        local playercoords = GetEntityCoords(player)
        local dst = GetDistanceBetweenCoords(playercoords, v.markers.x, v.markers.y, v.markers.z, true)
        local dst2 = GetDistanceBetweenCoords(playercoords, v.markers.x, v.markers.y, v.markers.z, true)
		if dst < 1 then
            DrawMarker(2, v.markers.x, v.markers.y, v.markers.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.1, 0.1, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
            if dst < 1 then
                sleep = 1
                DrawText3D(v.markers.x, v.markers.y, v.markers.z + 0.2, v.text)
                if IsControlJustReleased(0, 38) then
                    SetEntityHeading(player, v.heading)
                    Citizen.Wait(300)
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "wht-jobs",
                        duration = v.duration,
                        label = v.progbar,
                        useWhileDead = false,
                        canCancel = false,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "melee@large_wpn@streamed_core",
                            anim = "ground_attack_on_spot",
                            flags = 49,
                        },
                        prop = {
                            model = "prop_tool_fireaxe",
                            bone = 57005,
                            coords = { x = 0.18, y = -0.02, z = -0.08 },
                            rotation = { x = 100.0, y = 350.00, z = 140.0 },
                        }
                    }, function(status)
                        if not status then
                            TriggerServerEvent("wht-ver")
                            took = true
                        end
                    end)
                end
            end
        end
        end
    end
    Citizen.Wait(sleep)
end
end)

-- * Utils * -- 

menuac = function(cb, isim, soyisim)
    ESX.TriggerServerCallback("wht-name:check", function(isim, soyisim) 
    elements = {
        {label = 'Is Al',value = 'took'},
        {label = 'Iptal',value = 'cancel'},
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wht-jobs', {
        title    = " ".. isim.. " " ..soyisim.. "",
        align    = 'left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'took' then
            Citizen.Wait(200)
ESX.TriggerServerCallback("checkmoney", function(money) 
    if money then
        took = true
		ESX.ShowNotification("Is Aldin Diger Gidecegin Yer Gps De Isaretlendi")
        SetNewWaypoint(-554.445, 5368.987, 70.355)
			menu.close()
            ESX.UI.Menu.CloseAll()
    else
        ESX.ShowNotification("Yeterli Paran Yok")
	end
        end)
	end
    if data.current.value == 'cancel' then
        ESX.UI.Menu.CloseAll() 
        menu.close()
end
    end)
end)
end

RegisterCommand("1", function()
SetEntityCoords(PlayerPedId(), 390.2041, -75.7696, 68.180)
end)
    
RegisterCommand("2", function()
SetEntityCoords(PlayerPedId(), -554.519, 5368.999, 70.348)
end)

DrawText3D = function (x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 75)
end

AddEventHandler("onResourceStop", function(resource)
    ESX.UI.Menu.CloseAll()
end)
    