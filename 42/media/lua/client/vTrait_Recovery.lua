vTrait = vTrait or {}

function vTrait.getLimiter(pl)
    pl = pl or getPlayer()
    if not pl then return end 
    local hungerLvl = pl:getMoodles():getMoodleLevel(MoodleType.Hungry)
    local peak = SandboxVars.vTrait.RecoveryPeakDebuff or 0.2
    local isHungerBonus = SandboxVars.vTrait.isHealHungerBonus or false
    local normalized = hungerLvl / 4
    if isHungerBonus then
        return 1 + normalized * (1 - peak)
    else
        return math.max(peak, 1 - normalized * (1 - peak))
    end
end

function vTrait.getInjuryRecoveryRate(pl)
    pl = pl or getPlayer()
    local rec = SandboxVars.vTrait.RecoverRate or 5
    return rec * vTrait.getLimiter(pl)
end

function vTrait.getHealthRecoveryRate(pl)
    pl = pl or getPlayer()
    if not pl then return end 
    local isBurning = vTrait.isShouldBurn(pl)
    local rec = SandboxVars.vTrait.HealthRecoveryRate or 10
    if isBurning then
        rec = rec / 2
    end
    return rec * vTrait.getLimiter()
end

function vTrait.vRecovery()
    local pl = getPlayer()
    if not pl or not pl:HasTrait("V") then return end
    
    local bd = pl:getBodyDamage()
    local healRate = vTrait.getInjuryRecoveryRate(pl)
    local hpRate = vTrait.getHealthRecoveryRate(pl)

    bd:setFoodSicknessLevel(0)
    bd:setPoisonLevel(0)
    local isBurning = vTrait.isShouldBurn(pl)
    local healedMap = {}

    for i = 0, BodyPartType.ToIndex(BodyPartType.MAX) - 1 do
        local bp = bd:getBodyPart(BodyPartType.FromIndex(i))
        local bpName = tostring(BodyPartType.FromIndex(i))
        local healed = {}

        if bp:getScratchTime() > 0 then
            bp:setScratchTime(math.max(0, bp:getScratchTime() - healRate))
        end
        if bp:getScratchTime() <= 0 and bp:scratched() then
            bp:setScratched(false, true)
            table.insert(healed, "Scratch")
        end

        if bp:getCutTime() > 0 then
            bp:setCutTime(math.max(0, bp:getCutTime() - healRate))
        end
        if bp:getCutTime() <= 0 and bp:isCut() then
            bp:setCut(false, true)
            table.insert(healed, "Cut")
        end

        if bp:getBiteTime() > 0 then
            bp:setBiteTime(math.max(0, bp:getBiteTime() - healRate))
        end
        if bp:getBiteTime() <= 0 and bp:bitten() then
            bp:SetBitten(false)
            table.insert(healed, "Bite")
        end

        if bp:getDeepWoundTime() > 0 then
            bp:setDeepWoundTime(math.max(0, bp:getDeepWoundTime() - healRate))
        end
        if bp:getDeepWoundTime() <= 0 and bp:isDeepWounded() then
            bp:setDeepWounded(false)
            table.insert(healed, "DeepWound")
        end

        if bp:getBleedingTime() > 0 then
            bp:setBleedingTime(math.max(0, bp:getBleedingTime() - healRate))
        end
        if bp:getBleedingTime() <= 0 and bp:bleeding() then
            bp:setBleeding(false)
            table.insert(healed, "Bleed")
        end

        if bp:isInfectedWound() then
            bp:setWoundInfectionLevel(-1)
            table.insert(healed, "WoundInfection")
        end

        if bp:getFractureTime() > 0 then
            bp:setFractureTime(math.max(0, bp:getFractureTime() - healRate))
            table.insert(healed, "Fracture")
        end

        if bp:getBurnTime() > 0 then
            bp:setBurnTime(math.max(0, bp:getBurnTime() - healRate))
        end
        if bp:getBurnTime() <= 0 and bp:isBurnt() then
            bp:setNeedBurnWash(false)
            table.insert(healed, "Burn")
        end

        if bp:haveBullet() then
            bp:setHaveBullet(false, 10)
            table.insert(healed, "Bullet")
        end

        if bp:haveGlass() then
            bp:setHaveGlass(false)
            table.insert(healed, "Glass")
        end

        if bp:getStiffness() > 0 then
            bp:setStiffness(math.max(0, bp:getStiffness() - healRate))
            table.insert(healed, "Stiffness")
        end

        if bp:getAdditionalPain() > 0 then
            bp:setAdditionalPain(math.max(0, bp:getAdditionalPain() - healRate))
            table.insert(healed, "Pain")
        end

        if bp:IsInfected() then
            if SandboxVars.vTrait.CureInfection then
                bp:setInfected(false)
                table.insert(healed, "Infection")
            end
        end

        if bp:IsFakeInfected() then
            bp:SetFakeInfected(false)
            table.insert(healed, "FakeInfection")
        end

        if #healed > 0 then
            healedMap[bpName] = table.concat(healed, ", ")
        end
    end

    local healedPartCount = 0
    for _ in pairs(healedMap) do
        healedPartCount = healedPartCount + 1
    end
    if healedPartCount > 0 then
        bd:AddGeneralHealth(hpRate * healedPartCount)
    end

    local hasHealed = false
    for _ in pairs(healedMap) do
        hasHealed = true
        break
    end
    if hasHealed then
        local out = {}
        for k, v in pairs(healedMap) do
            table.insert(out, k .. ": " .. v)
        end
        if SandboxVars.vTrait.InjuryHealOverheadMessage  then
            local msg = table.concat(out, "\n")
            HaloTextHelper.addTextWithArrow(pl, (tostring(msg)), true, HaloTextHelper.getColorGreen())
            print(msg)
        end
    end

    if healedPartCount == 0 then
        bd:AddGeneralHealth(hpRate)
    end
 
end
Events.EveryOneMinute.Add(vTrait.vRecovery)

function vTrait.hasAnyInjury(pl)
    pl = pl or getPlayer()
    local bodyParts = pl:getBodyDamage():getBodyParts()
    for i = 0, bodyParts:size() - 1 do
        local bp = bodyParts:get(i)
        if bp:HasInjury()
        or bp:isDeepWounded()
        or bp:bitten()
        or bp:isCut()
        or bp:bleeding()
        or bp:isInfectedWound()
        or bp:IsInfected()
        or bp:IsFakeInfected()
        or bp:getScratchTime() > 0
        or bp:getCutTime() > 0
        or bp:getBiteTime() > 0
        or bp:getFractureTime() > 0
        or bp:getBurnTime() > 0
        or bp:haveBullet()
        or bp:haveGlass()
        or bp:getAdditionalPain() > 10
        or bp:getStiffness() > 5 then
            return true
        end
    end
    return false
end
