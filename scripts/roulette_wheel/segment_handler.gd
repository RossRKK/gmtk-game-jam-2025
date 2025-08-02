extends Node2D

class_name SegmentHandler

var game: Game = Game.get_instance()

var random = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(game.WHEEL_SIZE):
		#if i == 0 or i == game.WHEEL_SIZE/2:
			var colour: Segment.RouletteColour = Segment.RouletteColour.Zero
			add_child(Segment.new(colour, 0, i))
		#else:
			#var colour: Segment.RouletteColour = Segment.RouletteColour.Black if random.randi_range(0, 1) == 0 else Segment.RouletteColour.Red
			#add_child(Segment.new(colour, random.randi_range(1, game.WHEEL_SIZE - 2), i))

func get_segment_curve(segment) -> Curve:
	return segment.segment_effect.probability_effect
	
func random_segment(ball: RouletteBall) -> Segment:
	var segment_curves: Array[Curve] = []
	for child in get_children():
		segment_curves.append(get_segment_curve(child))

	var distribution: Array[float] = []
	distribution.resize(game.WHEEL_SIZE)
	distribution.fill(1.)

	for i in game.WHEEL_SIZE:
		var curve := segment_curves[i]
		for j in game.WHEEL_SIZE:
			var effect_index: int = (i + j) % game.WHEEL_SIZE

			var domain_width := curve.max_domain - curve.min_domain
			var bucket_domain_width := domain_width / game.WHEEL_SIZE
			var sample_point := curve.min_domain + bucket_domain_width * j

			distribution[effect_index] *= curve.sample(sample_point)

	for i in game.WHEEL_SIZE:
		distribution[i] *= ball.segment_affinity(get_child(i))
	
	var selected_segment_index = random.rand_weighted(distribution)
	return get_children()[selected_segment_index]
