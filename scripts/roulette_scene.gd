extends Node2D

@onready var money_text: RichTextLabel = $MoneyText


func _ready() -> void:
	EventBus.on_money_changed.connect(on_money_changed)
	update_money_text()

func update_money_text() -> void:
	money_text.text = "$%d" % PlayerInventory.available_money

func on_money_changed(new_value: int):
	update_money_text()
	
