local cat = "mosley"
local currentTask = {}
TGSE = TriggerServerEvent
local function sub(str)
    return ("%s_%s"):format(cat,str)
end
inventaireDuJoueur = nil
InfosDuVehicule = nil

RMenu.Add(cat, sub('main'), RageUI.CreateMenu("Menu Mosley","Actions disponibles"))
RMenu:Get(cat, sub('main')).Closed = function()
    MenuPrincipalMosley = false
end

RMenu.Add(cat, sub('citoyens'), RageUI.CreateSubMenu(RMenu:Get(cat, sub('main')), "Intéractions citoyens", "Actions disponibles"))
RMenu:Get(cat, sub('citoyens')).Closed = function()
end

RMenu.Add(cat, sub('annonces'), RageUI.CreateSubMenu(RMenu:Get(cat, sub('main')), "Annonces", "Actions disponibles"))
RMenu:Get(cat, sub('annonces')).Closed = function()
end

function openMosleyMenu()
    MenuPrincipalMosley = not MenuPrincipalMosley
    RageUI.Visible(RMenu:Get(cat, sub('main')), true)

    Citizen.CreateThread(function()
        while MenuPrincipalMosley do
            RageUI.IsVisible(RMenu:Get(cat, sub('main')),true,true,true,function()
                
                RageUI.Separator("↓ ~o~Interactions ~s~↓")


                RageUI.ButtonWithStyle("Interactions citoyens", "Accédez aux intéractions avec citoyens", { RightLabel = "→" }, true, function()
                end, RMenu:Get(cat, sub('citoyens')))

                
                RageUI.Separator("↓ ~g~Annonces ~s~↓")

                RageUI.ButtonWithStyle("Passer une annonce", "Vous permets de passer une annonce à la ville", { RightLabel = "→" }, true, function()
                end, RMenu:Get(cat, sub('annonces')))
                
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, sub('annonces')),true,true,true,function()
                
                RageUI.Separator("↓ ~o~Annonces ~s~↓")

                RageUI.ButtonWithStyle("~g~Annonce ouverture", "Annoncez l'ouverture !", {RightLabel = "→"}, true, function(_, _, s)
                    if s then   
                        TGSE('esx_Mosley:annoncesClients', 'Ouverture')
                    end
                end)

                RageUI.ButtonWithStyle("~r~Annonce fermeture", "Annoncez la fermeture !", {RightLabel = "→"}, true, function(_, _, s)
                    if s then   
                        TGSE('esx_Mosley:annoncesClients', 'Fermeture')
                    end
                end)

            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, sub('citoyens')),true,true,true,function()
                
                RageUI.Separator("↓ ~o~Interactions ~s~↓")

                RageUI.ButtonWithStyle("Attribuer les clés", nil, { RightLabel = "→" }, true, function(_,a,s)
                    if a then
                        local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 7.0, 0 , 70)
                        local coords = GetEntityCoords(veh)
                        DrawMarker(20, coords.x, coords.y, coords.z+1.5, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.7, 0.7, 0.7, 255, 0, 0, 150, 1, 0, 2, 0, nil, nil, 0)
                    end
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance < 3.0 then
                            if veh ~= 0 then
                                local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 7.0, 0 , 70)
                                local vehicleProps = ESX.Game.GetVehicleProperties(veh)
                                TriggerServerEvent('esx_Mosley:GiveVehToPly', GetPlayerServerId(closestPlayer), vehicleProps)            
                            else
                                ESX.ShowNotification('~r~Aucun véhicule proche de vous.')
                            end
                        else
                            ESX.ShowNotification('~r~Aucun joueurs proche de vous.')
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Facturer le client", nil, { RightLabel = "→" }, true, function(_,_,s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            local montant = tonumber(KeyboardInput('Montant :', '', 8))
                            if montant ~= nil and montant > 0 then
                                TGSE('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mosley', 'Mosley', montant)
                            else
                                ESX.ShowNotification('~r~Montant invalide.')
                            end     
                        else
                            ESX.ShowNotification('~r~Aucun joueurs proche.')
                        end              
                    end
                end)

            end, function()    
            end, 1)
    
            Wait(1)
        end
        MenuPrincipalMosley = false
    end)
	
end



RegisterCommand('debugMenuMOSLEY', function()
    if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'mosley' then
        MenuPrincipalMOSLEY = false
        MenuArmurerieMOSLEY = false
        MenuGarageMOSLEY = false
        MenuVestiairesMOSLEY = false
        MenuBossMOSLEY = false
        ESX.ShowNotification('~g~D�bug du menu effectu�. Merci de fermer vos menu via la touche "retour" !')
    else
        ESX.ShowNotification('~r~Vous devez être membre du Mosley.')
    end
end, false)

