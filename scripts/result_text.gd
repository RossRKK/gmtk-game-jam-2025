extends RichTextLabel

var game: Game = Game.get_instance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.event_bus.announce_result.connect(update_result_text)


func update_result_text(segment: Segment, winnings: float) -> void:
	text = "%s %s$%d" % [segment.format_name(), "-" if winnings < 0 else "", abs(winnings)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
