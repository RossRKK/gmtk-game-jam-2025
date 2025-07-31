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
@export var probability_effect: Curve = load("res://resources/segment_effects/default_segment_curve.tres").duplicate()

@export_category("Bet Multiplier")
# If this segment is hit, multiply the bet by this value. 
# See Bet Multiplier Cost for how much this costs the user
@export var bet_multiplier: float = 1

# How much the muliplier costs.
# i.e. 1 would cost the user the amount their bet was increased
# 0 would be free, negative values would give the user more money
@export var bet_multiplier_cost: float = 1


func apply_bet_muliplication(bet: Bet) -> Bet:
	var new_bet_amount = bet.bet_amount * bet_multiplier
	var bet_diff = new_bet_amount - bet.bet_amount
	
	var cost_to_player = bet_diff * bet_multiplier_cost
	
	bet.bet_amount = new_bet_amount
	
	return bet
