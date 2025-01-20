ESX = nil
if (Config.versionESX == "newESX") then
    ESX = exports['es_extended']:getSharedObject()
else
    CreateThread(function()
        while ESX == nil do
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
            Wait(0)
        end
    end)
end