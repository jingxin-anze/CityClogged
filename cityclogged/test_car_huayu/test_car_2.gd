class_name CommonCar
extends CharacterBody3D
#车辆一般的运动速度
@export var speed: float = 5
#与目的地的最小距离
#@export var stop_min: float = 1
#车辆的目的地，现在为一个点，以后可以为两个点（比如一个地方有两个停车场）或一片区域（一个数组）
var stop_min = 5
var target_one: Vector3 = Vector3.ZERO
var direction_3d: Vector3 = Vector3.ZERO
var current_path_3d: PackedVector3Array = []
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _ready() -> void:
	await get_tree().current_scene.ready
	navigation_agent_3d.target_position = target_one

func _physics_process(delta: float) -> void:
	if navigation_agent_3d.get_current_navigation_path().size() == 0:
		current_path_3d = navigation_agent_3d.get_current_navigation_path()
	if navigation_agent_3d.distance_to_target() < stop_min:
		self.velocity = Vector3.ZERO
		#angular_velocity = Vector3(0,0,0)
		queue_free()
		return
		
	direction_3d = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	
	var direction_2d: = Vector2(direction_3d.z,direction_3d.x)
	#print(navigation_agent_3d.get_next_path_position())
	
	var target_quaternion: Quaternion = Quaternion.from_euler(Vector3(0,direction_2d.angle(),0))
	self.quaternion = self.quaternion.slerp(target_quaternion,delta*10)
	if ray_cast_3d.is_colliding():
		self.velocity = self.velocity.slerp(Vector3.ZERO,delta*10)
		return
	if direction_3d != Vector3.ZERO:
		self.velocity = direction_3d * speed
	move_and_slide()
