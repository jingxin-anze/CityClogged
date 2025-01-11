# 状态：拥堵
class_name JamState
extends State

func enter() -> void:
	print("进入待机状态")

func exit() -> void:
	print("退出待机状态")

func update(delta: float) -> void:
	# 待机状态逻辑
	pass

func physics_update(delta: float) -> void:
	# 待机状态物理逻辑
	pass

func handle_input(event: InputEvent) -> void:
	# 待机状态输入处理
	pass
