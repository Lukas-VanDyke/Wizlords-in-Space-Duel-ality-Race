extends Control

export var start_bg = false setget _start_bg

export(Array, Texture) var PossibleTextures
var currentTexture = 0

func _ready():
	$CharacterControl/CharacterSprite.set_texture(PossibleTextures[currentTexture])
	
func begin():
	$CharacterControl/CharacterSprite/AnimationPlayer.play("run")

func _start_bg(var _val):
	if $Background:
		$Background.material.set_shader_param("play", true)
		
func _next_character_pressed():
	currentTexture += 1
	if (currentTexture >= PossibleTextures.size()):
		currentTexture = 0
		
	$CharacterControl/CharacterSprite.set_texture(PossibleTextures[currentTexture])
	
func _prev_character_pressed():
	currentTexture -= 1
	if (currentTexture < 0):
		currentTexture = PossibleTextures.size() - 1
		
	$CharacterControl/CharacterSprite.set_texture(PossibleTextures[currentTexture])
	
func _continue_pressed():
	WizLord.set_player_sprite(currentTexture)
	WizLord.wizload("res://Menus/TrapSelection.tscn")
