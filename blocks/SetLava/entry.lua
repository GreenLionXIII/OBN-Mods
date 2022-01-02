function package_init(block)
    block:declare_package_id("Thor.SetLava")
    block:set_name("SetLava")
	block:as_program()
    block:set_description("Panels become lava panels.")
    block:set_color(Blocks.Green)
    block:set_shape({
        0, 0, 1, 1, 0,
        0, 0, 1, 1, 0,
        0, 0, 1, 1, 0,
        0, 1, 1, 1, 0,
        0, 0, 0, 0, 0
    })
    block:set_mutator(modify)
end

function modify(player)
    local panel11 = player:get_field():tile_at( 1, 1 )
	local panel12 = player:get_field():tile_at( 1, 2 )
	local panel13 = player:get_field():tile_at( 1, 3 )
	local panel21 = player:get_field():tile_at( 2, 1 )
	local panel22 = player:get_field():tile_at( 2, 2 )
	local panel23 = player:get_field():tile_at( 2, 3 )
	local panel31 = player:get_field():tile_at( 3, 1 )
	local panel32 = player:get_field():tile_at( 3, 2 )
	local panel33 = player:get_field():tile_at( 3, 3 )
	local panel41 = player:get_field():tile_at( 4, 1 )
	local panel42 = player:get_field():tile_at( 4, 2 )
	local panel43 = player:get_field():tile_at( 4, 3 )
	local panel51 = player:get_field():tile_at( 5, 1 )
	local panel52 = player:get_field():tile_at( 5, 2 )
	local panel53 = player:get_field():tile_at( 5, 3 )
	local panel61 = player:get_field():tile_at( 6, 1 )
	local panel62 = player:get_field():tile_at( 6, 2 )
	local panel63 = player:get_field():tile_at( 6, 3 )
	
	
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