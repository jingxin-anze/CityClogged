extends VehicleBody3D

@export var is_target: bool = false
##车辆的目的地，现在为一个点，以后可以为两个点（比如一个地方有两个停车场）或一片区域（一个数组）
var target_one: Vector3 = Vector3.ZERO
var direction_3d: Vector3 = Vector3.ZERO
var current_path_3d: PackedVector3Array = []
var one_await: bool = true ##有目标后的第一帧不运行
var direction_2d_long: Vector2 
var speed: float = 3

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
#@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	await get_tree().current_scene.ready
	direction_2d_long = Vector2(cos(rotation.y),sin(rotation.y))
	navigation_agent_3d.target_position = target_one

func _physics_process(delta: float) -> void:
	if is_target:
		if one_await:
			navigation_agent_3d.target_position = target_one
			one_await = false
			return
		direction_2d_long = Vector2(cos(rotation.y),sin(rotation.y))
		#print(direction_2d_long)
		direction_3d = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
		var direction_2d: = Vector2(direction_3d.z,direction_3d.x)
				#print(navigation_agent_3d.get_next_path_position())
		#var target_quaternion: Quaternion = Quaternion.from_euler(Vector3(0,direction_2d.angle(),0))
		#self.quaternion = self.quaternion.slerp(target_quaternion, delta*10)
		steering = clamp(direction_2d_long.angle_to(direction_2d),-PI/4,PI/4)
		print(direction_2d_long.angle_to(direction_2d))
		if linear_velocity.length() <= speed:
			engine_force = 30
		else:
			engine_force = 0
	#steering是改变轮子的方向
	#engin_force是力的大小

#func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
