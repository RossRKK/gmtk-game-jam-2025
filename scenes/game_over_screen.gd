extends Node2D


func _ready() -> void:
	visible = false
	Game.get_instance().event_bus.game_over.connect(game_over)


func game_over() -> void:
	visible = true


func _on_button_pressed() -> void:
	Game.reset()
