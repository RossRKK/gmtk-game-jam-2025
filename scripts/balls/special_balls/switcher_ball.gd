class_name SwitcherBall
extends RouletteBall

static func make_switcher_ball() -> SwitcherBall:
	return SwitcherBall.new()


func _init() -> void:
	super()
	texture_normal = preload("res://assets/png/ball_switcher.png")


func segment_affinity(segment: Segment) -> float:
	return 1.

func ball_effect(segment: Segment, bet: Bet) -> Bet:
	match segment.colour:
		Segment.RouletteColour.Red:
			segment.colour = Segment.RouletteColour.Black
		Segment.RouletteColour.Black:
			segment.colour = Segment.RouletteColour.Red
	
	return bet


func description() -> String:
	return "Switcher ball\nSwaps the colour of the segment it lands on"
