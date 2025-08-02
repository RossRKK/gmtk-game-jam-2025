class_name RouletteWheel
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

var ball_distance: float = 164.0

@onready var ball_queue: BallQueue = get_parent().get_node("BallQueue")

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
var ball: RouletteBall
var bets: Array[Bet]

var result_segment: Segment
var target_rotation: float = 0.
var ball_initial_rotation: float = 0.
var stop_rotation: float

var ball_offset_out = Vector2.UP * ball_distance
var ball_offset_orthogonal = Vector2.LEFT * 17


func _ready() -> void:
	ball_queue.enqueue(GolfBall.make_golf_ball())
	
	for i in range(8):
		match i % 3:
			1: ball_queue.enqueue(ColouredBall.make_coloured_ball(Segment.RouletteColour.Red))
			2: ball_queue.enqueue(ColouredBall.make_coloured_ball(Segment.RouletteColour.Black))
			_: ball_queue.enqueue(RouletteBall.make_basic_ball())
		
	
	receive_ball(ball_queue.dequeue())

func next_ball():
	remove_child(ball)
	ball = ball_queue.cycle(ball)
	receive_ball(ball)

func receive_ball(b: RouletteBall) -> void:
	ball = b
	ball.position = ball_offset_out + ball_offset_orthogonal
	add_child(ball)

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
	# pick a cell at random (taking any effects into account)
	result_segment.apply_landed_effect(bets, ball)

	state = WheelState.Returning
	$ReturnTimer.start()
	
	$ReturnTimer.timeout.connect(_stop_return)
	

func _stop_return() -> void:
	state = WheelState.Upright
	next_ball()
	game.event_bus.spin_complete.emit()

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
		
		var angle = lerp_angle(ball_initial_rotation, target_rotation, ball_curve.sample(normalised_time))
		ball.position = ball_offset_out.rotated(angle) + ball_offset_orthogonal.rotated(angle)
	
	if state == WheelState.Returning:
		self.rotation = lerp_angle(stop_rotation, 0, return_curve.sample(normalised_time))
