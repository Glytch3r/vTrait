

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



require "TimedActions/ISBaseTimedAction"

vTrait_BiteAction = ISBaseTimedAction:derive("vTrait_BiteAction")

function vTrait_BiteAction:isValid()
    local csq = self.pl:getCurrentSquare()
    return not self.sq:isBlockedTo(csq)
end

--[[ function vTrait_BiteAction:waitToStart()
    return false
end ]]

function vTrait_BiteAction:update()
   
end

function vTrait_BiteAction:start()

   -- self.pl:setVariable("V_BiteAction", true)
	self.pl:setVariable("PerformingAction", "bite")
	--print("V_BiteAction")
end

function vTrait_BiteAction:animEvent(event, parameter)
    if event == "AttackCollisionCheck" then
        if vTrait.isMultiHit() then
            for i = 1, self.sq:getMovingObjects():size() do
                local zed = self.sq:getMovingObjects():get(i - 1)
                if vTrait.isValidZed(zed) then
                    vTrait.doDmg(zed)
                end
            end
        else
            for i = 1, self.sq:getMovingObjects():size() do
                local zed = self.sq:getMovingObjects():get(i - 1)
                if vTrait.isValidZed(zed) then
                    vTrait.doDmg(zed)
                    break
                end
            end
        end
    elseif event == "EndAttack" then
        self:forceComplete()
    end
end

function vTrait_BiteAction:stop()

    ISBaseTimedAction.stop(self)
end

function vTrait_BiteAction:perform()

    ISBaseTimedAction.perform(self)
end

function vTrait_BiteAction:new(pl, sq, maxTime)
    local o = ISBaseTimedAction.new(self, pl)
    o.pl = pl
    o.character = pl
    o.sq = sq
    o.stopOnWalk = true
    o.stopOnRun = true
    o.stopOnAim = false
    o.maxTime = maxTime or 10
    return o
end










-----------------------            ---------------------------
--[[ 
vTrait = vTrait or {}

require "TimedActions/ISBaseTimedAction"

vTrait_BiteAction = ISBaseTimedAction:derive("vTrait_BiteAction")

function vTrait_BiteAction:isValid()
    local csq = self.pl:getCurrentSquare() 
    return not self.sq:isBlockedTo(csq)
end

function vTrait_BiteAction:update()
end

function vTrait_BiteAction:start()
    self.pl:setActionAnim("V_BiteAction")	
    self.pl:setAnimVariable("V_BiteAction", true)

end

function vTrait_BiteAction:stop()
    ISBaseTimedAction.stop(self)
end

function vTrait_BiteAction:perform()
	if vTrait.isMultiHit() then
		for i = 1, self.sq:getMovingObjects():size() do
			local zed = self.sq:getMovingObjects():get(i - 1)
			if vTrait.isValidZed(zed) then
				vTrait.doDmg(zed)
			end
		end
	else
		for i = 1, self.sq:getMovingObjects():size() do
			local zed = self.sq:getMovingObjects():get(i - 1)
			if vTrait.isValidZed(zed) then
				vTrait.doDmg(zed)
				break
			end
		end
	end
    ISBaseTimedAction.perform(self)
end

function vTrait_BiteAction:new(pl, sq, maxTime)
    local o = ISBaseTimedAction.new(self, pl) 
    o.pl = pl
    o.character = pl
    o.sq = sq
    o.stopOnWalk = true
    o.stopOnRun = true
    o.stopOnAim = false
    o.maxTime = maxTime or 10
    return o
end
 ]]