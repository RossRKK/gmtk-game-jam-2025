extends Control

var game: Game = Game.get_instance()

@export var spin_base_cost: float = 100.

var spinning: bool = false

func get_spin_cost() -> float:
	return spin_base_cost * game.level() ** 2

func _ready() -> void:
	start_spin()

func enter_coin():
	game.player_inventory.update_money(-get_spin_cost())
	$CoinSound.finished.connect(start_spin)
	$CoinSound.play()

func start_spin():
	spinning = true
	$SpinSound.play()
	$SpinTimer.timeout.connect(stop_spin)
	$SpinTimer.start()
	
func stop_spin():
	$SpinSound.stop()
	spinning = false
	update_labels()
	
func update_labels() -> void:
	if $LeftLabel and $Backdrop/LeftSlotMachineColumn and $Backdrop/LeftSlotMachineColumn.get_active_power_up():
		$LeftLabel.text = "$%d" % $Backdrop/LeftSlotMachineColumn.get_active_power_up().price()
	if $MiddleLabel and $Backdrop/MiddleSlotMachineColumn and $Backdrop/MiddleSlotMachineColumn.get_active_power_up():
		$MiddleLabel.text = "$%d" % $Backdrop/MiddleSlotMachineColumn.get_active_power_up().price()
	if $RightLabel and $Backdrop/RightSlotMachineColumn and $Backdrop/RightSlotMachineColumn.get_active_power_up():
		$RightLabel.text = "$%d" % $Backdrop/RightSlotMachineColumn.get_active_power_up().price()


func _process(delta: float) -> void:
	if spinning:
		if $Backdrop/LeftSlotMachineColumn:
			$Backdrop/LeftSlotMachineColumn.randomise()
		if $Backdrop/MiddleSlotMachineColumn:
			$Backdrop/MiddleSlotMachineColumn.randomise()
		if $Backdrop/RightSlotMachineColumn:
			$Backdrop/RightSlotMachineColumn.randomise()
		
