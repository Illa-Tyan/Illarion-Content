--[[
Illarion Server

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

-- UPDATE common SET com_script='item.tree' WHERE com_itemid IN (308, 586, 1804, 1807, 1808, 1809, 1817, 960, 961, 962, 963, 589);

require("alchemy.base.teacher")
require("base.common")
require("base.lookat")
require("content.gatheringcraft.herbgathering")
require("content.gatheringcraft.woodchopping")
require("content.tree")

module("item.tree", package.seeall)

function UseItem(User, SourceItem, ltstate)
    -- alchemy stuff
	if SourceItem.pos == position(432,238,0) then
		alchemy.base.teacher.UseItem(User, SourceItem, ltstate)
		return
	end
	-- alchemy end

	-- Try to harvest herbs first
	if content.gatheringcraft.herbgathering.isHerbItem(SourceItem) and
			content.gatheringcraft.herbgathering.GetValidProduct(SourceItem) and
			User:countItemAt("body",126) > 0 then
		content.gatheringcraft.herbgathering.StartGathering(User, SourceItem, ltstate);
		return;
	end

	-- Try to chop tree
	if content.gatheringcraft.woodchopping.isChoppableTree(SourceItem) then
		content.gatheringcraft.woodchopping.StartGathering(User, SourceItem, ltstate);
		return;
	end
end

function LookAtItem(User,Item)
    -- alchemy stuff
	if Item.pos == position(432,238,0) then
		alchemy.base.teacher.LookAtItem(User, Item)
		return
	end
	-- alchemy end

	return base.lookat.GenerateLookAt(User, Item)

end
