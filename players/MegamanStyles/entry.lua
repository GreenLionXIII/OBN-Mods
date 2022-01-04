--[[
Player Mod by Thor

Styles:

	Heat Shadow
		ToDo: Charge Shot - Ivis

	Elec Ground - Done
		Charge Shot - ZapRing
		Crack hit tile

	Wood Shield
		Special - Shield
		ToDo: Charge Shot - Tornado
		Heal on Grass Panals

	Aqua Bug
		Charge Shot - Bubbler
		Random Bug upon Transform

	Heat Guts
		ToDo: Charge Shot - FlameThrower, Special - GutsBuster


Thanks to:
	https://github.com/Keristero/keristero-onb-mods
	Guard Chips


	https://github.com/RogueClaris/ONBChips/
	Shotgun and Zapring

]]



local battle_helpers = include("chargedbusters/guard/battle_helpers.lua")
local wave_texture = Engine.load_texture(_modpath.."chargedbusters/guard/shockwave.png")
local wave_sfx = Engine.load_audio(_modpath.."chargedbusters/guard/shockwave.ogg")
local shield_texture = Engine.load_texture(_modpath.."chargedbusters/guard/guard_attachment.png")
local sheild_animation_path = _modpath.."chargedbusters/guard/guard_attachment.animation"
local guard_hit_effect_texture = Engine.load_texture(_modpath.."chargedbusters/guard/guard_hit.png")
local guard_hit_effect_animation_path = _modpath.."chargedbusters/guard/guard_hit.animation"
local tink_sfx = Engine.load_audio(_modpath.."chargedbusters/guard/tink.ogg")

local guard = {
    name="Guard1",
    codes={'A',"D","K","*"},
    damage=50,
    duration=1.024,
    guard_animation = "GUARD1",
    description = "Repels an enemys attack"
}

local ZAP_DAMAGE = 20
local ZAP_TEXTURE = Engine.load_texture(_modpath.."chargedbusters/zapring/spell_zapring.png")
local ZAP_BUSTER_TEXTURE = Engine.load_texture(_modpath.."chargedbusters/zapring/buster_zapring.png")
local ZAP_AUDIO = Engine.load_audio(_modpath.."chargedbusters/zapring/fwish.ogg")

local BUB_DAMAGE = 50
local BUB_BUSTER_TEXTURE = Engine.load_texture(_modpath.."chargedbusters/bubbler/spread_buster.png")
local BUB_BURST_TEXTURE = Engine.load_texture(_modpath.."chargedbusters/bubbler/spread_impact.png")
local BUB_AUDIO = Engine.load_audio(_modpath.."chargedbusters/bubbler/sfx.ogg")




local style_element = "None"
local counter = 0
local inflicted_bug = "None"
local random_number = math.random(1,10)


function package_init(package)
    package:declare_package_id("com.Thor.char.MegamanStyles")
    package:set_special_description("Megaman with Style Change!")
    package:set_speed(1.0)
    package:set_attack(5)
    package:set_charged_attack(50)
    package:set_icon_texture(Engine.load_texture(_modpath.."icon.png"))
    package:set_preview_texture(Engine.load_texture(_modpath.."preview.png"))
    package:set_overworld_animation_path(_modpath.."overworld.animation")
    package:set_overworld_texture_path(_modpath.."overworld.png")
    package:set_mugshot_texture_path(_modpath.."mug.png")
    package:set_mugshot_animation_path(_modpath.."mug.animation")
	
end

