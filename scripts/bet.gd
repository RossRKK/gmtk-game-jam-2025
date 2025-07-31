class_name Bet

enum BetType {
	Red,
	Black,
	Odd,
	Even,
	Zero,
}

var game: Game = Game.get_instance()

var bet_type: BetType
var bet_amount: int


func _init(ba: int, bt: BetType) -> void:
	bet_amount = ba
	bet_type = bt



func resolve(segment: Segment) -> int:
	var winner = \
		(bet_type == BetType.Red and segment.colour == Segment.RouletteColour.Red) \
		or (bet_type == BetType.Black and segment.colour == Segment.RouletteColour.Black) \
		or (bet_type == BetType.Even and segment.number % 2 == 0) \
		or (bet_type == BetType.Odd and segment.number % 2 == 1)
		
	if winner:
		game.player_inventory.update_money(bet_amount)
		return bet_amount
	else:
		game.player_inventory.update_money(-bet_amount)
		return -bet_amount
		
