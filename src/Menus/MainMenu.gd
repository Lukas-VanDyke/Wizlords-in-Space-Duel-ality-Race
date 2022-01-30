extends Control

export var start_bg = false setget _start_bg

func begin():
	pass

func _start_bg(var _val):
	if $Background:
		$Background.material.set_shader_param("play", true)

func _on_LineEdit_text_changed(new_text):
	if new_text.to_lower() == "start":
		WizLord.play_one_shot("continue")
		WizLord.wizload("res://Player/PlayerSelect.tscn")

