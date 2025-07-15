local VORPcore = exports.vorp_core:GetCore()
local UserAmmo = nil
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

RegisterServerEvent('mms-transform:server:GetPlayerData',function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local job = Character.job
    local group = Character.group
    TriggerClientEvent('mms-transform:client:RecivePlayerData',src,job,group)
end)

RegisterNetEvent('mms-transform:server:rc')
AddEventHandler('mms-transform:server:rc',function ()
    local src = source
    Citizen.Wait(2000)
    VORPcore.Player.Heal(src)
end)

RegisterServerEvent('mms-transform:server:SaveAmmo',function()
    local src = source
    UserAmmo = exports.vorp_inventory:getUserAmmo(src)
    TriggerClientEvent('mms-transform:client:SaveMyAmmo',src,UserAmmo)
end)

RegisterServerEvent('mms-transform:server:GiveBackAmmo',function(MyAmmo)
    local src = source
    exports.vorp_inventory:removeAllUserAmmo(src)
    local AmmoData = json.encode(MyAmmo)
    for h,v in ipairs(AmmoData) do
        exports.vorp_inventory:addBullets(src, h, v)
    end
end)

RegisterNetEvent("legado:attack")

AddEventHandler("legado:attack", function(target, entity)
	TriggerClientEvent("legado:attack", target, source, entity)
end)


--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()