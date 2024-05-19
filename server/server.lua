local VORPcore = exports.vorp_core:GetCore()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-transform/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end


RegisterNetEvent('mms-transform:server:rc')
AddEventHandler('mms-transform:server:rc',function ()
    local src = source
    Citizen.Wait(2000)
    TriggerClientEvent('vorp:heal', src)
end)

RegisterNetEvent("legado:attack")

AddEventHandler("legado:attack", function(target, entity)
	TriggerClientEvent("legado:attack", target, source, entity)
end)


--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()