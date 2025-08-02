class_name PowerUp
extends TextureButton

var game: Game = Game.get_instance()

static var random: RandomNumberGenerator = RandomNumberGenerator.new()

const BASIC_WEIGHT = 1

@export var base_price: float = 100

static func random_power_up() -> PowerUp:
	var power_ups: Array = [
		PowerUpMakeColour.new_black,
		PowerUpMakeColour.new_red,
	]
	var weights: Array[int] = [12 * BASIC_WEIGHT, 12 * BASIC_WEIGHT]
	
	for i in range(Game.get_instance().WHEEL_SIZE):
		weights.append(BASIC_WEIGHT)
		power_ups.append(PowerUpMakeNumber.make_with_number.bind(i))
		
	var power_up: PowerUp = power_ups[random.rand_weighted(weights)].call()
	
	power_up.scale.x = 0.2
	power_up.scale.y = 0.2
	
	return power_up



func _init() -> void:
	texture_normal = preload("res://assets/png/chip-black.png")
	texture_hover = preload("res://assets/png/chip-red.png")
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
func _ready() -> void:
	pressed.connect(_on_pressed)

# the user has clicked this power up and is activating it
func activate() -> void:
	pass


func price() -> float:
	return base_price * (game.level() ** 2)

func _on_pressed() -> void:
	# just cheat and remove our texture and disable
	texture_normal = null
	texture_hover = null
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	disabled = true # disable the button to prevent a double activate
	
	game.player_inventory.update_money(-price())
	activate()
