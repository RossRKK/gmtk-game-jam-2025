class_name PowerUp
extends TextureButton

var game: Game = Game.get_instance()

static var random: RandomNumberGenerator = RandomNumberGenerator.new()

const BASIC_WEIGHT = 1
const SEGEMENT_DUPLICATE_WEIGHT = 6
const POWER_UP_DUPLICATE_WEIGHT = 4

@export var base_price: float = 100

static func random_power_up() -> PowerUp:
	var balls: Array = [
		ColouredBall.make_coloured_ball.bind(Segment.RouletteColour.Red),
		ColouredBall.make_coloured_ball.bind(Segment.RouletteColour.Black),
	]
	var power_ups: Array = [
		PowerUpMakeColour.new_black,
		PowerUpMakeColour.new_red,
		PowerUpDuplicateSegment.make,
		PowerUpDuplicatePowerUp.make,
	]
	var weights: Array[int] = [
		12 * BASIC_WEIGHT, # make red
		12 * BASIC_WEIGHT, # make black
		SEGEMENT_DUPLICATE_WEIGHT,
		POWER_UP_DUPLICATE_WEIGHT,
		100, # red ball
		100, # black ball
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

# the user has clicked this power up and is activating it
func activate() -> void:
	pass


func price() -> float:
	return base_price * (Game.get_instance().level() ** 2)

func _on_pressed() -> void:
	# just cheat and remove our texture and disable
	texture_normal = null
	texture_hover = null
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	disabled = true # disable the button to prevent a double activate
	
	game.player_inventory.update_money(-price())
	activate()
	game.last_used_power_up = self
