class_name Segment
extends Node2D

enum RouletteColour {
	Red,
	Black,
	Zero,
}

func get_colour_for_roulette_colour(seg_colour: RouletteColour) -> Color:
	if seg_colour == RouletteColour.Red:
		return Color(1, 0, 0)
	if seg_colour == RouletteColour.Black:
		return Color(0, 0, 0)
	if seg_colour == RouletteColour.Zero:
		return Color(0, 1, 0)
		
	return Color(1, 0, 1)

var game: Game = Game.get_instance()

@export var colour: RouletteColour:
	set(value):
		colour = value
		if sprite:
			sprite.modulate = get_colour_for_roulette_colour(colour)
			
@export var number: int:
	set(value):
		number = value
		if number_text:
			number_text.text = get_label()

@export var segment_effect: SegmentEffect

var sprite: Sprite2D

var number_text: RichTextLabel

var index: int

func _init(col: RouletteColour, num: int, i: int):
	colour = col
	number = num
	segment_effect = SegmentEffect.new()
	index = i
	rotation = i * (2 * PI / game.WHEEL_SIZE)
	
func get_label() -> String:
	if number == 0 and index != 0:
		return "00"
		
	return "%d" % number

func mouse_entered() -> void:
	sprite.scale.x = 1.1
	sprite.scale.y = 1.1
	
func mouse_exited() -> void:
	sprite.scale.x = 1
	sprite.scale.y = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene = load("res://scenes/segment.tscn").instantiate()
	add_child(scene)
	
	scene.mouse_entered.connect(mouse_entered)
	scene.mouse_exited.connect(mouse_exited)
	
	sprite = scene.get_node("SegmentSprite")
	number_text = scene.get_node("SegmentLabel")
	
	sprite.modulate = get_colour_for_roulette_colour(colour)
	number_text.text = get_label()

func format_name() -> String:
	return "%s %d" % [RouletteColour.keys()[colour], number]


func apply_landed_effect(bets: Array[Bet], ball: Ball):
	print("%s %d" % ["Red" if colour else "Black", number])
	
	var total_winnings := 0
	for bet in bets:
		bet = segment_effect.apply_bet_muliplication(bet)
		total_winnings += bet.resolve(self)

	game.event_bus.announce_result.emit(self, total_winnings)
		
