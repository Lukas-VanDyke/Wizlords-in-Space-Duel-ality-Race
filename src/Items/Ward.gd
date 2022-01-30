extends Node2D

const FireBlam = preload("res://Items/FireBlam.gd")
const IceBlam = preload("res://Items/IceBlam.gd")
const player = preload("res://Player/Player.gd")

func _ready():
	$AnimationPlayer.play("idle")

func _on_Area2D_body_entered(body):
	if body is player:
		body.emit_signal("collect_ward")
		visible = false
	elif body is KinematicBody2D:
		queue_free()
