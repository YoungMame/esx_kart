ESX = exports["es_extended"]:getSharedObject()

local Lang = Config.Locales[Config.Lang]
local MenuState = false  -- Assurez-vous que MenuState est déclarée comme une variable locale.
local timeTrial = 0
local trialLaunched = false
local inLocation = false

--time trial--

function StartTrial()
    if not trialLaunched then
        trialLaunched = true
        timeTrial = 0
        CreateThread(function()
            while trialLaunched do
                Citizen.Wait(100)
                timeTrial = timeTrial + 0.1
            end
        end)
    end
end

--SCALEFORMS--
Scaleform = {}

function Scaleform.Request(scaleform)
    local scaleform_handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform_handle) do
        Citizen.Wait(0)
    end
    return scaleform_handle
end

function Scaleform.CallFunction(scaleform, returndata, the_function, ...)
    BeginScaleformMovieMethod(scaleform, the_function)
    local args = {...}

    if args ~= nil then
        for i = 1,#args do
            local arg_type = type(args[i])

            if arg_type == "boolean" then
                ScaleformMovieMethodAddParamBool(args[i])
            elseif arg_type == "number" then
                if not string.find(args[i], '%.') then
                    ScaleformMovieMethodAddParamInt(args[i])
                else
                    ScaleformMovieMethodAddParamFloat(args[i])
                end
            elseif arg_type == "string" then
                ScaleformMovieMethodAddParamTextureNameString(args[i])
            end
        end

        if not returndata then
            EndScaleformMovieMethod()
        else
            return EndScaleformMovieMethodReturnValue()
        end
    end
end

function showCountdown(_number, _r, _g, _b)
    local scaleform = Scaleform.Request('COUNTDOWN')

    Scaleform.CallFunction(scaleform, false, "SET_MESSAGE", _number, _r, _g, _b, true)
    Scaleform.CallFunction(scaleform, false, "FADE_MP", _number, _r, _g, _b)

    return scaleform
end

-----

