require("base.common")
require("base.hair")
require("base.money")

module("triggerfield.hairdresser", package.seeall)

priceInCP = 10000;

function MoveToField(User)
	-- gets all npcs in a range of 1
	local npcsInRange = world:getNPCSInRangeOf(User.pos, 1)
	
	-- gets the npcStruct to make the npc talk or whatever else
	for i, npcStruct in pairs(npcsInRange) do
		if not base.money.CharHasMoney(User,priceInCP) then --not enough money!
			gText="Ihr habt nicht genug Geld dabei! Ihr benötigt"..germanMoney..".";
			eText="You don't have enough money with you! You'll need"..englishMoney..".";
			outText=base.common.GetNLS(User,gText,eText);
			npcStruct:talk(Character.say, outText);
			break;
		end
	
		npcStruct:talk(Character.say, "Willkommen, was möchtet Ihr gemacht haben?", "Welcome, what would you like to have done?");
		-- call the function to get the first selectiondialog for selecting either change of hair style, beard style, hair color or original haircolor	
		selectChoice(User, npcStruct);
	end
end

function MoveFromField(User)
	-- gets all npcs in a range of 1
	local npcsInRange = world:getNPCSInRangeOf(User.pos, 1)
	-- gets the npcStruct to make the npc talk or whatever else
	for i, npcStruct in pairs(npcsInRange) do
		-- call the function to get the first selectiondialog for selecting either change of hair style, beard style, hair color or original haircolor
		payForHairchange(User, npcStruct);
	end
end

function payForHairchange(User, NPC)
	local germanMoney, englishMoney = base.money.MoneyToString(priceInCP);
	
	if not base.money.CharHasMoney(User,priceInCP) then --not enough money!
		gText="Ihr habt nicht genug Geld dabei! Ihr benötigt"..germanMoney..".";
		eText="You don't have enough money with you! You'll need"..englishMoney..".";
		outText=base.common.GetNLS(User,gText,eText);
        NPC:talk(Character.say, outText);
		return;
	end
	base.money.TakeMoneyFromChar(User,priceInCP); --take money
	User:inform("Ihr habt "..germanMoney.." bezahlt. Viel Dank und beehrt mich bald wieder!", "You paid"..englishMoney..". Thank you and please come back again!");
	return true;
end


function selectChoice(User, NPC)
	local callback = function(dialog) 
		local success = dialog:getSuccess() 
		if success then
			local selected = dialog:getSelectedIndex();
			if selected == 0 then
				selectHair(User, NPC);
			elseif selected == 1 then
				selectBeard(User, NPC);
			else
				selectHaircolor(User, NPC);
			end
		end
	end

	local dialog = SelectionDialog(base.common.GetNLS(User,"Friseur","Hair dresser"), base.common.GetNLS(User,"Bitte wähle aus, was du ändern möchtest. Alles kostet 1 Gold und es wird bezahlt wenn du das Feld verlässt.","Please select what you would like to change. Everything costs 1 gold and will be paid once you leave the field."), callback)
	dialog:setCloseOnMove()
	dialog:addOption(0, base.common.GetNLS(User, "Frisur","Hair style"))
	dialog:addOption(0, base.common.GetNLS(User, "Bart","Beard"))
	dialog:addOption(0, base.common.GetNLS(User, "Haarfarbe","Hair color"))

	User:requestSelectionDialog(dialog)
end

function selectHair(User, NPC)
	local race = User:getRace();
	local gender = User:increaseAttrib("sex", 0)+1;
	
	-- if character is a lizardman, say something and deny service
	if race == 5 then
		NPC:talk(Character.say, "Ich werde Euren Kamm nicht färben oder schneiden.", "I won't cut or dye your ridge.");
		return;
	end
		
	local callback = function(dialog) 
		local success = dialog:getSuccess();
		if success then
			local selected = dialog:getSelectedIndex()+1;
			User:setHair(base.hair.hairStyles[race][gender][selected].id)
		end	
	end

	local dialog = SelectionDialog(base.common.GetNLS(User,"Friseur","Hair dresser"), base.common.GetNLS(User,"Bitte wähle aus, welche Frisur du haben möchtest.","Please select what hair style you wish to have."), callback);
	dialog:setCloseOnMove();
	local hairTable = base.hair.hairStyles[race][gender];
	for i=1, #(hairTable) do 
		dialog:addOption(0, base.common.GetNLS(User, hairTable[i].nameDe, hairTable[i].nameEn));
	end

	User:requestSelectionDialog(dialog)
