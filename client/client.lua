local VORPcore = exports.vorp_core:GetCore()
local FeatherMenu =  exports['feather-menu'].initiate()

local playerjob = nil
if Config.Joblock then
---------------------------------------------------------------------------------
------------------------------Get Playerjob--------------------------------------
---------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while playerjob == nil do
        Citizen.Wait(1000)
        TriggerServerEvent('mms-transform:server:getplayerjob')
    end
end)

RegisterNetEvent('mms-transform:client:getplayerjob')
AddEventHandler('mms-transform:client:getplayerjob',function(job)
    playerjob = job
    if playerjob == nil then
        Citizen.Wait(500)
    else
        RegisterCommand(Config.Command, function()
            TriggerEvent('mms-transform:client:transformmenu')
        end)
    end
end)
end

if not Config.JobLock then
RegisterCommand(Config.Command, function()
    TriggerEvent('mms-transform:client:transformmenu')
end)
end

local inform = false

Citizen.CreateThread(function ()    ------------ Register Menü
AnimalTransform = FeatherMenu:RegisterMenu('feather:character:transformmenu', {
    top = '50%',
    left = '50%',
    ['720width'] = '500px',
    ['1080width'] = '700px',
    ['2kwidth'] = '700px',
    ['4kwidth'] = '8000px',
    style = {
        ['border'] = '5px solid orange',
        -- ['background-image'] = 'none',
        ['background-color'] = '#FF8C00'
    },
    contentslot = {
        style = {
            ['height'] = '550px',
            ['min-height'] = '550px'
        }
    },
    draggable = true,
})
AnimalTransformPage1 = AnimalTransform:RegisterPage('first:transform')
AnimalTransformPage1:RegisterElement('header', {
    value = 'Transformations Menü',
    slot = "header",
    style = {
        ['color'] = 'orange',
    }
})
AnimalTransformPage1:RegisterElement('line', {
    slot = "header",
    style = {
        ['color'] = 'orange',
    }
})
for _, v in pairs(Config.TransformList) do
AnimalTransformPage1:RegisterElement('button', {
    label = v.name,
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    },
}, function()
    local model = v.model
    local name = v.name
    TriggerEvent('mms-transform:client:dothetransformation' , model,name)
end)
end
AnimalTransformPage1:RegisterElement('button', {
    label = "Werde Wieder Mensch",
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    },
}, function()
    TriggerEvent('mms-transform:client:rc')
end)
AnimalTransformPage1:RegisterElement('button', {
    label = "Transformations Menü Schließen",
    style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
    },
}, function()
    AnimalTransform:Close({ 
    })
end)
AnimalTransformPage1:RegisterElement('subheader', {
    value = "Transformations Menü",
    slot = "footer",
    style = {
        ['color'] = 'orange',
    }
})
AnimalTransformPage1:RegisterElement('line', {
    slot = "footer",
    style = {
        ['color'] = 'orange',
    }
})

end)

RegisterNetEvent('mms-transform:client:transformmenu',function()
    AnimalTransform:Open({
        startupPage = AnimalTransformPage1,
    })
end)


RegisterNetEvent('mms-transform:client:dothetransformation')
AddEventHandler('mms-transform:client:dothetransformation',function(model,name)

        local modelHash = GetHashKey(model)     ---- is horse model but tried other models too Like A_C_Cow
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
            Wait(1)
            end
        

        local player = PlayerId()
        Citizen.Wait(250)
        Citizen.InvokeNative(0xED40380076A31506, player, modelHash, false) -- SetPlayerModel
        Citizen.Wait(250)
        Citizen.InvokeNative(0x283978A15512B2FE, PlayerPedId(), false)  -- SetRandomOutfitVariation
        Citizen.Wait(250)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4,PlayerPedId(),4,0)
        Citizen.Wait(250)
        SetEntityMaxHealth(PlayerPedId(), 1000)
        Citizen.Wait(250)
        SetEntityHealth(PlayerPedId(), 1000)
        Citizen.Wait(250)
        SetModelAsNoLongerNeeded(model)
        inform = true
        TriggerEvent('mms-transform:client:timer',model,name)
        
end)

