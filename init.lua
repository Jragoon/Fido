local Fido = {
    initial_properties = {
        hp_max = 10,
        physical = true,
        collide_with_objects = true,
        collisionbox = {-.7, 0, -.7, .7, 1.1, .7},
		visual = "mesh",
		mesh = "Pig.obj",
		textures = {"Pig.png"},
        visual_size = {x = 0.5, y = 0.5},
        spritediv = {x = 1, y = 1},
		initial_sprite_basepos = {x = 0, y = 0},
		follow = "farming:wheat",
		makes_footstep_sound = true,
		tamed = false
    },

    message = "Oink Oink! Please don't hurt me.",
}

function Fido:on_step(dtime)
	local pos = self.object:get_pos()
	local players = minetest.get_connected_players()
	local player = players[1]
	local dest = vector.add(player:get_pos(), vector.new(1, 0, 1))
    local pos_down = vector.subtract(pos, vector.new(0, 1, 0))

    local delta
    if minetest.get_node(pos_down).name == "air" then
		delta = vector.new(0, -1, 0)
	end
    if vector.distance(dest, pos) > 1 and self.tamed then
		delta = vector.subtract(dest, pos)
		delta = vector.normalize(delta)
	else 
		delta = vector.new(0, 0, 0)
    end

    delta = vector.multiply(delta, dtime)
	self.object:move_to(vector.add(pos, delta))
end

function Fido:on_punch(hitter)
    minetest.chat_send_player(hitter:get_player_name(), self.message)
end

function Fido:on_rightclick(clicker)
	thank_you = "Thanks for the wheat and pets, friend!"
	local item = clicker:get_wielded_item()
	if item:get_name() == "farming:wheat" then
		if not self.tamed then
			item:take_item()
			clicker:set_wielded_item(item)
			self.tamed = true
			minetest.chat_send_player(clicker:get_player_name(), thank_you)
		end
	end
end

function Fido:on_death(killer)
	goodbye = "Remember.. You did this to me."
	minetest.chat_send_player(killer:get_player_name(), goodbye)
end

minetest.register_entity("fido:Fido", Fido)
