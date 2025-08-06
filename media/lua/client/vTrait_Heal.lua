--▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲--
--        ▄▄▄  ▄    ▄   ▄ ▄▄▄▄▄  ▄▄▄  ▄   ▄  ▄▄▄   ▄▄▄       --
--       █   ▀ █    █▄▄▄█   █   █   ▀ █▄▄▄█ ▀  ▄█ █ ▄▄▀      --
--       █  ▀█ █      █     █   █   ▄ █   █ ▄   █ █   █      --
--        ▀▀▀▀ ▀▀▀▀   ▀     ▀    ▀▀▀  ▀   ▀  ▀▀▀  ▀   ▀      --
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

------▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬------



function vTrait.hasAnyInjury(pl)
    pl = pl or getPlayer()
    local bodyParts = pl:getBodyDamage():getBodyParts()
    for i = 0, bodyParts:size() - 1 do
        local bp = bodyParts:get(i)
        if bp:HasInjury()
            or bp:bandaged()
            or bp:stitched()
            or bp:getSplintFactor() > 0
            or bp:getAdditionalPain() > 10
            or bp:getStiffness() > 5 then
            return true
        end
    end
    return false
end

function vTrait.doRoll(percent)
    if percent <= 0 then return false end
    if percent >= 100 then return true end
    return percent >= ZombRand(1, 101)
end

function vTrait.collectHealable(pl)
    local healable = {}
    local bodyParts = pl:getBodyDamage():getBodyParts()

    for i = 0, bodyParts:size() - 1 do
        local part = bodyParts:get(i)

        if part:getScratchTime() > 0 then
            table.insert(healable, { part = part, label = "Scratched", func = function(p)
                p:setScratched(false, true)
                p:setScratchTime(0)
            end })
        end

        if part:isCut() then
            table.insert(healable, { part = part, label = "Cut", func = function(p)
                p:setCut(false)
                p:setCutTime(0)
            end })
        end

        if part:isDeepWounded() and part:getDeepWoundTime() > 0 then
            table.insert(healable, { part = part, label = "DeepWounded", func = function(p)
                p:setDeepWoundTime(0)
                p:setDeepWounded(false)
                p:setBleedingTime(0)
            end })
        end

        if part:bitten() then
            table.insert(healable, { part = part, label = "Bitten", func = function(p)
                p:setBitten(false)
                if SandboxVars.vTrait.CureInfection then
                    p:setInfected(false)
                    p:setFakeInfected(false)
                end
            end })
        end

        if part:bleeding() then
            table.insert(healable, { part = part, label = "Bleeding", func = function(p)
                p:setBleedingTime(0)
            end })
        end

        if part:isInfectedWound() then
            table.insert(healable, { part = part, label = "InfectedWound", func = function(p)
                p:setWoundInfectionLevel(-1)
            end })
        end

        if part:haveBullet() then
            table.insert(healable, { part = part, label = "Bullet", func = function(p)
                local deep = p:isDeepWounded()
                local dtime = p:getDeepWoundTime()
                local btime = p:getBleedingTime()
                p:setDeepWoundTime(dtime)
                p:setDeepWounded(deep)
                p:setBleedingTime(btime)
                p:setHaveBullet(false, 0)
            end })
        end

        if part:haveGlass() then
            table.insert(healable, { part = part, label = "Have Glass", func = function(p)
                local deep = p:isDeepWounded()
                local dtime = p:getDeepWoundTime()
                local btime = p:getBleedingTime()
                p:setHaveGlass(false)
                p:setDeepWoundTime(dtime)
                p:setDeepWounded(deep)
                p:setBleedingTime(btime)
            end })
        end

        if part:getFractureTime() > 0 then
            table.insert(healable, { part = part, label = "Fracture", func = function(p)
                p:setFractureTime(0)
            end })
        end

        if part:getBurnTime() > 0 then
            table.insert(healable, { part = part, label = "Burn", func = function(p)
                p:setNeedBurnWash(false)
                p:setBurnTime(0)
            end })
        end
    end

    return healable
end

function vTrait.HealRandPart()
    local pl = getPlayer()
    if not pl:HasTrait("V") then return end

    while vTrait.doRoll(SandboxVars.vTrait.InjuryHealChance) do
        local healable = vTrait.collectHealable(pl)

        if #healable > 0 then
            local injury = healable[ZombRand(#healable) + 1]
            injury.func(injury.part)

            if SandboxVars.vTrait.InjuryHealOverheadMessage == true then
                local msg = string.format("[vTrait] Healed %s on %s", injury.label, tostring(injury.part:getType()))
                pl:addLineChatElement(msg)
            end
        else
            local bd = pl:getBodyDamage()
            local currentHp = bd:getOverallBodyHealth()
            local healAmount = SandboxVars.vTrait.HPRestoreAmount or 1 
            bd:setOverallBodyHealth(math.min(100, currentHp + healAmount))

            if SandboxVars.vTrait.InjuryHealOverheadMessage == true then
                pl:addLineChatElement("[vTrait] Restored Health +" .. tostring(healAmount))
            end
        end

        if not vTrait.hasAnyInjury(pl) and pl:getBodyDamage():getOverallBodyHealth() >= 100 then
            break
        end
    end

    return true
end

Events.EveryTenMinutes.Add(vTrait.HealRandPart)
