extends LineEdit

export(bool) var skip_type = true

signal legoo
var os = OS.get_name()

func _input(ev):
	if ev is InputEventKey:
		self.grab_focus()

func _on_Button_pressed():
	if skip_type or os == "Android" or os == "iOS":
		emit_signal("legoo")

func _on_TypeStart_text_changed(new_text):
	if new_text.to_lower().strip_edges() == "start":
		emit_signal("legoo")
