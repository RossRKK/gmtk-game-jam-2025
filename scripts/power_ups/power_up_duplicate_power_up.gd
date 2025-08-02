class_name PowerUpDuplicatePowerUp
extends PowerUp

	
static func make() -> PowerUpDuplicatePowerUp:
	var power_up = PowerUpDuplicatePowerUp.new()
	power_up.texture_normal = preload("res://assets/png/power_bell.png")
	power_up.scale.x = 0.4
	power_up.scale.y = 0.4
	return power_up
	
func _init() -> void:
	super()
	base_price = 1_000.


func activate() -> void:
	if game.last_used_power_up == null or game.last_used_power_up is PowerUpDuplicatePowerUp:
		# if the power up doesn't make sense refund the player
		game.player_inventory.update_money(price())
	else:
		game.last_used_power_up.activate()
