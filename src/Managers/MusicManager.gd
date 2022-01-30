extends Control

var current_playing = null
var music_dict = null
var one_shot_dict = null

func _ready():
	music_dict = {
		"res://Menus/MainMenu.tscn" : $MainMenu,
		"res://Player/PlayerSelect.tscn" : $MainMenu,
		"res://Menus/TrapSelection.tscn" : $TrapSelection,
		"res://Managers/GameManager.tscn" : $Gameplay,
		"res://Managers/ScoreManager.tscn" : $Score
	}
	
	one_shot_dict = {
		"continue" : $OneShots/Continue
	}

func play_scene(scene):
	var playNext = music_dict[scene]
	
	if playNext != current_playing:
		if current_playing != null:
			current_playing.stop()
			
		current_playing = playNext
		current_playing.play()
		
func play_one_shot(oneShot):
	var player = one_shot_dict[oneShot]
	player.play()
