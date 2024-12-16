class_name Player extends CharacterBody3D

@onready var pitch: Node3D = %Pitch

@export var self_attri:EntityAttributes
var movement_speed:float=30
var jump_speed:float=50

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var mouse_sensitivity:int=250
var movement_direction:Vector2
var movement_direction_3d:Vector3

func _ready() -> void:
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
