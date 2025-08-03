

  --[[ ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
  ╣ □□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□ ╠  
  ╣                  Custom  PZ  Mod  Developer  for  Hire                     ╠  
  ╣ ◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦╠  
  ╣    ► Discord:   glytch3r                                                   ╠   
  ╣    ► Portfolio: https://steamcommunity.com/id/glytch3r/myworkshopfiles/    ╠  
  ╣    ► Support:   https://ko-fi.com/glytch3r                                 ╠  
  ╣    ► Youtube:   https://www.youtube.com/@glytch3r                          ╠  
    ╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳ --]] 

--[[■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
░░▓██████▓░░░░▓█▓░░░░▓█▓░░░░▓█▓░░▓███████▓░░░▓██████▓░░░░▓█▓░░░░░▓█▓░░░▓███████▓░░░▓███████▓░░
░▓█▓░░░░▓█▓░░░▓█▓░░░░▓█▓░░░░▓█▓░░░░░▓█▓░░░░░▓█▓░░░░▓█▓░░░▓█▓░░░░░▓█▓░░▓█░░░░░░▓█▓░░▓█░░░░░░▓█░
░▓█▓░░░░░░░░░░▓█▓░░░░▓█▓░░░░▓█▓░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█▓░░▓█░░░░░░▓█░
░▓█▓░░▓███▓░░░▓█▓░░░░░▓██████▓░░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█████████▓░░░░░░▓███▓░░░░▓███████▓░░
░▓█▓░░░░▓█▓░░░▓█▓░░░░░░░▓█▓░░░░░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█▓░░▓█▓░░░░░█▓░
░▓█▓░░░░▓█▓░░░▓█▓░░░░░░░▓█▓░░░░░░░░░▓█▓░░░░░▓█▓░░░░▓█▓░░░▓█▓░░░░░▓█▓░░▓█░░░░░░▓█▓░░▓█▓░░░░░██░
░░▓██████▓░░░░▓██████░░░▓█▓░░░░░░░░░▓█▓░░░░░░▓██████▓░░░░▓█▓░░░░░▓█▓░░░▓███████▓░░░▓█▓░░░░░██░
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■--]]


vTrait = vTrait or {}

function vTrait.getHitRecoveryPercent(dmg)
    local dmgPercent = SandboxVars.vTrait.HitRecoveryPercent or 30
    local factor = dmgPercent / 100           
    local roll = ZombRand(0, math.floor(dmg * factor) + 1)
    return math.min(100, math.max(0, roll))
end


function vTrait.defense(pl, dmgType, dmg)
	pl = pl or getPlayer()
	if tostring(dmgType) == "WEAPONHIT" and pl == getPlayer() and  pl:HasTrait("V")  then
		local chance = SandboxVars.vTrait.HitRecoverChance or 25
		if vTrait.doRoll(chance) then			
			pl:AddGeneralHealth(vTrait.getHitRecoveryPercent(dmg))
		end
	end
end
Events.OnPlayerGetDamage.Add(vTrait.defense)



--[[ 
function vTrait.isUnarmed(pl)
	pl = pl or getPlayer()
    return tostring(WeaponType.getWeaponType(pl)) == "barehand"
end

function vTrait.hitZed(zed, attacker, bodyPart, wpn)
    if attacker and zed and instanceof(attacker, "IsoPlayer") and attacker:HasTrait("V") and vTrait.isUnarmed(attacker) and not vTrait.isTargOnFloor(zed) then
		local hp = zed:getHealth()
        local dmg = ZombRand(0, hp)
        vTrait.recover(attacker, 0.8)
        zed:setHealth(hp - dmg)
        zed:update()
		zed:setVariable('vHit', true)
    end
end
Events.OnHitZombie.Add(vTrait.hitZed)
 ]]

--[[ 
function vTrait.isTargOnFloor(targ)
	if tostring(targ:getCurrentStateName()) == "ZombieOnGroundState" then return true end
	if targ:isBeingSteppedOn() then return true end
	if targ:isCanWalk() then return true end
	if targ:isFakeDead() then return true end
	if targ:isForceEatingAnimation() then return true end
	if targ:isOnFloor() then return true end
	if targ:isCrawling() then return true end
	if targ:isUseless() then return true end
	if targ:isSitAgainstWall() then return true end
	if targ:isUnderVehicle() then return true end
	return false
end
 ]]
