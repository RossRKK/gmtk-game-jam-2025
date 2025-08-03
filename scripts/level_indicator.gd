extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.get_instance().event_bus.spin_complete.connect(update_text)
	update_text()

func update_text() -> void:
	var game = Game.get_instance()
	var spin_in_level = (game.num_spins % game.NUM_SPINS_PER_LEVEL) + 1
	text = "Spin: %d/%d\nLvl. %d" % [spin_in_level, game.NUM_SPINS_PER_LEVEL, game.level()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
