class_name ToolTip
extends Node2D

var game: Game = Game.get_instance()

var random: RandomNumberGenerator = RandomNumberGenerator.new()

@export var offset: Vector2 = (Vector2.DOWN + Vector2.RIGHT) * 8

func _ready() -> void:
	game.tool_tip = self
	
func _process(delta: float) -> void:
	position = get_global_mouse_position() + offset

var locked_by: int = -1

func show_tool_tip(tool_tip_text: String) -> int:
	if locked_by == -1:
		visible = true
		$TooltipText.text = tool_tip_text
		locked_by = random.randi()
		return locked_by
	else:
		return -1
	
func hide_tool_tip(lock_id: int) -> void:
	if lock_id == locked_by:
		visible = false
		locked_by = -1
