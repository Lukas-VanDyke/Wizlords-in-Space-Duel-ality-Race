extends Node2D

var begun = false

func _ready():
	$LevelGenerator.init_level() # add 5 tiles to game

func begin():
	$LevelGenerator.begin()
	$Player.begin()
	begun = true

func _process(delta):
	if not begun: return

	var player_pos = $Player.position.x / 80
	if $LevelGenerator.current_slice < player_pos + 10:
		$LevelGenerator.add_tile()
