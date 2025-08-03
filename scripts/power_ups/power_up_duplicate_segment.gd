class_name PowerUpDuplicateSegment
extends PowerUp
	
static func make() -> PowerUpDuplicateSegment:
	var power_up = PowerUpDuplicateSegment.new()
	power_up.texture_normal = preload("res://assets/png/power_cherries.png")
	power_up.scale.x = 0.4
	power_up.scale.y = 0.4
	return power_up
	
func _init() -> void:
	super()
	base_price = 300.


var base_segment: Segment = null

func segment_clicked(segment: Segment) -> void:
	if base_segment == null:
		base_segment = segment
		game.event_bus.help_text.emit("Click again to paste the segment")
	else:
		segment.colour = base_segment.colour
		segment.number = base_segment.number
		segment.segment_effect = base_segment.segment_effect
		game.event_bus.segment_clicked.disconnect(segment_clicked)
		game.event_bus.help_text.emit("")

func activate() -> void:
	super.activate()
	game.event_bus.segment_clicked.connect(segment_clicked)
	game.event_bus.help_text.emit("Click a segment to copy it")

func description() -> String:
	return "Duplicate a wheel segment"