function player_init(player)
    player:set_name("MegaMan")
    player:set_health(1000)
    player:set_element(Element.None)
    player:set_height(48.0)

    local base_texture = Engine.load_texture(_modpath.."battle.png")
    local base_animation_path = _modpath.."battle.animation"
    local base_charge_color = Color.new(57, 198, 243, 255)

    player:set_animation(base_animation_path)
    player:set_texture(base_texture, true)
    player:set_fully_charged_color(base_charge_color)
    player:set_charge_position(0, -20)
	player.normal_attack_func = create_normal_attack_norm
	player.charged_attack_func = create_special_attack_norm
	
	
	
	player.update_func = function()
		random_number = math.random(1,10)
		local moved = false
		if (style_element == "Grass" and player:get_tile():get_state() == TileState.Grass) 
		then
			counter = counter + 1
			local result = counter % 14
			if (result == 0)
			then
				player:set_health(player:get_health() + 1)
			end
		end
		
		
		if (inflicted_bug == "None")
		then
			--Nothing
		
		elseif (inflicted_bug == "HealthDown")
		then
			counter = counter + 1
			local result = counter % 14
			if (result == 0)
			then
				player:set_health(player:get_health() - 1)
			end
		
		elseif (inflicted_bug == "HealthUp")
		then
			counter = counter + 1
			local result = counter % 14
			if (result == 0)
			then
				player:set_health(player:get_health() + 1)
			end
		
		elseif (inflicted_bug == "MovementUp")
		then
			counter = counter + 1
			local result = counter % 30
			if (result == 0)
			then
				target_movement_tile = player:get_tile(Direction.Up,1)
				moved = player:teleport(target_movement_tile, ActionOrder.Immediate)
			end
		
		elseif (inflicted_bug == "MovementDown")
		then
			counter = counter + 1
			local result = counter % 30
			if (result == 0)
			then
				target_movement_tile = player:get_tile(Direction.Down,1)
				moved = player:teleport(target_movement_tile, ActionOrder.Immediate)
			end
		
		elseif (inflicted_bug == "MovementLeft")
		then
			counter = counter + 1
			local result = counter % 30
			if (result == 0)
			then
				target_movement_tile = player:get_tile(Direction.Left,1)
				moved = player:teleport(target_movement_tile, ActionOrder.Immediate)
			end
		
		elseif (inflicted_bug == "MovementRight")
		then
			counter = counter + 1
			local result = counter % 30
			if (result == 0)
			then
				target_movement_tile = player:get_tile(Direction.Right,1)
				moved = player:teleport(target_movement_tile, ActionOrder.Immediate)
			end
			
		elseif (inflicted_bug == "FullHealth")
		then
			player:set_health(1000)
			inflicted_bug = "None"
			
		elseif (inflicted_bug == "SetPoison")
		then
			counter = counter + 1
			local result = counter % 70
			if (result == 0)
			then
				player:get_tile():set_state(TileState.Poison)
			end
			
		elseif (inflicted_bug == "SetHoly")
		then
			counter = counter + 1
			local result = counter % 70
			if (result == 0)
			then
				player:get_tile():set_state(TileState.Holy)
			end
			
		elseif (inflicted_bug == "SetCracked")
		then
			counter = counter + 1
			local result = counter % 70
			if (result == 0)
			then
				player:get_tile():set_state(TileState.Cracked)
			end
		end
	end
	
	
	
	local FireShdw = player:create_form()
    FireShdw:set_mugshot_texture_path(_modpath.."forms/FireShadow_Entry.png")

    local original_attack_level, original_charge_level

    FireShdw.on_activate_func = function(self, player)
        original_attack_level = player:get_attack_level()
        original_charge_level = player:get_charge_level()
        player:set_attack_level(5) -- max attack level
        player:set_charge_level(5) -- max charge level
        player:set_animation(_modpath.."forms/Styles.animation")
        player:set_texture(Engine.load_texture(_modpath.."forms/FireShadow.png"), true)
        player:set_fully_charged_color(Color.new(243, 57, 198, 255))
		player:set_element(Element.Fire)
		--player.charged_attack_func = create_special_attack_water
		player.special_attack_func = create_special_attack_shield_off
		style_element = "Fire"
		inflicted_bug = "None"
    end

    FireShdw.on_deactivate_func = function(self, player)
        player:set_animation(base_animation_path)
        player:set_texture(base_texture, true)
        player:set_fully_charged_color(base_charge_color)
        player:set_attack_level(original_attack_level)
        player:set_charge_level(original_charge_level)
		player:set_element(Element.None)
		player.charged_attack_func = create_special_attack_norm
		player.special_attack_func = create_special_attack_shield_off
		style_element = "None"
		inflicted_bug = "None"
    end
	
	
	local ElecGrnd = player:create_form()
    ElecGrnd:set_mugshot_texture_path(_modpath.."forms/ElecGround_Entry.png")

    local original_attack_level, original_charge_level

    ElecGrnd.on_activate_func = function(self, player)
        original_attack_level = player:get_attack_level()
        original_charge_level = player:get_charge_level()
        player:set_attack_level(5) -- max attack level
        player:set_charge_level(5) -- max charge level
        player:set_animation(_modpath.."forms/Styles.animation")
        player:set_texture(Engine.load_texture(_modpath.."forms/ElecGround.png"), true)
        player:set_fully_charged_color(Color.new(243, 57, 198, 255))
		player:set_element(Element.Elec)
		player.charged_attack_func = create_special_attack_elec
		player.special_attack_func = create_special_attack_shield_off
		style_element = "Elec"
		inflicted_bug = "None"
    end

    ElecGrnd.on_deactivate_func = function(self, player)
        player:set_animation(base_animation_path)
        player:set_texture(base_texture, true)
        player:set_fully_charged_color(base_charge_color)
        player:set_attack_level(original_attack_level)
        player:set_charge_level(original_charge_level)
		player:set_element(Element.None)
		player.charged_attack_func = create_special_attack_norm
		player.special_attack_func = create_special_attack_shield_off
		style_element = "None"
		inflicted_bug = "None"
    end
	
	
	local GrassShield = player:create_form()
    GrassShield:set_mugshot_texture_path(_modpath.."forms/GrassShield_Entry.png")

    local original_attack_level, original_charge_level

    GrassShield.on_activate_func = function(self, player)
        original_attack_level = player:get_attack_level()
        original_charge_level = player:get_charge_level()
        player:set_attack_level(5) -- max attack level
        player:set_charge_level(5) -- max charge level
        player:set_animation(_modpath.."forms/GrassShield.animation")
        player:set_texture(Engine.load_texture(_modpath.."forms/GrassShield.png"), true)
        player:set_fully_charged_color(Color.new(243, 57, 198, 255))
		player:set_element(Element.Wood)
		--player.charged_attack_func = create_special_attack_water
		player.special_attack_func = create_special_attack_shield
		style_element = "Grass"
		inflicted_bug = "None"
    end

    GrassShield.on_deactivate_func = function(self, player)
        player:set_animation(base_animation_path)
        player:set_texture(base_texture, true)
        player:set_fully_charged_color(base_charge_color)
        player:set_attack_level(original_attack_level)
        player:set_charge_level(original_charge_level)
		player:set_element(Element.None)
		player.charged_attack_func = create_special_attack_norm
		player.special_attack_func = create_special_attack_shield_off
		style_element = "None"
		inflicted_bug = "None"
    end
	
	
	local WaterBug = player:create_form()
    WaterBug:set_mugshot_texture_path(_modpath.."forms/WaterBug_Entry.png")

    local original_attack_level, original_charge_level

    WaterBug.on_activate_func = function(self, player)
        original_attack_level = player:get_attack_level()
        original_charge_level = player:get_charge_level()
        player:set_attack_level(5) -- max attack level
        player:set_charge_level(5) -- max charge level
        player:set_animation(_modpath.."forms/Styles.animation")
        player:set_texture(Engine.load_texture(_modpath.."forms/WaterBug.png"), true)
        player:set_fully_charged_color(Color.new(243, 57, 198, 255))
		player:set_element(Element.Aqua)
		player.charged_attack_func = create_special_attack_water
		player.special_attack_func = create_special_attack_shield_off
		style_element = "Aqua"
		if (random_number == 1)
		then
			inflicted_bug = "HealthDown"
		elseif (random_number == 2)
		then
			inflicted_bug = "HealthUp"
		elseif (random_number == 3)
		then
			inflicted_bug = "MovementUp"
		elseif (random_number == 4)
		then
			inflicted_bug = "MovementDown"
		elseif (random_number == 5)
		then
			inflicted_bug = "MovementLeft"
		elseif (random_number == 6)
		then
			inflicted_bug = "MovementRight"
		elseif (random_number == 7)
		then
			inflicted_bug = "FullHealth"
		elseif (random_number == 8)
		then
			inflicted_bug = "SetPoison"
		elseif (random_number == 9)
		then
			inflicted_bug = "SetHoly"
		elseif (random_number == 10)
		then
			inflicted_bug = "SetCracked"
		end
    end

    WaterBug.on_deactivate_func = function(self, player)
        player:set_animation(base_animation_path)
        player:set_texture(base_texture, true)
        player:set_fully_charged_color(base_charge_color)
        player:set_attack_level(original_attack_level)
        player:set_charge_level(original_charge_level)
		player:set_element(Element.None)
		player.charged_attack_func = create_special_attack_norm
		player.special_attack_func = create_special_attack_shield_off
		style_element = "None"
		inflicted_bug = "None"
    end
	
	
	local FireGuts = player:create_form()
    FireGuts:set_mugshot_texture_path(_modpath.."forms/FireGuts_Entry.png")

    local original_attack_level, original_charge_level

    FireGuts.on_activate_func = function(self, player)
        original_attack_level = player:get_attack_level()
        original_charge_level = player:get_charge_level()
        player:set_attack_level(5) -- max attack level
        player:set_charge_level(5) -- max charge level
        player:set_animation(_modpath.."forms/Styles.animation")
        player:set_texture(Engine.load_texture(_modpath.."forms/FireGuts.png"), true)
        player:set_fully_charged_color(Color.new(243, 57, 198, 255))
		player:set_element(Element.Fire)
		player.charged_attack_func = create_special_attack_fire
		player.special_attack_func = create_special_attack_shield_off
		style_element = "Fire"
		inflicted_bug = "None"
    end

    FireGuts.on_deactivate_func = function(self, player)
        player:set_animation(base_animation_path)
        player:set_texture(base_texture, true)
        player:set_fully_charged_color(base_charge_color)
        player:set_attack_level(original_attack_level)
        player:set_charge_level(original_charge_level)
		player:set_element(Element.None)
		player.charged_attack_func = create_special_attack_norm
		player.special_attack_func = create_special_attack_shield_off
		style_element = "None"
		inflicted_bug = "None"
    end
