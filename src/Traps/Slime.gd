extends Node2D

signal hit

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		emit_signal("hit", body)
