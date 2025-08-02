extends TextureButton
class_name RouletteBall
const SPRITE_SCALE = 0.5

var game: Game = Game.get_instance()

static func make_basic_ball() -> RouletteBall:
	return RouletteBall.new()

func _init() -> void:
	texture_normal = preload("res://assets/png/ball_base.png")
	scale *= SPRITE_SCALE

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	
	
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
