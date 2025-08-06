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

vTrait = vTrait or {}

function vTrait.hasAnyInjury(pl)
    pl = pl or getPlayer()
    local bodyParts = pl:getBodyDamage():getBodyParts()
    local check = false
    for i = 1, bodyParts:size() do
        local bp = bodyParts:get(i - 1)
        if bp:HasInjury() 
            or bp:bandaged() 
            or bp:stitched() 
            or bp:getSplintFactor() > 0 
            or bp:getAdditionalPain() > 10 
            or bp:getStiffness() > 5 then
            check = true
            break
        end
    end
    local isShowCap = SandboxVars.vTrait.InjuryHealOverheadMessage
    if not check then 
        if isShowCap then  pl:addLineChatElement("No Injuries") end
    end
    return check
end

function vTrait.doRoll(percent)
	if percent <= 0 then return false end
	if percent >= 100 then return true end
	return percent >= ZombRand(1, 101)
end

function vTrait.HealRandPart()
    local pl = getPlayer()
    if not pl:HasTrait("V") then return end
    if not vTrait.hasAnyInjury(pl) then return end

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
                p:SetBitten(false)
                if SandboxVars.vTrait.CureInfection then
                    p:SetInfected(false)
                    p:SetFakeInfected(false)
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
                p:setWoundInfectionLevel(0)
            end })
        end

        if part:haveBullet() then
            table.insert(healable, { part = part, label = "Bullet", func = function(p)
                p:setHaveBullet(false, 0)
            end })
        end

        if part:haveGlass() then
            table.insert(healable, { part = part, label = "Glass", func = function(p)
                p:setHaveGlass(false, 0)
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

    local isShowAlert = SandboxVars.vTrait.InjuryHealOverheadMessage ~= false
    if #healable == 0 then return false end

    local injury = healable[ZombRand(#healable) + 1]
    injury.func(injury.part)

    if isShowAlert then
        local msg = string.format("[vTrait] Healed %s on %s", injury.label, tostring(injury.part:getType()))
        print(msg)
        pl:addLineChatElement(msg)
    end

    return true
end

Events.EveryHours.Add(vTrait.HealRandPart)
