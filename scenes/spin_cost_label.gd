extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.get_instance().event_bus.spin_complete.connect(update_label)


func update_label() -> void:

	
