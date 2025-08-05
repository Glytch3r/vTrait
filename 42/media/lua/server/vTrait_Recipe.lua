Recipe = Recipe or {}
Recipe.GetItemTypes = Recipe.GetItemTypes or {}
Recipe.OnCanPerform = Recipe.OnCanPerform or {}
Recipe.OnCreate = Recipe.OnCreate or {}
Recipe.OnGiveXP = Recipe.OnGiveXP or {}
Recipe.OnTest = Recipe.OnTest or {}
Recipe.WeaponParts = Recipe.WeaponParts or {}
--[[ 
 function Recipe.GetItemTypes.ZombieMeat(scriptItems)
    scriptItems:addAll(getScriptManager():getItemsTag("ZombieMeat"));
 end
 ]]

