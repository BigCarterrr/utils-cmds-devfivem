-- Commande GetCoords

RegisterCommand("coords", function(source, args, rawCommand)

    local playerPed = PlayerPedId()

    local playerCoords = GetEntityCoords(playerPed)
    
    local playerHeading = GetEntityHeading(playerPed)

    local coordsText = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", playerCoords.x, playerCoords.y, playerCoords.z, playerHeading)

    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0}, -- Couleur du texte (rouge)
        multiline = true,
        args = {"Coordonnées", coordsText}
    })

    SendNUIMessage({
        action = "copyToClipboard",
        text = coordsText
    })

    print("Les coordonnées vector4 ont été copiées dans le presse-papier.")
end, false)

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------


-- Commande TPMARKER

function TeleportToWaypoint()

    local playerPed = PlayerPedId()
    
    if DoesBlipExist(GetFirstBlipInfoId(8)) then

        local waypointBlip = GetFirstBlipInfoId(8)
        local coord = GetBlipInfoIdCoord(waypointBlip)

        local groundZ = 0.0
        local foundGround, zCoord = GetGroundZFor_3dCoord(coord.x, coord.y, 1000.0, 0)
        
        if foundGround then
            groundZ = zCoord
        else
            groundZ = coord.z
        end

        if IsPedInAnyVehicle(playerPed, false) then
            -- Sortir le joueur du véhicule
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            TaskLeaveVehicle(playerPed, vehicle, 0)
            Wait(1000) 
        end


        SetEntityCoords(playerPed, coord.x, coord.y, groundZ + 1.0, false, false, false, true)


        TriggerEvent('chat:addMessage', {
            color = { 255, 255, 0},
            multiline = true,
            args = {"Système", "Vous avez été téléporté à votre marqueur sur la carte."}
        })
    else

        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Erreur", "Aucun marqueur n'a été trouvé sur la carte."}
        })
    end
end

RegisterCommand("tpmarker", function()
    TeleportToWaypoint()
end, false)


------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

-- Commande /me

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local scale = 0.35
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

RegisterCommand('me', function(source, args)
    local text = table.concat(args, " ")
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    if text == "" then
        return
    end
    
    local displayTime = 5000 

    Citizen.CreateThread(function()
        local endTime = GetGameTimer() + displayTime
        while GetGameTimer() < endTime do
            Citizen.Wait(0)
            local playerCoords = GetEntityCoords(playerPed)
            DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, text)
        end
    end)
end, false)


