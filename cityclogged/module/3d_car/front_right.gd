extends VehicleWheel3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func calculate_look_at_rotation(target_position: Vector3) -> float:
	# 获取当前位置
	var current_pos = global_position
	
	# 计算方向向量（忽略y轴）
	var direction = target_position - current_pos
	direction.y = 0  # 忽略y轴
	
	# 如果方向向量太小，返回当前旋转
	if direction.length_squared() < 0.001:
		return rotation.y
		
	# 使用 atan2 计算朝向角度
	var target_rotation = atan2(direction.x, direction.z)
	return target_rotation
	
	
