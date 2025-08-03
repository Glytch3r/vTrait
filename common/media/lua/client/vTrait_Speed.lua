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
        if hasTrait then 
            if pl:getVariableBoolean('isV') ~= hasTrait then pl:setVariable('isV', hasTrait) end	
            pl:setVariable("vSpeed", vTrait.getVSpeed(pl))    
        end
        ticks = 0
    end
end
Events.OnPlayerUpdate.Add(vTrait.speedHandler)