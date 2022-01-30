extends Node

onready var stone_tile = load("res://Traps/Stone.tscn")
onready var spike_tile = load("res://Traps/Spikes.tscn")
onready var lava_tile = load("res://Traps/Lava.tscn")
onready var ice_tile = load("res://Traps/Ice.tscn")
onready var magic_missile_tile = load("res://Traps/Magic Missile.tscn")
onready var monster_tile = load("res://Traps/Monster.tscn")
onready var wind_tile = load("res://Traps/Wind.tscn")
onready var crate_tile = load("res://Traps/Crate.tscn")

var trap_dict = null
var trap_frequency = null

var current_slice = 0
export var y_pos = 500

# Called when the node enters the scene tree for the first time.
func begin():
	randomize()
	trap_dict = WizLord.get_traps()
	var total_frequency = 0
	trap_frequency = trap_dict["Traps"]
	for key in trap_dict:
		if key == "Traps": continue
		total_frequency += trap_dict[key]
	if total_frequency == 0:
		total_frequency = 1
	for key in trap_dict:
		if key == "Traps": continue
		trap_dict[key] = 100 * (trap_dict[key] / total_frequency)

func init_level():
	for i in range(15):
		var tile = stone_tile.instance()
		tile.position.x = i * 80
		tile.position.y = y_pos
		add_child(tile)
	current_slice = 15

func get_next_tile():
	if randf() * 100 > trap_frequency:
		return stone_tile.instance()
	else:
		var tile = randf() * 100

		if tile < trap_dict["Spike"]:
			return spike_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"]:
			return lava_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"] + trap_dict["Magic Missile"]:
			return magic_missile_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"] + trap_dict["Magic Missile"] + trap_dict["Monster"]:
			return monster_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"] + trap_dict["Magic Missile"] + trap_dict["Monster"] + trap_dict["Wind"]:
			return wind_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"] + trap_dict["Magic Missile"] + trap_dict["Monster"] + trap_dict["Wind"] + trap_dict["Crate"]:
			return crate_tile.instance()
		else:
			return ice_tile.instance()
	

func add_tile():
	var tile = get_next_tile()
	tile.position.y = y_pos
	tile.position.x = current_slice * 80 # may need to change
	add_child(tile)
	current_slice += 1
	
