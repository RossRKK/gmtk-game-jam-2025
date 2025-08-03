class_name OddBall
extends RouletteBall

static func make_odd_ball() -> OddBall:
	return OddBall.new()


func _init() -> void:
	super()
	modulate = Color(0., 0., .8)


func segment_affinity(segment: Segment) -> float:
	return 1.

func ball_effect(segment: Segment, bet: Bet) -> Bet:
	if segment.number % 2 == 1:
		bet.bet_amount *= 2.
	
	return bet


func description() -> String:
	return "Odd ball\n2x winnings on odd numbers"
