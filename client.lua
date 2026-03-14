local JerrycanAnimLoaded = false
local LoopThread = false

-- mythic-inventory fires 'Weapons:Client:SwitchedWeapon' instead of ox_inventory:currentWeapon
-- Args: weaponName (string | false), item (table | nil), itemData (table | nil)
AddEventHandler('Weapons:Client:SwitchedWeapon', function(weaponName, item, itemData)
    local ped = PlayerPedId()
    -- weaponName is false when the player unequips; otherwise it's an uppercase string e.g. "WEAPON_PISTOL"
    local CurrentWeapon = weaponName and Config.AnimWeapons[weaponName]

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
