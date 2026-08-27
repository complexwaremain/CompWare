local isfile = isfile or function(file)
    local suc, res = pcall(function()
        return readfile(file)
    end)
    return suc and res ~= nil and res ~= ''
end

local function downloadFile(path, func)
    -- Only downloads if the file doesn't exist locally
    if not isfile(path) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/complexwaremain/CompWare/main/'..select(1, path:gsub('CompWare/', '')), true)
        end)
        if not suc or res == '404: Not Found' then
            error(res)
        end
        if path:find('.lua') then
            res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n'..res
        end
        writefile(path, res)
    end
    return (func or readfile)(path)
end

-- Create CompWare directories
for _, folder in {'CompWare', 'CompWare/games', 'CompWare/profiles', 'CompWare/assets', 'CompWare/libraries', 'CompWare/guis'} do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

-- Load the script
return loadstring(downloadFile('CompWare/MainScript.lua'), 'main')()
