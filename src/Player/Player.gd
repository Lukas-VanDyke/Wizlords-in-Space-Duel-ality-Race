extends KinematicBody2D

onready var FireBlam = load("res://Items/FireBlam.tscn")
onready var IceBlam = load("res://Items/IceBlam.tscn")

export(Array, Texture) var PossibleTextures
var currentTexture = 0

export(Texture) var GhostTexture
export(Texture) var GhostdolfTexture
var shouldGhost = false

enum PositionState { Floor, Air, Dead }
var currentPositionState

var currentSpeed = 0
export (int) var startSpeed = 400
export (int) var speedIncrease = 35
export (int) var gravity = 2500
export (int) var jumpHeight = 1000

var velocity = Vector2()
var jumpNext = false
var begun = false

var iced = false
var slowed = false
var warded = false
var flaming = false

signal hit_trap(trap)
signal collect_ward
signal collect_jump
signal collect_blam

func _ready():
	connect("hit_trap", self, "_hit_trap")
	
	currentTexture = WizLord.get_player_sprite()
	shouldGhost = WizLord.get_should_ghost()
	
	$PlayerSprite.set_texture(PossibleTextures[currentTexture])
	$PlayerSprite/AnimationPlayer.play("run")
	
	$FullWard.play()
	$TransparentWard.play()

func begin():
	currentSpeed = startSpeed
	velocity.x = currentSpeed
	$Camera2D.current = true
	begun = true

#Change the sprite sheet used in the player's animations
func change_sprite(newSprite):
	currentTexture = newSprite
	
	#Ensure the value passed in is not outside the bounds of the possible textures
	if (currentTexture < 0):
		currentTexture = 0
	if (currentTexture >= PossibleTextures.size()):
		currentTexture = PossibleTextures.size() - 1
		
	$PlayerSprite.set_texture(PossibleTextures[currentTexture])

func increase_speed():
	currentSpeed += speedIncrease
	velocity.x = currentSpeed
	
	$IncreaseSpeedTimer.start()
	
func jump():
	jumpNext = true
	
func double_jump():
	velocity.y = -jumpHeight
	$"Sounds/Double Jump".play()
	
func start_ice():
	iced = true
	$IceTimer.start()
	$PlayerSprite/AnimationPlayer.play("ice")
	
func ice_end():
	iced = false
	$IceTimer.stop()
	if currentPositionState != PositionState.Dead:
		$PlayerSprite/AnimationPlayer.play("run")

func start_fire():
	flaming = true
	$FireTimer.start()
	$PlayerSprite/AnimationPlayer.play("fire")
	
func fire_end():
	flaming = false
	$PlayerSprite/AnimationPlayer.play("run")
	if currentPositionState != PositionState.Dead:
		$PlayerSprite/AnimationPlayer.play("run")

func start_ward():
	warded = true
	$FullWard.show()
	$TransparentWard.show()
	$WardTimer.start()
	$Sounds/Ward.play()
	
func ward_end():
	warded = false
	$FullWard.hide()
	$TransparentWard.hide()
	$WardTimer.stop()
	
func send_blam():
	var newBlam = null
	var newX = 40
	
	if currentPositionState == PositionState.Dead:
		return
	elif currentPositionState == PositionState.Air:
		newBlam = FireBlam.instance()
		newX = 80
	elif currentPositionState == PositionState.Floor:
		newBlam = IceBlam.instance()
		
	newBlam.position.x += newX
	add_child(newBlam)
	$"Sounds/Blam Blam".play()

func _physics_process(delta):
	if not begun: return
	if currentPositionState == PositionState.Dead: return
	
	if currentPositionState == PositionState.Air:
		velocity.y += gravity * delta
	
	get_input()
	move(delta)
	play_state_animation()
	jumpNext = false
		
func get_input():
	if (Input.is_action_just_pressed("jump") or jumpNext) and can_jump() and not iced:
		velocity.y = -jumpHeight
		$Sounds/Jump.play()

#Move the player
func move(delta):
	var collision_info = move_and_collide(velocity * delta)
	velocity.x = currentSpeed
	if slowed:
		velocity.x = currentSpeed / 2
	elif flaming:
		velocity .x = currentSpeed * 2
	
	if collision_info:
		set_position_state(collision_info)
		velocity = velocity.slide(collision_info.normal)
	else:
		currentPositionState = PositionState.Air
		
#Set the current position state
func set_position_state(collision):
	if collision.collider.get_collision_layer() == 1:
		var normal = collision.normal
		if normal == Vector2.UP:
			currentPositionState = PositionState.Floor
		else:
			currentPositionState = PositionState.Air
		
		if normal == Vector2.RIGHT:
			velocity.x = 0
			
func can_jump():
	return currentPositionState == PositionState.Floor
	
#Play animation based on the current state
func play_state_animation():
	if flaming:
		$PlayerSprite/AnimationPlayer.play("fire")
	elif (currentPositionState == PositionState.Air and velocity.y < 0):
		$PlayerSprite/AnimationPlayer.play("jump")
	elif (currentPositionState == PositionState.Air and velocity.y >= 0):
		$PlayerSprite/AnimationPlayer.play("fall")
	elif currentPositionState != PositionState.Dead:
		if iced:
			$PlayerSprite/AnimationPlayer.play("ice")
		else:
			$PlayerSprite/AnimationPlayer.play("run")

func _hit_trap(var trap):
	play_hit_sound(trap)
	
	if (trap == "ice_start"):
		start_ice()
	elif (trap == "wind_start"):
		$Sounds/Wind.play()
		slowed = true
	elif (trap == "wind_end"):
		slowed = false
	elif (trap == "lava"):
		start_fire()
	elif (trap == "spikes" or trap == "magic_missile" or trap == "monster" or trap == "explosion"):
		check_end()
		
func play_hit_sound(trap):
	if (trap == "ice_start"):
		$Sounds/Ice.play()
	elif (trap == "wind_start"):
		$Sounds/Wind.play()
	elif (trap == "lava"):
		$Sounds/Lava.play()
	elif (trap == "spikes"):
		$Sounds/Spike.play()
	elif (trap == "magic_missile"):
		$"Sounds/Magic Missile".play()
	elif (trap == "monster"):
		$Sounds/Monster.play()
	elif (trap == "explosion"):
		$Sounds/Explosion.play()
		
func check_end():
	if warded:
		ward_end()
		return
		
	#Check for ghost stuff
	if shouldGhost:
		ghost_time()
		return
	
	death()
	
func ghost_time():
	if currentTexture == PossibleTextures.size() - 1 :
		$PlayerSprite.set_texture(GhostdolfTexture)
	else:
		$PlayerSprite.set_texture(GhostTexture)
		
	shouldGhost = false
	
func death():
	$DeathTimer.start()
	$DeathExplosion.frame = 0
	$DeathExplosion.show()
	$DeathExplosion.play()
	
	$PlayerSprite/AnimationPlayer.play("death")
	currentPositionState = PositionState.Dead
	currentSpeed = 0
	velocity = Vector2(0, 0)
	
func death_explosion_finished():
	$DeathExplosion.hide()
		
func end_game():
	$DeathTimer.stop()
	WizLord.wizload("res://Managers/ScoreManager.tscn")
