extends Node2D

class_name BettingBoard

var game: Game = Game.get_instance()

@onready var bet_text: RichTextLabel = $BetText

signal submit_bet(Bet)

var bet_increment: int = 100

var bet: Bet = Bet.new(bet_increment, Bet.BetType.Unset)

func update_bet_text() -> void:
	bet_text.text = "$%d" % bet.bet_amount

func reset() -> void:
	print("Reseting buttons")
	bet = Bet.new(bet_increment, Bet.BetType.Unset)
	set_button_state()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.event_bus.spin_complete.connect(reset)
	game.player_inventory.on_money_changed.connect(set_button_state)
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
	$Odd.disabled = false
	$Even.disabled = false
	
	if bet.bet_type == Bet.BetType.Unset:
		$SpinButton.disabled = true
	elif bet.bet_type == Bet.BetType.Red:
		$Red.disabled = true
	elif bet.bet_type == Bet.BetType.Black:
		$Black.disabled = true
	elif bet.bet_type == Bet.BetType.Even:
		$Even.disabled = true
	elif bet.bet_type == Bet.BetType.Odd:
		$Odd.disabled = true
		
	if bet.bet_amount + bet_increment > game.player_inventory.available_money:
		$Up.disabled = true
		
	if bet.bet_amount - bet_increment < 0:
		$Down.disabled = true

func on_submit_bet() -> void:
	if bet.bet_type == Bet.BetType.Unset:
		print("Must set bet before spinning")
		return
		
	if bet.bet_amount > game.player_inventory.available_money:
		print("Bet higher than available funds")
		return
		
	if bet.bet_amount < 0:
		print("Bet must be positive")
		return
		
	submit_bet.emit(bet)
		
	
func increase_bet() -> void:
	bet.bet_amount += bet_increment
	update_bet_text()
	set_button_state()
	
func decrease_bet() -> void:
	bet.bet_amount -= bet_increment
	if bet.bet_amount < bet_increment:
		bet.bet_amount = bet_increment
	update_bet_text()
	set_button_state()
	
func bet_red() -> void:
	bet.bet_type = Bet.BetType.Red
	set_button_state()
	
func bet_black() -> void:
	bet.bet_type = Bet.BetType.Black
	set_button_state()
	
func bet_odd() -> void:
	bet.bet_type = Bet.BetType.Odd
	set_button_state()
	
func bet_even() -> void:
	bet.bet_type = Bet.BetType.Even
	set_button_state()
