class_name PowerUp
extends TextureButton

var game: Game = Game.get_instance()

static var random: RandomNumberGenerator = RandomNumberGenerator.new()

const BASIC_WEIGHT = 1
const SEGEMENT_DUPLICATE_WEIGHT = 6
const POWER_UP_DUPLICATE_WEIGHT = 4

const MAGNET_WEIGHT = 6

@export var base_price: float = 100

static func random_power_up() -> PowerUp:
	var magnet_curve = preload("res://resources/segment_effects/magnet_segment_curve.tres")
	var repolsor_curve = preload("res://resources/segment_effects/repulsor_segment_curve.tres")
	var banana_curve = preload("res://resources/segment_effects/banana_segment_curve.tres")
	var balls: Array = [
		ColouredBall.make_coloured_ball.bind(Segment.RouletteColour.Red),
		ColouredBall.make_coloured_ball.bind(Segment.RouletteColour.Black),
		GolfBall.make_golf_ball,
		EightBall.make_eight_ball,
		SwitcherBall.make_switcher_ball,
		PrimeBall.make_prime_ball.bind(3),
		OddBall.make_odd_ball,
	]
	var power_ups: Array = [
		PowerUpMakeColour.new_black,
		PowerUpMakeColour.new_red,
		PowerUpMakeColour.new_zero,
		PowerUpDuplicateSegment.make,
		PowerUpDuplicatePowerUp.make,
		PowerUpMagnet.make.bind(magnet_curve, 200.,"Magnetised", "The ball is more likely to land near here", "Make your own luck. Make the ball more likely to land in a segment or it's neighbours"),
		PowerUpMagnet.make.bind(repolsor_curve, 200.,"Repellent", "The ball is less likely to land near here", "Make your own luck. Make the ball less likely to land in a segment or it's neighbours"),
		PowerUpMagnet.make.bind(banana_curve, 200.,"Slippery", "The ball will slip passed here into the next segment", "Slick up a segment so that the ball lands in the next space"),

	]
	var weights: Array[int] = [
		12 * BASIC_WEIGHT, # make red
		12 * BASIC_WEIGHT, # make black
		BASIC_WEIGHT, # make zero
		SEGEMENT_DUPLICATE_WEIGHT,
		POWER_UP_DUPLICATE_WEIGHT,
		MAGNET_WEIGHT, # magnet
		MAGNET_WEIGHT, # replusor
		MAGNET_WEIGHT, # banana
		
		# these are added after the hard coded ones
		12 * BASIC_WEIGHT, # red ball
		12 * BASIC_WEIGHT, # black ball
		6, # golf ball
		12, # eight ball
		6, # switcher ball
		12, # prime ball
		12, # odd ball
	]
	
	for ball_factory in balls:
		power_ups.append(PowerUpBall.make_with_ball.bind(ball_factory))
	
	for i in range(Game.get_instance().WHEEL_SIZE):
		weights.append(BASIC_WEIGHT)
		power_ups.append(PowerUpMakeNumber.make_with_number.bind(i))

	var power_up: PowerUp = power_ups[random.rand_weighted(weights)].call()

	
	return power_up


func _init() -> void:
	game = Game.get_instance()
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


var tool_tip_id = -1

func _mouse_entered() -> void:
	tool_tip_id = game.tool_tip.show_tool_tip(description())

func _mouse_exited() -> void:
	if tool_tip_id != -1:
		game.tool_tip.hide_tool_tip(tool_tip_id)
		tool_tip_id = -1

# the user has clicked this power up and is activating it
func activate() -> void:
	pass


func price() -> float:
	return base_price * (Game.get_instance().level() ** 2)

func _on_pressed() -> void:
	if game.player_inventory.available_money > (price() + game.minimum_bet()):
		# just cheat and remove our texture and disable
		texture_normal = null
		texture_hover = null
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		disabled = true # disable the button to prevent a double activate
		game.player_inventory.update_money(-price())
		activate()
		game.last_used_power_up = self
	else:
		var reject_sound = AudioStreamPlayer2D.new()
		reject_sound.stream = preload("res://assets/sound/reject.wav")
		add_child(reject_sound)
		reject_sound.play()


func description():
	return "This power up doesn't have a description, very mysterious"
