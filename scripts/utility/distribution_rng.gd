class_name DistributionRNG

static var random = RandomNumberGenerator.new()

static func random_with_distribution(dists: Array[Curve], num_buckets: int) -> int:
	var cut_offs: Array[float] = []
	
	var running_total: float = 0
	for i in range(num_buckets):
		cut_offs.push_back(running_total)
		for curve in dists:
			var domain_width := curve.max_domain - curve.min_domain
			var bucket_domain_width := domain_width / num_buckets
			var sample_point := curve.min_domain + bucket_domain_width * (i + 0.5)

			cut_offs[i] += curve.sample(sample_point)
		
		running_total = cut_offs[i]
	
	if running_total <= 0.0:
		return random.randi_range(0, num_buckets - 1)
	
	var random_value := random.randf_range(0, running_total)
	
	for i in range(num_buckets):
		if random_value < cut_offs[i]:
			return i

	# I don't think this can actually happen but just in case, also g script complains if this isn't here
	return num_buckets - 1
