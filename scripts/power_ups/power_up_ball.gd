class_name PowerUpBall
extends PowerUp
	
var ball: RouletteBall

static func make_with_ball(make_ball: Callable) -> PowerUpBall:
	var ball_instance: RouletteBall = make_ball.call()
	var power_up = PowerUpBall.new(ball_instance)
	
	power_up.texture_normal = ball_instance.sprite.texture
	power_up.modulate = ball_instance.sprite.modulate
	power_up.scale.x = 0.4
	power_up.scale.y = 0.4
	return power_up

func _init(b: RouletteBall) -> void: 
	super()
	base_price = 1000.
	ball = b


func activate() -> void:
	super.activate()
	Game.get_instance().roulette_wheel.receive_ball(ball)
