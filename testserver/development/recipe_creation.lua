require("base.common")


module("development.recipe_creation", package.seeall)

function FirstMenu(User, ingredientsList)
    local getText = function(deText,enText) return base.common.base.common.GetNLS(User,deText,enText) end
    
	if ingredientsList == nil then
	    ingredientsList = {}
	end

    local callback = function(dialog) 
		success = dialog:getSuccess() 
		if success then
			selected = dialog:getSelectedIndex()+1
			if selected == 1 then
			    SelectPlantCategory(User, ingredientsList)
			elseif selected == 2 then
                SelectGemDust(User, ingredientsList)
      		elseif selected == 3 then
                SelectFillIntoCauldron(User, ingredientsList)
			elseif selected == 4 then
                BottleFromCauldron(User, ingredientsList)
			elseif selected == 5 then
			    RemoveLastIngredient(User, ingredientsList)
			elseif selected == 6 then
                ShowRecipe(User, ingredientsList) 
			elseif selected == 7 then
                FinishRecipe(User, ingredientsList)
			end	
		else
			User:inform("Du hast die Rezeptherstellung abgebrochen.","You aborted the recipe creation.",Character.lowPriority) 
		end
	end

    local dialog = SelectionDialog(getText("Rezepterstellung","Recipe creation"), getText("W�hle eine Kategorie aus, aus der du dem Rezept etwas hinzutun willst.","Select a category from which you want to add something to the recipe."), callback)
	dialog:addOption(0, getText("Pflanzen","Plants"))
	dialog:addOption(0, getText("Edelsteinstaub", "Gem powder"))
	dialog:addOption(0, getText("Kessel bef�llen","Fill into the cauldron"))
	dialog:addOption(0, getText("Kesslinhalt abf�llen","Bottle cauldron content"))
	dialog:addOption(0, getText("Letzte Zutat entfernen","Remove last ingredient"))
	dialog:addOption(0, getText("Rezept betrachten","Show recipe"))
	dialog:addOption(0, getText("Rezept fertigstellen","Finish recipe"))
    dialog:setCloseOnMove()
	User:requestSelectionDialog(dialog)	

end

PLANT_CATS = {}
PLANT_CATS["DE"] = {"Pilze"    ,"Beeren" ,"Bl�tter"}
PLANT_CATS["EN"] = {"Mushrooms","Berries","Leaves"}

function SelectPlantCategory(User, ingredientsList)
    local getText = function(deText,enText) return base.common.base.common.GetNLS(User,deText,enText) end
	
	local callback = function(dialog) 
		success = dialog:getSuccess() 
		if success then
			selected = dialog:getSelectedIndex()+1
			if selected == 1 then
			    FirstMenu(User, ingredientsList)
			else	
			    SelectPlant(User, ingredientsList, PLANT_CATS["EN"][selected-1])
			end	
		else
			User:inform("Du hast die Rezeptherstellung abgebrochen.","You aborted the recipe creation.",Character.lowPriority)
		end
	end

	local dialog = SelectionDialog(getText("Rezepterstellung","Recipe creation"), getText("W�hle die Pflanzenkategorie aus, aus der du etwas zu dem Rezept hinzutun willst.","Select the plant category from which you want to add something to your recipe."), callback)
	dialog:addOption(0, getText("Zur�ck","Back"))
	for i=1,#PLANT_CATS["DE"] do
		dialog:addOption(0, getText(PLANT_CATS["DE"][i],PLANT_CATS["EN"][i]))
	end	
	dialog:setCloseOnMove()
	User:requestSelectionDialog(dialog)
end

PLANTS = {}
PLANTS["Mushrooms"] = {158,159,160}
PLANTS["Berries"]   = {142,143}
PLANTS["Leaves"]    = {140,153,156}

