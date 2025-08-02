class_name PowerUpMakeColour
extends PowerUp

static func new_black() -> PowerUpMakeColour:
	var power_up = PowerUpMakeColour.new(Segment.RouletteColour.Black)
	power_up.texture_normal = preload("res://assets/png/chip-black.png")
	return power_up
	
static func new_red() -> PowerUpMakeColour:
	var power_up = PowerUpMakeColour.new(Segment.RouletteColour.Red)
	power_up.texture_normal = preload("res://assets/png/chip-red.png")
	return power_up
	
var colour: Segment.RouletteColour

func _init(c: Segment.RouletteColour) -> void:
	base_price = 100.
	colour = c
