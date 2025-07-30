extends Node

var event_bus = EventBus

@export var starting_money: int = 10_000

signal on_money_changed(new_value: int, diff: int)

var available_money = starting_money

func _ready() -> void:
	on_money_changed.connect(on_money_changed_handler)
	
func on_money_changed_handler(new_value: int, diff: int) -> void:
	available_money = new_value
	if available_money < 0:
		event_bus.game_over.emit()

func update_money(diff: int) -> void:
	print(diff)
	available_money += diff
	on_money_changed.emit(available_money, diff)
