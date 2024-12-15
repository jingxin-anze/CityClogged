extends RigidBody3D
#车辆面朝右

#是否启动导航
@export var navigation: bool = true
#车辆一般的运动速度
@export var speed: float = 5
#与目的地的最小距离
@export var stop_min: float = 1
#车辆的目的地，现在为一个点，以后可以为两个点（比如一个地方有两个停车场）或一片区域（一个数组）
var target_one: Vector3 = Vector3.ZERO
var direction_3d: Vector3 = Vector3.ZERO

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	if navigation == false:
		navigation_agent_3d.queue_free()

func _physics_process(delta: float) -> void:
	#var direction_3d: = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	#
	#linear_velocity = direction_3d * speed
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if navigation:
		_navigation()
	pass
	

func _navigation() -> void:
	if target_one == Vector3.ZERO:
		return
	#print(self.rotation)
	if navigation_agent_3d.distance_to_target() < stop_min:
		linear_velocity = Vector3(0,0,0)
		angular_velocity = Vector3(0,0,0)
		queue_free()
		return
	direction_3d = (navigation_agent_3d.get_next_path_position() - global_position).normalized()

	var direction_2d: = Vector2(direction_3d.z,direction_3d.x)
	#print(navigation_agent_3d.get_next_path_position())
	
	var target_quaternion: Quaternion = Quaternion.from_euler(Vector3(0,direction_2d.angle(),0))
	self.quaternion = self.quaternion.slerp(target_quaternion,0.02*10)
	if direction_3d != Vector3.ZERO:
		linear_velocity = direction_3d * speed


func _on_timer_timeout() -> void:
	if navigation:
		navigation_agent_3d.target_position = target_one
		navigation_agent_3d.target_position = navigation_agent_3d.get_final_position()