end
	
function create_normal_attack_norm(player)
	return Battle.Buster.new(player, false, player:get_attack_level())
end

function create_special_attack_norm(player)
	return Battle.Buster.new(player, true, player:get_attack_level() * 10)
end

function create_special_attack_elec(player)
	print("charged attack")
    local props = Battle.CardProperties:new()
    props.damage = 20
    local buster_action = card_create_action_zapring(player,props)
    return buster_action
end

function create_special_attack_water(player)
	print("charged attack")
    local props = Battle.CardProperties:new()
    --props.damage = 20
    local buster_action = card_create_action_bubbler(player,props)
    return buster_action
end

function create_special_attack_fire(player)
	--Nothing Yet
end

function create_special_attack_shield(player)
    print("execute special")
    local props = Battle.CardProperties:new()
    props.damage = 30+(player:get_attack_level()*10)
    guard.guard_duration = 0.384
    guard.guard_animation = "PROTOGUARD"
    local guard_action = guard.card_create_action_shield(player,props)
    return guard_action
end

function create_special_attack_shield_off(player)
    --nothing
end





function guard.card_create_action_shield(actor,props)
    local action = Battle.CardAction.new(actor, "PLAYER_SHOOTING")
    --special properties
    action.guard_animation = guard.guard_animation

	--protoman's counter in BN5 lasts 24 frames (384ms)
	--there are 224ms of the shield fading away where protoman can move
	action:set_lockout(make_animation_lockout())
	local GUARDING = {1,guard.duration}
	local POST_GUARD = {1, 0.224} 
	local FRAMES = make_frame_data({GUARDING,POST_GUARD})
	action:override_animation_frames(FRAMES)

    action.execute_func = function(self, user)
        --local props = self:copy_metadata()
		local guarding = false
        local guard_attachment = self:add_attachment("BUSTER")
        local guard_sprite = guard_attachment:sprite()
        guard_sprite:set_texture(shield_texture)
        guard_sprite:set_layer(-2)

        local guard_animation = guard_attachment:get_animation()
        guard_animation:load(sheild_animation_path)
        guard_animation:set_state(action.guard_animation)

        local guarding_defense_rule = Battle.DefenseRule.new(0,DefenseOrder.Always)

		self:add_anim_action(1,function()
			guarding = true
		end)
		self:add_anim_action(2,function()
			guard_animation:set_state("FADE")
			guarding = false
            user:remove_defense_rule(guarding_defense_rule)
		end)

        guarding_defense_rule.can_block_func = function(judge, attacker, defender)
            if not guarding then 
                return 
            end
            local attacker_hit_props = attacker:copy_hit_props()
            if attacker_hit_props.damage > 0 then
                if attacker_hit_props.flags & Hit.Breaking == Hit.Breaking then
                    --cant block breaking hits with guard
                    return
                end
                judge:block_impact()
                judge:block_damage()
                Engine.play_audio(tink_sfx, AudioPriority.Highest)
                local reflected_damage = props.damage
                local direction = actor:get_facing()
                if not guarding_defense_rule.has_reflected then
                    battle_helpers.spawn_visual_artifact(actor,actor:get_current_tile(),guard_hit_effect_texture,guard_hit_effect_animation_path,"DEFAULT",0,-30)
                    spawn_shockwave(actor, actor:get_team(),actor:get_field(),actor:get_tile(direction, 1), direction,reflected_damage, wave_texture,wave_sfx,0.2)
                    guarding_defense_rule.has_reflected = true
                end
            end
        end

        user:add_defense_rule(guarding_defense_rule)
    end

    return action
