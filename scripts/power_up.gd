class_name PowerUp
extends TextureButton

var game: Game = Game.get_instance()

@export var base_price: float = 100

static func random_power_up() -> PowerUp:
	var power_up := PowerUp.new()
	
	power_up.scale.x = 0.2
	power_up.scale.y = 0.2
	
	power_up.texture_normal = preload("res://assets/png/chip-black.png")
	power_up.texture_hover = preload("res://assets/png/chip-red.png")
	
	return power_up
	
func _init() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
func _ready() -> void:
	pressed.connect(_on_pressed)

# the user has clicked this power up and is activating it
func activate() -> void:
	pass


func price() -> float:
	return base_price * game.level()

func _on_pressed() -> void:
	print("Click")
	# TODO tell the slot machine to remove us
	# TODO charge the player the price
	disabled = true # disbale the button to prevent a double activate
	activate()
