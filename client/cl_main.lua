ESX = nil
if (Config.ESXVerison == "newESX") then
    ESX = exports['es_extended']:getSharedObject()
else
    CreateThread(function()
        while ESX == nil do
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
            Wait(0)
        end
    end)
end