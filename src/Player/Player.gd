extends KinematicBody2D

export(Array, Texture) var PossibleTextures
var currentTexture = 0

enum PositionState { Floor, Air }
var currentPositionState

var currentSpeed
export (int) var startSpeed = 400
export (int) var speedIncrease = 35
export (int) var gravity = 2500
export (int) var jumpHeight = 1000

var velocity = Vector2()
var jumpNext = false

signal hit_trap(trap)

func _ready():
	connect("hit_trap", self, "_hit_trap")
	$PlayerSprite.set_texture(PossibleTextures[currentTexture])
	$PlayerSprite/AnimationPlayer.play("run")
	
	currentSpeed = startSpeed
	velocity.x = currentSpeed

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

func _physics_process(delta):
	if currentPositionState == PositionState.Air:
		velocity.y += gravity * delta
	
	get_input()
	move(delta)
	play_state_animation()
	jumpNext = false
		
func get_input():
	if (Input.is_action_just_pressed("jump") or jumpNext) and can_jump():
		velocity.y = -jumpHeight

#Move the player
func move(delta):
	var collision_info = move_and_collide(velocity * delta)
	velocity.x = currentSpeed
	
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
		$PlayerSprite/AnimationPlayer.play("run")

func _hit_trap(var trap):
	print(trap)
