class_name EightBall
extends RouletteBall

static func make_eight_ball() -> EightBall:
	return EightBall.new()


func _init() -> void:
	super()
	modulate = Color(0., 0., 0.)


func segment_affinity(segment: Segment) -> float:
	return 1.

func ball_effect(segment: Segment, bet: Bet) -> Bet:
	if segment.number % 8 == 0:
		bet.bet_amount *= 3.
	
	return bet


func description() -> String:
	return "8 ball\n3x winnings on multiples of 8"
