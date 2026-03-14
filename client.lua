local JerrycanAnimLoaded = false
local LoopThread = false

local function ResolveWeaponConfig(weaponName, itemData)
    if not weaponName then return nil end

    local cfg = Config.AnimWeapons[weaponName]
    if cfg then return cfg end

    if itemData and itemData.weapon and itemData.weapon ~= weaponName then
        cfg = Config.AnimWeapons[itemData.weapon]
        if cfg then return cfg end
    end

    return nil
end

AddEventHandler('Weapons:Client:SwitchedWeapon', function(weaponName, item, itemData)
    local ped = PlayerPedId()
    local CurrentWeapon = ResolveWeaponConfig(weaponName, itemData)

    if CurrentWeapon and CurrentWeapon.enabled then
        if not JerrycanAnimLoaded then
            RequestClipSet("move_ped_wpn_jerrycan_generic")
            RequestClipSet("move_m@prison_gaurd")

            while not HasClipSetLoaded("move_ped_wpn_jerrycan_generic") or not HasClipSetLoaded("move_m@prison_gaurd") do
                Wait(0)
            end
            JerrycanAnimLoaded = true
        end

        if CurrentWeapon.twoHanded then
            if not LoopThread then
                LoopThread = true
                CreateThread(function()
                    while LoopThread do
                        if GetEntitySpeed(ped) < 2.5 then
                            SetPedWeaponMovementClipset(ped, "move_m@prison_gaurd", 1.50)
                        else
                            SetPedWeaponMovementClipset(ped, "move_ped_wpn_jerrycan_generic", 1.50)
                        end
                        Wait(100)
                    end
                end)
            end
        else
            SetPedWeaponMovementClipset(ped, "move_ped_wpn_jerrycan_generic", 0.50)
            LoopThread = false
        end
    else
        LoopThread = false
        ResetPedWeaponMovementClipset(ped, 0.0)
    end
end)
