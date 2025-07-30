extends Node2D

@onready var money_text: RichTextLabel = $MoneyText

var player_inventory = PlayerInventory

func _ready() -> void:
	player_inventory.on_money_changed.connect(on_money_changed)
	update_money_text()

func update_money_text() -> void:
	print(player_inventory.available_money)
	money_text.text = "$%d" % player_inventory.available_money

func on_money_changed(new_value: int, diff: int):
	update_money_text()
	
