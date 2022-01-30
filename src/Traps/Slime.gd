extends Node2D

const FireBlam = preload("res://Items/FireBlam.gd")
const IceBlam = preload("res://Items/IceBlam.gd")

signal hit

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		emit_signal("hit", body)
		
	if body is FireBlam or body is IceBlam:
		kill()
		
func kill():
	get_parent().remove_child(self)
	queue_free()
