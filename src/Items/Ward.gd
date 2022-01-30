extends Node2D

func _ready():
	$AnimationPlayer.play("idle")

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		body.emit_signal("collect_ward")
		visible = false
