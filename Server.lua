ESX              = nil
local PlayerData = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('lookmoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney('money') >= 100 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('itemLtd')
AddEventHandler('itemLtd', function(price, item, number)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local sourceItem = xPlayer.getInventoryItem(item)
    if xPlayer.getMoney() >= price then	
        if sourceItem.limit ~= -1 and (sourceItem.count ) > sourceItem.limit then
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous ne pouvez pas en porter plus')
        else
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(item, number)
        end
    else 
        TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas l\'argent')
    end           
end)
--TriggerServerEvent('buyitem',price,"item" , number)