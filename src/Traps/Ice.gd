extends Node2D

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "ice_start")


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "ice_end")
