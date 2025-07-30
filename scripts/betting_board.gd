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

var max_bet: int = bet

func update_bet_text() -> void:
	bet_text.text = "$%d" % bet

func reset() -> void:
	bet_type = BetType.Unset
	set_button_state()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.spin_complete.connect(reset)
	EventBus.on_money_changed.connect(set_button_state)
	update_bet_text()
	set_button_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_button_state() -> void:
	$SpinButton.disabled = false
	$Down.disabled = false
	$Up.disabled = false
	$Red.disabled = false
	$Black.disabled = false
	
	if bet_type == BetType.Unset:
		$SpinButton.disabled = true
	elif bet_type == BetType.Red:
		$Red.disabled = true
	elif bet_type == BetType.Black:
		$Black.disabled = true
	elif bet_type == BetType.Even:
		$Even.disabled = true
	elif bet_type == BetType.Odd:
		$Odd.disabled = true
		
	if bet + bet_increment > PlayerInventory.available_money:
		$Up.disabled = true
		
	if bet - bet_increment < 0:
		$Down.disabled = true

func on_submit_bet() -> void:
	if bet_type == BetType.Unset:
		print("Must set bet before spinning")
		return
		
	if bet > PlayerInventory.available_money:
		print("Bet higher than available funds")
		return
		
	if bet < 0:
		print("Bet must be positive")
		return
		
	submit_bet.emit(bet, bet_type)
		
	
func increase_bet() -> void:
	bet += bet_increment
	update_bet_text()
	set_button_state()
	
func decrease_bet() -> void:
	bet -= bet_increment
	if bet < bet_increment:
		bet = bet_increment
	update_bet_text()
	set_button_state()
	
func bet_red() -> void:
	bet_type = BetType.Red
	set_button_state()
	
func bet_black() -> void:
	bet_type = BetType.Black
	set_button_state()
	
func bet_odd() -> void:
	bet_type = BetType.Odd
	set_button_state()
	
func bet_even() -> void:
	bet_type = BetType.Even
	set_button_state()
