local Client = {}
local Version = GetResourceMetadata("LGF_ToolBones", "version", 0)
local cachedCoords = {}
LocalPlayer.state.boneToolBusy = false
local isScreenBlurActive = false

local storedBones = {}
local loadedList = false

function Client.getAvailableBones()
    if not loadedList then
        storedBones = require "Data.bones"
        loadedList = true
    end

    return lib.table.deepclone(storedBones)
end

function Client.manageBlur(data)
    if data.Display and not isScreenBlurActive then
        TriggerScreenblurFadeIn(1000)
        isScreenBlurActive = true
    end

    if not data.Display and isScreenBlurActive then
        TriggerScreenblurFadeOut(1000)
        isScreenBlurActive = false
    end
end

function Client.openPanel(data)
    LocalPlayer.state.boneToolBusy = data.Display
    SetNuiFocus(data.Display, data.Display)

    SendNUIMessage({
        action = "showBonePanel",
        data = {
            Display = data.Display,
            BonesInfo = Client.getAvailableBones(),
            Version = Version
        }
    })

    Client.manageBlur(data)
    cachedCoords = GetEntityCoords(cache.ped)
end

RegisterCommand("bone", function()
    if not LocalPlayer.state.boneToolBusy then
        Client.openPanel({
            Display = true
        })
    else
        Client.openPanel({
            Display = false
        })
    end
end)


RegisterNUICallback("LGF_BonesTool.NUI.copyInfo", function(data, cb)
    local info = data and data or {}
    lib.setClipboard(info)
    cb("ok")
end)


RegisterNUICallback("LGF_BonesTool.NUI.closePanel", function(data, cb)
    Client.openPanel({
        Display = false
    })
    cb("ok")
end)


RegisterNUICallback("LGF_BonesTool.NUI.attachBone", function(data, cb)
    local Utils = require "modules.client.cl-utils"
    local sourceCoords = GetEntityCoords(cache.ped)
    if #(sourceCoords - cachedCoords) > 5.0 then return cb(false) end
    Utils.createObjectAndAttach(data)
    cb("ok")
end)



AddEventHandler('gameEventTriggered', function(event, data)
    if event ~= 'CEventNetworkEntityDamage' then
        return
    end

    local victimPed = data[1]
    local killerPed = data[2]
    local victimDied = data[4]
    local weaponUsed = data[7]

    local victimID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victimPed))
    local killerID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killerPed))


    if not IsPedAPlayer(victimPed) then return end
    local found, boneHit = GetPedLastDamageBone(victimPed)

    if found and Client.getAvailableBones()[boneHit] then
        local boneData = Client.getAvailableBones()[boneHit]
        local data = {
            boneName = boneData.name,
            boneId = boneData.id,
            boneIndex = boneData.index,
            killerId = killerID,
            victimId = victimID,
        }

        TriggerEvent("LGF_ToolBones:onBoneHit", data)

        SendNUIMessage({
            action = "sendLogHit",
            data = data
        })
    end
end)

exports("getAvailableBones", Client.getAvailableBones)


exports("isBoneToolBusy", function()
    return LocalPlayer.state.boneToolBusy
end)


return Client
