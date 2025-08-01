@tool
class_name SegmentEffect
extends Resource

var game: Game = Game.get_instance()

@export_category("User Experience")
# The name of this segment effect that will be displayed to the user
@export var effect_name: String
# The long description of the effect that will be displayed to the user
@export var effect_description: String

@export_category("Probability effect")
# The sample at 0. on the curve multiplicatively effects the probability of landing on this space, 1. the space clockwise to it, 23. the space 1 anti-clockwise
@export var probability_effect: Curve = load("res://resources/segment_effects/default_segment_curve.tres").duplicate()

@export_category("Bet Multiplier")
# If this segment is hit, multiply the bet by this value. 
# See Bet Multiplier Cost for how much this costs the user
@export var bet_multiplier: float = 1

# How extra winnings to give the player if they one the bet
@export var bet_multiplier_bonus: float = 0


func apply_bet_muliplication(bet: Bet) -> Bet:
	bet.additional_winnings += bet_multiplier_bonus * bet.bet_amount
	bet.bet_amount *= bet_multiplier	
	
	return bet
