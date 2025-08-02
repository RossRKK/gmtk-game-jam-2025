class_name SlotMachineColumn
extends Control

const COLUMN_HEIGHT := 3;
const VERTICAL_SPACING := 35.;

const ACTIVE_INDEX := 1;

signal power_ups_have_changed

func set_positions():
	for i in get_child_count():
		var power_up = get_child(i) as PowerUp
		power_up.position.y = (i - ACTIVE_INDEX) * VERTICAL_SPACING
		power_up.position.x = 0.
		

func disable_enable_powerups():
	for i in range(COLUMN_HEIGHT):
		var power_up: PowerUp = get_child(i)
		var enabled = i == ACTIVE_INDEX
		power_up.disabled = !enabled
		power_up.mouse_default_cursor_shape = CURSOR_POINTING_HAND if enabled else CURSOR_ARROW

func set_power_up_ui_states():
	set_positions()
	disable_enable_powerups()

func get_active_power_up() -> PowerUp:
	return get_child(ACTIVE_INDEX)

func randomise() -> void:
	for child in get_children():
		remove_child(child)
	for i in range(COLUMN_HEIGHT):
		var power_up = PowerUp.random_power_up()
		add_child(power_up)
	
	set_power_up_ui_states()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomise()
