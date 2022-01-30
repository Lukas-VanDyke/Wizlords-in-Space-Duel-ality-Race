extends KinematicBody2D

var currentSpeed = 200
var velocity = Vector2()
var initialY = 0

signal hit_trap(trap)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("hit_trap", self, "_hit_trap")
	$AnimatedSprite.play()
	initialY = global_position.y

func set_speed(playerSpeed):
	currentSpeed += playerSpeed

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	velocity.x = currentSpeed
	global_position.y = initialY
	
func _hit_trap(trap):
	if trap != "monster":
		return
		
	remove()
	
func remove():
	get_parent().remove_child(self)
	queue_free()
