extends TextureButton

signal tutorial_done
var state = 0

func _on_Tutorial_pressed():
	var children = get_children()
	if state == get_child_count() - 1:
		self.visible = false
		emit_signal("tutorial_done")
	else:
		children[state].visible = false
		state += 1
		children[state].visible = true

