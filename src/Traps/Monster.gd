extends Node2D

onready var slime = load("res://Traps/Slime.tscn")
onready var mushroom = load("res://Traps/Mushroom.tscn")

var monster = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if randf() > 0.5:
		monster = slime.instance()
	else:
		monster = mushroom.instance()
	monster.position.y = -80
	add_child(monster)
	monster.connect("hit", self, "_hit_monster")

func _hit_monster(body):
	body.emit_signal("hit_trap", "monster")