--[[ 
function vTrait.hitTarg(attacker, targ, wpn, dmg)
    local pl = getPlayer()

    if attacker and targ and instanceof(attacker, "IsoPlayer") and attacker:HasTrait("V") then
        if vTrait.isUnarmed(attacker) and not vTrait.isTargOnFloor(targ) then
            local roll = vTrait.doRoll()

            if isDebugEnabled() then
                print(tostring(roll))
                targ:addLineChatElement(tostring(roll))
            end

            if attacker == pl and isClient() and instanceof(targ, "IsoPlayer") then
				vTrait.recover(attacker, 1)
                local targID = targ:getOnlineID()
                if targID then
                    sendClientCommand("vTrait", "doBite", {targID = targID, roll = roll})
                end
            end
        end
    end
end
Events.OnWeaponHitCharacter.Add(vTrait.hitTarg)
 ]]

--[[ 
function vTrait.doTurnV(targ)
	if targ and not targ:HasTrait("V") then
		targ:getTraits():add("V")
		sendPlayerStatsChange(targ)
		SyncXp(targ)
	end
end
 ]]
--[[ 
function vTrait.bite(targ, roll)
	if targ and not targ:HasTrait("V") then
		local roll = roll or vTrait.doRoll()
		if roll then
			vTrait.doTurnV(targ)
		else
			if not targ:isGodMod() then
				local bodyDmg = targ:getBodyDamage()
				local bodyPart = bodyDmg:getBodyPart(BodyPartType.Neck)
				bodyPart:setBleedingTime((bodyPart:getBleedingTime() > 0) and 0 or 100)
				targ:addBlood(BloodBodyPartType.Neck, true, true, false)
				local x, y, z = round(targ:getX()),  round(targ:getY()),  round(targ:getZ())
				addBloodSplat(getCell():getGridSquare(x, y, z), 20);
			end
		end
	end
end
 ]]
--[[◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙
░░▓██████▓░░░░▓██████░░░▓█▓░░░░░░░░░▓█▓░░░░░░▓██████▓░░░░▓█▓░░░░░▓█▓░░░▓███████▓░░░▓█▓░░░░░██░
░▓█▓░░░░▓█▓░░░▓█▓░░░░░░░▓█▓░░░░░░░░░▓█▓░░░░░▓█▓░░░░▓█▓░░░▓█▓░░░░░▓█▓░░▓█░░░░░░▓█▓░░▓█▓░░░░░██░
░▓█▓░░░░▓█▓░░░▓█▓░░░░░░░▓█▓░░░░░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█▓░░▓█▓░░░░░█▓░
░▓█▓░░▓███▓░░░▓█▓░░░░░▓██████▓░░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█████████▓░░░░░░▓███▓░░░░▓███████▓░░
░▓█▓░░░░░░░░░░▓█▓░░░░▓█▓░░░░▓█▓░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█▓░░░░░▓█▓░░░░░░░░░░▓█▓░░▓█░░░░░░▓█░
░▓█▓░░░░▓█▓░░░▓█▓░░░░▓█▓░░░░▓█▓░░░░░▓█▓░░░░░▓█▓░░░░▓█▓░░░▓█▓░░░░░▓█▓░░▓█░░░░░░▓█▓░░▓█░░░░░░▓█░
░░▓██████▓░░░░▓█▓░░░░▓█▓░░░░▓█▓░░▓███████▓░░░▓██████▓░░░░▓█▓░░░░░▓█▓░░░▓███████▓░░░▓███████▓░░
◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙--]]

--[[
function vTrait.isUnarmed(targ)
	local isUnarmed = tostring(WeaponType.getWeaponType(targ)) == "barehand"
	return isUnarmed
end


function vTrait.hit(attacker, targ, wpn, dmg)
	local pl = getPlayer()
	if attacker and targ then
		if vTrait.isUnarmed(attacker) and instanceof(attacker, "IsoPlayer") and attacker:HasTrait("V") and instanceof(targ, "IsoPlayer")  then
			local roll = vTrait.doRoll()

			if isDebugEnabled() then
				print(roll)
			end

			if attacker == pl then
				if isClient() then
					local targID = targ:getOnlineID()
					if targID then
						sendClientCommand("vTrait", "doBite", {targID = targID, roll = roll})
					end
				end
			end
		end
	end
end
Events.WeaponHitCharacter.Add(vTrait.hit)
 ]]




