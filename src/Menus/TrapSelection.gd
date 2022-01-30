extends Control

func _ready():
	# TODO: This is just for testing
#	begin()
	pass

func begin():
	if WizLord.show_selection_tutorial:
		$Tutorial.visible = true
	WizLord.show_selection_tutorial = false


func _create_level_dict():
	var level_dict = {}
	for trap in $Traps.get_children():
		level_dict[trap.item] = trap.freq
	return level_dict


func _on_TypeStart_legoo():
	WizLord.set_should_ghost($Traps/All.freq == 100)
	WizLord.play_one_shot("continue")
	WizLord.set_traps(_create_level_dict())
	WizLord.wizload("res://Managers/GameManager.tscn")
