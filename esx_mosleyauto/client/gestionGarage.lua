local cat = "mosley"
local function sub(str)
    return ("%s_%s"):format(cat,str)
end

RMenu.Add(cat, sub('gestion'), RageUI.CreateMenu("Stock Mosley","Actions disponibles"))
RMenu:Get(cat, sub('gestion')).Closed = function()
    MenuStockInMosley = false
end


RMenu.Add(cat, sub('listcar'), RageUI.CreateSubMenu(RMenu:Get(cat, sub('gestion')), "Véhicules disponibles", "Actions disponibles"))
RMenu:Get(cat, sub('listcar')).Closed = function()
end


RMenu.Add(cat, sub('actionsOnCar'), RageUI.CreateSubMenu(RMenu:Get(cat, sub('listcar')), "Véhicules", "Actions disponibles"))
RMenu:Get(cat, sub('actionsOnCar')).Closed = function()
end



local vehicleInStock = nil
local VehSelectionner =  nil

local function getCarInStockMosley()
    ESX.TriggerServerCallback('esx_Mosley:GetvehicleInStock', function(vehicles)
        Citizen.SetTimeout(10, function()
            vehicleInStock = vehicles
        end)
    end)
end


function openGestionGarageMosley()
    MenuStockInMosley = not MenuStockInMosley
    RageUI.Visible(RMenu:Get(cat, sub('gestion')), true)
    Citizen.CreateThread(function()
        while MenuStockInMosley do
            RageUI.IsVisible(RMenu:Get(cat, sub('gestion')),true,true,true,function()
               
                RageUI.ButtonWithStyle("Liste des véhicules du Mosley",'Accédez à la liste des véhicules disponible au Mosley !', { RightLabel = "→" }, true, function(_, _, s)
                    if s then
                        vehicleInStock = nil
                        getCarInStockMosley()   
                    end
                end, RMenu:Get(cat, sub('listcar')))

            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, sub('listcar')),true,true,true,function()
               
                if vehicleInStock == nil then
                    RageUI.Separator('')
                    RageUI.Separator('~o~Chargement de la liste de véhicules..')
                    RageUI.Separator('')
                elseif #vehicleInStock < 1 then
                    RageUI.Separator('')
                    RageUI.Separator('~r~Aucun véhicules dans le stock.')
                    RageUI.Separator('')
                elseif #vehicleInStock >= 1 then
                    RageUI.Separator("↓ ~g~Véhicules Mosley ~s~↓")
                    for i = 1, #vehicleInStock, 1 do
                        RageUI.ButtonWithStyle('~o~'..vehicleInStock[i].typeVeh..'~s~ - '..vehicleInStock[i].plate..'',nil, {RightLabel = "→"}, true, function(_, _, s)
                            if s then
                                VehSelectionner = nil
                                VehSelectionner = vehicleInStock[i]
                            end
                        end, RMenu:Get(cat, sub('actionsOnCar')))
                    end
                end

            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, sub('actionsOnCar')),true,true,true,function()
               
                RageUI.Separator('Model du véhicule : ~o~'..VehSelectionner.typeVeh..'')
                RageUI.Separator('Plaque du véhicule : ~o~'..VehSelectionner.plate..'')
                RageUI.Separator('')
                RageUI.ButtonWithStyle('Faire spawn le véhicule', 'Faites apparaître le véhicule pour le mettre en showcase dans le magasin !', {RightLabel = "→"}, true, function(_, _, s)
                    if s then
                        local spawned = false
                        for k,v in pairs(Config.Mosley.places) do
                            local pointclear = ESX.Game.IsSpawnPointClear(v.pos, 3.0)
                            if pointclear then                   
                                TriggerEvent("esx_Mosley:spawnVehInMosley", vector3(v.pos.x, v.pos.y, v.pos.z), v.heading)
                                RageUI.CloseAll()
                                MenuStockInMosley = false
                                ESX.ShowNotification('~g~Le véhicule a été placé dans le magasin, près de la vitrine.')
                                spawned = true
                                return
                            end
                        end
                        if not spawned then
                            ESX.ShowNotification('~r~Il n\'y a plus de points de spawn disponibles.')
                        end
                    end
                end)    

                RageUI.ButtonWithStyle('Faire despawn le véhicule', 'Faites despawn le véhicule !', {RightLabel = "→"}, true, function(_, _, s)
                    if s then
                        local despawned = false
                        for k,v in pairs(Config.Mosley.places) do
                            if IsAnyVehicleNearPoint(v.pos, 3.0) then
                                local hash = GetHashKey(VehSelectionner.model)
                                local veh = GetClosestVehicle(v.pos, 3.0, hash, 70)
                                local displaytext = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                                local test = string.upper(VehSelectionner.typeVeh)
                                local comparate = string.gsub(test, "%s+", "")
                            
                                if displaytext == comparate then                   
                                    DeleteEntity(veh)
                                    RageUI.CloseAll()
                                    MenuStockInMosley = false
                                    ESX.ShowNotification('~g~Le véhicule a été remis dans le stock.')
                                    despawned = true
                                    return
                                end
                            end
                        end
                        if not despawned then
                            ESX.ShowNotification('~r~Il n\'y a pas de véhicules de ce type garés dans le magasin.')
                        end
                    end
                end)

            end, function()    
            end, 1)

    
            Wait(1)
        end
        MenuStockInMosley = false
    end)
	
end

RegisterNetEvent("esx_Mosley:spawnVehInMosley")
AddEventHandler('esx_Mosley:spawnVehInMosley', function(pos,heading)
    PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
    ESX.Game.SpawnVehicle(VehSelectionner.cara.model, pos, heading, function(vehicle)
        ESX.Game.SetVehicleProperties(vehicle, VehSelectionner.cara)
    end)
end)
