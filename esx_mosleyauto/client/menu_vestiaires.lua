local cat = "mosley"
local function sub(str)
    return ("%s_%s"):format(cat,str)
end

RMenu.Add(cat, sub('main_v'), RageUI.CreateMenu("Vestiaires","Actions disponibles"))
RMenu:Get(cat, sub('main_v')).Closed = function()
    MenuVestiairesMosley = false
end


function openMenuVestiairesMosley()
    MenuVestiairesMosley = not MenuVestiairesMosley
    RageUI.Visible(RMenu:Get(cat, sub('main_v')), true)

    Citizen.CreateThread(function()
        while MenuVestiairesMosley do
            RageUI.IsVisible(RMenu:Get(cat, sub('main_v')),true,true,true,function()
                

                RageUI.ButtonWithStyle("Votre tenue","Reprenez votre tenue !", {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                    if s then
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            TriggerEvent('skinchanger:loadSkin', skin)
                        end)
                    end
                end)
                

                RageUI.Separator("↓ ~b~Tenues de service~s~ ↓")

                for i = 1, #Config.Mosley.TenuesJob, 1 do
                    RageUI.ButtonWithStyle("Tenue : "..Config.Mosley.TenuesJob[i].label,"Prendre la tenue : "..Config.Mosley.TenuesJob[i].label, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(_,_,s)
                        if s then
                            setPedClothes(i, PlayerPedId())
                        end
                    end)
                end


                
            end, function()    
            end, 1)




    
            Wait(1)
        end
        MenuVestiairesMosley = false
    end)
	
end

