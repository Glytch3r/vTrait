

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
    local wpn = pl:getPrimaryHandItem()
    local wType = WeaponType.getWeaponType(pl)
    return (wType and tostring(wType) == "barehand") or (wpn and wpn:getCategories():contains("Unarmed"))
end

function vTrait.click()
    if not isIngameState() then return end
    local pl = getPlayer()

    if not pl or not pl:HasTrait("V") then return end
    if not pl:isAlive() then return end
    if not pl:isAiming() or pl:isAimAtFloor() then return end
    if pl:isLookingWhileInVehicle() then return end
    local unarmed = vTrait.isUnarmed(pl)
    if not unarmed then return end
    --pl:setAuthorizeMeleeAction(not unarmed)
	
    local sq = pl:getCurrentSquare()
    local adj = sq and sq:getAdjacentSquare(pl:getDir())
    if adj then
		vTrait.vAttack(adj)
        --ISTimedActionQueue.add(vTrait_BiteAction:new(pl, adj, 50))
    end
end
Events.OnMouseDown.Remove(vTrait.click)
--Events.OnMouseDown.Add(vTrait.click)

function vTrait.vAttack(adj)
	if not adj then return end
	if vTrait.isMultiHit() then
		for i = 1, adj:getMovingObjects():size() do
			local zed = adj:getMovingObjects():get(i - 1)
			if vTrait.isValidZed(zed) then
				vTrait.doDmg(zed)
			end
		end
	else
		for i = 1, adj:getMovingObjects():size() do
			local zed = adj:getMovingObjects():get(i - 1)
			if vTrait.isValidZed(zed) then
				vTrait.doDmg(zed)
				break
			end
		end
	end
end


--[[ 
function vTrait.done(pl, wpn)
	if pl and  vTrait.isUnarmed(pl) and  pl:HasTrait("V")  then
		pl:setAuthorizeMeleeAction(true)		
	end
end
Events.OnPlayerAttackFinished.Remove(vTrait.done)
Events.OnPlayerAttackFinished.Add(vTrait.done)

 ]]
function vTrait.getTSq(pl)
    pl = pl or getPlayer()

    local result = {}
    local csq = pl:getCurrentSquare()
    if not csq then return result end

    table.insert(result, csq)

    local adj = csq:getAdjacentSquare(pl:getDir())
    if not adj then return result end
    table.insert(result, adj)

    local dir = pl:getDir()
    local leftDir, rightDir

    if dir == IsoDirections.N then
        leftDir, rightDir = IsoDirections.W, IsoDirections.E
    elseif dir == IsoDirections.S then
        leftDir, rightDir = IsoDirections.E, IsoDirections.W
    elseif dir == IsoDirections.E then
        leftDir, rightDir = IsoDirections.N, IsoDirections.S
    elseif dir == IsoDirections.W then
        leftDir, rightDir = IsoDirections.S, IsoDirections.N
    end

    local leftSq = adj:getAdjacentSquare(leftDir)
    if leftSq then table.insert(result, leftSq) end

    local rightSq = adj:getAdjacentSquare(rightDir)
    if rightSq then table.insert(result, rightSq) end

    return result
end

function vTrait.doBite(pl)
    pl = pl or getPlayer()
    if not pl or not pl:HasTrait("V") then return false end    

    local csq = pl:getCurrentSquare()
    if not csq then return false end

    local adj = csq:getAdjacentSquare(pl:getDir())
    if not adj then return false end

    local squares = vTrait.getTSq(pl)

    if vTrait.isMultiHit() then
        for _, tsq in ipairs(squares) do
            for i = 1, tsq:getMovingObjects():size() do
                local zed = tsq:getMovingObjects():get(i - 1)
                if vTrait.isValidZed(zed) and not tsq:isBlockedTo(csq) then
                    vTrait.doDmg(zed, csq)
                end
            end
        end
    else
        local check = false
        for i = 1, adj:getMovingObjects():size() do
            local zed = adj:getMovingObjects():get(i - 1)
            if vTrait.isValidZed(zed) and not adj:isBlockedTo(csq) then
                vTrait.doDmg(zed, csq)
                check = true
                break
            end
        end

        if not check then
            for _, tsq in ipairs(squares) do
                if check then break end
                for i = 1, tsq:getMovingObjects():size() do
                    local zed = tsq:getMovingObjects():get(i - 1)
                    if vTrait.isValidZed(zed) and not tsq:isBlockedTo(csq) then
                        vTrait.doDmg(zed, csq)
                        check = true
                        break
                    end
                end
            end
        end
    end
    return true    
end

function vTrait.zHit(zed, pl, bp, wpn)
	if not pl or not pl:HasTrait("V") then return end
    if not zed:isAlive() then return end
    if not pl:isAlive() then return end
    --if not pl:isAiming() or pl:isAimAtFloor() then return end
    --if pl:isLookingWhileInVehicle() then return end
    local unarmed = vTrait.isUnarmed(pl)
    if not unarmed then return end
	vTrait.doDmg(zed)
	
