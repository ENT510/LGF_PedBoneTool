local Utils = {
    StoredProps = {}
}

function Utils.createObjectAndAttach(data)
    local boneData = data.boneData
    local model = lib.requestModel(data.objectName)
    local ped = cache.ped
    local useAnim = data.dictName and data.animName and true or false
    local animDuration = data.animDuration and tonumber(data.animDuration) or 5000

    while not HasModelLoaded(model) do Wait(500) end

    local boneCoords = GetWorldPositionOfEntityBone(ped, boneData.index)

    local object = CreateObject(model, boneCoords.x, boneCoords.y, boneCoords.z, false, true, false)
    SetEntityAsMissionEntity(object, true, false)

    Utils.StoredProps[#Utils.StoredProps + 1] = object
    AttachEntityToEntity(
        object,
        ped,
        boneData.index,
        tonumber(data.offset.x), tonumber(data.offset.y), tonumber(data.offset.z),
        tonumber(data.rotation.x), tonumber(data.rotation.y), tonumber(data.rotation.z),
        true, true, false, true, 0, true
    )

    SetModelAsNoLongerNeeded(model)

    if useAnim then
        lib.requestAnimDict(data.dictName)
        while not HasAnimDictLoaded(data.dictName) do Wait(500) end

        local animFlag = animDuration == -1 and 1 or 2

        TaskPlayAnim(ped, data.dictName, data.animName, 8.0, -8.0, animDuration, animFlag, 0, false, false, false)

        if animDuration ~= -1 then
            Wait(animDuration)
            ClearPedTasks(ped)
            DeleteEntity(object)
        end

        RemoveAnimDict(data.dictName)
    end

    return object
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, object in ipairs(Utils.StoredProps) do
            DeleteEntity(object)
        end


        Utils.StoredProps = {}
    end
end)




return Utils
