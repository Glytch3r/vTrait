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
local defaultSpeed = 1.04




function vTrait.getSpeedLimiter(pl)
    pl = pl or getPlayer()
    local hungerLvl = pl:getMoodles():getMoodleLevel(MoodleType.Hungry)
    local peak = SandboxVars.vTrait.vSpeedPeakDebuff ~= nil and SandboxVars.vTrait.vSpeedPeakDebuff or 0.2
    local isHungerBonus = SandboxVars.vTrait.isSpeedHungerBonus ~= nil and SandboxVars.vTrait.isSpeedHungerBonus or false

    local normalized = hungerLvl / 4

    if isHungerBonus then
        return 1 + normalized * (1 - peak)
    else
        local limiter = 1 - normalized * (1 - peak)
        return math.max(peak, limiter)
    end
end

function vTrait.getVSpeed(pl)
    pl = pl or getPlayer()
    if not pl:isMoving() then return 0 end
    if (pl:isSneaking() or pl:isAiming()) then return 0 end
    if not (pl:isSprinting() or pl:isRunning()) then return 0 end

    local minSpeed = SandboxVars.vTrait.vSpeedMin ~= nil and SandboxVars.vTrait.vSpeedMin or 1.04
    local maxSpeed = SandboxVars.vTrait.vSpeedMax ~= nil and SandboxVars.vTrait.vSpeedMax or 3
    local bonus = SandboxVars.vTrait.vSpeedBonus ~= nil and SandboxVars.vTrait.vSpeedBonus or 0.15
    local sprintLevel = pl:getPerkLevel(Perks.Sprinting)
    local limiter = vTrait.getSpeedLimiter(pl)

    local baseSpeed = defaultSpeed + (bonus * sprintLevel)
    local speed = baseSpeed * limiter

    return math.min(maxSpeed, math.max(minSpeed, speed))
end

local ticks = 0
function vTrait.speedHandler(pl)
    ticks = ticks + 1
    if ticks % 250 == 0 then
        local hasTrait =  pl:HasTrait("V")
        if hasTrait ~= nil then 
            if pl:getVariableBoolean('isV') ~= hasTrait then pl:setVariable('isV', hasTrait) end	
            pl:setVariable("vSpeed", vTrait.getVSpeed(pl))    
        end
        ticks = 0
    end
end
Events.OnPlayerUpdate.Add(vTrait.speedHandler)
-----------------------            ---------------------------



function vTrait.doMove( x, y)    
    local pl = getPlayer(); 
    if not pl or not pl:isAlive() then return end     
    if vTrait.isShouldBurn(pl) then return end     
    pl:setForwardDirection(x, y)
    --pl:getForwardDirection():set(x, y)
    local vSpeed = vTrait.getVSpeed(pl)
    local step = math.min(1, math.max(-1, vSpeed/5))
    local xPos = pl:getX()
    local yPos = pl:getY()    
    pl:setX(xPos+step*x)
    pl:setY(yPos+step*y)
    pl:setLx(xPos+step*x)
    pl:setLy(yPos+step*y)
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
end
Events.OnKeyKeepPressed.Add(vTrait.speedKey)

