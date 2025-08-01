@tool
class_name BetZone
extends Node2D


signal bet_updated(Bet)

var game: Game = Game.get_instance()

@export var bet_type: Bet.BetType

@export var label_text: String = "Label":
	set(value):
		label_text = value
		if $Label:
			$Label.text = label_text
			

@export var background_colour: Color:
	set(value):
		background_colour = value
		if $BackDrop:
			$BackDrop.color = background_colour


@onready var bet_text: TextEdit = $BetText

var bet_increment: int = 100

var remaining_funds: int = game.player_inventory.available_money

@onready var bet: Bet = Bet.new(0, bet_type):
	set(value):
		bet = value
		update_bet_text()

func update_bet_text() -> void:
	bet_updated.emit(bet)
	bet_text.text = "%d" % bet.bet_amount

func reset() -> void:
	bet = Bet.new(0, bet_type)
	update_bet_text()
	set_button_state()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = label_text
	game.event_bus.spin_complete.connect(reset)
	game.player_inventory.on_money_changed.connect(set_button_state)
	update_bet_text()
	set_button_state()
	
	game.event_bus.spin_complete.connect(unlock)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func lock() -> void:
	$Down.disabled = false
	$Up.disabled = false
	bet_text.editable = false

func unlock() -> void:
	$Down.disabled = true
	$Up.disabled = true
	bet_text.editable = true

func set_button_state() -> void:
	$Down.disabled = false
	$Up.disabled = false

	if bet_increment > remaining_funds:
		$Up.disabled = true
		
	if (bet.bet_amount - bet_increment) < 0:
		$Down.disabled = true
		
	
func increase_bet() -> void:
	bet.bet_amount += bet_increment
	update_bet_text()
	set_button_state()
	
func decrease_bet() -> void:
	bet.bet_amount -= bet_increment
	if bet.bet_amount < 0:
		bet.bet_amount = 0
	update_bet_text()
	set_button_state()


func _on_bet_text_text_changed() -> void:
	bet.bet_amount = int(bet_text.text)

func apply_limit(rf: int) -> void:
	remaining_funds = rf
	set_button_state()
