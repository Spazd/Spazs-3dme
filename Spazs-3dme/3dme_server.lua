
local printItems = true

local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)

	local Player = QBCore.Functions.GetPlayer(source)
	if Player then name =  Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname end

	TriggerClientEvent('3dme:triggerDisplay', -1, name, text, source)
	TriggerEvent("QBCore-log:server:CreateLog", "me", "Me", "white", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..")** " ..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.. " **" ..text, false)
	
	if source ~= nil then
		local coords = GetEntityCoords(GetPlayerPed(source))
		TriggerClientEvent('cmd:me', -1, source, name, text, coords)
	end	
end)

RegisterServerEvent('3dme:sceneDisplay')
AddEventHandler('3dme:sceneDisplay', function(sceneText)
	TriggerClientEvent('3dme:sceneTriggerDisplay', -1, sceneText, source)
end)

