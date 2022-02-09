ESX = nil

local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(100)

	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
	end 
	
    PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

local quantite = {"1","2","3","4","5","6","7","8","9","10"}

LTD = {
    Base = { Header = {"customui", "shopui_title_ltdgasoline"}, title = ""},
    Data = {currentMenu = "Zone d'achat !", ""},
    Events = {
        onOpened = function()
            RequestStreamedTextureDict("commonmenu",false)
            SetStreamedTextureDictAsNoLongerNeeded("commonmenu",false)
        end,
        onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
            RequestStreamedTextureDict("commonmenu",false)
            SetStreamedTextureDictAsNoLongerNeeded("commonmenu",false)
            SetStreamedTextureDictAsNoLongerNeeded("commonmenu",false) 
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            if self.Data.currentMenu == "Zone d'achat !" then
                ESX.TriggerServerCallback('lookmoney', function(hasEnoughMoney)   
                    if hasEnoughMoney then
                        local id = GetPlayerServerId(PlayerId())
                        
                       -- xPlayer.removeMoney(tonumber(btn.slidenum)*btn.price4)
                        TriggerServerEvent("itemLtd", tonumber(btn.slidenum)*btn.price4, btn.item4, btn.slidenum)
                        ESX.ShowNotification("~r~Votre facture ~s~: \n~b~Achat ~s~: ~g~" .. btn.label4 .. "\n~b~Nombre ~s~: ~g~" .. btn.slidenum .. "\n~b~Prix ~s~: ~g~" .. tonumber(btn.slidenum)*btn.price4 .. "~g~$")
                        print(btn.label4)
                        print(btn.slidenum)
                        print(btn.price4)
                    else
                        ESX.ShowNotification("~r~Solde insufisant !\n~b~ Il vous manque "..tonumber(btn.slidenum)*btn.price4.."$")
                    end
                end)
            end
        end
    },

    Menu = {
        ["Zone d'achat !"] = {
            b = {}
        },
    }
}

function OpenLTD(seven)
    LTD.Menu["Zone d'achat !"].b = {}
    for i=1, #CFG.ItemShop, 1 do
        table.insert(LTD.Menu["Zone d'achat !"].b, {name = CFG.ItemShop[i].Label .. "~b~ " .. CFG.ItemShop[i].Price .." ~s~~g~$", slidemax = quantite, askX = true, label4 = CFG.ItemShop[i].Label, item4 = CFG.ItemShop[i].Item, price4 = CFG.ItemShop[i].Price})
    end
    if seven == nil then
        LTD.Base.Header[2] = "shopui_title_ltdgasoline"
    else
        LTD.Base.Header[2] = "shopui_title_24-7"
    end
    CreateMenu(LTD)
end

Citizen.CreateThread(function()
    while true do Citizen.Wait(5)

        for k,v in pairs (CFG.Localisation) do  
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)
            if dist <= 3.0 then
                if not HasStreamedTextureDictLoaded("customui") then
                    RequestStreamedTextureDict("customui", true)
                    while not HasStreamedTextureDictLoaded("customui") do
                        Wait(1)
                    end
                else
                DrawMarker(9, v.x,v.y,v.z, 0.0, 0.0, 0.0, 0.0, 90.0, 90.0, 0.5, 0.5, 0.5, 200, 200, 200, 200,false, false, 2, true, "customui", "metromark", false)
            end
            end
            if dist <= 0.8 then
                --Draw3DText(v.x,v.y,v.z, "Appuyez sur ~b~E~s~ pour ouvrir le ~b~Frigo")
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour ouvrir le ~b~Frigo")
                if IsControlJustPressed(1,38) then
                    OpenLTD(v.seven)
                end 
            end
        end 
    end 
end)