extends Node2D

var triggered = false

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D and not triggered:
		$Sprite.visible = false
		triggered = true
		$Explosion.play()
		$Fire.emitting = true
		body.emit_signal("hit_trap", "explosion")


func _on_Trigger_body_entered(body):
	$Sprite.visible = false
	triggered = true
	$Explosion.play()
	$Fire.emitting = true


func _on_DeathZone_body_entered(body):
	if body is KinematicBody2D and triggered:
		body.emit_signal("hit_trap", "explosion")
