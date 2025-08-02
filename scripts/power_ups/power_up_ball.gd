class_name PowerUpBall
extends PowerUp
	
var ball: RouletteBall

static func make_with_ball(b: RouletteBall) -> PowerUpBall:
	var power_up = PowerUpBall.new(b)
	power_up.texture_normal = b.texture
	power_up.scale.x = 0.2
	power_up.scale.y = 0.2
	return power_up

func _init(b: RouletteBall) -> void: 
	super()
	base_price = 1000.
	ball = b


func activate() -> void:
	super.activate()