function SpawnFX(dict, name)
    local Player = PlayerId()
    local new_ptfx_dictionary = dict or "scr_net_target_races"
    local new_ptfx_name = name or "scr_net_target_fire_ring_burst_mp"
    local is_particle_effect_active = false
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name
    local current_ptfx_handle_id = false
    local ptfx_offcet_x = 0.0
    local ptfx_offcet_y = 0.0
    local ptfx_offcet_z = 0.0
    local ptfx_rot_x = -90.0
    local ptfx_rot_y = 0.0
    local ptfx_rot_z = 0.0
    local ptfx_scale = 1.0
    local ptfx_axis_x = 0
    local ptfx_axis_y = 0
    local ptfx_axis_z = 0


    if not is_particle_effect_active then
        current_ptfx_dictionary = new_ptfx_dictionary
        current_ptfx_name = new_ptfx_name
        if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then                         -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))                                 -- RequestNamedPtfxAsset
            local counter = 0
            while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do -- while not HasNamedPtfxAssetLoaded
                Citizen.Wait(0)
            end
        end
        if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary)                 -- UseParticleFxAsset


            current_ptfx_handle_id = Citizen.InvokeNative(0xE6CFE43937061143, current_ptfx_name,
                PlayerPedId(), ptfx_offcet_x, ptfx_offcet_y, ptfx_offcet_z, ptfx_rot_x, ptfx_rot_y,
                ptfx_rot_z, ptfx_scale, ptfx_axis_x, ptfx_axis_y, ptfx_axis_z) -- StartNetworkedParticleFxNonLoopedOnEntity
            is_particle_effect_active = true
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_ptfx_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_ptfx_handle_id) then    -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_ptfx_handle_id, false) -- RemoveParticleFx
            end
        end
        current_ptfx_handle_id = false
        is_particle_effect_active = false

        Wait(2000)
    end
end


RegisterNetEvent('mms-transform:client:timer')
AddEventHandler('mms-transform:client:timer',function(model,name)
    while inform do
        --SpawnFX()
        --SetPedScale(PlayerPedId(), 50.9)
        Citizen.InvokeNative(0xE4CB5A3F18170381, PlayerId(), 20.0)
        Citizen.Wait(3)
    end
    ExecuteCommand('rc')
    TriggerServerEvent('mms-transform:server:rc')
end)

RegisterNetEvent('mms-transform:client:rc')
AddEventHandler('mms-transform:client:rc',function()
    inform = false
    Citizen.InvokeNative(0xE4CB5A3F18170381, PlayerId(), 1.0)
    ExecuteCommand('rc')
    TriggerServerEvent('mms-transform:server:rc')
end)


function SetMonModel(name)
	local model = GetHashKey(name)
	local player = PlayerId()
	
	if not IsModelValid(model) then return end
	PerformRequest(model)
	
	if HasModelLoaded(model) then
		Citizen.InvokeNative(0xED40380076A31506, player, model, false)
		Citizen.InvokeNative(0x283978A15512B2FE, PlayerPedId(), true)
		SetModelAsNoLongerNeeded(model)
	end
end


function PerformRequest(hash)
    RequestModel(hash, 0)
    local bacon = 1
    while not Citizen.InvokeNative(0x1283B8B89DD5D1B6, hash) do
        Citizen.InvokeNative(0xFA28FE3A6246FC30, hash, 0)
        bacon = bacon + 1
        Citizen.Wait(0)
        if bacon >= 100 then break end
    end
end


local IsAnimal = false
local IsAttacking = false

RegisterNetEvent("legado:attack")

function SetControlContext(pad, context)
	Citizen.InvokeNative(0x2804658EB7D8A50B, pad, context)
end

function GetPedCrouchMovement(ped)
	return Citizen.InvokeNative(0xD5FE956C70FF370B, ped)
end

function SetPedCrouchMovement(ped, state, immediately)
	Citizen.InvokeNative(0x7DE9692C6F64CFE8, ped, state, immediately)
end

function PlayAnimation(anim)
	if not DoesAnimDictExist(anim.dict) then
		print("Invalid animation dictionary: " .. anim.dict)
		return
	end

	RequestAnimDict(anim.dict)

	while not HasAnimDictLoaded(anim.dict) do
		Citizen.Wait(0)
	end

	TaskPlayAnim(PlayerPedId(), anim.dict, anim.name, 4.0, 4.0, -1, 0, 0.0, false, false, false, "", false)

	RemoveAnimDict(anim.dict)
end

function IsPvpEnabled()
	return GetRelationshipBetweenGroups(`PLAYER`, `PLAYER`) == 5
end

function IsValidTarget(ped)
	return not IsPedDeadOrDying(ped) and not (IsPedAPlayer(ped) and not IsPvpEnabled())
