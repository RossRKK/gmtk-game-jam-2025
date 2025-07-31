extends Node2D

class_name SegmentHandler

var game: Game = Game.get_instance()

var random = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var number = 1
	for i in range(game.WHEEL_SIZE):
		if i == 0 or i == game.WHEEL_SIZE/2:
			var colour: Segment.RouletteColour = Segment.RouletteColour.Zero
			add_child(Segment.new(colour, 0, i))
		else:
			var colour: Segment.RouletteColour = Segment.RouletteColour.Black if i % 2 == 0 else Segment.RouletteColour.Red
			add_child(Segment.new(colour, number, i))
			number += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func get_segment_curve(segment) -> Curve:
	return segment.segment_effect.probability_effect
	
func random_segment() -> Segment:
	# allow segments to effect the distribution
	var segment_curves: Array[Curve] = []
	for child in get_children():
		print("Child name: ", child.name)
		print("Child type: ", child.get_class())
		print("Child script: ", child.get_script())
		print("Is Segment: ", child is Segment)
		print("---")
		segment_curves.append(get_segment_curve(child))
	var selected_segment_index = DistributionRNG.random_with_distribution(segment_curves, game.WHEEL_SIZE)
	return get_children()[selected_segment_index]
	
	
func pick_and_apply_segment(bet: Bet, ball: Ball) -> Segment:
	var segment: Segment = random_segment()
	segment.apply_landed_effect(bet, ball)
	return segment
