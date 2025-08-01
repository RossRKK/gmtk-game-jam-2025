class_name DistributionRNG

static var random = RandomNumberGenerator.new()

static func random_with_distribution(dists: Array[Curve], num_buckets: int) -> int:
	var weights: Array[float] = []
	
	var running_total: float = 0
	for i in range(num_buckets):
		weights.push_back(0)
		for curve in dists:
			var domain_width := curve.max_domain - curve.min_domain
			var bucket_domain_width := domain_width / num_buckets
			var sample_point := curve.min_domain + bucket_domain_width * (i + 0.5)

			weights[i] += curve.sample(sample_point)
		
		running_total += weights[i]

	
	if running_total <= 0.0:
		return random.randi_range(0, num_buckets - 1)
	
	return random.rand_weighted(weights)
