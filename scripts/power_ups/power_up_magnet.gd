class_name PowerUpMagnet
extends PowerUp

static func make(curve: Curve, base_price: float, title: String, description: String, tool_tip: String) -> PowerUpMagnet:
	var power_up = PowerUpMagnet.new(curve, base_price, title, description, tool_tip)
	if title == "Magnetised":
		power_up.texture_normal = preload("res://assets/png/power_horseshoe_upright.png")
	else:
		power_up.texture_normal = preload("res://assets/png/power_horseshoe.png")
	power_up.scale.x = 0.4
	power_up.scale.y = 0.4
	return power_up

var curve: Curve
var tool_tip: String
var effect_title: String
var effect_description: String

func _init(c: Curve, bp: float, t: String, d: String, tt: String) -> void: 
	super()
	base_price = bp
	curve = c
	tool_tip = tt
	effect_title = t
	effect_description = d

func segment_clicked(segment: Segment) -> void:
	segment.segment_effect = SegmentEffect.new()
	segment.segment_effect.probability_effect = curve.duplicate()
	segment.segment_effect.effect_name = effect_title
	segment.segment_effect.effect_description = effect_description
	
	game.event_bus.segment_clicked.disconnect(segment_clicked)
	game.event_bus.help_text.emit("")

func activate() -> void:
	super.activate()
	game.event_bus.segment_clicked.connect(segment_clicked)
	game.event_bus.help_text.emit("Click a segment to alter it")


func description() -> String:
	return tool_tip
