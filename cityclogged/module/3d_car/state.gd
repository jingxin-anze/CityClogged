# 状态基类
class_name State
extends Node

# 虚函数：进入状态
func enter() -> void:
	pass

# 虚函数：退出状态
func exit() -> void:
	pass

# 虚函数：状态更新
func update(_delta: float) -> void:
	pass

# 虚函数：物理更新
func physics_update(_delta: float) -> void:
	pass

# 虚函数：输入处理
func handle_input(_event: InputEvent) -> void:
	pass