end

function spawn_shockwave(owner, team, field, tile, direction,damage, wave_texture, wave_sfx,frame_time)
    local spawn_next
    spawn_next = function()
        if not tile:is_walkable() then return end

        Engine.play_audio(wave_sfx, AudioPriority.Highest)

        local spell = Battle.Spell.new(team)
        spell:set_facing(direction)
        spell:highlight_tile(Highlight.Solid)
        spell:set_hit_props(HitProps.new(damage, Hit.Impact|Hit.Flash, Element.None, owner:get_context() , Drag.None))

        local sprite = spell:sprite()
        sprite:set_texture(wave_texture)

        local animation = spell:get_animation()
        animation:load(_modpath.."chargedbusters/guard/shockwave.animation")
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
    end

    spawn_next()
end





function card_create_action_zapring(actor, props)
    print("in create_card_action()!")
    local action = Battle.CardAction.new(actor, "PLAYER_SHOOTING")
	
	action:set_lockout(make_animation_lockout())

    action.execute_func = function(self, user)
		local buster = self:add_attachment("BUSTER")
		buster:sprite():set_texture(ZAP_BUSTER_TEXTURE, true)
		buster:sprite():set_layer(-1)
		
		local buster_anim = buster:get_animation()
		buster_anim:load(_modpath.."chargedbusters/zapring/buster_zapring.animation")
		buster_anim:set_state("DEFAULT")
		
		local cannonshot = create_zap("DEFAULT", user)
		local tile = user:get_tile(user:get_facing(), 1)
		actor:get_field():spawn(cannonshot, tile)
	end
    return action
