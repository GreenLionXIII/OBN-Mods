local battle_helpers = include("battle_helpers.lua")
local character_info = {name = "GutsMan V1", hp = 300,height=80}


local damage_shockwave = 20
local damage_fist = 30
local damage_slam = 20
local damage_guts_barrage = 0
local wait_length = 30 -- lower is quicker
local fist_speed = 4  -- lower is quicker
local shock_chance = 2 -- higher means more punches
local shockwave_animation = _modpath.."shockwave.animation"
local gutsman_animation = _modpath.."battle.animation"


local GUTSMAN_TEXTURE = Engine.load_texture(_modpath .. "battle.png")
local wave_sfx = Engine.load_audio(_modpath .. "shockwave.ogg")
local punch_sfx = Engine.load_audio(_modpath .. "punch.ogg")
local crack_sfx = Engine.load_audio(_modpath .. "crack.ogg")
local wave_texture = Engine.load_texture(_modpath .. "shockwave.png")
local fist_texture = Engine.load_texture(_modpath .. "fist.png")



local move_counter = 0
local attack_counter = 0
local which_attack = 0
local used_guts_barrage = true
local in_guts_barrage = false
local punch_counter = 0

function package_init(self)

    -- Required function, main package information

    -- Load character resources
	move_counter = 0
	attack_counter = 0
	which_attack = 0
	used_guts_barrage = true
	punch_counter = 0
	
	if self:get_rank() == Rank.V2 then
		damage_shockwave = 40
		damage_fist = 60
		damage_slam = 40
		damage_guts_barrage = 0
		wait_length = 25 -- lower is quicker
		fist_speed = 3  -- lower is quicker
		shock_chance = 3
		used_guts_barrage = true
		shockwave_animation = _modpath.."shockwavev2.animation"
		gutsman_animation = _modpath.."battlev2.animation"
		character_info = {name = "GutsMan V", hp = 700,height=80}
		
	elseif self:get_rank() == Rank.V3 then
		damage_shockwave = 100
		damage_fist = 150
		damage_slam = 100
		damage_guts_barrage = 150
		wait_length = 20 -- lower is quicker
		fist_speed = 2 -- lower is quicker
		shock_chance = 4
		used_guts_barrage = false
		shockwave_animation = _modpath.."shockwavev3.animation"
		gutsman_animation = _modpath.."battlev3.animation"
		character_info = {name = "GutsMan V", hp = 900,height=80}
	
	elseif self:get_rank() == Rank.SP then
		damage_shockwave = 200
		damage_fist = 300
		damage_slam = 200
		damage_guts_barrage = 300
		wait_length = 15 -- lower is quicker
		fist_speed = 1 -- lower is quicker
		shock_chance = 5
		used_guts_barrage = false
		shockwave_animation = _modpath.."shockwavev4.animation"
		gutsman_animation = _modpath.."battlev4.animation"
		character_info = {name = "GutsMan ", hp = 2000,height=80}
	end
	
	
	
    local base_animation_path = gutsman_animation
	self:set_texture(GUTSMAN_TEXTURE, true)
    self.animation = self:get_animation()
    self.animation:load(base_animation_path)

    -- Load extra resources

    -- Set up character meta
    self:set_name(character_info.name)
    self:set_health(character_info.hp)
    self:set_height(character_info.height)
    self:share_tile(false)
    self:set_explosion_behavior(4, 1, false)
    self:set_offset(0, 0)
	self:set_facing(Direction.Right)

	self.can_move_to_func = function(tile)
		if not tile:is_walkable() or tile:get_team() ~= self:get_team() or tile:is_reserved({ self:get_id(), self._reserver }) then
		  return false
		end

		local has_character = false

		tile:find_characters(function(c)
		  if c:get_id() ~= self:get_id() then
			has_character = true
		  end
		  return false
		end)

		return not has_character
	end
	
	
	self.can_move_to_func_front_row = function(tile)
		if not tile:is_walkable() or tile:get_team() ~= self:get_team() or tile:is_reserved({ self:get_id(), self._reserver }) then
		  return false
		end

		local has_character = false

		tile:find_characters(function(c)
			if c:get_id() ~= self:get_id() then
				has_character = true
			end
			return false
		end)

		if tile:get_tile(Direction.Left,1):get_team() == self:get_team() then
			has_character = true
		end

		return not has_character


		
	end
	
	
	self.can_move_to_func_target_enemy = function(tile)
		
		if not tile:is_walkable() or tile:get_team() ~= self:get_team() or tile:is_reserved({ self:get_id(), self._reserver }) then
		  return false
		end

		local has_enemy = false
		local x = 0
		while x < 6 do 
			if tile:get_tile(Direction.Left, x):is_edge() then
				return has_enemy
			end
			tile:get_tile(Direction.Left, x):find_characters(function(c)
				if c:get_id() ~= self:get_id() then
					has_enemy = true
				end
				return false
			end)
			x = x + 1
		end
		return has_enemy


		
	end
	
	
	

    -- Initial state
    idle(self)
	
	
