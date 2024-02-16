ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx_kart:rentKart')

AddEventHandler('esx_kart:rentKart', function(price, timeInMin, kartHash)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getMoney() < price then return TriggerClientEvent('esx:showNotification', src, Lang['not_enough_money']) end
    xPlayer.removeMoney(price)
    ESX.OneSync.SpawnVehicle(kartHash, Config.spawnCoords, Config.spawnHeading,properties, function(netID)
        print(netID)
        TriggerClientEvent('esx_kart:clientStartRent', src, netID, timeInMin)
    end)
    

end)