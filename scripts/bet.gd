class_name Bet

enum BetType {
	Unset,
	Red,
	Black,
	Odd,
	Even,
}

var game: Game = Game.get_instance()

var bet_type: BetType = BetType.Unset
var bet_amount: int = -1;


func _init(ba: int, bt: BetType) -> void:
	bet_amount = ba
	bet_type = bt



func resolve(segment: Segment) -> void:
	var winner = \
		(bet_type == BetType.Red and segment.colour == Segment.RouletteColour.Red) \
		or (bet_type == BetType.Black and segment.colour == Segment.RouletteColour.Black) \
		or (bet_type == BetType.Even and segment.number % 2 == 0) \
		or (bet_type == BetType.Odd and segment.number % 2 == 1)
		
	if winner:
		print("Winner")
		game.event_bus.announce_result.emit(true, segment, bet_amount)
		game.player_inventory.update_money(bet_amount)
	else:
		print("Loser")
		game.event_bus.announce_result.emit(false, segment, bet_amount)
		game.player_inventory.update_money(-bet_amount)
		
