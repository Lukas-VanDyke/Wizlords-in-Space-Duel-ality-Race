extends Node2D

var begun = false

var jumps = 0
var wards = 0
var blams = 0

func _ready():
	$PlayerUI/DoubleJump.disabled = true
	$PlayerUI/Ward.disabled = true
	$PlayerUI/BlamBlam.disabled = true
	
	$LevelGenerator.init_level() # add start tiles to game
	$Player.connect("collect_ward", self, "add_ward")
	$Player.connect("collect_jump", self, "add_jump")
	$Player.connect("collect_blam", self, "add_blam")
	
	$PlayerUI/DoubleJump/CenterContainer/Label.text = "%s" % jumps
	$PlayerUI/Ward/CenterContainer/Label.text = "%s" % wards
	$PlayerUI/BlamBlam/CenterContainer/Label.text = "%s" % blams

func begin():
	$LevelGenerator.begin()
	$Player.begin()
	begun = true

func _process(delta):
	if not begun: return

	var player_pos = $Player.position.x / 80
	if $LevelGenerator.current_slice < player_pos + 15:
		$LevelGenerator.add_tile()
	if $Player.position.x > $BG1.position.x + 2000:
		$BG1.position.x += 5000 
	if $Player.position.x > $BG2.position.x + 2000:
		$BG2.position.x += 5000
		
func add_jump():
	jumps += 1
	$PlayerUI/DoubleJump.disabled = false
	$PlayerUI/DoubleJump/CenterContainer/Label.text = "%s" % jumps
	
func use_jump():
	jumps -= 1
	$PlayerUI/DoubleJump/CenterContainer/Label.text = "%s" % jumps
	
	if jumps == 0:
		$PlayerUI/DoubleJump.disabled = true
	
func add_ward():
	wards += 1
	$PlayerUI/Ward.disabled = false
	$PlayerUI/Ward/CenterContainer/Label.text = "%s" % wards
	
func use_ward():
	wards -= 1
	$PlayerUI/Ward/CenterContainer/Label.text = "%s" % wards
	
	if wards == 0:
		$PlayerUI/Ward.disabled = true
	
func add_blam():
	blams += 1
	$PlayerUI/BlamBlam.disabled = false
	$PlayerUI/BlamBlam/CenterContainer/Label.text = "%s" % blams
	
func use_blam():
	blams -= 1
	$PlayerUI/BlamBlam/CenterContainer/Label.text = "%s" % blams
	
	if blams == 0:
		$PlayerUI/BlamBlam.disabled = true
