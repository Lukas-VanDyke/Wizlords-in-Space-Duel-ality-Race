extends Control

var current_playing = null

func play_scene(scene):
	var playNext = get_player(scene)
	
	if playNext != current_playing:
		if current_playing != null:
			current_playing.stop()
			
		current_playing = playNext
		current_playing.play()
		
func get_player(scene):
	if scene == "res://Menus/MainMenu.tscn":
		return get_node("MainMenu")
	elif scene == "res://Player/PlayerSelect.tscn":
		return get_node("MainMenu")
	elif scene == "res://Menus/TrapSelection.tscn":
		return get_node("TrapSelection")
	elif scene == "res://Managers/GameManager.tscn":
		return get_node("Gameplay")
	elif scene == "res://Managers/ScoreManager.tscn":
		return get_node("Score")
