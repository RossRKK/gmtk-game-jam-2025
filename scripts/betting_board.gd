
extends Node2D

var game: Game = Game.get_instance()

signal submit_bet(bets: Array[Bet])

@onready var bet_zones = [$RedBet, $BlackBet, $EvenBet, $OddBet, $ZeroBet]

var total_bet: int:
	set(value):
		total_bet = value
		limit_bets_to_remaining_funds()
		if $TotalText:
			$TotalText.text = "$%d" % total_bet
		
		
func limit_bets_to_remaining_funds():
	var remaining_funds = game.player_inventory.available_money - total_bet
	if bet_zones:
		for bz in bet_zones:
			var bet_zone = bz as BetZone
			bet_zone.apply_limit(remaining_funds)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.event_bus.spin_complete.connect(spin_complete)
	game.player_inventory.on_money_changed.connect(on_money_changed)
	handle_bet_amount()

func spin_complete():
	handle_bet_amount()
	
func handle_bet_amount():
	var _total_bet := 0.
	if bet_zones:
		for bz in bet_zones:
			var bet_zone = bz as BetZone
			_total_bet += bet_zone.bet.bet_amount
		total_bet = _total_bet
	else:
		total_bet = 0
		
	$MinBetText.text = "$%d" % [game.minimum_bet()]
	if total_bet < game.minimum_bet():
		BetZone.toggle_button($SpinButton, false)
	else:
		BetZone.toggle_button($SpinButton, true)

func _on_bet_updated(bet: Bet) -> void:
	handle_bet_amount()
	
	
func on_money_changed(new_value: float, diff: float) -> void:
	limit_bets_to_remaining_funds()
	
func _on_spin_button_pressed() -> void:
	var bets: Array[Bet] = []
	BetZone.toggle_button($SpinButton, false)
	if bet_zones:
		for bz in bet_zones:
			var bet_zone = bz as BetZone
			bet_zone.lock()
			bets.append(bet_zone.bet)
		submit_bet.emit(bets)
