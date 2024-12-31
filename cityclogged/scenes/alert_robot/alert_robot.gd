class_name AlertRobot extends CharacterBody3D

@export var can_track:bool
@onready var player:Player=get_tree().get_first_node_in_group("player")
var fall_speed:int=10
var p1:Vector3
var p2:Vector3
var dir:Vector2


func _physics_process(delta: float) -> void:

	var player_pos3:Vector3=self.to_local(Vector3(player.global_position.x,0,player.global_position.z))
	var player_pos:Vector2=Vector2(player_pos3.x,player_pos3.z)
	#var self_pos:Vector2=Vector2(self.global_position.x,self.global_position.z)
	dir=(player_pos-Vector2.ZERO).normalized()

	#众所周知重力加速度为9.8米每秒的二次方，所以直接赋值了
	if not is_on_floor():
		velocity.y-=9.8*delta*fall_speed
	move_and_slide()
