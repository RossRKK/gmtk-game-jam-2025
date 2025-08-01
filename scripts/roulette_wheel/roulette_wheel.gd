extends Node2D


var game: Game = Game.get_instance()

@export var spin_curve: Curve = Curve.new()
@export var ball_curve: Curve = Curve.new()
@export var return_curve: Curve = Curve.new()

@export var wobble_frequency: float = 10
@export var wobble_amplitude: float = 0.01

@onready var sprite: AnimatedSprite2D = $WheelBaseSprite
@onready var spin_sfx: AudioStreamPlayer2D = $SpinSFX

@onready var segment_handler: SegmentHandler = $SegmentHandler

@onready var ball_distance: float = $BallSprite.position.length()

enum WheelState {
	Spinning,
	Returning,
	Upright,
}

@onready var state_timers := {
	WheelState.Spinning: $SpinTimer,
	WheelState.Returning: $ReturnTimer,
}

var state: WheelState = WheelState.Upright
var ball: RouletteBall = RouletteBall.new()
var bets: Array[Bet]

var result_segment: Segment
var target_rotation: float = 0.
var ball_initial_rotation: float = 0.
var stop_rotation: float

func _start_spin(bs: Array[Bet]) -> void:
	bets = bs
	state = WheelState.Spinning
	$SpinTimer.start()
	$SpinTimer.timeout.connect(_stop_spin)
	spin_sfx.play()
	
	result_segment = segment_handler.random_segment(ball)
		
	target_rotation = Segment.get_roation_for_index(result_segment.index)
	
	game.event_bus.spin_start.emit()
	
func _stop_spin() -> void:
	stop_rotation = rotation
	game.event_bus.spin_complete.emit()
	# pick a cell at random (taking any effects into account)
	result_segment.apply_landed_effect(bets, ball)

	state = WheelState.Returning
	$ReturnTimer.start()
	
	$SpinTimer.timeout.connect(_stop_return)
	

func _stop_return() -> void:
	state = WheelState.Upright

func get_normalised_time(timer: Timer) -> float:
	return 1 - (timer.time_left / timer.wait_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var state_timer: Timer = state_timers.get(state)
	
	var normalised_time = get_normalised_time(state_timer) if state_timer != null else 0.0
	
	if state == WheelState.Spinning:
		var speed_at_time = spin_curve.sample(normalised_time)
		self.rotate(2 * PI * delta * speed_at_time)
		self.position.x += sin(normalised_time * wobble_frequency * PI) * speed_at_time * wobble_amplitude
		self.position.y += cos(normalised_time * wobble_frequency * PI) * speed_at_time * wobble_amplitude
		
		$BallSprite.position = Vector2.UP.rotated(lerp_angle(ball_initial_rotation, target_rotation, ball_curve.sample(normalised_time))) * ball_distance
	
	if state == WheelState.Returning:
		self.rotation = lerp_angle(stop_rotation, 0, return_curve.sample(normalised_time))
