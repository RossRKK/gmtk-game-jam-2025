class_name Segment
extends Node2D

enum RouletteColour {
	Red,
	Black,
	Zero,
}

func get_colour_for_roulette_colour(seg_colour: RouletteColour, highlight: bool) -> Color:
	var highlight_boost = 0.2 if highlight else 0.
	if seg_colour == RouletteColour.Red:
		return Color(0.8 + highlight_boost, 0 + highlight_boost, 0 + highlight_boost)
	if seg_colour == RouletteColour.Black:
		return Color(0 + highlight_boost, 0 + highlight_boost, 0 + highlight_boost)
	if seg_colour == RouletteColour.Zero:
		return Color(0 + highlight_boost, 0.8 + highlight_boost, 0 + highlight_boost)
		
	return Color(0.8, 0, 0.8)

var game: Game = Game.get_instance()

var is_highlighted := false:
	set(value):
		is_highlighted = value
		if sprite:
			sprite.modulate = get_colour_for_roulette_colour(colour, is_highlighted)

@export var colour: RouletteColour:
	set(value):
		colour = value
		if sprite:
			sprite.modulate = get_colour_for_roulette_colour(colour, is_highlighted)
			
@export var number: int:
	set(value):
		number = value
		if number_text:
			number_text.text = get_label()

@export var segment_effect: SegmentEffect

var sprite: Sprite2D

var number_text: RichTextLabel

var index: int

static func get_roation_for_index(i: int) -> float:
	return i * (2 * PI / Game.get_instance().WHEEL_SIZE)

func _init(col: RouletteColour, num: int, i: int):
	colour = col
	number = num
	segment_effect = SegmentEffect.new()
	index = i
	rotation = get_roation_for_index(i)
	
func get_label() -> String:
	if number == 0 and index != 0:
		return "00"
		
	return "%d" % number

func mouse_entered() -> void:
	is_highlighted = true
	
func mouse_exited() -> void:
	is_highlighted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene = load("res://scenes/segment.tscn").instantiate()
	add_child(scene)
	
	scene.mouse_entered.connect(mouse_entered)
	scene.mouse_exited.connect(mouse_exited)
	
	sprite = scene.get_node("SegmentSprite")
	number_text = scene.get_node("SegmentLabel")
	
	sprite.modulate = get_colour_for_roulette_colour(colour, is_highlighted)
	number_text.text = get_label()

func format_name() -> String:
	return "%s %d" % [RouletteColour.keys()[colour], number]


func apply_landed_effect(bets: Array[Bet], ball: RouletteBall):
	print("%s %d" % ["Red" if colour else "Black", number])
	
	var total_winnings := 0
	for bet in bets:
		bet = segment_effect.apply_bet_muliplication(bet)
		total_winnings += bet.resolve(self)

	game.event_bus.announce_result.emit(self, total_winnings)
		
