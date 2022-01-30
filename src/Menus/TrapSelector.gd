extends Control


onready var spike_tile = load("res://Art/Traps/Spike.tres")
onready var lava_tile = load("res://Art/Traps/Lava.tres")
onready var ice_tile = load("res://Art/Traps/Ice.tres")
onready var magic_missile_tile = load("res://Art/Traps/Magic Missile.tres")
onready var monster_tile = load("res://Art/Traps/Monster.tres")
onready var wind_tile = load("res://Art/Traps/Wind.tres")
onready var crate_tile = load("res://Art/Traps/Crate.tres")
onready var traps_tile = load("res://Art/Traps/Traps.tres")

export(String, "Spike", "Lava", "Ice", "Magic Missile", "Monster", "Wind", "Crate", "Traps") var item


export var freq = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	match item:
		"Spike":
			$Item.texture = spike_tile
		"Lava":
			$Item.texture = lava_tile
		"Ice":
			$Item.texture = ice_tile
		"Magic Missile":
			$Item.texture = magic_missile_tile
		"Monster":
			$Item.texture = monster_tile
		"Wind":
			$Item.texture = wind_tile
		"Crate":
			$Item.texture = crate_tile
		"Traps":
			$Item.texture = traps_tile

	$Item/Label/Slider.value = freq
	$Item/Label.text = str(freq)

func _on_Slider_value_changed(value):
	$Item/Label.text = str(value)
	freq = value
