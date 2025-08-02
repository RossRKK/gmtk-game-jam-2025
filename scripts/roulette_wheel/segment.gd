class_name Segment
extends Node2D

enum RouletteColour {
	Red,
	Black,
	Zero,
}


static func get_colour_for_roulette_colour(seg_colour: RouletteColour, highlight: bool) -> Color:
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
var scene: Area2D
var collider: CollisionPolygon2D

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
	
	
var tool_tip_id: int = -1

func mouse_entered() -> void:
	is_highlighted = true
	tool_tip_id = game.tool_tip.show_tool_tip("%s %d\n%s\n%s" % [RouletteColour.find_key(colour), number, segment_effect.effect_description, segment_effect.effect_description])

	
func mouse_exited() -> void:
	is_highlighted = false
	if tool_tip_id != -1:
		game.tool_tip.hide_tool_tip(tool_tip_id)
		tool_tip_id = -1

#func is_point_in_area(point: Vector2, area: Area2D) -> bool:
	#var space_state = get_world_2d().direct_space_state
	#var query = PhysicsPointQueryParameters2D.new()
	#query.position = point
	#query.collision_mask = area.collision_layer
	#query.collide_with_areas = true
	#query.collide_with_bodies = false
	#
	#var result = space_state.intersect_point(query)
	#
	## Check if any of the results match our area
	#for collision in result:
		#if collision.collider == area:
			#return true
	#return false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if ((not event.pressed) and is_highlighted):
			game.event_bus.segment_clicked.emit(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene = load("res://scenes/segment.tscn").instantiate()
	add_child(scene)
	
	scene.input_pickable = true

	scene.mouse_entered.connect(mouse_entered)
	scene.mouse_exited.connect(mouse_exited)
		
	sprite = scene.get_node("SegmentSprite")
	number_text = scene.get_node("SegmentLabel")
	collider = scene.get_node("CollisionPolygon")
	
	sprite.modulate = get_colour_for_roulette_colour(colour, is_highlighted)
	number_text.text = get_label()

func _process(delta: float) -> void:
	if is_highlighted:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)


func format_name() -> String:
	return "%s %d" % [RouletteColour.keys()[colour], number]


func apply_landed_effect(bets: Array[Bet], ball: RouletteBall):	
	var total_winnings := 0
	for bet in bets:
		bet.debug_print()
		bet = ball.ball_effect(self, bet)
		bet = segment_effect.apply_bet_muliplication(bet)
		total_winnings += bet.resolve(self)
		
	game.event_bus.announce_result.emit(self, total_winnings)
		
