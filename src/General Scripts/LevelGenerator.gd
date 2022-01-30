extends Node

onready var stone_tile = load("res://Traps/Stone.tscn")
onready var spike_tile = load("res://Traps/Spikes.tscn")
onready var lava_tile = load("res://Traps/Lava.tscn")
onready var ice_tile = load("res://Traps/Ice.tscn")
onready var magic_missile_tile = load("res://Traps/Magic Missile.tscn")
onready var monster_tile = load("res://Traps/Monster.tscn")
onready var wind_tile = load("res://Traps/Wind.tscn")
onready var crate_tile = load("res://Traps/Crate.tscn")
onready var feather = load("res://Items/DoubleJump.tscn")
onready var potion = load("res://Items/Ward.tscn")
onready var scroll = load("res://Items/BlamBlam.tscn")

var trap_dict = null
var trap_frequency = null
var trap_count_dict = null

var current_slice = 0
export var y_pos = 500

# Called when the node enters the scene tree for the first time.
func begin():
	randomize()
	trap_dict = WizLord.get_traps()
	trap_count_dict = {}
	var total_frequency = 0
	trap_frequency = trap_dict["Traps"]
	for key in trap_dict:
		if key == "Traps": continue
		total_frequency += float(trap_dict[key])
		trap_count_dict[key] = 0
	if total_frequency == 0:
		total_frequency = 1
	for key in trap_dict:
		if key == "Traps": continue
		trap_dict[key] = 100 * (trap_dict[key] / total_frequency)

func init_level():
	for i in range(-5, 15):
		var tile = stone_tile.instance()
		tile.position.x = i * 80
		tile.position.y = y_pos
		add_child(tile)
	current_slice = 15

func add_bonus(item, dist = 2):
	var bonus = item.instance()
	bonus.position.x = (current_slice - dist - randi() % 4) * 80
	bonus.position.y = y_pos - 120
	add_child(bonus)

func get_next_tile():
	if randf() * 100 > trap_frequency:
		return stone_tile.instance()
	else:
		var tile = randf() * 100

		if tile < trap_dict["Spike"]:
			add_bonus(feather)
			trap_count_dict["Spike"] += 1
			WizLord.set_trap_counts(trap_count_dict)
			return spike_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"]:
			add_bonus(feather)
			trap_count_dict["Lava"] += 1
			WizLord.set_trap_counts(trap_count_dict)
			return lava_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"] + trap_dict["Magic Missile"]:
			add_bonus(potion)
			trap_count_dict["Magic Missile"] += 1
			WizLord.set_trap_counts(trap_count_dict)
			return magic_missile_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"] + trap_dict["Magic Missile"] + trap_dict["Monster"]:
			add_bonus(scroll, 6)
			trap_count_dict["Monster"] += 1
			WizLord.set_trap_counts(trap_count_dict)
			return monster_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"] + trap_dict["Magic Missile"] + trap_dict["Monster"] + trap_dict["Wind"]:
			add_bonus(feather)
			trap_count_dict["Wind"] += 1
			WizLord.set_trap_counts(trap_count_dict)
			return wind_tile.instance()
		elif tile < trap_dict["Spike"] + trap_dict["Lava"] + trap_dict["Magic Missile"] + trap_dict["Monster"] + trap_dict["Wind"] + trap_dict["Crate"]:
			add_bonus(scroll, 6)
			trap_count_dict["Crate"] += 1
			WizLord.set_trap_counts(trap_count_dict)
			return crate_tile.instance()
		else:
			add_bonus(potion)
			trap_count_dict["Ice"] += 1
			WizLord.set_trap_counts(trap_count_dict)
			return ice_tile.instance()
	

func add_tile():
	var tile = get_next_tile()
	tile.position.y = y_pos
	tile.position.x = current_slice * 80 # may need to change
	add_child(tile)
	current_slice += 1
	
