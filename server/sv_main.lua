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

RegisterNetEvent("esx_kart:webhook", function(timeTrial)
    if not Config.WebHook == false then
        local steamid  = false
        local license  = false
        local discord  = false
        local xbl      = false
        local liveid   = false
        local ip       = false
    
        for k,v in pairs(GetPlayerIdentifiers(source))do
                
              if string.sub(v, 1, string.len("steam:")) == "steam:" then
                steamid = v
              elseif string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
              elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                xbl  = v
              elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                ip = v
              elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discord = v
              elseif string.sub(v, 1, string.len("live:")) == "live:" then
                liveid = v
              end
            
          end
                                                                                                                                                   --You can edit content if you want to
        PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = "``New karting race record by ``"..discord.."\n Time : "..timeTrial}), { ['Content-Type'] = 'application/json' })
    end
end)