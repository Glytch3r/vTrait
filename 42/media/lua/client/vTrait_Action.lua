

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

require "TimedActions/ISBaseTimedAction"


vTrait_BiteAction = ISBaseTimedAction:derive("vTrait_BiteAction");

function vTrait_BiteAction:isValidStart()
	return zed and instanceof(zed, "IsoZombie") and vTrait.isUnarmed(self.pl)
end

function vTrait_BiteAction:isValid()

end

function vTrait_BiteAction:update()
	
end

function vTrait_BiteAction:forceComplete()
    self.action:forceComplete();
end

function vTrait_BiteAction:start()
	self:setActionAnim("V_BiteAction")	
end

function vTrait_BiteAction:stop()
	ISBaseTimedAction.stop(self);
end

function vTrait_BiteAction:perform()
	ISBaseTimedAction.perform(self);
end

function vTrait_BiteAction:setOverrideHandModels(_primaryHand, _secondaryHand, _resetModel)
	self.action:setOverrideHandModelsObject(_primaryHand, _secondaryHand, _resetModel or true)
end

function vTrait_BiteAction:new(pl, sq, zed, maxTime)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.pl = pl;
	o.sq = sq;
	o.zed = zed;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.stopOnAim = true;
	o.maxTime = maxTime or -1;
	return o
end

