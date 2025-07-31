
extends Node2D

var game: Game = Game.get_instance()

signal submit_bet(bets: Array[Bet])

@onready var bet_zones = [$RedBet, $BlackBet, $EvenBet, $OddBet, $ZeroBet]

var total_bet: int:
	set(value):
		total_bet = value
		if $TotalText:
			$TotalText.text = "$%d" % total_bet
		
		var remaining_funds = game.player_inventory.available_money - total_bet
		if bet_zones:
			for bz in bet_zones:
				var bet_zone = bz as BetZone
				bet_zone.apply_limit(remaining_funds)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bet_updated(bet: Bet) -> void:
	var _total_bet = 0
	if bet_zones:
		for bz in bet_zones:
			var bet_zone = bz as BetZone
			_total_bet += bet_zone.bet.bet_amount
		total_bet = _total_bet
	else:
		total_bet = 0

func _on_spin_button_pressed() -> void:
	var bets: Array[Bet] = []
	if bet_zones:
		for bz in bet_zones:
			var bet_zone = bz as BetZone
			bet_zone.lock()
			bets.append(bet_zone.bet)
		submit_bet.emit(bets)
