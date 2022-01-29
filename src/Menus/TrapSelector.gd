extends Control

export(String, "Spike", "Ice", "Lava", "Traps") var item
export(Dictionary) var itemMap

export var freq = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Item.texture = itemMap[item]
	$Item/Label/Slider.value = freq

func _on_Slider_value_changed(value):
	$Item/Label.text = str(value)
	freq = value
