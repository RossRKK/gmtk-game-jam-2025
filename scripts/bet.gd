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
var additional_winnings: int = 0


func _init(ba: int, bt: BetType) -> void:
	bet_amount = ba
	bet_type = bt

func debug_print() -> void:
	var bet_types = ["Red", "Black", "Odd", "Even", "Zero"]
	var type_name = bet_types[bet_type] if bet_type < bet_types.size() else "Unknown"
	print("Bet[%s: $%d, +$%d win, total: $%d]" % [type_name, bet_amount, additional_winnings, bet_amount + additional_winnings])

func resolve(segment: Segment) -> int:
	var winner = \
		(bet_type == BetType.Red and segment.colour == Segment.RouletteColour.Red) \
		or (bet_type == BetType.Black and segment.colour == Segment.RouletteColour.Black) \
		or (bet_type == BetType.Zero and segment.colour == Segment.RouletteColour.Zero) \
		or (bet_type == BetType.Even and segment.number % 2 == 0 and segment.number != 0) \
		or (bet_type == BetType.Odd and segment.number % 2 == 1 and segment.number != 0)
		
	if winner:
		var total_winnings = bet_amount + additional_winnings
		game.player_inventory.update_money(total_winnings)
		return total_winnings
	else:
		game.player_inventory.update_money(-bet_amount)
		return -bet_amount
		
