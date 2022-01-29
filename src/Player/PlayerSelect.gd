extends Control

export var start_bg = false setget _start_bg

func _start_bg(var _val):
	if $Background:
		$Background.material.set_shader_param("play", true)
		
func _next_character_pressed():
	return
	
func _prev_character_pressed():
	return
	
func _continue_pressed():
	return
