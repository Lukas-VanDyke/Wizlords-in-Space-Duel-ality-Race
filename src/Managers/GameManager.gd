extends Node2D

var begun = false

func _ready():
	$LevelGenerator.init_level() # add start tiles to game

func begin():
	$LevelGenerator.begin()
	$Player.begin()
	begun = true

func _process(delta):
	if not begun: return

	var player_pos = $Player.position.x / 80
	if $LevelGenerator.current_slice < player_pos + 10:
		$LevelGenerator.add_tile()
	if $Player.position.x > $BG1.position.x + 2000:
		$BG1.position.x += 5000 
	if $Player.position.x > $BG2.position.x + 2000:
		$BG2.position.x += 5000
