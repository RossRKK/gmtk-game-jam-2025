extends Node2D


var game: Game = Game.get_instance()

@export var spin_curve: Curve = Curve.new()

@export var wobble_frequency: float = 10
@export var wobble_amplitude: float = 0.01

@onready var spin_timer: Timer = $SpinTimer
@onready var sprite: AnimatedSprite2D = $WheelBaseSprite
@onready var spin_sfx: AudioStreamPlayer2D = $SpinSFX

@onready var segment_handler: SegmentHandler = $SegmentHandler


# signal that will be emitted when the wheel stops spinning


var spinning: bool = false
var ball: Ball
var bet: Bet

func _start_spin(b: Bet) -> void:
	bet = b
	spinning = true
	spin_timer.start()
	spin_timer.timeout.connect(_stop_spin)
	spin_sfx.play()
	
	game.event_bus.spin_start.emit()
	


func _stop_spin() -> void:
	spinning = false
	game.event_bus.spin_complete.emit()
	# pick a cell at random (taking any effects into account)
	var segment: Segment = segment_handler.pick_and_apply_segment(bet, ball)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spinning:
		var normalised_time = 1 - (spin_timer.time_left / spin_timer.wait_time)
		var speed_at_time = spin_curve.sample(normalised_time) # rotations per second
		var rotation_this_frame = 2 * PI * delta * speed_at_time # distance to move at this speed
		sprite.rotate(rotation_this_frame)
		
		sprite.position.x += sin(normalised_time * wobble_frequency * PI) * speed_at_time * wobble_amplitude
		sprite.position.y += cos(normalised_time * wobble_frequency * PI) * speed_at_time * wobble_amplitude
