extends LineEdit

signal legoo

func _input(ev):
	if ev is InputEventKey:
		self.grab_focus()

func _on_Button_pressed():
	emit_signal("legoo")

func _on_TypeStart_text_changed(new_text):
	if new_text.to_lower() == "start":
		emit_signal("legoo")
