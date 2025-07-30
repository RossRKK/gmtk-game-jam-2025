extends Node2D

@export var spin_curve: Curve = Curve.new()

@onready var spin_timer: Timer = $SpinTimer
@onready var sprite: AnimatedSprite2D = $WheelBaseSprite

@onready var segment_handler: SegmentHandler = $SegmentHandler

# signal that will be emitted when the wheel stops spinning
signal wheel_stopped

var spinning: bool = false
var ball: Ball

func _start_spin(bet: BettingBoard.BetType, bet_value: int) -> void:
	spinning = true
	spin_timer.start()
	spin_timer.timeout.connect(_stop_spin)


func _stop_spin() -> void:
	spinning = false
	# pick a cell at random (taking any effects into account)
	var segment: Segment = segment_handler.pick_and_apply_segment(ball)
	# apply the effect of the cell we landed on
	wheel_stopped.emit(segment)

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
