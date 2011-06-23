-- Tree Script
-- Envi
require("base.common")
require("content.pillar")

module("item.pillar", package.seeall)

-- UPDATE common SET com_script='item.pillar' WHERE com_itemid IN (272, 440, 441, 442, 443, 692, 693, 694, 695, 2805);

function LookAtItemIdent(User,Item)
    local test = "no value";
	if (first==nil) then
        content.pillar.InitPillar()
        first=1;
    end

    -- fetching local references
    local signTextDe     = content.pillar.signTextDe;
    local signTextEn     = content.pillar.signTextEn;
    local signCoo        = content.pillar.signCoo;
    local signItemId     = content.pillar.signItemId;
    local signPerception = content.pillar.signPerception;

    found = false;
    UserPer = User:increaseAttrib("perception",0);
    tablePosition = Item.pos.x .. Item.pos.y .. Item.pos.z;
	if signCoo ~= nil then
		if (signCoo[tablePosition] ~= nil) then
			for i, signpos in pairs(signCoo[tablePosition]) do
				if equapos(Item.pos,signpos) then
					if (UserPer >= signPerception[tablePosition][i]) then
						found = true;
						world:itemInform(User,Item,base.common.GetNLS(User,string.gsub(signTextDe[tablePosition][i],"currentChar",User.name),string.gsub(signTextEn[tablePosition][i],"currentChar",User.name)));
						test = signTextDe[tablePosition][i];
					else
                        found = true;
						world:itemInform(User,Item,base.common.GetNLS(User,"~Du erkennst, dass hier etwas ist, kannst es aber nicht entziffern, da du zu blind bist.~","~You recognise something, but you cannot read it, because you are too blind.~"));
					end
				end
			end
		end
	end

	--[[local outText = checkNoobiaSigns(User,Item.pos);
	if outText and not found then
		world:itemInform(User,Item,outText);
		found = true;
	end ]]

	if not found then
        world:itemInform(User,Item,base.common.GetNLS(User,"Du siehst ","You see ")..world:getItemName(Item.id,User:getPlayerLanguage()));
    end

		User:inform("in LookAtItem of base_wegweiser.lua");
		User:inform(test);
end

