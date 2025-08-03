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


function vTrait.getSpeedLimiter(pl)
    pl = pl or getPlayer()
    local speedPeakDebuff = SandboxVars.vTrait.speedPeakDebuff

    local hungerLvl = pl:getMoodles():getMoodleLevel(MoodleType.Hungry)
    local normalized = hungerLvl / 4
    if SandboxVars.vTrait.isSpeedHungerBonus then

        return 1 + normalized * (1 - speedPeakDebuff)
    else
        return math.max(speedPeakDebuff, 1 - normalized * (1 - speedPeakDebuff))
    end
end

function vTrait.getVSpeed(pl)
    pl = pl or getPlayer()
    local res = 0
    if pl:isSneaking() or pl:isAiming() then return 0 end
    if pl:isSprinting() or pl:isRunning() then 
        local sprintLevel = pl:getPerkLevel(Perks.Sprinting)
        local baseSpeed = defaultSpeed +(defaultSpeed*2)  + SandboxVars.vTrait.speedBonus * sprintLevel
        local speed = baseSpeed --* vTrait.getSpeedLimiter(pl)
        res = math.min(SandboxVars.vTrait.speedMax, math.max(SandboxVars.vTrait.speedMin, speed))
    end
    return res
end


function vTrait.speedHandler(pl)
    pl = pl or getPlayer()
    if pl:HasTrait("V") then
        pl:setVariable("isV", true)
        pl:setVariable("vSpeed", vTrait.getVSpeed(pl))
    else
        pl:setVariable("isV", false)
    end
end
Events.OnPlayerUpdate.Add(vTrait.speedHandler)

function vTrait.doMove(x, y)
    local pl = getPlayer() 
    if not pl or not pl:isAlive() then return end

    local isShouldBurn = vTrait.isShouldBurn(pl) and SandboxVars.vTrait.PreventSpeed
    if isShouldBurn then return end

    local vSpeed = vTrait.getVSpeed(pl) / 50
    --local dot = pl:getDotWithForwardDirection(pl:getX(), pl:getY())

    pl:setX(pl:getX() + (vSpeed*x))
    pl:setY(pl:getY() + (vSpeed*y))

    if isClient() then
        pl:setLx(pl:getX() + (vSpeed*x))
        pl:setLy(pl:getY() + (vSpeed*y))
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