function SelectPlant(User, ingredientsList, category)
    local getText = function(deText,enText) return base.common.base.common.GetNLS(User,deText,enText) end
	
	local callback = function(dialog) 
		success = dialog:getSuccess() 
		if success then
			selected = dialog:getSelectedIndex()+1
			if selected == 1 then
			    SelectPlantCategory(User, ingredientsList)
			else
				if not CheckAmount(ingredientsList) then
				    return
				end	
				AddToRecipe(ingredientsList,PLANTS[category][selected-1])
				User:inform("Wurde dem Rezept hinzugef�gt: "..world:getItemName(PLANTS[category][selected-1],Player.german),"Has beend added to the recipe: "..world:getItemName(PLANTS[category][selected-1],Player.english),Character.lowPriority)
			    SelectPlant(User, ingredientsList, category)
			end 
		else
			User:inform("Du hast die Rezeptherstellung abgebrochen.","You aborted the recipe creation.",Character.lowPriority)
		end
	end

	local dialog = SelectionDialog(getText("Rezepterstellung","Recipe creation"), getText("W�hle die Pflanze aus, die du dem Rezept hinzuf�gen willst.","Select the plant you want to add to the recipe."), callback)
	dialog:addOption(0, getText("Zur�ck","Back"))
	for i=1,#PLANTS[category] do
		dialog:addOption(PLANTS[category][i],getText(world:getItemName(PLANTS[category][i],Player.german),world:getItemName(PLANTS[category][i],Player.english)))
	end	
	dialog:setCloseOnMove()
	User:requestSelectionDialog(dialog)

end

GEMPOWDERS = {446,447,448,449,450,451,452}	
	
function SelectGemDust(User, ingredientsList)
    local getText = function(deText,enText) return base.common.base.common.GetNLS(User,deText,enText) end
	
	local callback = function(dialog) 
		success = dialog:getSuccess() 
		if success then
			selected = dialog:getSelectedIndex()+1
			if selected == 1 then
			    FirstMenu(User, ingredientsList)
			else
				if not CheckAmount(ingredientsList) then
				    return
				end	
				AddToRecipe(ingredientsList,GEMPOWDERS[selected-1])
				User:inform("Wurde dem Rezept hinzugef�gt: "..world:getItemName(GEMPOWDERS[selected-1],Player.german),"Has beend added to the recipe: "..world:getItemName(GEMPOWDERS[selected-1],Player.english),Character.lowPriority)
			    SelectGemDust(User, ingredientsList)
			end 
		else
			User:inform("Du hast die Rezeptherstellung abgebrochen.","You aborted the recipe creation.",Character.lowPriority)
		end
	end

	local dialog = SelectionDialog(getText("Rezepterstellung","Recipe creation"), getText("W�hle den Edelsteinstaub aus, den du dem Rezept hinzuf�gen willst.","Select the gem powder you want to add to the recipe."), callback)
	dialog:addOption(0, getText("Zur�ck","Back"))
	for i=1,#GEMPOWDERS do
		dialog:addOption(GEMPOWDERS[i],getText(world:getItemName(GEMPOWDERS[i],Player.german),world:getItemName(GEMPOWDERS[i],Player.english)))
	end	
	dialog:setCloseOnMove()
	User:requestSelectionDialog(dialog)
end

function BottleFromCauldron(User, ingredientsList)
	
	if not CheckAmount(ingredientsList) then
		return
	end	
	local counter = 1
	for i=1,#ingredientsList do
	    local a,b,queue = string.find(ingredientsList[i],"bottle (%d+)")
		if a ~= nil then
			counter = counter + 1
		end
    end	
	AddToRecipe(ingredientsList,"bottle "..counter)
	local de, en = BottleBottlingString("bottle "..counter)
	User:inform("Wurde dem Rezept hinzugef�gt: "..de,"Has beend added to the recipe: "..en,Character.lowPriority)
	FirstMenu(User, ingredientsList)
end

