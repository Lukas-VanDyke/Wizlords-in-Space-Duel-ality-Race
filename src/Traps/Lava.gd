extends Node2D

func _ready():
	$Sprite.frame = int(rand_range(0.0, 5.0))
	$Sprite.play()

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "lava")
