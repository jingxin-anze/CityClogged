class_name Player extends CharacterBody3D

@onready var pitch: Node3D = %Pitch
@onready var state_machine: StateMachine = $StateMachine
@onready var idle: Node3D = $StateMachine/Idle

@export var self_attri:EntityAttributes
@export var is1920:bool=true
@onready var camera_3d: Camera3D = $Pitch/Camera3D

var movement_speed:int=30
var jump_speed:int=50

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement_direction:Vector2
var movement_direction_3d:Vector3

var move_state:bool
var can_pick:bool

enum state{
	z_p,
	z_n,
	x_p,
	x_n,
}
var current_state=state.z_p
var body_toward:String
var input_direction:Vector2

#动画方向
var an_dir:Dictionary={
	"down":Vector2(-1,0),
	"up":Vector2(1,0),
	"left":Vector2(0,-1),
	"right":Vector2(0,1),
}

func _ready() -> void:
	if is1920:
		var list:PackedInt32Array=DisplayServer.get_window_list()
		var size:Vector2i=Vector2i(1920,1080)
		var ss:Vector2i=DisplayServer.screen_get_size()
		DisplayServer.window_set_size(size,list[0])
		DisplayServer.window_set_position(Vector2(ss.x/2-1920/2,ss.y/2-1080/2),list[0])

	movement_speed=self_attri.attri["movement_speed"]
	jump_speed=self_attri.attri["jump_speed"]
	input_direction=Vector2(0,1)
	
	 
func _physics_process(delta: float) -> void:
	movement_direction= Input.get_vector("move_backward", "move_forward", "move_left", "move_right")
	movement_direction_3d= basis.x * movement_direction.y  - basis.z * movement_direction.x
	if not is_on_floor():
		velocity.y-=gravity*delta*0.01
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y+=jump_speed*delta
	
	
	# 用于检测汽车是否在视野内并且在视野范围内
	if Global.breakdown_car_array:
		var car:Car = Global.breakdown_car_array.pop_front()
		if global_position.distance_to(car.global_position) < 10 and camera_3d.is_position_in_frustum(car.global_position):
			Global.maintain_breakdown_car_array.append(car)
		else:
			car.queue_free()
			
	move_and_slide()

	
func _input(event:InputEvent) -> void:
	#退出
	if event.is_action_pressed("quit"):
		get_tree().quit()
	#转向
	if event.is_action_pressed("turn_noclock"):
		self.rotation_degrees.y+=90.0
		_view_changed(false)
	if event.is_action_pressed("turn_clock"):
		self.rotation_degrees.y-=90.0
		_view_changed(true)
	#加速
	if event.is_action_pressed("speed_up"):
		change_speed(movement_speed*2)
	if event.is_action_released("speed_up"):
		change_speed(movement_speed/2)
	#转向动画适配
	if event is InputEventKey:
		input_direction=Input.get_vector("move_left", "move_right", "move_forward","move_backward", )
		match input_direction:
			Vector2(-1,0):
				body_toward="left"
			Vector2(1,0):
				body_toward="right"
			Vector2(0,1):
				body_toward="down"
			Vector2(0,-1):
				body_toward="up"
	#切换移动模式
	if Input.is_action_just_pressed("pick_drop") && can_pick:
		move_state=!move_state 
		
func _view_changed(is_clockwise:bool):
	var cp_dir:Vector3=(self.global_position-pitch.global_position)
	#记录相机所处的方位，并作为参数发出
	if is_equal_approx(cp_dir.x,0) and cp_dir.z<0:
		Global.player_change_view.emit("z_p")
	if is_equal_approx(cp_dir.z,0) and cp_dir.x<0:
		Global.player_change_view.emit("x_p")
	if is_equal_approx(cp_dir.x,0) and cp_dir.z>0:
		Global.player_change_view.emit("z_n")
	if is_equal_approx(cp_dir.z,0) and cp_dir.x>0:
		Global.player_change_view.emit("x_n")
	#根据当前的动画，适配Idle
	match body_toward:
		"down":
			if is_clockwise:
				state_machine.change_state("Idle")
				idle.determine_dir(an_dir["right"])
				body_toward="right"
			else:
				state_machine.change_state("Idle")
				idle.determine_dir(an_dir["left"])
				body_toward="left"
		"up":
			if is_clockwise:
				state_machine.change_state("Idle")
				idle.determine_dir(an_dir["left"])
				body_toward="left"
			else:
				state_machine.change_state("Idle")
				idle.determine_dir(an_dir["right"])
				body_toward="right"
		"right":
			if is_clockwise:
				state_machine.change_state("Idle")
				idle.determine_dir(an_dir["up"])
				body_toward="up"
			else:
				state_machine.change_state("Idle")
				idle.determine_dir(an_dir["down"])
				body_toward="down"
		"left":
			if is_clockwise:
				state_machine.change_state("Idle")
				idle.determine_dir(an_dir["down"])
				body_toward="down"
			else:
				state_machine.change_state("Idle")
				idle.determine_dir(an_dir["up"])
				body_toward="up"
				
func change_speed(movement:int,jump:int=200,):
	self_attri.attri["movement_speed"]=movement
	self_attri.attri["jump_speed"]=jump
	movement_speed=self_attri.attri["movement_speed"]
	jump_speed=self_attri.attri["jump_speed"]