end
Events.OnHitZombie.Remove(vTrait.zHit)
Events.OnHitZombie.Add(vTrait.zHit)

function vTrait.isMultiHit()
    return getSandboxOptions():getOptionByName("MultiHitZombies"):getValue()
end

function vTrait.isValidZed(zed)
    return zed and instanceof(zed, "IsoZombie") and zed:isAlive() and not vTrait.isTargOnFloor(zed)
end

function vTrait.isTargOnFloor(zed)
    return zed:isOnFloor() or zed:isUnderVehicle() or zed:isSitAgainstWall() or zed:isBeingSteppedOn()
end
function vTrait.doDmg(zed, csq)
    local pl = getPlayer()
    if not (pl and zed) then return end

    local hp = zed:getHealth()
    local dmg = ZombRand(1, hp) 

    triggerEvent("OnWeaponHitCharacter", pl, zed, nil, dmg)

    zed:setAttackedBy(pl)
	if vTrait.doRoll(40) then
		zed:Kill(pl) 
		zed:becomeCorpse(zed)
		return
	end
    zed:setHealth(math.max(0, hp - dmg))
    local newHp = zed:getHealth()
    if getCore():getDebug() then
        zed:addLineChatElement("HP: " .. tostring(newHp))
    end

    if newHp <= 0 then
        zed:Kill(pl) 
		zed:becomeCorpse(zed)
        return
    end
	--zed:setStaggerBack(false);
	zed:setKnockedDown(true);
	--zed:setOnFloor(true);
	--zed:setFallOnFront(true);
	zed:setHitReaction("FenceWindow");
--[[     if vTrait.doRoll and vTrait.doRoll(90) then
        zed:setHitReaction("")
    else
        zed:setKnockedDown(true)
    end ]]
end

function vTrait.doRoll(percent)
    if percent <= 0 then return false end
    if percent >= 100 then return true end
    return percent >= ZombRand(1, 101)
end

-----------------------            ---------------------------
--[[ 
vTrait = vTrait or {}

function vTrait.isUnarmed(pl)
    pl = pl or getPlayer()
    local wpn = pl:getPrimaryHandItem()
    local wType = WeaponType.getWeaponType(pl)
    return (wType and tostring(wType) == "barehand") or (wpn and wpn:getCategories():contains("Unarmed"))
end

function vTrait.click()
    if not isIngameState() then return end

    local pl = getPlayer()
    if not pl or not pl:HasTrait("V") then return end

    local unarmed = vTrait.isUnarmed(pl)
    pl:setAuthorizeMeleeAction(unarmed)

	local sq = pl:getSquare()
    if not sq then return end
    local adj = sq:getAdjacentSquare(pl:getDir())
    if not adj then return end
	
    if unarmed then
        pl:setInitiateAttack(false)
        ISTimedActionQueue.add(vTrait_BiteAction:new(pl, adj,10))
    end
end
Events.OnMouseUp.Add(vTrait.click)

function vTrait.isMultiHit()
	return getSandboxOptions():getOptionByName("MultiHitZombies")
end

function vTrait.isValidZed(zed)
	return zed and instanceof(zed, "IsoZombie") and zed:isAlive() and not vTrait.isTargOnFloor(zed) 
end

function vTrait.isTargOnFloor(zed)
    return zed:isOnFloor() or zed:isUnderVehicle() or zed:isSitAgainstWall() or zed:isBeingSteppedOn()
end

function vTrait.doRoll(percent)
    if percent <= 0 then return false end
    if percent >= 100 then return true end
    return percent >= ZombRand(1, 101)
end

function vTrait.doDmg(zed)
    local pl = getPlayer()
    if pl and zed then  
		local dmg = ZombRand(0, zed:getHealth())
		triggerEvent("OnWeaponHitCharacter", pl, zed, nil, dmg) 
		zed:setHealth(dmg)
		zed:setAttackedBy(pl)
		if not zed:isDead() then
			if vTrait.doRoll(50) then
				zed:setHitReaction("")
			else
				zed:setKnockedDown(true)
			end
		end

	end
end
 ]]
-----------------------            ---------------------------

--[[ 
function vTrait.isTargOnFloor(zed)
    if tostring(zed:getCurrentStateName()) == "ZombieOnGroundState" then return true end
    if zed:isBeingSteppedOn() then return true end
    if zed:isFakeDead() then return true end
    if zed:isForceEatingAnimation() then return true end
    if zed:isOnFloor() then return true end
    if zed:isCrawling() then return true end
    if zed:isSitAgainstWall() then return true end
    if zed:isUnderVehicle() then return true end
    return false
end
 ]]

--[[ 


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




