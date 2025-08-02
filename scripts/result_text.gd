extends RichTextLabel

var game: Game = Game.get_instance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.event_bus.announce_result.connect(update_result_text)
	game.event_bus.help_text.connect(update_help_text)
	game.event_bus.game_over.connect(game_over)


func update_result_text(segment: Segment, winnings: float) -> void:
	text = "%s %s$%d" % [segment.format_name(), "-" if winnings < 0 else "", abs(winnings)]

func update_help_text(help_text: String) -> void:
	text = help_text
	
func game_over() -> void:
	text = "Game Over!"
