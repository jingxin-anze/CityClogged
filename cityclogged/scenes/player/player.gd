extends CharacterBody3D

@onready var pitch: Node3D = %Pitch

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement_speed:float=15
var mouse_sensitivity:int=150

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var movement_direction:Vector2 = Input.get_vector("move_backward", "move_forward", "move_left", "move_right")
	var movement_direction_3d:Vector3 = basis.x * movement_direction.y  - basis.z * movement_direction.x
	if not is_on_floor():
		velocity.y-=gravity*delta*0.01
	else:
		velocity = movement_direction_3d *movement_speed
	move_and_slide()

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
		
	if not event is InputEventMouseMotion:
		return
	
	var mouse_movement:Vector2 = event.relative /mouse_sensitivity * PI
	self.rotate_y(-mouse_movement.x )
	pitch.rotate_x(-mouse_movement.y )
