extends Resource
class_name RouletteBall

# multiplicative effect on segment probability based on ho much the balls likes it
func segment_affinity(segment: Segment) -> float:
	return 1.

func ball_effect(segment: Segment, bet: Bet) -> Bet:
	return bet