end

idle = function(self)
	self.animation:set_state("IDLE")
    self.animation:set_playback(Playback.Loop)
    self.frames_between_actions = 40 
    self.cascade_frame_index = 5 --lower = faster shockwaves
    self.ai_wait = self.frames_between_actions
    self.ai_taken_turn = false
	local wait_time = 0
	self.update_func = function ()
		wait_time = wait_time + 1

		if wait_time < wait_length then
		  return
		end

		self.update_func = function() end
		
		local move_or_attack = math.random(1,8)
		if move_or_attack == 8 or move_counter > 4 then
			attack(self)
		elseif attack_counter > 4 then
			move_smash(self)
		elseif self:get_health() <= character_info.hp / 2 and used_guts_barrage == false then
			guts_barrage(self)
		else
			move(self)
		end
		
	end
end


function move(self)

	move_counter = move_counter + 1

	local anim = self:get_animation()
	anim:set_state("TELEPORT_OUT")
	anim:on_complete(function()
		
		--anim:set_playback(Playback.Once)

		local target_tile = find_valid_move_location(self)
		--character:toggle_hitbox(false)

		self:slide(target_tile, frames(0), frames(0), ActionOrder.Voluntary, function()
		end)
		
		anim:set_state("TELEPORT_IN")
		anim:on_complete(function()
				idle(self)
		end)

	end)
	return
end

function guts_barrage(self)
	in_guts_barrage = true
	local green = Color.new( 102, 255, 0, 255 )
	local currentcolor = self:get_color()
	print("in guts barrage")
	local guarding_defense_rule = Battle.DefenseRule.new(0,DefenseOrder.Always)
	guarding_defense_rule.can_block_func = function(judge,self)
        judge:block_impact()
        judge:block_damage()
	end
	local green_counter = true
	self.update_func = function()
			self:set_color(green)
	end

	self:add_defense_rule(guarding_defense_rule)
	if punch_counter < 10 then
		local anim = self:get_animation()
		anim:set_state("PUNCH")
		
		self:toggle_counter(true)
		anim:on_complete(function()
			self:toggle_counter(false)
			local cannonshot = spawn_fist(self)
			local tile = self:get_tile(Direction.Left, 1)
			self:get_field():spawn(cannonshot, tile)
			anim:set_state("TELEPORT_OUT")
			anim:on_complete(function()
				--anim:set_playback(Playback.Once)
				local target_tile = find_valid_move_location(self)
				--character:toggle_hitbox(false)
				self:slide(target_tile, frames(0), frames(0), ActionOrder.Voluntary, function()
				end)
				anim:set_state("TELEPORT_IN")
					punch_counter = punch_counter + 1
					guts_barrage(self)
			end)

		end)		
	end			
	
	which_attack = 0
	move_counter = 0
	
	if punch_counter >= 10 then 
		used_guts_barrage = true
		self:remove_defense_rule(guarding_defense_rule)
		self:set_color(currentcolor)
		in_guts_barrage = false
		idle(self)
	end
return
end





function attack(self)
	local anim = self:get_animation()
	move_counter = 0
	if which_attack == 3 then
		self:toggle_counter(true)
		attack_counter = 0
		anim:set_state("SLAM")
		anim:on_complete(function()
			self:toggle_counter(false)
			if self:get_tile(Direction.Left,1):is_walkable() then
				crack_tiles(self)
			end
			which_attack = 0
			anim:set_state("SLAM_DELAY")
			anim:on_complete(function()
				idle(self)
			end)
		end)
	else
		which_attack = math.random(1,shock_chance)
		
		if which_attack == 1 then
			anim:set_state("SHOCKWAVE")
			self:toggle_counter(true)
			anim:on_complete(function()
				self:toggle_counter(false)
				spawn_shockwave(self, self:get_team(), self:get_field(), self:get_tile(Direction.Left, 1), Direction.Left, damage_shockwave, wave_texture, wave_sfx, 5)
				attack_counter = attack_counter + 1
				which_attack = 0
				idle(self)
			end)
			
		
		else
			anim:set_state("PUNCH")
			self:toggle_counter(true)
			anim:on_complete(function()
				self:toggle_counter(false)
				attack_counter = attack_counter + 1
				which_attack = 0
				local cannonshot = spawn_fist(self)
				local tile = self:get_tile(Direction.Left, 1)
				self:get_field():spawn(cannonshot, tile)
				idle(self)
				
			end)
		end
	end
	
	
	
