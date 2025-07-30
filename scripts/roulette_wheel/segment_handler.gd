extends Node2D

class_name SegmentHandler

const NUM_SEGMENTS: int = 24

@onready var segments: Array[Segment] = Array([], TYPE_OBJECT, "Node", Segment) 

var random = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(NUM_SEGMENTS):
		var colour: Segment.RouletteColour = Segment.RouletteColour.Black if i % 2 == 0 else Segment.RouletteColour.Red
		segments.push_back(Segment.new(colour, i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

	
func random_segment() -> Segment:
	#TODO allow segments to effect the distribution
	return segments[random.randi() % segments.size()] as Segment
	
	
func pick_and_apply_segment(ball: Ball) -> Segment:
	var segment: Segment = random_segment()
	segment.apply_landed_effect(ball)
	return segment
