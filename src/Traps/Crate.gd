extends Node2D

var triggered = false
var finished = false

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D and not triggered and not finished:
		$Sprite.play()
		$Sprite/Sprite.play()
		$Sprite/Sprite2.play()
		triggered = true
		$Explosion.play()
		$Fire.emitting = true
		body.emit_signal("hit_trap", "explosion")
		finished = true


func _on_Trigger_body_entered(body):
	$Sprite.play()
	$Sprite/Sprite.play()
	$Sprite/Sprite2.play()
	triggered = true
	$Explosion.play()
	$Fire.emitting = true


func _on_DeathZone_body_entered(body):
	if body is KinematicBody2D and triggered and not finished:
		body.emit_signal("hit_trap", "explosion")
		finished = true
