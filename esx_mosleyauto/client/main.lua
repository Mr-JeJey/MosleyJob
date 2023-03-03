ESX = nil

Citizen.CreateThread(function ()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Wait(0)
    end

    initBlips()
	RefreshMoneyMosley()
	
	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
	
    print('[^6Mr_JeJey^7] State Mosley-job : ^2loaded')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterKeyMapping('openMosley', 'Menu Mosley', 'keyboard', 'F6')

RegisterCommand('openMosley', function()
    if GetEntityHealth(PlayerPedId()) > 0 and ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'mosley' then
        openMosleyMenu()
    end
end, false)
  

Citizen.CreateThread(function() -- Thread pour les markers : optimisé !
    while true do
        local coords = GetEntityCoords(PlayerPedId())
		local playerPed = PlayerPedId()
        local fps = false
		local CurrentZone = nil
		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mosley' then
			for k,v in pairs(Config.Mosley.Positions) do
				if #(coords - v.Pos) < 1.5 then
					fps = true
					BeginTextCommandDisplayHelp('STRING') 
					AddTextComponentSubstringPlayerName("Appuyer sur ~INPUT_PICKUP~ pour intéragir.") 
					EndTextCommandDisplayHelp(0, false, true, -1)
					if IsControlJustReleased(0, 38) then
						if k == 'vestiaires' then
							openMenuVestiairesMosley()
						elseif k == 'menuboss' then
							if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and ESX.PlayerData.job.name == 'mosley' then
								openBossMenuMosley()
							else
								ESX.ShowNotification('~r~Vous n\'avez pas accès à ce menu.')
							end
						elseif k == 'garage' then
							openGarageMenuMosley()
						elseif k == 'AchatNourriture' then
							openBuyMenuMosley()
						elseif k == 'gestionGarage' then
							openGestionGarageMosley()
						elseif k == 'AjouterDansStock' then
							local veh = GetVehiclePedIsIn(PlayerPedId(), false)
							if veh ~= nil then
								carProp = ESX.Game.GetVehicleProperties(veh)
								ESX.TriggerServerCallback('garage:stockv',function(ok)
									if ok then
										local displaytext = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
										local name = GetLabelText(displaytext)
										TriggerServerEvent("esx_Mosley:addCarInStock", name, carProp)
									else
										ESX.ShowNotification("~r~Ce véhicule ne vous appartient pas. Vous ne pouvez pas le mettre dans le stock du Mosley !")
									end
								end, carProp)
							else
								ESX.ShowNotification('~r~Vous devez être dans un véhicule !')
							end
						end
					end
				elseif #(coords - v.Pos) < 12.0 then
					fps = true
					DrawMarker(v.MarkerType, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.MarkerColor.r, v.MarkerColor.g, v.MarkerColor.b, 200, false, true, 2, false, false, false, false)
				end
			end
		end
        
        if fps then
            Wait(1)
        else
            Wait(1500)
        end
    end
end)



RegisterNetEvent('esx_Mosley:sendNotifs')
AddEventHandler('esx_Mosley:sendNotifs', function(raison)
	if raison ~= nil and raison == 'Ouverture' then
		ESX.ShowAdvancedNotification('Mosley', '~b~Information', Config.Mosley.MessageOuverture, 'CHAR_CHAT_CALL', 8)
	elseif raison == 'Fermeture' then 
		ESX.ShowAdvancedNotification('Mosley', '~b~Information', Config.Mosley.MessageFermeture, 'CHAR_CHAT_CALL', 8)
	end
end)


RegisterNetEvent('esx_Mosley:delCar')
AddEventHandler('esx_Mosley:delCar', function()
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	if veh ~= 0 then
		DeleteVehicle(veh)
	end
end)


RegisterCommand('debugmosley', function()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mosley' then
        RageUI.CloseAll()
        MenuArmurerieMOSLEY = false
        MenuBossMOSLEY = false
        MenuGarageMOSLEY = false
        MenuVestiairesMOSLEY = false
        MenuPrincipalMosley = false
       ESX.ShowNotification('~g~Débug du menu effectué. Merci de fermer vos menu via la touche "retour" !')
    else
        ESX.ShowNotification('~r~Vous devez être membre du Mosley.')
    end
end, false)