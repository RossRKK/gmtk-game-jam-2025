class_name Segment
extends Node2D

enum RouletteColour {
	Red,
	Black,
	Zero,
}

var game: Game = Game.get_instance()

@export var colour: RouletteColour
@export var number: int
@export var segment_effect: SegmentEffect

var sprite: Sprite2D

var index: int

func _init(col: RouletteColour, num: int, i: int):
	colour = col
	number = num
	segment_effect = SegmentEffect.new()
	index = i
	rotation = i * (2 * PI / game.WHEEL_SIZE)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = load("res://assets/png/segment.png")
	sprite.modulate = Color(0, 0, 1)
	add_child(sprite)


func apply_landed_effect(bet: Bet, ball: Ball):
	print("%s %d" % ["Red" if colour else "Black", number])
	
	bet = segment_effect.apply_bet_muliplication(bet)
		
	bet.resolve(self)
		
