extends Node

class_name EventBus

signal spin_start
signal spin_complete
signal game_over
signal announce_result(segment: Segment, winnings: float)
signal segment_clicked(segment: Segment)
signal help_text(help_text: String)
signal tool_tip(tooltip_text: String)
signal close_tool_tip
