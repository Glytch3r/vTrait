--▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲--
--        ▄▄▄  ▄   ▄   ▄ ▄▄▄▄▄  ▄▄▄  ▄   ▄  ▄▄▄   ▄▄▄        --
--       █   ▀ █   █▄▄▄█   █   █   ▀ █▄▄▄█ ▀  ▄█ █ ▄▄▀       --
--       █  ▀█ █     █     █   █   ▄ █   █ ▄   █ █   █       --
--        ▀▀▀▀ ▀▀▀▀  ▀     ▀    ▀▀▀  ▀   ▀  ▀▀▀  ▀   ▀       --
--□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□--
--╣    Custom  Project Zomboid  Mod  Developer  for  Hire   ╠--
--╣ https://steamcommunity.com/id/glytch3r/myworkshopfiles/ ╠--
--╣                                                         ╠--
--╣   ► Discord: glytch3r                                   ╠--
--╣   ► Support: https://ko-fi.com/glytch3r                 ╠--
--╣   ► Youtube: https://www.youtube.com/@glytch3r          ╠--
--╣                                                         ╠--
--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬--

------▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬------


vTrait = vTrait or {}

function vTrait.getLimiter()
    local pl = getPlayer()
    local hungerLvl = pl:getMoodles():getMoodleLevel(MoodleType.Hungry)
    local peak = SandboxVars.vTrait.RecoveryPeakDebuff ~= nil and SandboxVars.vTrait.RecoveryPeakDebuff or 0.2
    local isHungerBonus = SandboxVars.vTrait.isHealHungerBonus ~= nil and SandboxVars.vTrait.isHealHungerBonus or false
    local normalized = hungerLvl / 4

    if isHungerBonus then
        return 1 + normalized * (1 - peak)
    else
        return math.max(peak, 1 - normalized * (1 - peak))
    end
end

function vTrait.getInjuryRecoveryRate()
    local rMin = SandboxVars.vTrait.RecoverRateMin ~= nil and SandboxVars.vTrait.RecoverRateMin or 0.0005
    local rMax = SandboxVars.vTrait.RecoverRateMax ~= nil and SandboxVars.vTrait.RecoverRateMax or 0.01
    local roll = ZombRand(rMin, rMax)
    return roll * vTrait.getLimiter()
end

function vTrait.getHealthRecoveryRate()
    local rate = SandboxVars.vTrait.HealthRecoveryRate ~= nil and SandboxVars.vTrait.HealthRecoveryRate or 0.004
    local roll = ZombRand(0, rate)
    return math.min(100, math.max(0, roll * vTrait.getLimiter()))
end

function vTrait.applyHeal(pl, bp)
    if not pl:HasTrait("V") then return end
    
    local healRate = vTrait.getInjuryRecoveryRate()

    if bp:getScratchTime() > 0 then
        bp:setScratchTime(math.max(0, bp:getScratchTime() - healRate))
    end
    if bp:getCutTime() > 0 then
        bp:setCutTime(math.max(0, bp:getCutTime() - healRate))
    end
    if bp:getBiteTime() > 0 then
        bp:setBiteTime(math.max(0, bp:getBiteTime() - healRate))
    end
    if bp:getDeepWoundTime() > 0 then
        bp:setDeepWoundTime(math.max(0, bp:getDeepWoundTime() - healRate))
    end
    if bp:getFractureTime() > 0 then
        bp:setFractureTime(math.max(0, bp:getFractureTime() - healRate))
    end
    if bp:getStiffness() > 0 then
        bp:setStiffness(math.max(0, bp:getStiffness() - healRate))
    end
    pl:AddGeneralHealth(vTrait.getHealthRecoveryRate())
    
end

function vTrait.RecoveryHandler(pl, dmgType, dmg)
    pl = pl or getPlayer()
    if not pl or not pl:HasTrait("V") then return end

    local bd = pl:getBodyDamage()
    for i = 0, BodyPartType.ToIndex(BodyPartType.MAX) - 1 do
        local bp = bd:getBodyPart(BodyPartType.FromIndex(i))
        vTrait.applyHeal(pl, bp)
    end
end
Events.OnPlayerGetDamage.Add(vTrait.RecoveryHandler)
Events.EveryTenMinutes.Add(vTrait.RecoveryHandler)


