extends Node

class_name Game

var event_bus: EventBus = EventBus.new()
var player_inventory: PlayerInventory = PlayerInventory.new()


static var instance: Game = Game.new()

static func get_instance() -> Game:
	return instance