end

function GetClosestPed(playerPed, radius)
	local playerCoords = GetEntityCoords(playerPed)

	local itemset = CreateItemset(true)
	local size = Citizen.InvokeNative(0x59B57C4B06531E1E, playerCoords, radius, itemset, 1, Citizen.ResultAsInteger())

	local closestPed
	local minDist = radius

	if size > 0 then
		for i = 0, size - 1 do
			local ped = GetIndexedItemInItemset(i, itemset)

			if playerPed ~= ped and IsValidTarget(ped) then
				local pedCoords = GetEntityCoords(ped)
				local distance = #(playerCoords - pedCoords)

				if distance < minDist then
					closestPed = ped
					minDist = distance
				end
			end
		end
	end

	if IsItemsetValid(itemset) then
		DestroyItemset(itemset)
	end

	return closestPed
end

function MakeEntityFaceEntity(entity1, entity2)
	local p1 = GetEntityCoords(entity1)
	local p2 = GetEntityCoords(entity2)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)

	SetEntityHeading(entity1, heading)
end

function GetAttackType(playerPed)
	local playerModel = GetEntityModel(playerPed)

	for _, attackType in ipairs(Config.AttackTypes) do
		for _, model in ipairs(attackType.models) do
			if playerModel == model then
				return attackType
			end
		end
	end
end

function ApplyAttackToTarget(attacker, target, attackType)
	if attackType.force > 0 then
		SetPedToRagdoll(target, 1000, 1000, 0, 0, 0, 0)
		SetEntityVelocity(target, GetEntityForwardVector(attacker) * attackType.force)
	end

	if attackType.damage > 0 then
		ApplyDamageToPed(target, attackType.damage, 1, -1, 0)
	end
end

function GetPlayerServerIdFromPed(ped)
	for _, player in ipairs(GetActivePlayers()) do
		if GetPlayerPed(player) == ped then
			return GetPlayerServerId(player)
		end
	end
end

function Attack()
	if IsAttacking then
		return
	end

	local playerPed = PlayerPedId()

	if IsPedDeadOrDying(playerPed) or IsPedRagdoll(playerPed) then
		return
	end

	local attackType = GetAttackType(playerPed)

	if attackType then
		local target = GetClosestPed(playerPed, attackType.radius)

		if target then
			IsAttacking = true

			MakeEntityFaceEntity(playerPed, target)

			PlayAnimation(attackType.animation)

			if IsPedAPlayer(target) then
				TriggerServerEvent("legado:attack", GetPlayerServerIdFromPed(target), -1)
			elseif NetworkGetEntityIsNetworked(target) and not NetworkHasControlOfEntity(target) then
				TriggerServerEvent("legado:attack", -1, PedToNet(target))
			else
				ApplyAttackToTarget(playerPed, target, attackType)
			end

			Citizen.SetTimeout(Config.AttackCooldown, function()
				IsAttacking = false
			end)
		end
	end
end

function ToggleCrouch()
	local playerPed = PlayerPedId()

	SetPedCrouchMovement(playerPed, not GetPedCrouchMovement(playerPed), true)
end

AddEventHandler("legado:attack", function(attacker, entity)
	local attackerPed = GetPlayerPed(GetPlayerFromServerId(attacker))
	local attackType = GetAttackType(attackerPed)

	if entity == -1 then
		if IsPvpEnabled() then
			ApplyAttackToTarget(attackerPed, PlayerPedId(), attackType)
		end
	else
		ApplyAttackToTarget(attackerPed, NetToPed(entity), attackType)
	end
end)


Citizen.CreateThread(function()
	local lastPed = 0

	while true do
		local ped = PlayerPedId()

		if ped ~= lastPed then
			if IsPedHuman(ped) then
				SetControlContext(2, 0)
				IsAnimal = false
			else

				SetPedConfigFlag(ped, 43, true)
				IsAnimal = true
			end

			lastPed = ped
		end

		Citizen.Wait(1000)
	end
end)


Citizen.CreateThread(function()
	while true do
		if IsAnimal then

			SetControlContext(2, `OnMount`)

			DisableFirstPersonCamThisFrame()


			if IsControlJustPressed(0, `INPUT_ATTACK`) then
				Attack()
			end

			if IsControlJustPressed(0, `INPUT_HORSE_MELEE`) then
				ToggleCrouch()
			end
		end

		Citizen.Wait(0)
	end
end)