function SelectFillIntoCauldron(User, ingredientsList)
    local getText = function(deText,enText) return base.common.base.common.GetNLS(User,deText,enText) end
	
	local addList = {}
    local callback = function(dialog) 
		success = dialog:getSuccess() 
		if success then
			selected = dialog:getSelectedIndex()+1
			if selected == 1 then
			    FirstMenu(User, ingredientsList)
			elseif selected == 2 then 
			    if not CheckAmount(ingredientsList) then
				    return
				end	
				AddToRecipe(ingredientsList,52)
				User:inform("Wurde dem Rezept hinzugef�gt: "..world:getItemName(52,Player.german),"Has beend added to the recipe: "..world:getItemName(52,Player.english),Character.lowPriority)
				SelectFillIntoCauldron(User, ingredientsList)
			else
     			if not CheckAmount(ingredientsList) then
				    return
				end
				AddToRecipe(ingredientsList,addList[selected-2])
				local de, en = BottleBottlingString(addList[selected-2])
				User:inform("Wurde dem Rezept hinzugef�gt: "..de, "Has been added to the recipe: "..en)
				SelectFillIntoCauldron(User, ingredientsList)
		    end
		else
			User:inform("Du hast die Rezeptherstellung abgebrochen.","You aborted the recipe creation.",Character.lowPriority) 
		end
	end
    
	local dialog = SelectionDialog(getText("Rezepterstellung","Recipe creation"), getText("W�hle aus, was du in den Kessel f�llen willst.","Select what you want to fill into the cauldron."), callback)
	dialog:addOption(0, getText("Zur�ck","Back"))
	dialog:addOption(52, getText(world:getItemName(52,Player.german),world:getItemName(52,Player.english)))
	for i=1,#ingredientsList do
		if type(ingredientsList[i])=="string" then
			local a,b,queue = string.find(ingredientsList[i],"bottle (%d+)")
			if a ~= nil then
				local check = true
				for j=1,#ingredientsList do
					if "add "..queue == ingredientsList[j] then
						check = false 
						break
					end
				end	
				if check then
					local de, en = BottleBottlingString("add "..queue)
					table.insert(addList, "add "..queue)
					dialog:addOption(0,getText(de,en))
				end	
			end
		end			
	end
	
	dialog:setCloseOnMove()
	User:requestSelectionDialog(dialog)
end

function RemoveLastIngredient(User, ingredientsList)
    
	if #ingredientsList==0 then
	    User:inform("Das Rezept ist leer. Es kann nichts entfernt werden.","The recipe is empty. There is nothing to be removed.",Character.lowPriority)
	    FirstMenu(User, ingredientsList)
		return
	end	
    local removed = table.remove(ingredientsList)
	if type(removed)=="number" then
	    User:inform("Die letzte Zutat wurde vom Rezept entfernt: "..world:getItemName(removed,Player.german),"The last ingredient has been removed: "..world:getItemName(removed,Player.english),Character.lowPriority)
    elseif type(removed)=="string" then
	    local de, en = BottleBottlingString(removed)
		User:inform("Die letzte Zutat wurde vom Rezept entfernt: "..de,"The last ingredient has been removed: "..en,Character.lowPriority)
	end
end

function ShowRecipe(User, ingredientsList) 
    local getText = function(deText,enText) return base.common.base.common.GetNLS(User,deText,enText) end
	
	local recipeDe = ""; local recipeEn = ""
	if #ingredientsList == 0 then
	    recipeDe = "Das Rezept ist leer."
		recipeEn = "The recipe is empty."
	else
	    for i=1,#ingredientsList do
		    if type(ingredientsList[i])=="number" then
			    recipeDe = recipeDe..world:getItemName(ingredientsList[i],Player.german)
				recipeEn = recipeEn..world:getItemName(ingredientsList[i],Player.english)
			else
                local de,en = BottleBottlingString(ingredientsList[i])
                recipeDe = recipeDe..de
                recipeEn = recipeEn..en
            end
            if i < #ingredientsList then
                recipeDe = recipeDe..", "			
			    recipeEn = recipeEn..", "
			end
        end
    end
	local callback = function(dialog)
        FirstMenu(User, ingredientsList)
    end
	local dialog = MessageDialog(getText("Rezept","Recipe"), getText(recipeDe,recipeEn), callback)
	User:requestMessageDialog(dialog)
