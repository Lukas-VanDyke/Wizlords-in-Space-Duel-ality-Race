extends Node2D

func _ready():
	$LevelGenerator.init_level() # add 5 tiles to game

func _process(delta):
	var player_pos = $Player.position.x / 80
	if $LevelGenerator.current_slice < player_pos + 4:
		$LevelGenerator.add_tile()
