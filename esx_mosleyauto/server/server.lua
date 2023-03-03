ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'mosley', 'mosley', 'society_mosley', 'society_mosley', 'society_mosley', {type = 'public'})

RegisterServerEvent('esx_Mosley:annoncesClients')
AddEventHandler('esx_Mosley:annoncesClients', function(type)
    local _source = source
    local _raison = type
    local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.job.name == 'mosley' then
		TriggerClientEvent('esx_Mosley:sendNotifs', -1, _raison)
	end
end)

ESX.RegisterServerCallback('esx_Mosley:GetvehicleInStock', function (source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.job.name == 'mosley' then
        MySQL.Async.fetchAll('SELECT * FROM mosley_vehicles', {}, function (result)
            local vehicles = {}

            for i=1, #result, 1 do
                table.insert(vehicles, {
                    typeVeh = result[i].typeVeh,
                    plate = result[i].plate,
                    cara  = json.decode(result[i].vehicle),
                })
            end

            cb(vehicles)
        end)
    else 
        return
    end
end)

RegisterServerEvent('esx_Mosley:GiveVehToPly')
AddEventHandler('esx_Mosley:GiveVehToPly', function(playerId, vehicleProps)
    local _source = source
    local xPlayerSrc = ESX.GetPlayerFromId(_source)
	local xPlayer = ESX.GetPlayerFromId(playerId)
    local finish = false
    local found = false

    if xPlayerSrc.job.name == 'mosley' then
        MySQL.Async.fetchAll('SELECT * FROM mosley_vehicles', {}, function (result)
            for i=1, #result, 1 do
                if result[i].plate == vehicleProps.plate then
                    found = true
                    MySQL.Async.execute('DELETE FROM mosley_vehicles WHERE plate = @plate', {
                        ['@plate'] = vehicleProps.plate
                    })
                end
            end
            finish = true
        end)

        while not finish do Wait(100) end
        if found then
            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
            {
                ['@owner']   = xPlayer.identifier,
                ['@plate']   = vehicleProps.plate,
                ['@vehicle'] = json.encode(vehicleProps)
            }, function (rowsChanged)
                if rowsChanged > 0 then
                    TriggerClientEvent('esx:showNotification', _source, 'Vous avez donné les clés de ce véhicule.')
                    TriggerClientEvent('esx:showNotification', playerId, 'Des clés de véhicule vous ont été attribuées. ~g~Félicitation~s~ !')
                end
            end) 
        else
            TriggerClientEvent('esx:showNotification', playerId, '~r~Ce n\'est pas un véhicule du Mosley !')
        end
    else
        return
    end
end)

RegisterNetEvent("esx_Mosley:addCarInStock")
AddEventHandler("esx_Mosley:addCarInStock", function(typeVeh, vehicleModel)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local plate = vehicleModel.plate
    local caract = {}
    table.insert(caract, json.encode(vehicleModel))


    if xPlayer.job.name == 'mosley' then
        MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        })
        Wait(100)
        MySQL.Async.execute('INSERT INTO mosley_vehicles (typeVeh, plate, vehicle) VALUES (@typeVeh, @plate, @vehicle)', {
            ['@typeVeh'] = typeVeh,
            ['@plate'] = plate,
            ['@vehicle'] = caract,
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:showNotification', _source, "~g~Véhicule ajouté à votre stock avec succès.")
                TriggerClientEvent('esx_Mosley:delCar', _source)
            else
                TriggerClientEvent('esx:showNotification', _source, "~r~Une erreur s\'est produite. Merci de réessayer.")
            end
        end)
    else
        return
    end
end)

local function getPlayerVehicles(identifier)
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})	
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		table.insert(vehicles, {id = v.id, plate = vehicle.plate})
	end
	return vehicles
end

ESX.RegisterServerCallback('garage:stockv',function(source, cb, vehicleProps)
	local isFound = false
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(xPlayer.getIdentifier())
	local plate = vehicleProps.plate

    for _,v in pairs(vehicules) do
        if(plate == v.plate)then
            local idveh = v.id
            local vehprop = json.encode(vehicleProps)
            MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehprop WHERE plate=@plate",{
                ['@vehprop'] = vehprop, 
                ['@plate'] = plate
            })
            isFound = true
            break
        end		
    end
    cb(isFound)
end)

