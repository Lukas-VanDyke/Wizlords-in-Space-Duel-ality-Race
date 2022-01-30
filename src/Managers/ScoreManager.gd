extends Control

export(String) var currency = "Wizaridoos"

var trap_values = {
	"Spike": 0.9,
	"Lava": 0.7,
	"Ice": 0.4,
	"Magic Missile": 1,
	"Monster": 0.9,
	"Wind": 0.2,
	"Crate": 0.8
}

func _ready():
	$ScoreText.text = str(get_score()) + " " + currency

func get_score():
	var trap_counts = WizLord.get_trap_counts()
	var trap_freqs = WizLord.get_traps()
	var score = 0
	for key in trap_counts:
		if key == "Traps": continue
		score += trap_values[key] * trap_counts[key]
	return score * trap_freqs["Traps"] / 100

func _continue_pressed():
	WizLord.wizload("res://Menus/MainMenu.tscn")


func _on_Retry_pressed():
	WizLord.wizload("res://Managers/GameManager.tscn")
