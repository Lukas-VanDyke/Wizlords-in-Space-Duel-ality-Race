extends Node2D

export var speed = 250

func _ready():
	pass
	$AnimatedSprite.position.y = rand_range(-120, -200)

func _process(delta):
	$AnimatedSprite.position.x -= delta * speed

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "magic_missile")
