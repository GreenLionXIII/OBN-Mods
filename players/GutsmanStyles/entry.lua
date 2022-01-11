--[[ 	Mod by Thor
		GutsMan's Charge shot is a shockwave that will change tiles based on his style.
		You can also use his special to swap his charge shot to a stronger fist move that doesn't affect tiles.
		Depending on Style his fist/shockwave will do elemental damage.
		
		Normal Style 	- Break Element	(Cracks Tiles)
		Lava Style		- Fire Element	(Lava Tiles)
		Grass Style		- Wood Element	(Grass Tiles)
		Ice Style		- Aqua Element	(Ice Tiles)
		Magnet Style	- Elec Element	(Conveyor Tiles)
		Dusk Style 		- None Element	(Holy Tiles / Poison Tiles)
		
]]--
		

local battle_helpers = include("battle_helpers.lua")
local wave_sfx = Engine.load_audio(_modpath .. "shockwave.ogg")
local punch_sfx = Engine.load_audio(_modpath .. "punch.ogg")
local crack_sfx = Engine.load_audio(_modpath .. "crack.ogg")
local slam_sfx = Engine.load_audio(_modpath .. "slam.ogg")
local change_sfx = Engine.load_audio(_modpath.. "SpecialChange.wav")
local wave_texture = Engine.load_texture(_modpath .. "shockwave.png")
local fist_texture = Engine.load_texture(_modpath .. "fist.png")
local fist_dusk_texture = Engine.load_texture(_modpath .. "fist_dusk.png")
local fist_lava_texture = Engine.load_texture(_modpath .. "fist_lava.png")
local fist_ice_texture = Engine.load_texture(_modpath .. "fist_ice.png")
local fist_elec_texture = Engine.load_texture(_modpath .. "fist_elec.png")
local fist_grass_texture = Engine.load_texture(_modpath .. "fist_grass.png")
local shockwave_animation = _modpath.."shockwave.animation"

local shockwave_damage = 60
local player_health = 1000
local punch_damage = 100
local fist_speed = 4  -- lower is quicker
local punch_counter = 0

function package_init(package)
    package:declare_package_id("com.Thor.player.GutsMan")
    package:set_special_description("ACDC Town's Top NetNavi")
    package:set_speed(1.0)
    package:set_attack(5)
    package:set_charged_attack(100)
    package:set_preview_texture(Engine.load_texture(_modpath.."preview.png"))
    package:set_overworld_animation_path(_modpath.."overworld.animation")
    package:set_overworld_texture_path(_modpath.."overworld.png")
    package:set_mugshot_texture_path(_modpath.."mug.png")
    package:set_mugshot_animation_path(_modpath.."mug.animation")
end

