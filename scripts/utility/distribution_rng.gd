class_name DistributionRNG

static var random = RandomNumberGenerator.new()

# static func random_with_distribution(distribution: Array[Curve], num_buckets: int) -> int:
# 	var weights: Array[float] = []
	
# 	var running_total: float = 0
# 	for i in range(num_buckets):
# 		weights.push_back(0)
# 		for curve in dists:
			

# 			weights[i] += curve.sample(sample_point)
		
# 		running_total += weights[i]

	
# 	if running_total <= 0.0:
# 		return random.randi_range(0, num_buckets - 1)
	
# 	return r
