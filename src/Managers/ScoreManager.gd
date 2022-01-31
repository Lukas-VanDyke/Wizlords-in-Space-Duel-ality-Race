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
	
func begin():
	pass

func get_score():
	var trap_counts = WizLord.get_trap_counts()
	var trap_freqs = WizLord.get_traps()
	var score = 0
	for key in trap_counts:
		if key == "Traps": continue
		score += trap_values[key] * trap_counts[key]
	# There is a 20% bonus for overall trap frequency 
	return score * (1+trap_freqs["Traps"] / 500)

func _continue_pressed():
	WizLord.play_one_shot("continue")
	WizLord.wizload("res://Menus/MainMenu.tscn")


func _on_Retry_pressed():
	WizLord.play_one_shot("continue")
	WizLord.wizload("res://Managers/GameManager.tscn")
