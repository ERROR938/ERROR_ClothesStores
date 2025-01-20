function CalculAllClothes(skin)
    local count = 0
    for k,v in pairs(skin) do
        count = count + v
    end
    return count
end

function GetPedClotheNumber(c)
    return c.type == "variation" and GetNumberOfPedDrawableVariations(PlayerPedId(), c.id) or GetNumberOfPedPropDrawableVariations(PlayerPedId(), c.id)
end

function range(start, stop, step)
    step = step or 1
    local t = {}
    for i = start, stop, step do
        table.insert(t, i)
    end
    return t
end

function FormatJobTable(t)
    local _ = {}
    for k,v in pairs(t) do
        _[#_+1] = v
    end
    return _
end

function mergeTables(baseTable, additionalTable)
    local result = {}
    for _, item in ipairs(baseTable) do
        table.insert(result, item)
    end

    for _, jobCategory in pairs(additionalTable) do
        for _, item in ipairs(jobCategory) do
            table.insert(result, item)
        end
    end

    return result
end

function GenerateHexaCode()
    local _ = {}
    for i=1, 6 do
        _[#_+1] = string.char(math.random(48, 57))
    end
    return table.concat(_)
end

local function GetAllCat()
    local _ = {}
    for k,v in pairs(mergeTables(Config.DefaultCategories, Config.JobsCategories)) do
        if (v and v.name) then
            _[v.name] = true
        end
    end
    return _
end

function ApplyOutfit(skin)
    local cats = GetAllCat()
    for k,v in pairs(skin) do
        local clo = k:gsub("_1", "")
        local text = k:gsub("_2", "")
        if (cats[clo]) then
            TriggerEvent('skinchanger:change', k, v)
        end
        if (cats[text]) then
            TriggerEvent('skinchanger:change', k, v)
        end
    end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        if result == "" then
            return
        end
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

function LoadBlips()
    for k,v in pairs(Config.Locations) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, Config.Blips.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blips.scale)
        SetBlipColour(blip, Config.Blips.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blips.text)
        EndTextCommandSetBlipName(blip)
    end
end