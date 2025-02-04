extends Node2D

@onready var center: Sprite2D = $"../Center"

# 定义圆周运动的半径
var radius: = 300.0
# 定义角速度（弧度/秒）
var angular_velocity:= 5.0
# 定义初始角度
var angle: = 0.0
# 定义圆心位置

func _process(delta):
	# 更新角度
	angle += angular_velocity * delta
	# 确保角度在 0 到 TAU (2*PI) 之间循环
	angle = wrapf(angle, 0, TAU)
	# 计算新位置
	var new_position:Vector2 = center.global_position + Vector2(cos(angle), sin(angle)) * radius
	# 更新节点位置
	global_position = new_position