return
end

	
function move_smash(self)

	move_counter = move_counter + 1

	local anim = self:get_animation()
	anim:set_state("TELEPORT_OUT")
	anim:on_complete(function()
		
		--anim:set_playback(Playback.Once)

		local target_tile = find_valid_move_location_front_row(self)
		--character:toggle_hitbox(false)

		self:slide(target_tile, frames(0), frames(0), ActionOrder.Voluntary, function()
		end)
		
		anim:set_state("TELEPORT_IN")
		anim:on_complete(function()
			which_attack = 3
			attack(self)
		end)

	end)
	return	
end
	
	
	
	


function find_valid_move_location(self)
  
  local field = self:get_field()

  local tiles = field:find_tiles(function(tile)
    if math.random(1,5) == 1 or move_counter == 5 then
		return self.can_move_to_func_target_enemy(tile)
	else
		return self.can_move_to_func(tile)
	end
  end)

  local target_tile = tiles[math.random(#tiles)]
  local start_tile = self:get_tile()

  if #tiles > 1 then
    while target_tile == start_tile do
      -- pick another, don't try to jump on the same tile if it's not necessary
      target_tile = tiles[math.random(#tiles)]
    end
  end

  return target_tile
end


function find_valid_move_location_front_row(self)
  local field = self:get_field()

  local tiles = field:find_tiles(function(tile)
    return self.can_move_to_func_front_row(tile)
  end)

  local target_tile = tiles[math.random(#tiles)]
  local start_tile = self:get_tile()

  if #tiles > 1 then
    while target_tile == start_tile do
      -- pick another, don't try to jump on the same tile if it's not necessary
      target_tile = tiles[math.random(#tiles)]
    end
  end

  return target_tile
end









































function find_target(self)
    local field = self:get_field()
    local team = self:get_team()
    local target_list = field:find_characters(function(other_character)
        return other_character:get_team() ~= team
    end)
    if #target_list == 0 then
        debug_print("No targets found!")
        return
    end
    local target_character = target_list[1]
    return target_character
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
    end

    spawn_next()
end

function spawn_fist(user)
	Engine.play_audio(punch_sfx, AudioPriority.Highest)
    local spell = Battle.Spell.new(user:get_team())
    spell:set_texture(fist_texture, true)
    spell:highlight_tile(Highlight.Solid)
	spell:set_offset(0.0, 0.0)
	spell:never_flip(true)
	local direction = Direction.Left
    spell.slide_started = false
	
    if in_guts_barrage == true then
		spell:set_hit_props(
			HitProps.new(
				damage_guts_barrage, 
				Hit.Impact | Hit.Flinch | Hit.Flash, 
				Element.None,
				user:get_context(),
				Drag.None
			)
		)
	else
		spell:set_hit_props(
			HitProps.new(
				damage_fist, 
				Hit.Impact | Hit.Flinch | Hit.Flash, 
				Element.None,
				user:get_context(),
				Drag.None
			)
		)
	end
	
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

function crack_tiles(self)
	Engine.play_audio(crack_sfx, AudioPriority.Highest)
	local field = self:get_field()
	local column = 1
	local row = 1
	
	local hit = create_hit(self, props)
	local tile = self:get_tile(Direction.Left, 1)
	self:get_field():spawn(hit, tile)
	
	while column < 7 do
		while row < 4 do
			if field:tile_at(column, row):get_team() ~= self:get_team() then
				if field:tile_at(column, row):is_cracked() then
					field:tile_at(column, row):set_state(TileState.Broken)
				elseif field:tile_at(column, row):is_hole() then
					--do Nothing
				else
					field:tile_at(column, row):set_state(TileState.Cracked)
				end
			end
			row = row + 1
		end
		column = column + 1
		row = 0
	end
	return
end


function create_hit(user, props)
	local spell = Battle.Spell.new(user:get_team())
	--spell:set_texture(hit_texture, true)
	--spell:set_facing(user:get_facing())
	--spell:highlight_tile(Highlight.Flash)
	spell:set_hit_props(
		HitProps.new(
			damage_slam,
			Hit.Impact | Hit.Flinch | Hit.Flash,
			Element.Sword,
			user:get_context(),
			Drag.None
		)
	)
	local do_once = true
	
	spell.update_func = function(self, dt)
		if do_once then 
			self:get_tile():attack_entities(self)
			self:erase()
		end
		do_once = false

	end
	spell.attack_func = function(self, other) 
        self:erase()
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
	return spell
end