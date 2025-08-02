class_name PowerUpMoney
extends PowerUp

# this power up just refunds itself, it's job is to act as the inital previous power up
func _init() -> void:
	super()
	base_price = 100.


func activate() -> void:
	super.activate()
	Game.get_instance().player_inventory.update_money(price())
