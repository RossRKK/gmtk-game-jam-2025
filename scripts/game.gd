extends Node

class_name Game

const WHEEL_SIZE = 24

var event_bus: EventBus = EventBus.new()
var player_inventory: PlayerInventory = PlayerInventory.new()

var base_minimum_bet := 200.

var NUM_SPINS_PER_LEVEL := 4

var num_spins := 0

var last_used_power_up: PowerUp

var roulette_wheel: RouletteWheel

var tool_tip: ToolTip
func _init() -> void:
	event_bus.spin_start.connect(spin_started)

func spin_started():
	num_spins += 1

func level() -> int:
	return floor(num_spins/NUM_SPINS_PER_LEVEL) + 1

func minimum_bet() -> float:
	return base_minimum_bet * (level() ** 2)
	

static var instance: Game = Game.new()

static func get_instance() -> Game:
	return instance

static func reset() -> void:
	var tree = instance.roulette_wheel.get_tree()
	instance = Game.new()
	tree.change_scene_to_file("res://scenes/roulette_scene.tscn")
	