function createPed_(pedHash, pedCoords, pedHeading)
    CreateThread(function()
      RequestModel( GetHashKey( pedHash ) )
        while ( not HasModelLoaded( GetHashKey( pedHash ) ) ) do
            Wait( 1 )
        end
        local ped = CreatePed(6, pedHash, pedCoords.x, pedCoords.y, pedCoords.z - 1.0, pedHeading, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        RequestAnimDict("missbigscore2aleadinout@ig_7_p2@bankman@")
        while not HasAnimDictLoaded("missbigscore2aleadinout@ig_7_p2@bankman@") do
          Wait(10)
        end
        TaskPlayAnim(ped, "missbigscore2aleadinout@ig_7_p2@bankman@", 'leadout_waiting_loop', 1, 1, -1, 1, 1, false, false, false)
    end)
end

function openMenu()
    local main_menu = RageUI.CreateMenu("Karting", "OPTIONS") 

    main_menu.Closed = function()
        MenuState = false
        RageUI.CloseAll()
    end

    if MenuState then
        MenuState = false
    else
        MenuState = true
        RageUI.Visible(main_menu, true)
        Citizen.CreateThread(function()  
            while MenuState do
                Citizen.Wait(0)
                DisableControlAction(0, 35, true)
                DisableControlAction(0, 32, true)
                DisableControlAction(0, 33, true)
                DisableControlAction(0, 34, true)
            end
        end)
        Citizen.CreateThread(function() 
            local selectedOption = 1
            local selectedTime = 1
            local checkboxState = false
            local priceTotal = 0
            local hasInsurance = 0
            while MenuState do 
                print(Config.Times[selectedTime]) 
                print(Config.KartsDetails[Config.Karts[selectedOption]].price)
                priceTotal = Config.Times[selectedTime]*Config.pricePerMinute + Config.KartsDetails[Config.Karts[selectedOption]].price
                Citizen.Wait(2)
                RageUI.IsVisible(main_menu, function()
                    RageUI.List(Lang['time_rent'], Config.Times, selectedTime, nil, {}, true, {
                        onListChange = function(Index, Item)
                            selectedTime = Index
                        end,
                    })
                    RageUI.List(Lang['vehicle_choice'], Config.Karts, selectedOption, nil, {}, true, {
                        onListChange = function(Index, Item)
                            selectedOption = Index
                            -- Louez pour selectedOption
                        end,
                    })
                    --[[RageUI.Checkbox(Lang['insurance'], Config.mutualPrice .. "$", checkboxState, {}, {
                        onChecked = function()
                            checkboxState = true
                        end,
                        onUnChecked = function()
                            checkboxState = false
                        end,
                    })]]
                    RageUI.Button(Lang['rent_kart'], nil, { RightLabel = priceTotal .. "$" }, true, {
                        onSelected = function()
                            main_menu.Closed()
                            TriggerServerEvent('esx_kart:rentKart', priceTotal, Config.Times[selectedTime], Config.KartsDetails[Config.Karts[selectedOption]].string)
                        end
                    })
                end)
            end
        end)
    end
end

CreateThread(function()

    Wait(1000)
    local coords = Config.shopCoords

    local blip = AddBlipForCoord(Config.shopCoords)
    SetBlipScale(blip, 0.9)
    SetBlipAsShortRange(blip, true)
    SetBlipSprite(blip, 748)
    SetBlipColour(blip, 0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Karting")
    EndTextCommandSetBlipName(blip)
        createPed_(Config.pedHash, Config.pedCoords, Config.pedHeading)
    while true do
        local ms = 500
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(coords - playerCoords)
        if distance <= 8 then
            ms = 0
            if distance <= 1.1 and MenuState == false then 
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ '..Lang['access_shop'])
                if IsControlJustPressed(0, 51) then
                    openMenu()
                end
            end
        end
        Wait(ms)
    end
end)

function goAtStart()
    local coords = Config.start
    local ped = PlayerPedId()
    CreateThread(function()
        while inLocation do
            local ms = 500
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(coords - playerCoords)
            if distance <= 100 then
                ms = 0
                --DrawMarker(1, coords.x, coords.y, coords.z -1.1 , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 5.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
                if distance <= 1.1 and MenuState == false then 
                    ESX.ShowHelpNotification(Lang['start_trial'])
                    if IsControlJustPressed(0, 51) then 
                        startRace()
                    end
                end
            end
            Wait(ms)
        end
    end)
end

function startRace()
    print("commence le time trial")
    local kart = GetVehiclePedIsIn(PlayerPedId())
    FreezeEntityPosition(kart, true)

    CreateThread(function()
        local showCD = true
        local time = 3
        local scale = showCountdown(time, 200, 200, 10)
        PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", true)
        Citizen.CreateThread(function()
            while showCD do
                Citizen.Wait(1000)
                if time > 1 then
                    time = time - 1
                    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", true)
                    scale = showCountdown(time, 200, 200, 10)
                elseif time == 1 then
                    time = time - 1
                    PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", true)
                    scale = showCountdown("GO", 200, 200, 10)
                else
                    showCD = false
                end
            end
        end)

        Citizen.CreateThread(function()
            while showCD do
                Citizen.Wait(1)
                DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
            end
        end)
        Wait(4000)
        showCD = false
    end)
    Wait(3000)

    FreezeEntityPosition(kart, false)
    CreateThread(function()
        StartTrial()
    end)

    --[[CreateThread(function()
        while trialLaunched do 
            Wait(200)
            if not IsPedInVehicle(ped, kart) then
                local timeToGetIn = 0
                ESX.ShowNotification(Lang['get_back'])
                while not IsPedInVehicle(ped, kart) do
                    timeToGetIn = timeToGetIn +1
                    if timeToGetIn > 10 then
                        goAtStart()
                    end
                    Wait(500)
                end
            end
        end
    end)]]
    
    for i = 1, #Config.CheckPoints do
        local type = 3
        if i == #Config.CheckPoints then
            type =4
        end
        local coords = Config.CheckPoints[i]
        while not IsEntityAtCoord(PlayerPedId(), coords.x, coords.y, coords.z, 5.0, 5.0, 5.0, 0, 1, 0) and inLocation do
            Wait(0)
            DrawMarker(type, coords.x, coords.y, coords.z + 1.5 , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 5.0, 190, 190, 0, 50, false, true, 2, true, false, false, false)
        end
        PlaySoundFrontend(-1, "CHECKPOINT_AHEAD", "HUD_MINI_GAME_SOUNDSET", true)
        if inLocation == false then
            trialLaunched = false 
            return
        end
    end
    trialLaunched = false
    PlaySoundFrontend(-1, 'Race_PLACED', 'HUD_AWARDS', true)
    ESX.ShowNotification(Lang['your_time']..timeTrial..Lang['seconds'])
    if inLocation then goAtStart() end
end

RegisterNetEvent('esx_kart:clientStartRent')
AddEventHandler('esx_kart:clientStartRent', function(netID, inMinTime)
    
    inLocation = true
    local ped = PlayerPedId()
    rentalTimer = inMinTime * 60

    CreateThread(function()
        while not NetworkDoesEntityExistWithNetworkId(netID) do
            Wait(1)
        end
        local vehicle = NetworkGetEntityFromNetworkId(netID)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        startTimer(vehicle)
        goAtStart()
    end)

end)

function disp_time(time)
    local minutes = math.floor((time%3600/60))
    local seconds = math.floor((time%60))
    return string.format("%02dm %02ds",minutes,seconds)
end

function startTimer(vehicle)
    Citizen.CreateThread(function()
        Citizen.CreateThread(function()
            while rentalTimer>0 do
                rentalTimer=rentalTimer-1
                Citizen.Wait(1000)
            end
        end)
        while rentalTimer>0 do
            Citizen.Wait(0)
            SetTextFont(4)
            SetTextScale(0.45, 0.45)
            SetTextColour(185, 185, 185, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName(disp_time(rentalTimer).." - "..Lang['time_left'])
            EndTextCommandDisplayText(0.065, 0.55)
        end
        inLocation = false
        TaskLeaveVehicle(PlayerPedId(), vehicle, 1)
        SetVehicleDoorsLocked(vehicle, 2)
        trialLaunched = false
    end)
end
