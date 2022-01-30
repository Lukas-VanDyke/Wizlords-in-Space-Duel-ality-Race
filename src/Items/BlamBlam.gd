extends Node2D

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		body.emit_signal("collect_blam")
		visible = false
