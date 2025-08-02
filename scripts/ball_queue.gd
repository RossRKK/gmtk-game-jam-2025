class_name BallQueue
extends Node2D

@export var ball_distance: float = 50

func update_ball_positions() -> void:
	for i in range(get_child_count()):
		var ball = get_child(i) as RouletteBall
		if ball:
			ball.position.x = 0.
			ball.position.y = i * ball_distance

func enqueue(ball: RouletteBall) -> void:
	add_child(ball)
	update_ball_positions()

func dequeue() -> RouletteBall:
	if get_child_count() == 0:
		return null
	
	var output = get_child(0) as RouletteBall
	remove_child(output)
	update_ball_positions()
	return output

func cycle(ball: RouletteBall) -> RouletteBall:
	enqueue(ball)
	return dequeue()

func size() -> int:
	return get_child_count()

func is_empty() -> bool:
	return get_child_count() == 0
