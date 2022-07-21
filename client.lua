---------------| Developed by BabyDrill#7768 |---------------
ESX = exports.es_extended:getSharedObject()

local seduto = false

RegisterCommand("lavoro",function(source,args)
	if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'unemployed') then
        ESX.ShowNotification("Sei disoccupato, trovati un lavoro!")
    else
        ESX.ShowNotification("Il tuo lavoro è ".. ESX.PlayerData.job.label .." con il grado ".. ESX.PlayerData.job.grade_label)
    end
end)

RegisterCommand('sitcar', function()
    local ped = PlayerPedId()
    local vehicle   = ESX.Game.GetClosestVehicle(GetEntityCoords(ped))
    local vehCoords, pCoords = GetEntityCoords(vehicle), GetEntityCoords(ped)
    if GetDistanceBetweenCoords(vehCoords, pCoords, true) < 3.0 then
        if not seduto then
            TaskEnterVehicle(ped, vehicle, 2000, 1, 1.0, 1, 0)
            Citizen.Wait(2000)
            TaskLeaveVehicle(ped, vehicle, 16)
            Citizen.Wait(0)
            seduto = true
            AttachEntityToEntity(ped, vehicle, -1, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            ExecuteCommand('e sit5')
            ESX.ShowNotification("Sei entrato nel veicolo")
        else
            seduto = false
            DetachEntity(ped)
            ExecuteCommand('e c')
            ESX.ShowNotification("Sei uscito dal veicolo")
        end
    else
        ESX.ShowNotification("Non ci sono veicoli nelle vicinanze")
    end
end)

RegisterCommand("fix",function(source)
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        local auto = GetVehiclePedIsIn(PlayerPedId(), false)

        exports['progressBars']:startUI(4000, "Riparando Auto")
        Citizen.Wait(4000)
        SetVehicleFixed(auto)
        SetVehicleDirtLevel(auto, 0.0)
    else
        ESX.ShowNotification("Devi essere in un veicolo per poterlo riparare!")
    end
end)

RegisterCommand("heal", function()
    TriggerEvent('esx_basicneeds:healPlayer')
    ESX.ShowNotification("Ti sei curato con successo!")
end)

RegisterCommand("id",function()
    ESX.ShowNotification("Il tuo id è ".. GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId())))
end)

RegisterCommand("giubbo", function()
	SetPedArmour(GetPlayerPed(-1), 100)
    ESX.ShowNotification("Ti messo l'armatura!")
end)

RegisterCommand("ammo", function()
	local player = GetPlayerPed(-1)
    local calcio, arma = GetCurrentPedWeapon(player, 1)
    local calcio, colpi = GetMaxAmmo(player, arma)

    if IsPedArmed(player, 4) then 
        SetPedAmmo(player, arma, 250)
        ESX.ShowNotification("Hai ricaricato "..colpi.." nella tua arma!")
    else
        ESX.ShowNotification("Non hai un'arma in mano!")
    end
end)

RegisterCommand("giorno", function()
    NetworkOverrideClockTime(12, 00, 00)
    ESX.ShowNotification("Hai impostato il meteo di giorno!")
end)

RegisterCommand("pomeriggio", function()
    NetworkOverrideClockTime(18, 00, 00)
    ESX.ShowNotification("Hai impostato il meteo di pomeriggio!")
end)

RegisterCommand("notte", function()
    NetworkOverrideClockTime(00, 00, 00)
    ESX.ShowNotification("Hai impostato il meteo di notte!")
end)

RegisterCommand("fps", function()
	MenuFps()
end)

