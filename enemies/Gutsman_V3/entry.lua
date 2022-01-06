local package_id = "com.Thor.Gutsman_V3"
local character_id = "com.Thor.enemy.Gutsman_V1"

function package_requires_scripts()
	Engine.requires_character("com.Thor.enemy.Gutsman_V1")
end

function package_init(package)
  package:declare_package_id(package_id)
  package:set_name("GutsMan V3")
  package:set_description("BN3 Gutsman V3 (Beta) Battle!")
  package:set_speed(3)
  package:set_attack(150)
  package:set_health(900)
  package:set_preview_texture_path(_modpath.."previewV3.png")
end

function package_build(mob)
local texPath = _modpath.."background.png"
local animPath = _modpath.."background.animation"
mob:set_background(texPath, animPath, -0.5, -0.5)

local spawner = mob:create_spawner(character_id,Rank.V3)
spawner:spawn_at(5, 2)
end
