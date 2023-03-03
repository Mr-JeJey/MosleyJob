

local cat = "mosley"
local function sub(str)
    return ("%s_%s"):format(cat,str)
end

RMenu.Add(cat, sub('garage'), RageUI.CreateMenu("Garage","Actions disponibles"))
RMenu:Get(cat, sub('garage')).Closed = function()
    MenuGarageMosley = false
end


function openGarageMenuMosley()
    MenuGarageMosley = not MenuGarageMosley
    RageUI.Visible(RMenu:Get(cat, sub('garage')), true)

    Citizen.CreateThread(function()
        while MenuGarageMosley do
            RageUI.IsVisible(RMenu:Get(cat, sub('garage')),true,true,true,function()
                -- Ranger son véhicule opac
                RageUI.Separator("↓ ~r~Ranger son véhicule~s~ ↓")
                RageUI.ButtonWithStyle('Ranger son véhicule','Vous permet de ranger le véhicule dans lequel vous êtes.', {RightLabel = "→"}, true, function(_,_,s)
                    if s then
                        RageUI.CloseAll()
                        MenuGarageMosley = false
                        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                        if veh ~= nil then
                            DeleteEntity(veh)
                            ESX.ShowNotification('~g~Véhicule rangé avec succès.') 
                        else
                            ESX.ShowNotification('~r~Vous devez être à bord d\'un véhicule.') 
                        end
                    end
                end)

                RageUI.Separator("↓ ~b~Véhicules~s~ ↓")
                for i = 1,#Config.Mosley.Vehicules do    
                    RageUI.ButtonWithStyle(Config.Mosley.Vehicules[i].label,"~o~Véhicule : ~s~"..Config.Mosley.Vehicules[i].label, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_,_,s)
                        if s then
                            RageUI.CloseAll()
                            MenuGarageMosley = false
                            spawnMosleyVeh(PlayerPedId(), Config.Mosley.Vehicules[i].model)
                        end
                    end)
                end

            end, function()    
            end, 1)

    
            Wait(1)
        end
        MenuGarageMosley = false
    end)
	
end

