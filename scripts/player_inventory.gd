extends Node

@export var starting_money: int = 10_000

var available_money = starting_money

func _ready() -> void:
	EventBus.on_money_changed.connect(on_money_changed)
	
func on_money_changed(new_value: int, diff: int) -> void:
	available_money = new_value
