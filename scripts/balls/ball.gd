extends Node2D
class_name RouletteBall
const SPRITE_SCALE = 0.5

static func make_basic_ball() -> RouletteBall:
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/png/ball_base.png")
	sprite.scale *= SPRITE_SCALE
	return RouletteBall.new(sprite)

var sprite: Sprite2D

func _init(s: Sprite2D) -> void:
	sprite = s
	
func _ready() -> void:
	add_child(sprite)

# multiplicative effect on segment probability based on ho much the balls likes it
func segment_affinity(segment: Segment) -> float:
	return 1.

func ball_effect(segment: Segment, bet: Bet) -> Bet:
	return bet