function player_init(player)
    player:set_name("GutsMan")
    player:set_health(player_health)
    player:set_element(Element.Break)
    player:set_height(55.0)

    local base_texture = Engine.load_texture(_modpath.."battle.png")
    local base_animation_path = _modpath.."battle.animation"
    local base_charge_color = Color.new(255, 255, 0, 255)
	local second_charge_color = Color.new(128,255, 0, 255)

    player:set_animation(base_animation_path)
    player:set_texture(base_texture, true)
    player:set_fully_charged_color(base_charge_color)
    player:set_charge_position(0, -20)
	punch_counter = 0

    player.normal_attack_func = function(player)
        return Battle.Buster.new(player, false, player:get_attack_level())
    end

    player.charged_attack_func = charge_attack_shockwave
	
	player.special_attack_func = function(player)
        if player.charged_attack_func == charge_attack_shockwave then
			player.charged_attack_func = charge_attack_punch
			player:set_fully_charged_color(second_charge_color)
			Engine.play_audio(change_sfx, AudioPriority.Highest)
		else
			player.charged_attack_func = charge_attack_shockwave
			player:set_fully_charged_color(base_charge_color)
			Engine.play_audio(change_sfx, AudioPriority.Highest)
		end
	end
	
	local Lava = player:create_form()
    Lava:set_mugshot_texture_path(_modpath.."forms/Lava_Entry.png")

    local original_attack_level, original_charge_level

    Lava.on_activate_func = function(self, player)
        player:set_texture(Engine.load_texture(_modpath.."forms/Lava_Style.png"), true)
		player:set_element(Element.Fire)
    end

    Lava.on_deactivate_func = function(self, player)
        player:set_texture(base_texture, true)
		player:set_element(Element.Break)
    end
	
	local Grass = player:create_form()
    Grass:set_mugshot_texture_path(_modpath.."forms/Grass_Entry.png")

    local original_attack_level, original_charge_level

    Grass.on_activate_func = function(self, player)
        player:set_texture(Engine.load_texture(_modpath.."forms/Grass_Style.png"), true)
		player:set_element(Element.Wood)
    end

    Grass.on_deactivate_func = function(self, player)
        player:set_texture(base_texture, true)
		player:set_element(Element.Break)
	end
	
	local Ice = player:create_form()
    Ice:set_mugshot_texture_path(_modpath.."forms/Ice_Entry.png")

    local original_attack_level, original_charge_level

    Ice.on_activate_func = function(self, player)
        player:set_texture(Engine.load_texture(_modpath.."forms/Ice_Style.png"), true)
		player:set_element(Element.Aqua)
    end

    Ice.on_deactivate_func = function(self, player)
        player:set_texture(base_texture, true)
		player:set_element(Element.Break)
    end
	
	local Elec = player:create_form()
    Elec:set_mugshot_texture_path(_modpath.."forms/Elec_Entry.png")

    local original_attack_level, original_charge_level

    Elec.on_activate_func = function(self, player)
        player:set_texture(Engine.load_texture(_modpath.."forms/Elec_Style.png"), true)
		player:set_element(Element.Elec)
    end

    Elec.on_deactivate_func = function(self, player)
        player:set_texture(base_texture, true)
		player:set_element(Element.Break)
    end
	
	local Dusk = player:create_form()
    Dusk:set_mugshot_texture_path(_modpath.."forms/Dusk_Entry.png")

    local original_attack_level, original_charge_level

    Dusk.on_activate_func = function(self, player)
        player:set_texture(Engine.load_texture(_modpath.."forms/Dusk_Style.png"), true)
		player:set_element(Element.None)
    end

    Dusk.on_deactivate_func = function(self, player)
        player:set_texture(base_texture, true)
		player:set_element(Element.Break)
    end
	
end

function spawn_shockwave(owner, team, field, tile, direction,damage, wave_texture, wave_sfx)
    local spawn_next
    spawn_next = function()
        if not tile:is_walkable() then return end

        Engine.play_audio(wave_sfx, AudioPriority.Highest)

        local spell = Battle.Spell.new(team)
        spell:set_facing(direction)
        spell:highlight_tile(Highlight.Solid)
        spell:set_hit_props(HitProps.new(damage, Hit.Impact | Hit.Flinch | Hit.Flash, owner:get_element(), owner:get_context() , Drag.None))

        local sprite = spell:sprite()
        sprite:set_texture(wave_texture)

        local animation = spell:get_animation()
        animation:load(shockwave_animation)
        animation:set_state("DEFAULT")
        animation:refresh(sprite)
        animation:on_frame(3, function()
            tile = tile:get_tile(direction, 1)
            spawn_next()
        end, true)
        animation:on_complete(function() spell:erase() end)

        spell.update_func = function()
            spell:get_current_tile():attack_entities(spell)
        end

        field:spawn(spell, tile)
		if tile:is_walkable() then 
			if owner:get_element() == Element.Break then
				if tile:get_state() == TileState.Cracked then
					tile:set_state(TileState.Broken)
				else
					tile:set_state(TileState.Cracked)
				end
			elseif owner:get_element() == Element.None then
				if tile:get_team() == owner:get_team() then
					tile:set_state(TileState.Holy)
				else
					tile:set_state(TileState.Poison)
				end
				
			elseif owner:get_element() == Element.Fire then
				tile:set_state(TileState.Lava)
				
			elseif owner:get_element() == Element.Aqua then
				tile:set_state(TileState.Ice)
				
			elseif owner:get_element() == Element.Wood then
				tile:set_state(TileState.Grass)
				
			elseif owner:get_element() == Element.Elec then
				local random_number = math.random(1,4)
				if random_number == 1 then
					tile:set_state(TileState.DirectionDown)
				elseif random_number == 2 then
					tile:set_state(TileState.DirectionUp)
				elseif random_number == 3 then
					tile:set_state(TileState.DirectionLeft)
				elseif random_number == 4 then
					tile:set_state(TileState.DirectionRight)
				end
			end			
		end
    end

    spawn_next()
