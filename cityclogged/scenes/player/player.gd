class_name Player extends CharacterBody3D

@onready var pitch: Node3D = %Pitch

@export var self_attri:EntityAttributes
@export var is1920:bool=true

var movement_speed:int=30
var jump_speed:int=50

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
#var mouse_sensitivity:int=250
var movement_direction:Vector2
var movement_direction_3d:Vector3

func _ready() -> void:
	if is1920:
		var list:PackedInt32Array=DisplayServer.get_window_list()
		var size:Vector2i=Vector2i(1920,1080)
		var ss:Vector2i=DisplayServer.screen_get_size()
		DisplayServer.window_set_size(size,list[0])
		DisplayServer.window_set_position(Vector2(ss.x/2-1920/2,ss.y/2-1080/2),list[0])

	movement_speed=self_attri.attri["movement_speed"]
	jump_speed=self_attri.attri["jump_speed"]


func _physics_process(delta: float) -> void:
	movement_direction= Input.get_vector("move_backward", "move_forward", "move_left", "move_right")
	movement_direction_3d= basis.x * movement_direction.y  - basis.z * movement_direction.x
	if not is_on_floor():
		velocity.y-=gravity*delta*0.01
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y+=jump_speed*delta
	move_and_slide()
	
func _input(event:InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
		
	if event.is_action_pressed("turn_left"):
		self.rotation_degrees.y+=90.0

	if event.is_action_pressed("turn_right"):
		self.rotation_degrees.y-=90.0
	
	if event.is_action_pressed("speed_up"):
		change_speed(movement_speed*2)
	if event.is_action_released("speed_up"):
		change_speed(movement_speed/2)

func change_speed(movement:int,jump:int=200,):
	self_attri.attri["movement_speed"]=movement
	self_attri.attri["jump_speed"]=jump
	movement_speed=self_attri.attri["movement_speed"]
	jump_speed=self_attri.attri["jump_speed"]