function MenuFps()
    local fixfps = {}

    table.insert(fixfps, {label = "Colore", value = 'colore'})
    table.insert(fixfps, {label = "Distanza Bassa", value = 0.5})
    table.insert(fixfps, {label = "Distanza Media", value = 1.0})
    table.insert(fixfps, {label = "Distanza Alta", value = 75.0})

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fps', {
        title    = "Gestione FPS",
        align    = 'top-left',
        elements = fixfps
    }, function(data, menu)
        
        if data.current.value == 'colore' then
            if not boostabilitato then
                SetTimecycleModifier("cinema")
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
                boostabilitato = true
                ESX.ShowNotification("Hai cambiato i colori")
            elseif boostabilitato then
                SetTimecycleModifier("default")
                boostabilitato = false
                ESX.ShowNotification("Hai reimpostato i colori")
            end
        else
            if data.current.value == 0.5 then
                OverrideLodscaleThisFrame(0.5)
                SetLightsCutoffDistanceTweak(0.5)
                CascadeShadowsSetCascadeBoundsScale(0.0)	

                RopeDrawShadowEnabled(false)

                CascadeShadowsClearShadowSampleType()
                CascadeShadowsSetAircraftMode(false)
                CascadeShadowsEnableEntityTracker(true)
                CascadeShadowsSetDynamicDepthMode(false)
                CascadeShadowsSetEntityTrackerScale(0.0)
                CascadeShadowsSetDynamicDepthValue(0.0)
                CascadeShadowsSetCascadeBoundsScale(0.0)

                SetFlashLightFadeDistance(0.0)
                SetLightsCutoffDistanceTweak(0.0)
                DistantCopCarSirens(false)
                ESX.ShowNotification("Hai attivato la distanza bassa")
            elseif data.current.value == 1.0 then
                OverrideLodscaleThisFrame(1.0)
                SetLightsCutoffDistanceTweak(1.0)
                CascadeShadowsSetCascadeBoundsScale(0.5)	

                RopeDrawShadowEnabled(false)

                CascadeShadowsClearShadowSampleType()
                CascadeShadowsSetAircraftMode(false)
                CascadeShadowsEnableEntityTracker(true)
                CascadeShadowsSetDynamicDepthMode(false)
                CascadeShadowsSetEntityTrackerScale(0.0)
                CascadeShadowsSetDynamicDepthValue(0.0)
                CascadeShadowsSetCascadeBoundsScale(0.0)

                SetFlashLightFadeDistance(5.0)
                SetLightsCutoffDistanceTweak(5.0)
                DistantCopCarSirens(false)
                ESX.ShowNotification("Hai attivato la distanza media")
                
            elseif data.current.value == 75.0 then
                OverrideLodscaleThisFrame(75.0)
                SetLightsCutoffDistanceTweak(75.0)
                CascadeShadowsSetCascadeBoundsScale(1.0)	

                RopeDrawShadowEnabled(true)
                CascadeShadowsClearShadowSampleType()
                CascadeShadowsSetAircraftMode(false)
                CascadeShadowsEnableEntityTracker(true)
                CascadeShadowsSetDynamicDepthMode(false)
                CascadeShadowsSetEntityTrackerScale(5.0)
                CascadeShadowsSetDynamicDepthValue(3.0)
                CascadeShadowsSetCascadeBoundsScale(3.0)

                SetFlashLightFadeDistance(3.0)
                SetLightsCutoffDistanceTweak(3.0)
                DistantCopCarSirens(false)
                SetArtificialLightsState(false)
                ESX.ShowNotification("Hai attivato la distanza alta")

            
            end
        
        end


    end, function(data, menu)
        menu.close()
    end)
end


Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/lavoro', 'Per sapere il tuo lavoro!',{})
	TriggerEvent('chat:addSuggestion', '/id', 'Per sapere il tuo id!',{})
	TriggerEvent('chat:addSuggestion', '/fix', 'Per ripare il veicolo!',{})
	TriggerEvent('chat:addSuggestion', '/heal', 'Per curarti!',{})
    TriggerEvent('chat:addSuggestion', '/sitcar', 'Per sederti su un veicolo!',{})
	TriggerEvent('chat:addSuggestion', '/fps', 'Per aprire il menu Fps!',{})
    TriggerEvent('chat:addSuggestion', '/giubbo', 'Per il giubbotto antiproiettile!',{})
    TriggerEvent('chat:addSuggestion', '/ammo', 'Per ricaricare i colpi!',{})
    TriggerEvent('chat:addSuggestion', '/giorno', 'Per impostare il meteo di giorno!',{})
	TriggerEvent('chat:addSuggestion', '/pomeriggio', 'Per impostare il meteo di pomeriggio!',{})
	TriggerEvent('chat:addSuggestion', '/notte', 'Per impostare il meteo di notte!',{})
end)
---------------| Developed by ᴍɪᴋᴇ#6070 |---------------