local cat = "mosley"
local function sub(str)
    return ("%s_%s"):format(cat,str)
end
MoneyInCoffreMosley = nil

RMenu.Add(cat, sub('main_boss'), RageUI.CreateMenu("Menu Patron","Actions disponibles"))
RMenu:Get(cat, sub('main_boss')).Closed = function()
    MenuBossMosley = false
end


function openBossMenuMosley()
    MenuBossMosley = not MenuBossMosley
    RageUI.Visible(RMenu:Get(cat, sub('main_boss')), true)
    RefreshMoneyMosley()
    Wait(100)
    Citizen.CreateThread(function()
        while MenuBossMosley do
            RageUI.IsVisible(RMenu:Get(cat, sub('main_boss')),true,true,true,function()
                if MoneyInCoffreMosley ~= nil then
                    RageUI.Separator('~o~Argent dans le coffre : ~s~'..MoneyInCoffreMosley..' ~g~$')
                else
                end

                RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then

                        local amount = KeyboardInput('Montant :', '', 8)
    
                        if amount == nil then
                            RageUI.CloseAll()
                            MenuBossMosley = false
                            ESX.ShowNotification('Montant invalide')
                        else
                            RageUI.CloseAll()
                            MenuBossMosley = false
                            TGSE('esx_society:withdrawMoney', 'mosley', amount)
                        end
                    end
                end)
    
                RageUI.ButtonWithStyle("Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = KeyboardInput('Montant :', '', 8)
                        if amount == nil then
                            RageUI.CloseAll()
                            MenuBossMosley = false
                            ESX.ShowNotification('Montant invalide')
                        else
                            RageUI.CloseAll()
                            MenuBossMosley = false
                            TGSE('esx_society:depositMoney', 'mosley', amount)
                        end
                        
                    end
                end) 
    
               RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        MenuBossMosley = false
                        TriggerEvent('esx_society:openBossMenu', 'mosley', function(data, menu)
                            menu.close()
                        end, {wash = false})
                    end
                end)

            end, function()    
            end, 1)

    
            Wait(1)
        end
        MenuBossMosley = false
    end)
	
end

