extends Node2D

class_name Segment

enum RouletteColour {
	Red,
	Black,
	Zero,
}

@export var colour: RouletteColour
@export var number: int
@export var segment_effect: SegmentEffect

func _init(col: RouletteColour, num: int):
	colour = col
	number = num
	segment_effect = SegmentEffect.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func apply_landed_effect(bet: Bet, ball: Ball):
	print("%s %d" % ["Red" if colour else "Black", number])
	
	bet = segment_effect.apply_bet_muliplication(bet)
	
	#bet = ball.apply_bet_synergy(self, bet)
	
	bet.resolve(self)
		
