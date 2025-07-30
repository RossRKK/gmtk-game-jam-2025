extends Node2D

class_name BettingBoard

@onready var bet_text: RichTextLabel = $BetText

signal submit_bet

enum BetType {
	Unset,
	Red,
	Black,
	Odd,
	Even,
}

var bet: int = 1000

var bet_increment: int = 100

var bet_type: BetType = BetType.Unset

func update_bet_text() -> void:
	bet_text.text = "$%d" % bet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_bet_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_submit_bet() -> void:
	if bet_type != BetType.Unset:
		print("Spinning")
		submit_bet.emit(bet, bet_type)
	else:
		print("Must set bet before spinning")
	
func increase_bet() -> void:
	bet += bet_increment
	update_bet_text()
	
func decrease_bet() -> void:
	bet -= bet_increment
	if bet < bet_increment:
		bet = bet_increment
	update_bet_text()
	
func bet_red() -> void:
	bet_type = BetType.Red
	
func bet_black() -> void:
	bet_type = BetType.Black
	
func bet_odd() -> void:
	bet_type = BetType.Odd
	
func bet_even() -> void:
	bet_type = BetType.Even
