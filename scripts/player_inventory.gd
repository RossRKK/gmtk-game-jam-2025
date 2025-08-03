extends Node

class_name PlayerInventory

@export var starting_money: float = 10_000.

signal on_money_changed(new_value: float, diff: float)

var available_money = starting_money

func _init() -> void:
	on_money_changed.connect(on_money_changed_handler)
	
func on_money_changed_handler(new_value: float, diff: float) -> void:
	available_money = new_value
	if available_money < Game.get_instance().minimum_bet():
		on_money_changed.disconnect(on_money_changed_handler)
		Game.get_instance().event_bus.game_over.emit()
		on_money_changed.connect(on_money_changed_handler)

func update_money(diff: float) -> void:
	available_money += diff
	on_money_changed.emit(available_money, diff)
