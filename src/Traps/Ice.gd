extends Node2D

func _ready():
	$Sprite.frame = int(rand_range(4, 10))
	$Sprite.play()

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "ice_start")


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "ice_end")
