-- Special thanks to RogueClaris (Hacker Owl) for helping me with moving Rush off the screen!


nonce = function() end

local BUSTER_SHOT_TEXTURE = Engine.load_texture(_modpath.."Buster_Shot.png")
local MEGAMAN_TEXTURE = Engine.load_texture(_modpath.."Megaman.png")
local BUSTER_SFX = Engine.load_audio(_modpath .. "Buster_Shot.ogg")
local RUSH_SFX = Engine.load_audio(_modpath .. "Rush_Hit.ogg")

local rush_alive = true

function package_init(package) 
    package:declare_package_id("com.Thor.card.GoodRush")
    package:set_icon_texture(Engine.load_texture(_modpath.."icon.png"))
    package:set_preview_texture(Engine.load_texture(_modpath.."preview.png"))
	package:set_codes({'G', 'R'})

    local props = package:get_card_props()
    props.shortname = "GoodRush"
    props.damage = 140
    props.time_freeze = true
    props.element = Element.None
    props.description = "Sends Rush to attack"
	props.card_class = CardClass.Mega
	props.limit = 1
end

function card_create_action(actor, props)
    print("in create_card_action()!")
    local action = Battle.CardAction.new(actor, "PLAYER_IDLE")
	action:set_lockout(make_sequence_lockout())
	
	
	action.execute_func = function(self, user)
		local actor = self:get_actor()
		actor:hide()
        print("in custom card action execute_func()!")
		--user:hide()
		actor:hide()
		local sound_effect = false
		local step1 = Battle.Step.new()
		local field = user:get_field()
		local tile = user:get_tile(user:get_facing(), 0)
		local mega = Battle.Artifact.new()
		local do_once = true
		local do_once_again = true
		local self_variable = self
		rush_alive = true
		step1.update_func = function(self, dt)
				if do_once then
					do_once = false
					mega:set_facing(user:get_facing())
					mega:set_texture(MEGAMAN_TEXTURE, true)
					mega:sprite():set_layer(-2)
					
					local mega_anim = mega:get_animation()
					mega_anim:load(_modpath.."Megaman.animation")
					mega_anim:set_state("Megaman_Spawn")
					mega_anim:refresh(mega:sprite())
					mega_anim:on_complete(function()
						local cannonshot = create_rush(user, props)
						local tile1 = user:get_tile(user:get_facing(), 1)
						mega_anim:set_state("Megaman_Shoot")
						mega_anim:refresh(mega:sprite())
						self_variable:add_anim_action(2, function()
							if sound_effect == false then
								Engine.play_audio(BUSTER_SFX, AudioPriority.Highest)
								sound_effect = true
							end
						end)
						--Engine.play_audio(BUSTER_SFX, AudioPriority.Highest)
						mega_anim:on_complete(function()
							actor:get_field():spawn(cannonshot, tile1)
						end)
					end)
					
					actor:hide()
					field:spawn(mega, tile)
					
				end
				
				if rush_alive == false then
					if do_once_again then
						do_once_again = false
						local mega_anim = mega:get_animation()
						mega_anim:set_state("Megaman_Despawn")
						mega_anim:refresh(mega:sprite())
						mega_anim:on_complete(function()
							mega:erase()
							actor:reveal()
							--user:reveal()
							self:complete_step()
						end)
					end
				end
				
		end
		self:add_step(step1)
			
	end
	return action
	
end



function create_rush(user, props)
    local spell = Battle.Spell.new(user:get_team())
    spell:set_texture(BUSTER_SHOT_TEXTURE, true)
    --spell:highlight_tile(Highlight.Solid)
	spell:set_height(16.0)
	local direction = user:get_facing()
    spell.slide_started = false
	
    spell:set_hit_props(
        HitProps.new(
            props.damage, 
            Hit.Impact | Hit.Flinch | Hit.Flash, 
            Element.None,
            user:get_context(),
            Drag.None
        )
    )
	
    local anim = spell:get_animation()
    anim:load(_modpath.."Buster_Shot.animation")
    anim:set_state("BUSTER_SHOT")
	anim:refresh(spell:sprite())
    spell.update_func = function(self, dt) 
		local offset = self:get_offset()
        self:get_current_tile():attack_entities(self)
        if self:is_sliding() == false then 
			if spell:get_current_tile():is_edge() and self.slide_started then
				if offset.x >= 150 then
					self:delete()
					rush_alive = false
				else
					self:set_offset(offset.x + 5, offset.y)
				end
			end
            local dest = self:get_tile(direction, 1)
            local ref = self
            self:slide(dest, frames(15), frames(0), ActionOrder.Voluntary, 
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
		Engine.play_audio(RUSH_SFX, AudioPriority.Highest)
	end
	
    spell.delete_func = function(self) 
		print("good boy rush")
		self:erase()
    end

    spell.can_move_to_func = function(tile)
        return true
    end

    return spell
end