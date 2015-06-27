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

-- INSERT INTO triggerfields VALUES (107,543,0,'triggerfield.zelphiasStream');

local M = {}

function getMaximumLoad(user)
    return user:increaseAttrib("strength", 0) * 500 + 5000 -- This calculation is the same the server uses.
end

function getCharacterLoad(user)
    local totalLoad = 0
    
    local backPack
    if getItemAt(Character.backpack) then
        backPack = user:getBackPack()
    end
    
    if backPack then
        totalLoad = totalLoad + backPack:weight()
    end
    
    for i = 1, 17 do
        local currentItem = getItemAt(i)
        if currentItem then
            totalLoad = totalLoad +  world:getItemStats(currentItem).Weight
        end
    end
    
    return totalLoad
end

function M.MoveToField(user)

    if getCharacterLoad(user) >= getMaximumLoad(user)/5 then
        
        if user:getRace() == 5 then
            User:inform("Durch das Gewicht deiner Ausr�stung, wirst du tief ins Wasser gezogen und von einer Str�mung erfasst, doch durch das nat�rliche Schwimmverm�gen deiner Rasse kannst du dich ihr entgegenstemmen.","")
        else
            user:inform("Durch das Gewicht deriner Ausr�stung, wirst du tief ins Wasser gezogen und von einer Str�mung erfasst!", "")
            user:warp(2, 22, 0)
            user:talk(Character.say, "#me wird ans Ufer gesp�hlt.", "")
        end
        
    end

end

return M