class_name Player extends CharacterBody3D

@onready var pitch: Node3D = %Pitch

@export var self_attri:EntityAttributes
@export var is1920:bool=true

var movement_speed:float=30
var jump_speed:float=50

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var mouse_sensitivity:int=250
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
	move_and_slide()

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
		
	if event.is_action_pressed("turn_left"):
		self.rotation_degrees.y+=90.0
		#var t:Tween=create_tween()
		#t.tween_property(self,"rotation_degrees:y",self.rotation_degrees.y-90,1)
	if event.is_action_pressed("turn_right"):
		self.rotation_degrees.y-=90.0
		#var t:Tween=create_tween()
		#t.tween_property(self,"rotation_degrees:y",self.rotation_degrees.y+90,1)
	#if not event is InputEventMouseMotion:
		#return
	#
	#var mouse_movement:Vector2 = event.screen_relative /mouse_sensitivity * PI
	#self.rotate_y(-mouse_movement.x )
	#pitch.rotate_x(-mouse_movement.y )
