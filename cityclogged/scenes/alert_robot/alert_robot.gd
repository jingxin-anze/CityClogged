class_name AlertRobot extends CharacterBody3D

@export var can_track:bool
@onready var player:Player=get_tree().get_first_node_in_group("player")
var fall_speed:int=10
var p1:Vector3
var p2:Vector3
var dir:Vector2
enum state{
	z_p,
	z_n,
	x_p,
	x_n,
}
var current_state=state.z_p

func _ready() -> void:
	Global.connect("player_change_view",_on_player_view_changed)

func _on_player_view_changed(view:String):
	match view:
		"z_p":
			current_state=state.z_p
		"z_n":
			current_state=state.z_n
		"x_p":
			current_state=state.x_p
		"x_n":
			current_state=state.x_n

func _physics_process(delta: float) -> void:
	if is_instance_valid(player):
		var player_pos3:Vector3=self.to_local(Vector3(player.global_position.x,0,player.global_position.z))
		var player_pos:Vector2=Vector2(player_pos3.x,player_pos3.z)
		match current_state:
			state.z_p:
				dir=(player_pos-Vector2.ZERO).normalized()
			state.z_n:
				dir=-(player_pos-Vector2.ZERO).normalized()
			state.x_p:
				dir=(Vector2(-player_pos.y,player_pos.x)).normalized()
			state.x_n:
				dir=(Vector2(player_pos.y,-player_pos.x)).normalized()

	if not is_on_floor():
		velocity.y-=9.8*delta*fall_speed
	move_and_slide()
