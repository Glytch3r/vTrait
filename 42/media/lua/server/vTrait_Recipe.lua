Recipe = Recipe or {}
Recipe.GetItemTypes = Recipe.GetItemTypes or {}
Recipe.OnCanPerform = Recipe.OnCanPerform or {}
Recipe.OnCreate = Recipe.OnCreate or {}
Recipe.OnGiveXP = Recipe.OnGiveXP or {}
Recipe.OnTest = Recipe.OnTest or {}
Recipe.WeaponParts = Recipe.WeaponParts or {}

 function Recipe.GetItemTypes.ZombieMeat(scriptItems)
    scriptItems:addAll(getScriptManager():getItemsTag("ZombieMeat"));
 end

--[[ 
function Recipe.OnCreate.Make2Bowls(craftRecipeData, character)
	local items = craftRecipeData:getAllConsumedItems();
	local results = craftRecipeData:getAllCreatedItems();
	local dishTypes = {"Pasta", "Rice"};
	local condition = 10;
    for i=0,items:size() - 1 do
        local item = items:get(i)
        if instanceof(item, "Food") then
			condition = item:getCondition()
			for j=0,results:size() - 1 do
				local result = results:get(j)
				if instanceof(result, "Food") then
					result:setBaseHunger(item:getBaseHunger() / 2);
					result:setHungChange(item:getHungChange() / 2);
					result:setThirstChange(item:getThirstChangeUnmodified() / 2);
					result:setBoredomChange(item:getBoredomChangeUnmodified() / 2);
					result:setUnhappyChange(item:getUnhappyChangeUnmodified() / 2);
					result:setCarbohydrates(item:getCarbohydrates() / 2);
					result:setLipids(item:getLipids() / 2);
					result:setProteins(item:getProteins() / 2);
					result:setCalories(item:getCalories() / 2);
					result:setTainted(item:isTainted())
					if item:haveExtraItems() then
						for k=0,item:getExtraItems():size() - 1 do
							local extraItem = item:getExtraItems():get(k);
							result:addExtraItem(extraItem);
						end
					end
					if not item:isCustomName() and item:getEvolvedRecipeName() then
						result:setName(getText("Tooltip_food_Bowl", item:getEvolvedRecipeName()));
						result:setCustomName(true);
					elseif item:getDisplayName() then
						local itemName = item:getDisplayName();
						for k=1, #dishTypes do
							if string.contains(itemName, dishTypes[k]) then
								itemName = dishTypes[k];
								break
							end
						end
						result:setName(getText("Tooltip_food_Bowl", itemName));
                    	result:setCustomName(true);
					end
				else
					result:setCondition(condition)
				end
			end
        end
    end
end 
]]