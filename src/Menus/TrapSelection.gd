extends Control

func begin():
	pass

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
