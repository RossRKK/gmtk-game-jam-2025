class_name ColouredBall
extends RouletteBall

var game : Game = Game.get_instance()

@export var colour: Segment.RouletteColour

@export var bet_multiplier: float = 1.2
@export var affinity: float = 1.2
@export var bet_multiplier_bonus: float = 0.

static func make_coloured_ball(c: Segment.RouletteColour) -> ColouredBall:
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/png/ball_base.png")
	sprite.scale *= SPRITE_SCALE
	sprite.modulate = Segment.get_colour_for_roulette_colour(c, true)
	return ColouredBall.new(c, sprite)

func bet_type_matches_colour(bet_type: Bet.BetType) -> bool:
	return (colour == Segment.RouletteColour.Red and bet_type == Bet.BetType.Red) \
		or (colour == Segment.RouletteColour.Black and bet_type == Bet.BetType.Black) \
		or (colour == Segment.RouletteColour.Zero and bet_type == Bet.BetType.Zero)

func _init(c: Segment.RouletteColour, s: Sprite2D) -> void:
	super(s)
	colour = c


func segment_affinity(segment: Segment) -> float:
	return affinity if segment.colour == colour else 1.

func ball_effect(segment: Segment, bet: Bet) -> Bet:
	if segment.colour != colour or !bet_type_matches_colour(bet.bet_type):
		return bet

	bet.additional_winnings += bet_multiplier_bonus * bet.bet_amount
	bet.bet_amount *= bet_multiplier	
	
	return bet


func description() -> String:
	var colour_name: String = Segment.RouletteColour.find_key(colour)
	return "%s coloured ball.\n%.2fx increase to bet on %s\n%.2fx more likely to land on %s" % [colour_name, bet_multiplier, colour_name, affinity, colour_name]
