function initBlips()
	local blip = AddBlipForCoord(Config.Mosley.BlipPos.x, Config.Mosley.BlipPos.y, Config.Mosley.BlipPos.z)
	SetBlipSprite(blip, Config.Mosley.BlipSprite)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, Config.Mosley.BlipColour)
	SetBlipScale(blip, Config.Mosley.BlipScale)
	SetBlipCategory(blip, Config.Mosley.BlipCategory)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config.Mosley.BlipName)
	EndTextCommandSetBlipName(blip)
end


function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) 
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500) 
		blockinput = false
		return result
	else
		Citizen.Wait(500) 
		blockinput = false 
		return nil 
	end
end



function setPedClothes(tenue, ped)
	local test = tenue
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			test = Config.Mosley.TenuesJob[tenue].male
		else
			test = Config.Mosley.TenuesJob[tenue].female
		end
		if test then
			TriggerEvent('skinchanger:loadClothes', skin, test)
		end
	end)
	
end

function RefreshMoneyMosley()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateMoneyMosley(money)
        end, 'mosley')
    end
end

function UpdateMoneyMosley(money)
    MoneyInCoffreMosley = ESX.Math.GroupDigits(money)
end


function spawnMosleyVeh(player, vehicle)
	local hash = GetHashKey(vehicle)
	local coordsSpawn = Config.Mosley.SpawnCoords
	Citizen.CreateThread(function()
		RequestModel(hash)
		while not HasModelLoaded(hash) do Citizen.Wait(10) end

		local vehicle = CreateVehicle(hash, coordsSpawn.x, coordsSpawn.y, coordsSpawn.z, 90.0, true, false)

		TaskWarpPedIntoVehicle(player, vehicle, -1)
	end)
end

