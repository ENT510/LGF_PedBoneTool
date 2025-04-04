Shared = {}

function Shared.debug(type, ...)
    if type == "error" then
        error(..., 2)
    elseif type == "info" then
        print(...)
    elseif type == "warn" then
        warn(...)
    end
end

if IsDuplicityVersion() then
    lib.versionCheck('ENT510/LGF_UiPack')
end