end

function FinishRecipe(User, ingredientsList)
    local getText = function(deText,enText) return base.common.base.common.GetNLS(User,deText,enText) end
	
	local parchment = GetParchmentQuill(User)
	parchment = IsParchmentOK(User,parchment,ingredientsList)
	if not parchment then
		return
	end
	
	if #ingredientsList == 0 then
	    User:inform("Es wurde noch nichts zum Notieren ausgew�hlt.","Nothing has been selected to be written down so far.", Character.highPriority)
		FirstMenu(User, ingredientsList)
		return
    end
	
	local callback = function(dialog)
		if dialog:getSuccess() then
			local parchment = GetParchmentQuill(User)
			parchment = IsParchmentOK(User,parchment,ingredientsList)
			if not parchment then
				return
			end
			local data = {}
			data["descriptionDe"] = "Alchemistisches Rezept: "..dialog:getInput()
			data["descriptionEn"] = "Alchemical recipe: "..dialog:getInput()
			data["alchemyRecipe"] = "true"
			for i=1,#ingredientsList do
			    data["ingredient"..i] = ingredientsList[i]
			end
			world:erase(parchment,1)
			local notCreated = User:createItem(2745,1,333,data)
			if notCreated > 0 then
				world:createItemFromId(2745,notCreated,User.pos,true,333,data)
			end	
		else
			User:inform("Du hast die Rezeptbenennung abgebrochen.","You abroted the naming of the recipe.",Character.lowPriority)
			FirstMenu(User, ingredientsList)
		end
	end
	local dialog = InputDialog(getText("Rezeptbenennung","Recipe naming"), getText("Gebe einen Namen f�r das Rezept ein.","Enter a name for the recipe."), false, 100, callback)
	User:requestInputDialog(dialog)
	return
end

function IsParchmentOK(User,parchment,ingredientsList)
    if not parchment then
		User:inform("Du musst eine Feder und ein Pergamnet in den H�ndne halten, um das Rezept zu notieren.", "You have to hold a quill and a parchment in your hands to write the recipe.",Character.highPriority) 
		FirstMenu(User, ingredientsList)
		return
	end

	if parchment:getData("descriptionDe") ~= "" and parchment:getData("descriptionEn") ~= "" then
	    User:inform("Du braucht ein leeres Pergament.","You need an empty parchment.")
		FirstMenu(User, ingredientsList)
		return
	end
	return parchment
end

function GetParchmentQuill(User)
    local itemA = User:getItemAt(5)
	local itemB = User:getItemAt(6)
	
	local parchment
	if itemA.id == 2745 and itemB.id == 1266 then
	    return itemA
	elseif itemA.id == 1266 and itemB.id == 2745 then
	    return itemB
	end
	return nil
end

function BottleBottlingString(theString)

    local a,b,queue = string.find(theString,"bottle (%d+)")
    if a ~= nil then
        return  queue..". Abf�llen", queue.."th bottling"
	end
    a,b,queue = string.find(theString,"add (%d+)")
    if a ~= nil then    
		return "F�ge "..queue..". Abgef�lltes hinzu", "Add "..queue.."th bottled"
	end	
end

function CheckAmount(ingredientsList)

	if #ingredientsList > 59 then
		User:inform("Das Pergament ist voll. Du kannst dies nicht mehr dem Rezept hinzuf�gen.","The parchment is full. You cannot add this to the recipe anymore.",Character.highPriority)
        return false
	end
    return true	
end

function AddToRecipe(ingredientsList,addThis)
    
	table.insert(ingredientsList,addThis)
	
end