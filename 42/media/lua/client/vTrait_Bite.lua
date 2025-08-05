

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

function vTrait.isUnarmed(pl)
	pl = pl or getPlayer()
    return tostring(WeaponType.getWeaponType(pl)) == "barehand"
end

--[[ 
function vTrait.attack(pl, chargeDelta, wpn)
end
Hook.Attack.Add(vTrait.attack)
 ]]

function vTrait.click()
	local pl = getPlayer() 
	if not pl then return end
	if pl:HasTrait("V") and vTrait.isUnarmed(pl) then
		local sq = pl:getSquare():getAdjacentSquare(pl:getDir());
		if sq then
			local zed = sq:getZombie()
			if zed and not vTrait.isTargOnFloor(zed) then			
				pl:setInitiateAttack(false)
				pl:setDoShove(true)
				ISTimedActionQueue.add(vTrait_BiteAction:new(pl, sq, zed, -1))
			end
		end
	end
end
Events.OnMouseUp.Add(vTrait.click)

function vTrait.isTargOnFloor(zed)
	if tostring(zed:getCurrentStateName()) == "ZombieOnGroundState" then return true end
	if zed:isBeingSteppedOn() then return true end
	if zed:isCanWalk() then return true end
	if zed:isFakeDead() then return true end
	if zed:isForceEatingAnimation() then return true end
	if zed:isOnFloor() then return true end
	if zed:isCrawling() then return true end
	if zed:isSitAgainstWall() then return true end
	if zed:isUnderVehicle() then return true end
	--if zed:isUseless() then return true end
	return false
end
function vTrait.doRoll(percent)
	if percent <= 0 then return false end
	if percent >= 100 then return true end
	return percent >= ZombRand(1, 101)
end

function vTrait.doDmg(zed)
    local pl = getPlayer()
    if not pl or not zed or not zed:isAlive() then return end
	if not instanceof(zed, "IsoZombie")  then return end
    zed:setAttackedBy(pl)

    if vTrait.doRoll(50) then
        zed:setHitReaction("")
    else
        zed:setKnockedDown(true)
    end
end



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