end

function selectBeard(User, NPC)
	local race = User:getRace();
	local gender = User:increaseAttrib("sex", 0)+1;

	-- if character is not human or dwarf, say something and deny service
	if gender == 1 and (race ~= 0 and race ~= 1) then
		NPC:talk(Character.say, "Ich kann nichts schneiden, was nicht da ist.", "I can't cut something that isn't there.");
		return;
	-- if character is female, deny service
	elseif gender ~= 1 then
		NPC:talk(Character.say, "Ihr seid eine Frau. Frauen haben keinen Bart. Vielleicht Zwerginnen, aber den Schneide ich nicht.", "You're the woman. Women don't have beards. Maybe dwarfess but I won't cut those.");
		return;
	end

	local callback = function(dialog) 
		local success = dialog:getSuccess();
		if success then
			local selected = dialog:getSelectedIndex()+1;
			User:setBeard(base.hair.beardStyles[race][selected].id);
		end	
	end

	local dialog = SelectionDialog(base.common.GetNLS(User,"Friseur","Hair dresser"), base.common.GetNLS(User,"Bitte wähle aus, welchen Bart du haben möchtest.","Please select what beard style you wish to have."), callback);
	dialog:setCloseOnMove()
	local beardTable = base.hair.beardStyles[race];
	for i=1, #(beardTable) do 
		dialog:addOption(0, base.common.GetNLS(User, beardTable[i].nameDe, beardTable[i].nameEn))
	end
	User:requestSelectionDialog(dialog)
end

hairColorSimple = {
	{r=255 ,g=250 ,b=205 ,nameDe="Weißblond", nameEn="White blonde"},
	{r=255 ,g=215 ,b=0 ,nameDe="Blond", nameEn="Blonde"},
	{r=205 ,g=173 ,b=0 ,nameDe="Dunkelblond", nameEn="Dark blonde"},
	{r=139 ,g=129 ,b=76 ,nameDe="Hellbraun", nameEn="Light brown"},
	{r=139 ,g=69 ,b=19 ,nameDe="Braun", nameEn="Brown"},
	{r=60 ,g=22 ,b=21 ,nameDe="Dunkelbraun", nameEn="Dark brown"},
	{r=0 ,g=0 ,b=0 ,nameDe="Schwarz", nameEn="Black"},
	{r=255 ,g=127 ,b=36 ,nameDe="Hellrot", nameEn="Light ginger"},
	{r=205 ,g=51 ,b=51 ,nameDe="Dunkelrot", nameEn="Dark ginger"}
}

function selectHaircolor(User, NPC)
	local originalHaircolor = User:getQuestProgress(31)
	
	if originalHaircolor == 0 then
		local red, green, blue  = User:getHairColor();
		red = red*1000000;
		green = green*1000;
		blue = blue;
		
		User:setQuestProgress(31,tonumber(red+green+blue));
	end
	
	local callback = function(dialog) 
		local success = dialog:getSuccess() 
		if success then
			local selected = dialog:getSelectedIndex()
			if selected == 0 then
				local hairColor = User:getQuestProgress(31);
				local r, g, b;
				r = hairColor/1000000;
				g = (hairColor - r*1000000)/1000;
				b = (hairColor - r*1000000 - g*1000);
				
				User:setHairColor(r, g, b);				
			else
				User:setHairColor(hairColorSimple[selected].r, hairColorSimple[selected].g, hairColorSimple[selected].b);
			end
		end
	end

	local dialog = SelectionDialog(base.common.GetNLS(User,"Friseur","Hair dresser"), base.common.GetNLS(User,"Bitte wähle aus, welche Farbe du haben möchtest.","Please select what hair color you wish to have."), callback);
	dialog:setCloseOnMove();
	dialog:addOption(0, base.common.GetNLS(User,"Naturhaarfarbe", "Natural hair color"));
	for i=1, #(hairColorSimple) do
		dialog:addOption(0, base.common.GetNLS(User,hairColorSimple[i].nameDe,hairColorSimple[i].nameEn));
	end

	User:requestSelectionDialog(dialog)
	
end