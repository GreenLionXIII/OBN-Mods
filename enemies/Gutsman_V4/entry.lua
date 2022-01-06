local package_id = "com.Thor.Gutsman_V4"
local character_id = "com.Thor.enemy.Gutsman_V1"

function package_requires_scripts()
	Engine.requires_character("com.Thor.enemy.Gutsman_V1")
end

function package_init(package)
  package:declare_package_id(package_id)
  package:set_name("GutsMan SP")
  package:set_description("BN3 GutsMan SP (Omega) Battle!")
  package:set_speed(4)
  package:set_attack(300)
  package:set_health(2000)
  package:set_preview_texture_path(_modpath.."previewSP.png")
end

function package_build(mob)
local texPath = _modpath.."background.png"
local animPath = _modpath.."background.animation"
mob:set_background(texPath, animPath, -0.5, -0.5)

local spawner = mob:create_spawner(character_id,Rank.SP)
spawner:spawn_at(5, 2)
end
