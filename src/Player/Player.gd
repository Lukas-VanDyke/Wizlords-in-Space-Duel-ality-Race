extends KinematicBody2D

export(Array, Texture) var PossibleTextures
var currentTexture = 0

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

signal hit_trap(trap)

func _ready():
	connect("hit_trap", self, "_hit_trap")
	
	currentTexture = WizLord.get_player_sprite()
	
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
	
func start_ice():
	iced = true
	$IceTimer.start()
	$PlayerSprite/AnimationPlayer.play("ice")
	
func ice_end():
	iced = false
	$PlayerSprite/AnimationPlayer.play("run")
	$IceTimer.stop()
	
func start_ward():
	warded = true
	$FullWard.show()
	$TransparentWard.show()
	$WardTimer.start()
	
func ward_end():
	warded = false
	$FullWard.hide()
	$TransparentWard.hide()
	$WardTimer.stop()

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

#Move the player
func move(delta):
	var collision_info = move_and_collide(velocity * delta)
	velocity.x = currentSpeed
	if slowed:
		velocity.x = currentSpeed / 2
	
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
	if (currentPositionState == PositionState.Air and velocity.y < 0):
		$PlayerSprite/AnimationPlayer.play("jump")
	elif (currentPositionState == PositionState.Air and velocity.y >= 0):
		$PlayerSprite/AnimationPlayer.play("fall")
	else:
		if iced:
			$PlayerSprite/AnimationPlayer.play("ice")
		else:
			$PlayerSprite/AnimationPlayer.play("run")

func _hit_trap(var trap):
	if (trap == "ice_start"):
		start_ice()
	elif (trap == "wind_start"):
		slowed = true
	elif (trap == "wind_end"):
		slowed = false
	elif (trap == "lava" or trap == "spikes" or trap == "magic_missile" or trap == "monster" or trap == "explosion"):
		check_end()
		
func check_end():
	if warded:
		ward_end()
		return
		
	#Check for ghost stuff
	
	end_game()
	
func death():
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
	death()
	print("dead")
