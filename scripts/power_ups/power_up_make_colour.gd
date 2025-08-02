class_name PowerUpMakeColour
extends PowerUp

static func new_black() -> PowerUpMakeColour:
	var power_up = PowerUpMakeColour.new(Segment.RouletteColour.Black)
	power_up.texture_normal = preload("res://assets/png/chip-black.png")
	power_up.scale.x = 0.2
	power_up.scale.y = 0.2
	return power_up
	
static func new_red() -> PowerUpMakeColour:
	var power_up = PowerUpMakeColour.new(Segment.RouletteColour.Red)
	power_up.texture_normal = preload("res://assets/png/chip-red.png")
	power_up.scale.x = 0.2
	power_up.scale.y = 0.2
	return power_up
	
var colour: Segment.RouletteColour

func _init(c: Segment.RouletteColour) -> void:
	super()
	base_price = 100.
	colour = c


func segment_clicked(segment) -> void:
	segment.colour = colour
	game.event_bus.segment_clicked.disconnect(segment_clicked)
	game.event_bus.help_text.emit("")

func activate() -> void:
	super.activate()
	game.event_bus.segment_clicked.connect(segment_clicked)
	game.event_bus.help_text.emit("Click a segment to make it %s" % ["black" if colour == Segment.RouletteColour.Black else "red"])

func description() -> String:
	return "Make a segment %s" % Segment.RouletteColour.find_key(colour)
