extends Node

onready var music_scene = load("res://Managers/MusicManager.tscn")
var music_manager = null
var show_selection_tutorial = true

var current_scene = null
var current_traps = {"Traps": 20, "Wind": 1, "Spike": 1, "Lava": 1, "Ice":100, "Magic Missile":1, "Monster":1, "Crate":1}
var trap_counts = {"Traps": 20, "Wind": 1, "Spike": 1, "Lava": 1, "Ice":100, "Magic Missile":1, "Monster":1, "Crate":1}
var current_player_sprite = 0

var shouldGhost = false

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func wizload(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path)
	
func play_one_shot(oneShot):
	music_manager.play_one_shot(oneShot)

func get_traps():
	return current_traps
func set_traps(traps: Dictionary):
	current_traps = traps
	
func get_trap_counts():
	return trap_counts
func set_trap_counts(new_counts):
	trap_counts = new_counts
	
func set_player_sprite(newSprite):
	current_player_sprite = newSprite
	
func get_player_sprite():
	return current_player_sprite
	
func set_should_ghost(ghost):
	shouldGhost = ghost
	
func get_should_ghost():
	return shouldGhost

func _deferred_goto_scene(path):
	if music_manager == null:
		music_manager = music_scene.instance()
		get_tree().get_root().add_child(music_manager)
	
	# Make sure that the frame is finished drawing before we start the transation
#	yield(VisualServer, "frame_post_draw")
	var screenshot = get_viewport().get_texture().get_data()
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	transition(screenshot)
	music_manager.play_scene(path)

func transition(screenshot):
	var tween = Tween.new()
	current_scene.add_child(tween)
	var canvas_layer = CanvasLayer.new()
	current_scene.add_child(canvas_layer)
	var old_scene = TextureRect.new()
	canvas_layer.add_child(old_scene)
	
	## For some reason the screenshot is flipped when added to the scene
	# this line pre-flips it so that it's upright
	screenshot.flip_y()

	var tex = ImageTexture.new()
	tex.create_from_image(screenshot)
	old_scene.texture = tex
	
	tween.interpolate_property(old_scene, "rect_position:x", old_scene.rect_position.x, -1200, 1, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.start()
	# Might want to delay the actual start until this is done
	tween.connect("tween_all_completed", current_scene, "begin")
