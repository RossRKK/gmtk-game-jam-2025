class_name SlotMachineColumn
extends Control

const COLUMN_HEIGHT := 3;
const VERTICAL_SPACING := 35.;

func set_positions():
	for i in get_child_count():
		var power_up = get_child(i) as PowerUp
		power_up.position.y = (i - 1) * VERTICAL_SPACING
		power_up.position.x = 0.
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(COLUMN_HEIGHT):
		var power_up = PowerUp.random_power_up()
		#power_up.disabled = true
		add_child(power_up)
	
	set_positions()