end

function card_create_action_shockwave(actor, props)
    print("in create_card_action()!")
    local action = Battle.CardAction.new(actor, "PLAYER_SLAM")
	
	action:set_lockout(make_animation_lockout())

    action.animation_end_func = function(self)
		local cannonshot = spawn_shockwave(actor, actor:get_team(), actor:get_field(), actor:get_tile(actor:get_facing(), 1), actor:get_facing(), props.damage, wave_texture, wave_sfx)
	end
	
    return action
end

function card_create_action_punch(actor,props)
	print("in create_card_action()!")
	local action = Battle.CardAction.new(actor, "PLAYER_PUNCH")
	
	action:set_lockout(make_animation_lockout())

	action.animation_end_func = function(self)
		local cannonshot = spawn_fist(actor, props)
		local tile = actor:get_tile(actor:get_facing(), 1)
		actor:get_field():spawn(cannonshot, tile)
	end
	
	punch_counter = punch_counter + 1
	return action
end

function spawn_fist(actor,props)
	Engine.play_audio(punch_sfx, AudioPriority.Highest)
    local spell = Battle.Spell.new(actor:get_team())
    
	
	if actor:get_element() == Element.Break then 
		spell:set_texture(fist_texture, true)
	elseif actor:get_element() == Element.None then 
		spell:set_texture(fist_dusk_texture, true)
	elseif actor:get_element() == Element.Fire then 
		spell:set_texture(fist_lava_texture, true)
	elseif actor:get_element() == Element.Aqua then 
		spell:set_texture(fist_ice_texture, true)
	elseif actor:get_element() == Element.Elec then 
		spell:set_texture(fist_elec_texture, true)
	elseif actor:get_element() == Element.Wood then 
		spell:set_texture(fist_grass_texture, true)
	end
	
    spell:highlight_tile(Highlight.Solid)
	spell:set_offset(0.0, 0.0)
	--spell:never_flip(true)
	local direction = actor:get_facing()
	spell:set_facing(actor:get_facing_away())
    
	spell.slide_started = false
	

	spell:set_hit_props(
		HitProps.new(
			props.damage, 
			Hit.Impact | Hit.Drag | Hit.Flash | Hit.Shake | Hit.Flinch, 
			actor:get_element(),
			actor:get_context(),
			Drag.new(direction,6)
		)
	)

	
    local anim = spell:get_animation()
    anim:load(_modpath.."fist.animation")
    anim:set_state("FIST")

    spell.update_func = function(self, dt) 
        self:get_current_tile():attack_entities(self)

        if self:is_sliding() == false then 
            if self:get_current_tile():is_edge() and self.slide_started then 
                self:delete()
            end 

            local dest = self:get_tile(direction, 1)
            local ref = self
            self:slide(dest, frames(fist_speed), frames(0), ActionOrder.Voluntary, 
                function()
                    ref.slide_started = true 
                end
            )
        end
    end

    spell.attack_func = function(self, other) 
        -- nothing
    end
	
	spell.collision_func = function(self, other)
		--self:get_tile():set_state(TileState.Cracked)
		self:erase()
	end
	
    spell.delete_func = function(self) 
    end

    spell.can_move_to_func = function(tile)
        return true
    end

	--Engine.play_audio(ZAP_AUDIO, AudioPriority.Low)

    return spell
end

function charge_attack_shockwave(player)
	print("in charged buster")
	local props = Battle.CardProperties:new()
	props.damage = shockwave_damage
	local buster_action = card_create_action_shockwave(player,props)
	return buster_action
end

function charge_attack_punch(player)
	print("in charged buster")
	local props = Battle.CardProperties:new()
	props.damage = punch_damage
	local buster_action = card_create_action_punch(player,props)
	return buster_action
end