end

function create_zap(animation_state, user)
    local spell = Battle.Spell.new(user:get_team())
    spell:set_texture(ZAP_TEXTURE, true)
    spell:highlight_tile(Highlight.Solid)
	spell:set_offset(0.0, 16.0)
	local direction = user:get_facing()
    spell.slide_started = false
	
    spell:set_hit_props(
        HitProps.new(
            ZAP_DAMAGE, 
            Hit.Impact | Hit.Stun | Hit.Flinch, 
            Element.Elec,
            user:get_context(),
            Drag.None
        )
    )
	
    local anim = spell:get_animation()
    anim:load(_modpath.."chargedbusters/zapring/spell_zapring.animation")
    anim:set_state(animation_state)

    spell.update_func = function(self, dt) 
        self:get_current_tile():attack_entities(self)

        if self:is_sliding() == false then 
            if self:get_current_tile():is_edge() and self.slide_started then 
                self:delete()
            end 

            local dest = self:get_tile(direction, 1)
            local ref = self
            self:slide(dest, frames(4), frames(0), ActionOrder.Voluntary, 
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
		self:get_tile():set_state(TileState.Cracked)
		self:erase()
	end
	
    spell.delete_func = function(self) 
    end

    spell.can_move_to_func = function(tile)
        return true
    end

	Engine.play_audio(ZAP_AUDIO, AudioPriority.Low)

    return spell
end





function card_create_action_bubbler(actor, props)
    print("in create_card_action()!")
    local action = Battle.CardAction.new(actor, "PLAYER_SHOOTING")
	
	action:set_lockout(make_animation_lockout())

    action.execute_func = function(self, user)
		local buster = self:add_attachment("BUSTER")
		buster:sprite():set_texture(BUB_BUSTER_TEXTURE, true)
		buster:sprite():set_layer(-1)
		
		local buster_anim = buster:get_animation()
		buster_anim:load(_modpath.."chargedbusters/bubbler/spread_buster.animation")
		buster_anim:set_state("DEFAULT")
		
		local cannonshot = create_bubbler(user)
		local tile = user:get_tile(user:get_facing(), 1)
		actor:get_field():spawn(cannonshot, tile)
	end
    return action
end

function create_bubbler(user)
	local spell = Battle.Spell.new(user:get_team())
	spell.slide_started = false
	local direction = user:get_facing()
    spell:set_hit_props(
        HitProps.new(
            BUB_DAMAGE, 
            Hit.Impact, 
            Element.None,
            user:get_context(),
            Drag.None
        )
    )
	spell.update_func = function(self, dt) 
        self:get_current_tile():attack_entities(self)
        if self:is_sliding() == false then
            if self:get_current_tile():is_edge() and self.slide_started then 
                self:delete()
            end 
			
            local dest = self:get_tile(direction, 1)
            local ref = self
            self:slide(dest, frames(1), frames(0), ActionOrder.Voluntary, 
                function()
                    ref.slide_started = true 
                end
            )
        end
    end
	spell.collision_func = function(self, other)
		local fx = Battle.Artifact.new()
		fx:set_texture(BUB_BURST_TEXTURE, true)
		fx:get_animation():load(_modpath.."chargedbusters/bubbler/spread_impact.animation")
		fx:get_animation():set_state("DEFAULT")
		fx:get_animation():on_complete(function()
			fx:erase()
		end)
		fx:set_height(-16.0)
		local tile = self:get_current_tile()
		if tile and not tile:is_edge() then
			spell:get_field():spawn(fx, tile)
		end
	end
    spell.attack_func = function(self, other) 
		local fx = Battle.Artifact.new()
		fx:set_texture(BUB_BURST_TEXTURE, true)
		fx:get_animation():load(_modpath.."chargedbusters/bubbler/spread_impact.animation")
		fx:get_animation():set_state("DEFAULT")
		fx:get_animation():on_complete(function()
			fx:erase()
		end)
		fx:set_height(-16.0)
		local tile = self:get_current_tile():get_tile(direction, 1)
		if tile and not tile:is_edge() then
			spell:get_field():spawn(fx, tile)
			tile:attack_entities(self)
		end
		
		local fx2 = Battle.Artifact.new()
		fx2:set_texture(BUB_BURST_TEXTURE, true)
		fx2:get_animation():load(_modpath.."chargedbusters/bubbler/spread_impact.animation")
		fx2:get_animation():set_state("DEFAULT")
		fx2:get_animation():on_complete(function()
			fx2:erase()
		end)
		fx2:set_height(-16.0)
		
		local tile2 = self:get_current_tile():get_tile(direction, 1)
		if tile2 and not tile2:is_edge() then
			spell:get_field():spawn(fx2, tile2)
			tile2:attack_entities(self)
		end
		self:erase()
    end

    spell.delete_func = function(self)
		self:erase()
    end

    spell.can_move_to_func = function(tile)
        return true
    end

	Engine.play_audio(BUB_AUDIO, AudioPriority.High)
	return spell
end