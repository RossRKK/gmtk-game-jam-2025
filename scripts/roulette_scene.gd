extends Node2D

@onready var money_text: RichTextLabel = $MoneyText

var game: Game = Game.get_instance()

func _ready() -> void:
	game.player_inventory.on_money_changed.connect(on_money_changed)
	update_money_text()
	
	
	

func update_money_text() -> void:
	money_text.text = "$%d" % game.player_inventory.available_money

func on_money_changed(new_value: int, diff: int):
	update_money_text()
	
