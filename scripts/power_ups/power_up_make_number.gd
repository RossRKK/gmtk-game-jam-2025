class_name PowerUpMakeNumber
extends PowerUp
	
var number: int

static func make_with_number(num: int) -> PowerUpMakeNumber:
	var power_up = PowerUpMakeNumber.new(num)
	power_up.texture_normal = load("res://assets/png/nums/%02d.png" % num)
	power_up.scale.x = 0.2
	power_up.scale.y = 0.2
	return power_up

func _init(num: int) -> void:
	base_price = 100.
	number = num


func segment_clicked(segment: Segment) -> void:
	segment.number = number
	game.event_bus.segment_clicked.disconnect(segment_clicked)

func activate() -> void:
	super.activate()
	game.event_bus.segment_clicked.connect(segment_clicked)
