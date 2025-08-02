class_name GolfBall
extends RouletteBall

static func make_golf_ball() -> GolfBall:
	return GolfBall.new()

var sound_effect: AudioStreamPlayer2D

func _init() -> void:
	super()
	modulate = Color(0., .8, 0.)
	
	sound_effect = AudioStreamPlayer2D.new()
	sound_effect.stream = preload("res://assets/sound/nice-shot.mp3")

func _ready() -> void:
	add_child(sound_effect)

func segment_affinity(segment: Segment) -> float:
	return 1.

func ball_effect(segment: Segment, bet: Bet) -> Bet:
	sound_effect.play()
	if bet.bet_type == Bet.BetType.Zero and segment.colour == Segment.RouletteColour.Zero:
		bet.bet_amount *= 10.
	
	return bet


func description() -> String:
	return "Golf ball\n10x winnings if you land on the green"
