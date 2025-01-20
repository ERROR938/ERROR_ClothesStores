local main = RageUI.CreateMenu("", "Liste des options")
local catalogue = RageUI.CreateSubMenu(main, "", "Catalogue des vêtements")
local clothes_menu = RageUI.CreateSubMenu(catalogue, "", "Liste des vêtements")
local codes_menu = RageUI.CreateSubMenu(main, "", "Codes de tenues")
local outfit_interact = RageUI.CreateSubMenu(main, "", "Interactions")
local validate, hasJob = false, false
local clothes_codes, current_outfit = {}, {}
local beforepaid = 0
local name_filtered = ""
local ped = PlayerPedId()
local cache = {cat = {},}
local actual_category, myskin = {}, {}

local function RefreshOutfitList()
    ESX.TriggerServerCallback("ERROR_ClothesStores:Server:GetMyCodes", function(codes) 
        clothes_codes = codes
    end)
end

main.Closed = function()
    FreezeEntityPosition(PlayerPedId(), false)
end

catalogue.Closed = function()
    if (not validate) then
        TriggerEvent('skinchanger:loadSkin', myskin)
    end
    validate = false
    cache = {cat = {},}
end

function RageUI.PoolMenus:ClothesStore()
    main:IsVisible(function(Items)
        Items:AddButton("Catalogue des vêtements", nil, {RightLabel = "→"}, function(onSelected)
            if (onSelected) then
                ESX.TriggerServerCallback("ERROR_ClothesStores:Server:GetPlayerSkin", function(skin) 
                    beforepaid = CalculAllClothes(skin)
                    myskin = skin
                end)
            end
        end, catalogue)

        Items:AddButton("Codes de tenues", nil, {RightLabel = "→"}, function(onSelected)
            if (onSelected) then
                RefreshOutfitList()
            end
        end, codes_menu)
    end, function() end)

    catalogue:IsVisible(function(Items)
        local table = ESX.Table.Concat(Config.DefaultCategories, FormatJobTable(Config.JobsCategories))
        for k,v in pairs(hasJob and mergeTables(Config.DefaultCategories, Config.JobsCategories) or Config.DefaultCategories) do
            Items:AddButton(v.label, nil, {RightLabel = "→"}, function(onSelected)
                if (onSelected) then
                    actual_category = v
                    name_filtered = actual_category.label:gsub("%s", ""):lower()
                    cache[name_filtered] = {}
                end
            end, clothes_menu)
        end
        Items:AddButton("~g~Valider mes choix et payer~s~", nil, {}, function(onSelected)
            if (onSelected) then
                ESX.TriggerServerCallback("ERROR_ClothesStores:Server:PayOutfit", function(paid) 
                    if (paid) then
                        validate = true
                        TriggerEvent("skinchanger:getSkin", function(skin)
                            TriggerServerEvent("ERROR_ClothesStores:save", skin)
                        end)
                        ESX.ShowNotification("Merci pour votre achat !", "success")
                    end
                end)
            end
        end)
    end, function() end)

    clothes_menu:IsVisible(function(Items)
        for i=-1, GetPedClotheNumber(actual_category) do
            local textures = GetNumberOfPedTextureVariations(ped, actual_category.id, i)
            if (not cache[name_filtered][i]) then
                cache[name_filtered][i] = {
                    items = range(0, textures),
                    index = 1
                }
            end
            if (textures <= 1) then
                Items:AddButton(("%s #%s"):format(actual_category.label, i), nil, {}, function(onSelected, onHover)
                    if (onHover) then

                        if (cache.lastclothe ~= i) then
                            if (myskin[actual_category.name] ~= nil) then
                                TriggerEvent('skinchanger:change', actual_category.name, i)
                            else
                                TriggerEvent('skinchanger:change', ("%s_1"):format(actual_category.name), i)
                            end
                        end
                        cache.lastclothe = i
                    end
                end)
            else
                Items:AddList(("%s #%s"):format(actual_category.label, i), cache[name_filtered][i].items or 0, cache[name_filtered][i].index, nil, {}, function(Index, onSelected, onListChange, onHover)
                    if (onListChange) then
                        cache[name_filtered][i].index = Index
                    end

                    if (onHover) then
                        if (cache.lastclothe ~= i) then
                            if (myskin[actual_category.name] ~= nil) then
                                TriggerEvent('skinchanger:change', actual_category.name, i)
                            else
                                TriggerEvent('skinchanger:change', ("%s_1"):format(actual_category.name), i)
                            end
                        end
                        cache.lastclothe = i
                    end

                    if (onListChange) then
                        local name = ("%s_2"):format(actual_category.name)
                        print(name, i)
                        if (myskin[name] ~= nil) then
                            TriggerEvent('skinchanger:change', name, Index-1)
                        end
                    end
                end)
            end
        end
    end, function() end)

    codes_menu:IsVisible(function(Items)
        Items:AddButton("Crée un code", nil, {RightLabel = "→"}, function(onSelected)
            if (onSelected) then
                local outfit_name = KeyboardInput("Entrez le nom de la tenue", "", 20)
                if (not outfit_name) then return end
                TriggerEvent("skinchanger:getSkin", function(skin)
                    local code = GenerateHexaCode()
                    TriggerServerEvent("ERROR_ClothesStores:Server:CreateCode", code, skin, outfit_name)
                end)
                RefreshOutfitList()
            end
        end)

        Items:AddButton("Enfiler une tenue via un code", nil, {RightLabel = "→"}, function(onSelected)
            if (onSelected) then
                local code = KeyboardInput("Entrez le code de la tenue", "", 20)
                if (not code) then return end
                ESX.TriggerServerCallback("ERROR_ClothesStores:Server:GetOutfitByCode", function(outfit) 
                    ApplyOutfit(outfit)
                    TriggerEvent("skinchanger:getSkin", function(skin)
                        TriggerServerEvent("ERROR_ClothesStores:save", skin)
                    end)
                end, code)
            end
        end)

        Items:AddSeparator("Tenues enregistrées avec un code")
        for k,v in pairs(clothes_codes) do
            Items:AddButton(("Tenue %s n°%s"):format(v.label, v.code), nil, {}, function(onSelected)
                if (onSelected) then
                    current_outfit = v
                end
            end, outfit_interact)
        end
    end, function() end)

    outfit_interact:IsVisible(function(Items)
        Items:AddButton("Enfiler", nil, {}, function(onSelected)
            if (onSelected) then
                ApplyOutfit(current_outfit.skin)
                TriggerEvent("skinchanger:getSkin", function(skin)
                    TriggerServerEvent("ERROR_ClothesStores:save", skin)
                end)
            end
        end)
        Items:AddButton("Renommer", nil, {}, function(onSelected)
            if (onSelected) then
                local new_name = KeyboardInput("Entrez le nouveau nom de la tenue", "", 20)
                if (not new_name) then return end
                ESX.TriggerServerCallback("ERROR_ClothesStores:Server:RenameOutfit", function(renamed) 
                    if (renamed) then
                        RefreshOutfitList()
                        RageUI.GoBack()
                    end
                end, current_outfit.code, new_name)
            end
        end)
        Items:AddButton("Supprimer", nil, {}, function(onSelected)
            if (onSelected) then
                ESX.TriggerServerCallback("ERROR_ClothesStores:Server:DeleteCode", function(deleted) 
                    if (deleted) then
                        RefreshOutfitList()
                        RageUI.GoBack()
                    end
                end, current_outfit.code)
            end
        end)
    end, function() end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
    hasJob = Config.JobsCategories[ESX.PlayerData.job.name] ~= nil
    LoadBlips()
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
    hasJob = Config.JobsCategories[ESX.PlayerData.job.name] ~= nil
end)

CreateThread(function()
    local sleep, dst, pos
    while (true) do
        sleep = 1000
        pos = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.Locations) do
            dst = #(pos - v)
            if (dst <= 10) then
                sleep = 0
                DrawMarker(Config.Markers['id'], v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, Config.Markers['size'], Config.Markers['size'], Config.Markers['size'], Config.Markers['color'][1], Config.Markers['color'][2], Config.Markers['color'][3], Config.Markers['opacity'], Config.Markers['animate'], true, 2, Config.Markers['turn'], nil, false)

                if (dst <= Config.Markers['size']) then
                    ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour acceder au magasin de vêtements")
                    if (IsControlJustPressed(0, 51)) then
                        RageUI.Visible(main, not RageUI.Visible(main))
                        FreezeEntityPosition(PlayerPedId(), true)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)