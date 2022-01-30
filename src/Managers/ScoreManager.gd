extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _continue_pressed():
	WizLord.wizload("res://Menus/MainMenu.tscn")


func _on_Retry_pressed():
	WizLord.wizload("res://Managers/GameManager.tscn")
