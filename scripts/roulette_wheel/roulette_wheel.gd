extends Node2D


var game: Game = Game.get_instance()

@export var spin_curve: Curve = Curve.new()
@export var ball_curve: Curve = Curve.new()

@export var wobble_frequency: float = 10
@export var wobble_amplitude: float = 0.01

@onready var spin_timer: Timer = $SpinTimer
@onready var sprite: AnimatedSprite2D = $WheelBaseSprite
@onready var spin_sfx: AudioStreamPlayer2D = $SpinSFX

@onready var segment_handler: SegmentHandler = $SegmentHandler


# signal that will be emitted when the wheel stops spinning
var spinning: bool = false
var ball: Ball
var bets: Array[Bet]

var result_segment: Segment
var target_rotation: float = 0.

func _start_spin(bs: Array[Bet]) -> void:
	bets = bs
	spinning = true
	spin_timer.start()
	spin_timer.timeout.connect(_stop_spin)
	spin_sfx.play()
	
	result_segment = segment_handler.random_segment()
	
	target_rotation = Segment.get_roation_for_index(result_segment.index)
	
	game.event_bus.spin_start.emit()
	


func _stop_spin() -> void:
	spinning = false
	game.event_bus.spin_complete.emit()
	# pick a cell at random (taking any effects into account)
	result_segment.apply_landed_effect(bets, ball)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spinning:
		var normalised_time = 1 - (spin_timer.time_left / spin_timer.wait_time)
		var speed_at_time = spin_curve.sample(normalised_time) # rotations per second
		var rotation_this_frame = 2 * PI * delta * speed_at_time # distance to move at this speed
		self.rotate(rotation_this_frame)
		
		self.position.x += sin(normalised_time * wobble_frequency * PI) * speed_at_time * wobble_amplitude
		self.position.y += cos(normalised_time * wobble_frequency * PI) * speed_at_time * wobble_amplitude
		
		var ball_speed_at_time = ball_curve.sample(normalised_time)
		var target_speed = (ball_speed_at_time * normalised_time) + (speed_at_time * (1 - normalised_time))
		
		$BallSprite.position = Vector2.UP.rotated(target_rotation * target_speed) * 160
