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
	$Player.connect("use_jump", self, "use_jump")
	$Player.connect("try_double_jump", self, "try_double_jump")
	
	$PlayerUI/DoubleJump/CenterContainer/VBoxContainer/Label.text = "Air Jump\n%s" % jumps
	$PlayerUI/Ward/CenterContainer/VBoxContainer/Label.text = "Ward\n%s" % wards
	$PlayerUI/BlamBlam/CenterContainer/VBoxContainer/Label.text = "Blam Blam\n%s" % blams
	
	var vp_size = get_tree().root.get_viewport().size
	var vp_scale = vp_size / Vector2(1024, 600)
	$BG1.scale.y = vp_scale.y
	$BG2.scale.y = vp_scale.y
	$BG1.material.set_shader_param("scale", vp_scale)

func begin():
	if WizLord.show_gameplay_tutorial:
		$PlayerUI/Tutorial.visible = true
		WizLord.show_gameplay_tutorial = false
	else:
		actual_begin()
	
func actual_begin():
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
	$PlayerUI/DoubleJump/CenterContainer/VBoxContainer/Label.text = "Air Jump\n%s" % jumps
	
func use_jump():
	jumps -= 1
	$PlayerUI/DoubleJump/CenterContainer/VBoxContainer/Label.text = "Air Jump\n%s" % jumps
	
	if jumps == 0:
		$PlayerUI/DoubleJump.disabled = true
	
func add_ward():
	wards += 1
	$PlayerUI/Ward.disabled = false
	$PlayerUI/Ward/CenterContainer/VBoxContainer/Label.text = "Ward\n%s" % wards
	
func use_ward():
	wards -= 1
	$PlayerUI/Ward/CenterContainer/VBoxContainer/Label.text = "Ward\n%s" % wards
	
	if wards == 0:
		$PlayerUI/Ward.disabled = true
	
func add_blam():
	blams += 1
	$PlayerUI/BlamBlam.disabled = false
	$PlayerUI/BlamBlam/CenterContainer/VBoxContainer/Label.text = "Blam Blam\n%s" % blams
	
func use_blam():
	blams -= 1
	$PlayerUI/BlamBlam/CenterContainer/VBoxContainer/Label.text = "Blam Blam\n%s" % blams
	
	if blams == 0:
		$PlayerUI/BlamBlam.disabled = true
		
func try_double_jump():
	if jumps > 0:
		$Player.double_jump()


func _on_Tutorial_tutorial_done():
	actual_begin()

func _physics_process(delta):
	if Input.is_action_just_pressed("Ward") and wards > 0:
		use_ward()
		$Player.start_ward()
	if Input.is_action_just_pressed("Blam") and blams > 0:
		use_blam()
		$Player.send_blam()
