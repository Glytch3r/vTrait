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
local defaultSpeed = 1.04
local sOpt = SandboxVars.vTrait

vTrait.velocity = 0 

--[[ 
    local pl = getPlayer() 

    print(round(pl:getVariableFloat("WalkSpeed", 0)))
    print(round(pl:calculateBaseSpeed(), 2))
    pl:setVariableFloat("WalkSpeed", 1)
    print(round(pl:getVariableFloat("WalkSpeed", 0)))
    print(round(pl:calculateBaseSpeed(), 2))


 ]]
function vTrait.getSpeedLimiter(pl)
    pl = pl or getPlayer()
    local speedPeakDebuff = sOpt.vSpeedPeakDebuff
    local hungerLvl = pl:getMoodles():getMoodleLevel(MoodleType.Hungry)
    local normalized = hungerLvl / 4

    if sOpt.isSpeedHungerBonus then
        return 1 + normalized * (1 - speedPeakDebuff)
    else
        return math.max(speedPeakDebuff, 1 - normalized * (1 - speedPeakDebuff))
    end
end

function vTrait.getTargetSpeed(pl)
    pl = pl or getPlayer()
    if pl:isSneaking() or pl:isAiming() then return 0 end



    if pl:isSprinting() or pl:isRunning() then
        local sprintLevel = pl:getPerkLevel(Perks.Sprinting)
        local baseSpeed = defaultSpeed + (defaultSpeed * 2) + sOpt.vSpeedBonus * sprintLevel
        local speed = baseSpeed - vTrait.getSpeedLimiter(pl)
        return math.min(sOpt.vSpeedMax, math.max(sOpt.vSpeedMin, speed))
    end
    return 0
end
function vTrait.speedHandler(pl)
    pl = pl or getPlayer()
    pl:setVariable("isV", pl:HasTrait("V"))
    local targetSpeed = vTrait.getTargetSpeed(pl)
    if targetSpeed > vTrait.velocity then
        vTrait.velocity = math.min(targetSpeed, vTrait.velocity + sOpt.vSpeedAccelerationRate)
    elseif targetSpeed < vTrait.velocity then
        vTrait.velocity = math.max(0, vTrait.velocity - sOpt.vSpeedAccelerationRate*2)
    end
    pl:setVariable("vSpeed", vTrait.velocity)
    
end
Events.OnPlayerUpdate.Add(vTrait.speedHandler)

function vTrait.doMove(x, y)
    local pl = getPlayer()
    if not pl or not pl:isAlive() then return end

    if vTrait.isShouldBurn and vTrait.isShouldBurn(pl) and sOpt.PreventSpeed then return end
    local step = vTrait.velocity / 25
    step =  math.floor(step * 100) / 100

    if not vTrait.isBlocked(pl) then 

        --print(vTrait.velocity)
        pl:setX(pl:getX() + (step * x))
        pl:setY(pl:getY() + (step * y))

        if isClient() then
            pl:setLx(pl:getX() + (step * x))
            pl:setLy(pl:getY() + (step * y))
        end
    end
end

function vTrait.speedKey(key)
    local f = key == getCore():getKey("Forward")
    local b = key == getCore():getKey("Backward")
    local l = key == getCore():getKey("Left")
    local r = key == getCore():getKey("Right")
   
    if f or b or l or r then
        if f then
            vTrait.doMove(-1, -1)
        elseif b then
            vTrait.doMove(1, 1)
        elseif l then
            vTrait.doMove(-1, 1)
        elseif r then
            vTrait.doMove(1, -1)
        end

    end
    return key
end
Events.OnKeyKeepPressed.Add(vTrait.speedKey)


function vTrait.isBlocked(pl)
    pl = pl or getPlayer()
    if not pl then return end 
    local csq = pl:getCurrentSquare() 
    local adj = csq:getAdjacentSquare(pl:getDir());

    local blocked = adj:isBlockedTo(csq)
    return blocked
end
