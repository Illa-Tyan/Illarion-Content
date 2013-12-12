-- INSERT INTO triggerfields VALUES (890,793,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (890,792,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (890,791,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (890,790,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (889,793,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (889,792,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (889,791,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (889,790,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (888,792,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (888,791,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (888,790,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (887,790,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (887,791,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (887,792,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (886,790,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (886,791,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (886,792,0,'triggerfield.slimeFeeding');
-- INSERT INTO triggerfields VALUES (887,797,0,'triggerfield.slimeFeeding');


require("base.lookat")
module("triggerfield.slimeFeeding", package.seeall)

-- 24 items. For every day of the month an own item..
SLIME_DIET_ITEMS = {
{itemId = 159, amount = 15}, --[[toad stool]]
{itemId = 52, amount = 3}, --[[bucket of water]]
{itemId = 447, amount = 3}, --[[ruby powder]]
{itemId = 21, amount = 9}, --[[coal]]
{itemId = 152, amount = 3}, --[[life root]]
{itemId = 2529, amount = 10}, --[[honey comb]]
{itemId = 252, amount = 7}, --[[raw obsidian]]
{itemId = 15, amount = 25}, --[[apple]]
{itemId = 157, amount = 26}, --[[rotten tree bark]]
{itemId = 762, amount = 3}, --[[gold crak herb]]
{itemId = 314, amount = 10}, --[[potash]]
{itemId = 456, amount = 11}, --[[snowball]]
{itemId = 133, amount = 25}, --[[sun herb]]
{itemId = 450, amount = 4}, --[[ameythst powder]]
{itemId = 1149, amount = 10}, --[[eggs]]
{itemId = 150, amount = 15}, --[[red head]]
{itemId = 259, amount = 15}, --[[grain]]
{itemId = 140, amount = 60}, --[[donf blade]]
{itemId = 762, amount = 20}, --[[coarse sand]]
{itemId = 767, amount = 10}, --[[water blossom]]
{itemId = 451, amount = 3}, --[[topaz powder]]
{itemId = 138, amount = 3}, --[[night angels blossom]]
{itemId = 256, amount = 5}, --[[raw smaragd]]
{itemId = 26, amount = 15} --[[clay]]
}

REWARD_LIST = {
{itemId = 164, amount = 1, quality = 333, data = nil}, --[[empty bottle]]
{itemId = 59, amount = 1, quality = 333, data = {potionEffectId = 59555555, filledWith = "potion", descriptionDe = "Idiotenheilmitte. Idiot's treatment", descriptionEn = "Idiotenheilmitte. Idiot's treatment"}}, --[[potion, increase int]]
{itemId = 126, amount = 1, quality = 666, data = nil}, --[[sickel]]
{itemId = 3077, amount = 25, quality = 333, data = nil}, --[[silver coin]]
{itemId = 1318, amount = 1, quality = 333, data = nil}, --[[bottle of Elven wine]]
{itemId = 446, amount = 2, quality = 333, data = nil}, --[[sapphire powder]]
{itemId = 449, amount = 2, quality = 333, data = nil}, --[[obsidian powder]]
{itemId = 452, amount = 2, quality = 333, data = nil}, --[[diamond powder]]
{itemId = 83, amount = 1, quality = 555, data = nil}, --[[topaz amulet]]
{itemId = 254, amount = 5, quality = 333, data = nil}, --[[raw diamond]]
{itemId = 3076, amount = 2678, quality = 333, data = nil}, --[[copper coins]]
{itemId = 829, amount = 1, quality = 666, data = nil}, --[[yellow hat with feather]]
{itemId = 2588, amount = 27, quality = 333, data = nil}, --[[bricks]]
{itemId = 200, amount = 22, quality = 333, data = nil}, --[[tomato]]
{itemId = 2668, amount = 1, quality = 444, data = nil} --[[poisoned simple dagger]]
}

TELEPORTER_FIELD = position(887,797,0)
WARP_BACK_POSITION = position(882,792,0)
WARP_TO_SLIME_POSITION = position(887,791,0)
SLIME_CAVE_POSITION = position(890,792,0)
REWARD_POSITION = position(886,797,0)
OLD_SLIME = 1055

FEEDING_IN_PROGRESS = false


SIGN_POSITION = position(12,4,0)
if world:isItemOnField(SIGN_POSITION) then
	local signSlimeFeeding = world:getItemOnField(SIGN_POSITION)
	if signSlimeFeeding.id == 3084 then
		local day = world:getTime("day")
		local itemId = SLIME_DIET_ITEMS[day]["itemId"]
		local amount = SLIME_DIET_ITEMS[day]["amount"]
		base.lookat.SetSpecialName(signSlimeFeeding, "Regeln f�r das F�ttern des alten Schleims", "Rules for feeding the old slime")
		base.lookat.SetSpecialDescription(signSlimeFeeding,"Heutiges Futter: "..world:getItemName(itemId,Player.german)..", Anzahl: "..amount.." // Beachten: Nur Gegenstandsteleporter nutzen; pro Person nur einmal im Monat f�ttern (�berfressungspr�vention); nur vorgegebenes Futter verwenden (N�hrstoffversorgungssicherstellung); niemals sollen zwei Personen gleichzeitig f�ttern (Unentscheidbarkeitssyndromverhinderung); KEINE F�TTERUNG IM MAS!",
		"Today's feeding: "..world:getItemName(itemId,Player.english)..", amount: "..amount.." // Keep in mind: Use only object teleporter; every person may feed the slime only once a month (prevention of overating); use only feeding allowed on the current day (securing of nutrient supply); two persons should never ever feed simultaneously (prevention of undecidability syndrom); NO FEEDING DURING MAS!")
		world:changeItem(signSlimeFeeding)
	end
	
end 


function PutItemOnField(Item,User)
if Item.pos ~= TELEPORTER_FIELD then
	RefuseItem(Item)
	return
end
	local day = world:getTime("day")
	local neededId = SLIME_DIET_ITEMS[day]["itemId"]
	local neededAmount = SLIME_DIET_ITEMS[day]["amount"]
	
	local itemAccepted
	User:inform(""..neededId.." and "..neededAmount)
	User:inform(""..Item.id.." and "..Item.number)
	if Item.id == neededId and Item.number == neededAmount and FEEDING_IN_PROGRESS == false then
		AcceptItem(Item)
		SlimeCreation()
		if base.factions.isRunewickCitizen(User) then
			base.factions.setRankpoints(User, getRankpoints(User)+3)
		end
		
	else
		RefuseItem(Item)
	end
	
	-- The eating, rewarding and moving back to the cave are handled in the monster script for this slime monster in the function abortRoute
end

function RefuseItem(Item)

	world:gfx(45,Item.pos)
	world:gfx(46,WARP_BACK_POSITION)
    world:createItemFromItem(Item,WARP_BACK_POSITION,true)
	world:erase(Item,Item.number)
end

function AcceptItem(Item)

	world:gfx(45,Item.pos)
	world:gfx(46,WARP_TO_SLIME_POSITION)
    world:createItemFromItem(Item,WARP_TO_SLIME_POSITION,true)
	world:erase(Item,Item.number)
end

function SlimeCreation()

    local oldSlime = world:createMonster(OLD_SLIME,SLIME_CAVE_POSITION,0)
	oldSlime:talk(Character.say, "#me flie�t aus der H�hlennische und beginnt sich in Richtung des Futters zu bewegen.",
	"#me flows out from the small hole to the ground and start to move towards the feed.")
	oldSlime.movepoints = oldSlime.movepoints - 30
	oldSlime.waypoints:addWaypoint(WARP_TO_SLIME_POSITION)
	oldSlime:setOnRoute(true)
	FEEDING_IN_PROGRESS = true
	
end