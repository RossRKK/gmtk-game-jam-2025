class_name PrimeBall
extends RouletteBall

static func make_prime_ball(multiplier: float) -> PrimeBall:
	return PrimeBall.new(multiplier)


var primes = [2, 3, 5, 7, 11, 13, 17, 19, 23]

var multiplier

func _init(m: float) -> void:
	super()
	multiplier = m
	modulate = Color(.8, 0., .8)


func segment_affinity(segment: Segment) -> float:
	return 1.

func ball_effect(segment: Segment, bet: Bet) -> Bet:
	if primes[primes.bsearch(segment.number)] == segment.number:
		bet.bet_amount *= multiplier
	
	return bet


func description() -> String:
	return "Prime ball\n%.1fx winnings on prime numbers" % multiplier
