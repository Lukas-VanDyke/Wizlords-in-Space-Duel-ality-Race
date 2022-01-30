extends Node2D

export var speed = 150

func _ready():
	pass
	$Sprite.position.y = rand_range(-120, -200)

func _process(delta):
	$Sprite.position.x -= delta * speed

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "wind_start")


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		body.emit_signal("hit_trap", "wind_end")
