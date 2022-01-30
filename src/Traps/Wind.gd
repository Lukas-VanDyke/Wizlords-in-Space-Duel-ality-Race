extends Node2D

export var speed = 150

func _ready():
	speed = rand_range(100, 240)
	$Sprite.position.y = rand_range(-120, -200)
	for child in $Sprite.get_children():
		if child is AnimatedSprite:
			child.frame = int(rand_range(0.0, 13.0))

func _process(delta):
	$Sprite.position.x -= delta * speed

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "wind_start")


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "wind_end")
