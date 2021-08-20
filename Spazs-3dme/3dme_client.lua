local nbrDisplaying = 1

RegisterCommand('me', function(source, args)
    local text = ''
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' '
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterCommand('scene', function(source, args)
    local sceneText = table.concat(args, " ")
    TriggerServerEvent('3dme:sceneDisplay', sceneText)
end)

RegisterNetEvent('3dme:sceneTriggerDisplay')
AddEventHandler('3dme:sceneTriggerDisplay', function(sceneText, source)
    local player = GetPlayerFromServerId(source)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        Utils.DisplayScene(ped, sceneText)
    end
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(name, text, source)
    local player = GetPlayerFromServerId(source)
    if player ~= -1 then
        local offset = 0.25 + (nbrDisplaying*0.15)
        local ped = GetPlayerPed(player)
        Utils.Display(ped, name, text, offset)
    end
end)

Utils = {
    Draw3DTextScene = function(xyz, sceneText)
        local onScreen, _x, _y = World3dToScreen2d(xyz.x,xyz.y,xyz.z)
        local p = GetGameplayCamCoords()
        local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, xyz.x,xyz.y,xyz.z, 1)
        local scale = (1 / distance) * (4)
        local fov = (1 / GetGameplayCamFov()) * 75
        local scale = scale * fov
        if onScreen then
            SetTextScale(tonumber(1*0.0), tonumber(0.35 * (1)))
            SetTextFont(0)
            SetTextProportional(true)
            SetTextColour(255 , 215, 0, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(2, 0, 0, 0, 150)
            SetTextOutline()
            SetTextEntry("STRING")
            SetTextCentre(true)
            AddTextComponentString(sceneText)
            DrawText(_x,_y)
            local factor = (string.len(sceneText)) / 370
            DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
        end
    end,
    DisplayScene = function(ped, sceneText)
        local timeout = 600000
        local xyz=GetEntityCoords(ped)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local pedCoords = GetEntityCoords(ped)
        local displaying = true
        Citizen.CreateThread(function()
            Citizen.Wait(timeout)
            displaying = false
        end)
        Citizen.CreateThread(function()
            while displaying do
                Citizen.Wait(0)
                    local output = string.format("%s", sceneText)
    
                    if Vdist2(GetEntityCoords(PlayerPedId(), false), xyz ) <= 55 then
                        Utils.Draw3DTextScene(xyz, output)
                    
                end
            end
        end)
    end,
    DrawText3Ds = function(x, y, z, text)
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        local p = GetGameplayCamCoords()
        local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
        local scale = (1 / distance) * 2
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = scale * fov
        if onScreen then
              SetTextScale(0.35, 0.35)
              SetTextFont(4)
              SetTextProportional(1)
              SetTextColour(255, 255, 255, 215)
              SetTextEntry("STRING")
              SetTextCentre(1)
              AddTextComponentString(text)
              DrawText(_x,_y)
              local factor = (string.len(text)) / 370
              DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
          end
      end,
    Display = function(ped, name, text, offset)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local pedCoords = GetEntityCoords(ped)
        local dist = #(playerCoords - pedCoords)
    
        local displaying = true
        Citizen.CreateThread(function()
            Wait(7000)
            displaying = false
        end)
        Citizen.CreateThread(function()
            nbrDisplaying = nbrDisplaying + 1
            --print(nbrDisplaying)
            while displaying do
                Wait(0)
                if dist <= 15 then
                    local output = string.format("%s %s", name, text)
    
                    if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                        local x, y, z = table.unpack(GetEntityCoords(ped))
                        z = z + offset
                        Utils.DrawText3Ds(x, y, z, output, 3.0, 7)
                    end
                end
            end
            nbrDisplaying = nbrDisplaying - 1
        end)
    end,
}