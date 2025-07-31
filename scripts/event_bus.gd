extends Node

class_name EventBus

signal spin_start
signal spin_complete
signal game_over
signal announce_result(won: bool, segment: Segment, winnings: int)
