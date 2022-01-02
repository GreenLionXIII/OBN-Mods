nonce = function() end

function package_init(package) 
	package:declare_package_id("Thor.LavaStge")
	package:set_icon_texture(Engine.load_texture(_modpath.."icon.png"))
	package:set_preview_texture(Engine.load_texture(_modpath.."preview.png"))
	package:set_codes({'A', 'E', 'R', 'T', 'Y', '*'})

	local props = package:get_card_props()
	props.shortname = "LavaStge"
	props.time_freeze = true
	props.element = Element.Fire
	props.description = "Changes all panls to lava"
	props.limit = 5
end

function card_create_action(actor, props)
    print("in create_card_action()!")
	local action = Battle.CardAction.new(actor, "PLAYER_IDLE")
	action:set_lockout(make_sequence_lockout())
	action.execute_func = function(self, user)
		local panel11 = user:get_field():tile_at( 1, 1 )
		local panel12 = user:get_field():tile_at( 1, 2 )
		local panel13 = user:get_field():tile_at( 1, 3 )
		local panel21 = user:get_field():tile_at( 2, 1 )
		local panel22 = user:get_field():tile_at( 2, 2 )
		local panel23 = user:get_field():tile_at( 2, 3 )
		local panel31 = user:get_field():tile_at( 3, 1 )
		local panel32 = user:get_field():tile_at( 3, 2 )
		local panel33 = user:get_field():tile_at( 3, 3 )
		local panel41 = user:get_field():tile_at( 4, 1 )
		local panel42 = user:get_field():tile_at( 4, 2 )
		local panel43 = user:get_field():tile_at( 4, 3 )
		local panel51 = user:get_field():tile_at( 5, 1 )
		local panel52 = user:get_field():tile_at( 5, 2 )
		local panel53 = user:get_field():tile_at( 5, 3 )
		local panel61 = user:get_field():tile_at( 6, 1 )
		local panel62 = user:get_field():tile_at( 6, 2 )
		local panel63 = user:get_field():tile_at( 6, 3 )
		
		
		panel11:set_state(TileState.Lava)
		panel12:set_state(TileState.Lava)
		panel13:set_state(TileState.Lava)
		panel21:set_state(TileState.Lava)
		panel22:set_state(TileState.Lava)
		panel23:set_state(TileState.Lava)
		panel31:set_state(TileState.Lava)
		panel32:set_state(TileState.Lava)
		panel33:set_state(TileState.Lava)
		panel41:set_state(TileState.Lava)
		panel42:set_state(TileState.Lava)
		panel43:set_state(TileState.Lava)
		panel51:set_state(TileState.Lava)
		panel52:set_state(TileState.Lava)
		panel53:set_state(TileState.Lava)
		panel61:set_state(TileState.Lava)
		panel62:set_state(TileState.Lava)
		panel63:set_state(TileState.Lava)
	end
	return action
end