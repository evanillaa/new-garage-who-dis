Utils = {}

Utils.Debug = function(class, message)
    if Debug.debugLevel >= 1 then
        if class == "error" and Debug.debugLevel >= 1 then
            print(Debug.errorDebugColor.."[ERROR]:".. message)
        elseif class == "success" and Debug.debugLevel >= 2 then
            print(Debug.successDebugColor.."[SUCCESS]:".. message)
        elseif class == "inform" and Debug.debugLevel == 3 then
            print(Debug.informDebugColor.."[INFO]:".. message)
        elseif class ~= "error" and class ~= "success" and class ~= "inform" then
            print("^1  [ERROR]: Invalid Debug Class: ^0".. class .. "^1 Please use 'error', 'success' or 'inform'.")
        end
    end
end

Utils.getPlayerIdentifier = function(source)
    local identifier
    for k, v in ipairs(GetPlayerIdentifiers(source)) do 
		if string.match(v, Config.Identifier) then
			identifier = v
			break
		end
    end
    return identifier
end

CreateThread(function()
	local updatePath = '/project-error/new-garage-who-dis'
	local resourceName = "^5["..GetCurrentResourceName().."]^2"

	function checkVersion(err,responseText, headers)
		local curVersion = LoadResourceFile(GetCurrentResourceName(), "version")
		if responseText == nil or curVersion == nil then
            Utils.Debug('error', " " .. resourceName .. "^1- Update check failed. Response was nil")
		elseif curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
            print("\n^1###############################")
			print("\n" ..resourceName.." is outdated.")
            print("\nThe latest stable version is "..responseText..", your version is ("..curVersion..")\n\nPlease download the latest stable build from https://github.com/project-error/new-garage-who-dis")
			print("\n^1###############################")
		elseif(tonumber(curVersion) > tonumber(responseText)) then
			Utils.Debug("inform","You may be using a pre-release of ^8["..GetCurrentResourceName().."]^5 or the GitHub went offline.")
		else
			if GetConvar('onesync') == "on" then
				Utils.Debug("success"," ".. resourceName .. ' (v' .. responseText .. ") is up to date and has started.")
			else
				Utils.Debug("error"," ".. resourceName .. ' (v' .. responseText .. ")^1 is up to date but ^2[OneSync]^1 isn't enabled.\n ^1This resource requires ^2[OneSync]^1 to function correctly.")
			end
		end
	end

	PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/dev/version", checkVersion, "GET")
end)