local items = wesnoth.require "lua/wml/items.lua"
local knapsack = "items/knapsack.png"
local knapsack_bones = "items/knapsack_bones.png"
local bones_accepted = "quests.sn_bones_accepted"
local _ = wesnoth.textdomain "wesnoth-Brent"

local c = wesnoth.current.event_context
local x = c.x1
local y = c.y1
local unit = wesnoth.get_unit(x, y)


local accept_bones = function()
	items.remove(x, y, knapsack_bones)
	items.place_image(x, y, knapsack)
	wesnoth.set_variable(bones_accepted, true)
	wesnoth.fire("event", {name="victory", {"message", {speaker=unit.id, message=_ "Now which way was it to Port Meiran?"}}})
end

if not wesnoth.get_variable(bones_accepted) then
	local backpack = "portraits/story/backpack.png"
	local journal = "portraits/story/journal.png"
	local bones = "portraits/story/bones.png"
	local name = tostring(unit.name)
	quest_utils.message(backpack, string.format("%s finds a tattered oilskin backpack among the scattered bones.\nInside, there is a book.", name))
	if quest_utils.has_advance(unit, "reading") then
		quest_utils.message(journal, string.format("It seems to be some sort of journal... %s begins reading", name))
		quest_utils.message(journal, "The bones belong to an explorer named Laeran Markner. According to his journal, he has spent decades searching for his wife, who disappeared under mysterious circumstances.")
		quest_utils.message(journal, "His last entry reads, 'I've fallen and my leg snapped like a twig. I'm too old. The wolves are coming. Please, if you find my remains, take them back to my family in Port Meiren.'")
		quest_utils.message(journal, string.format("The script is hasty and hard to read, and looking down, %s notices gnaw marks on the bones.", name))
		quest_utils.dialog({image=journal, speaker='narrator', message='Do you take the bones?'}, {
			{
				opt="Yes, I'll take his bones.",
				func=accept_bones
			},
			{
				opt="I don't have time right now!",
				func=function() quest_utils.message(string.format("%s puts the book back.", name)) end
			}
		})
	else
		quest_utils.message("portraits/story/confusion.png", string.format("Unable to read the book, %s puts it back.", name))
	end
end