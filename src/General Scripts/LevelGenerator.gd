extends Node

onready var stone_tile = load("res://Traps/Stone.tscn")
onready var spike_tile = load("res://Traps/Spikes.tscn")

var trap_dict = null
var trap_frequency = null

var current_slice = 0
export var y_pos = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	trap_dict = WizLord.get_traps()
	var total_frequency = 0
	trap_frequency = trap_dict["Traps"]
	for key in trap_dict:
		if key == "Traps": continue
		total_frequency += trap_dict[key]
	for key in trap_dict:
		if key == "Traps": continue
		trap_dict[key] = 100 * (trap_dict[key] / total_frequency)
	init_level()

func init_level():
	for i in range(5):
		var tile = stone_tile.instance()
		tile.position.x = i * 80
		tile.position.y = y_pos
		add_child(tile)
	current_slice = 5

func get_next_tile():
	if randf() * 100 > trap_frequency:
		return stone_tile.instance()
	else:
		var tile = randf() * 100
		return spike_tile.instance()

func add_tile():
	var tile = get_next_tile()
	tile.position.y = y_pos
	tile.position.x = current_slice * 80 # may need to change
	add_child(tile)
	current_slice += 1
	
