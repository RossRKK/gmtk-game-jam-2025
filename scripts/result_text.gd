extends RichTextLabel

var game: Game = Game.get_instance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.event_bus.announce_result.connect(update_result_text)


func update_result_text(won: bool, segment: Segment, winnings: int) -> void:
	text = "You %s $%d on %s %d" % ["won" if won else "lost", winnings, "red" if segment.colour == segment.RouletteColour.Red else "black", segment.number]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
