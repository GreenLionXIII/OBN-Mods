nonce = function() end
local AUDIO1 = Engine.load_audio(_modpath.."PanelFinalChange.ogg")
local AUDIO2 = Engine.load_audio(_modpath.."PanalChange.wav")


function package_init(package) 
	package:declare_package_id("com.Thor.card.GrassStg")
	package:set_icon_texture(Engine.load_texture(_modpath.."icon.png"))
	package:set_preview_texture(Engine.load_texture(_modpath.."preview.png"))
	package:set_codes({'E', 'J', 'R', 'W', 'Z', '*'})

	local props = package:get_card_props()
	props.shortname = "GrassStg"
	--props.damage = DAMAGE
	props.time_freeze = true
	props.element = Element.Wood
	props.description = "Changes all panls to grass"
	props.limit = 5
	props.card_class = CardClass.Standard
	--props.can_boost = false
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
		
		
		local k = 0
		local cooldown = 0
		local step1 = Battle.Step.new()
		step1.update_func = function(self, dt)
			if cooldown <= 0 then
				k = k + 1
				cooldown = 0.05
				Engine.play_audio(AUDIO2, AudioPriority.Low)
				if user:get_tile():get_state() == TileState.Grass then
					panel11:set_state(TileState.Normal)
					panel12:set_state(TileState.Normal)
					panel13:set_state(TileState.Normal)
					panel21:set_state(TileState.Normal)
					panel22:set_state(TileState.Normal)
					panel23:set_state(TileState.Normal)
					panel31:set_state(TileState.Normal)
					panel32:set_state(TileState.Normal)
					panel33:set_state(TileState.Normal)
					panel41:set_state(TileState.Normal)
					panel42:set_state(TileState.Normal)
					panel43:set_state(TileState.Normal)
					panel51:set_state(TileState.Normal)
					panel52:set_state(TileState.Normal)
					panel53:set_state(TileState.Normal)
					panel61:set_state(TileState.Normal)
					panel62:set_state(TileState.Normal)
					panel63:set_state(TileState.Normal)
				else
					panel11:set_state(TileState.Grass)
					panel12:set_state(TileState.Grass)
					panel13:set_state(TileState.Grass)
					panel21:set_state(TileState.Grass)
					panel22:set_state(TileState.Grass)
					panel23:set_state(TileState.Grass)
					panel31:set_state(TileState.Grass)
					panel32:set_state(TileState.Grass)
					panel33:set_state(TileState.Grass)
					panel41:set_state(TileState.Grass)
					panel42:set_state(TileState.Grass)
					panel43:set_state(TileState.Grass)
					panel51:set_state(TileState.Grass)
					panel52:set_state(TileState.Grass)
					panel53:set_state(TileState.Grass)
					panel61:set_state(TileState.Grass)
					panel62:set_state(TileState.Grass)
					panel63:set_state(TileState.Grass)
				end
			else
				cooldown = cooldown - dt
			end
			
			if k == 14 then
				self:complete_step()
			end	
		end
		self:add_step(step1)		
		
		panel11:set_state(TileState.Grass)
		panel12:set_state(TileState.Grass)
		panel13:set_state(TileState.Grass)
		panel21:set_state(TileState.Grass)
		panel22:set_state(TileState.Grass)
		panel23:set_state(TileState.Grass)
		panel31:set_state(TileState.Grass)
		panel32:set_state(TileState.Grass)
		panel33:set_state(TileState.Grass)
		panel41:set_state(TileState.Grass)
		panel42:set_state(TileState.Grass)
		panel43:set_state(TileState.Grass)
		panel51:set_state(TileState.Grass)
		panel52:set_state(TileState.Grass)
		panel53:set_state(TileState.Grass)
		panel61:set_state(TileState.Grass)
		panel62:set_state(TileState.Grass)
		panel63:set_state(TileState.Grass)
		Engine.play_audio(AUDIO1, AudioPriority.Low)
	end
	return action
end