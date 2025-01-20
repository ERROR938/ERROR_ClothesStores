ESX = nil
if (Config.ESXVerison == "newESX") then
    ESX = exports['es_extended']:getSharedObject()
else
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
end

local function FilterRequest(data)
    local _ = {}
    for k,v in pairs(data) do
        v.skin = json.decode(v.skin)
        _[#_+1] = v
    end
    return _
end

ESX.RegisterServerCallback("ERROR_ClothesStores:Server:GetPlayerSkin", function(source, cb)
    local identifier = ESX.GetPlayerFromId(source).getIdentifier()
    local skin = MySQL.Sync.fetchAll("SELECT skin FROM users WHERE identifier = @identifier", {["@identifier"] = identifier})
    if (skin[1]) then
        cb(json.decode(skin[1].skin))
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("ERROR_ClothesStores:Server:PayOutfit", function(source, cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        if (xPlayer.getAccount('bank').money >= Config.price) then
            xPlayer.removeAccountMoney('bank', Config.price)
            cb(true)
        else
            xPlayer.showNotification("Vous n'avez pas assez d'argent sur votre compte en banque.", "error")
            cb(false)
        end
    else
        xPlayer.showNotification("Une erreur est survenue.", "error")
    end
end)

RegisterServerEvent('ERROR_ClothesStores:save')
AddEventHandler('ERROR_ClothesStores:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
	{
		['@skin']       = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

ESX.RegisterServerCallback("ERROR_ClothesStores:Server:GetMyCodes", function(source, cb)
    local identifier = ESX.GetPlayerFromId(source).getIdentifier()
    local codes = MySQL.Sync.fetchAll("SELECT * FROM outfit_codes WHERE identifier = @identifier", {["@identifier"] = identifier})
    if (codes[1]) then
        cb(FilterRequest(codes))
    else
        cb({})
    end
end)

RegisterNetEvent("ERROR_ClothesStores:Server:CreateCode", function(code, skin, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('INSERT INTO outfit_codes (identifier, code, skin, label) VALUES (@identifier, @code, @skin, @label)',
    {
        ['@identifier'] = xPlayer.identifier,
        ['@code'] = code,
        ['@skin'] = json.encode(skin),
        ['@label'] = label
    })
    xPlayer.showNotification("Code de tenue créé avec succès.", "success")
end)

ESX.RegisterServerCallback("ERROR_ClothesStores:Server:GetOutfitByCode", function(source, cb, code)
    local xPlayer = ESX.GetPlayerFromId(source)
    local code = MySQL.Sync.fetchAll("SELECT * FROM outfit_codes WHERE code = @code", {["@code"] = code})
    if (code[1]) then
        cb(json.decode(code[1].skin))
    else
        xPlayer.showNotification("Code de tenue invalide.", "error")
        cb(false)
    end
end)

ESX.RegisterServerCallback("ERROR_ClothesStores:Server:DeleteCode", function(source, cb, code)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM outfit_codes WHERE code = @code',{['@code'] = code})
    xPlayer.showNotification("Code de tenue supprimé avec succès.", "success")
    cb(true)
end)

ESX.RegisterServerCallback("ERROR_ClothesStores:Server:RenameOutfit", function(source, cb, code, newLabel)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE outfit_codes SET label = @label WHERE code = @code',
    {
        ['@label'] = newLabel,
        ['@code'] = code
    })
    xPlayer.showNotification("Nom de la tenue modifié avec succès.", "success")
    cb(true)
end)