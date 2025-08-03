extends Node2D
class_name RouletteBall
const SPRITE_SCALE = 0.5

var game: Game = Game.get_instance()

static func make_basic_ball() -> RouletteBall:
	return RouletteBall.new()

var texture_normal: Texture2D
var internal_button: TextureButton

func _init() -> void:
	texture_normal = preload("res://assets/png/ball_base.png")
	scale *= SPRITE_SCALE

func _ready() -> void:
	internal_button = TextureButton.new()
	internal_button.texture_normal = texture_normal
	internal_button.mouse_entered.connect(_mouse_entered)
	internal_button.mouse_exited.connect(_mouse_exited)
	internal_button.ready.connect(internal_ready)
	add_child(internal_button)


func internal_ready() -> void:
	var dimensions = internal_button.get_rect().size
	print(dimensions)
	internal_button.position -= dimensions/2
	
func _process(delta: float) -> void:
	pass
	
# multiplicative effect on segment probability based on ho much the balls likes it
func segment_affinity(segment: Segment) -> float:
	return 1.

func ball_effect(segment: Segment, bet: Bet) -> Bet:
	return bet

var tool_tip_id = -1

func _mouse_entered() -> void:
	tool_tip_id = game.tool_tip.show_tool_tip(description())

func _mouse_exited() -> void:
	if tool_tip_id != -1:
		game.tool_tip.hide_tool_tip(tool_tip_id)
		tool_tip_id = -1


func description() -> String:
	return "A simple ball with no effects"
