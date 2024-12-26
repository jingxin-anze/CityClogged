extends Area3D

@onready var alert_robot:CharacterBody3D=self.get_parent()
@onready var player:Player=get_tree().get_first_node_in_group("player")

var speed:int=80
var can_track:bool
var dir:Vector3


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		can_track=true
		pass
		
func _physics_process(delta: float) -> void:
	if can_track:
		dir=(player.global_position-self.global_position).normalized()
		alert_robot.velocity=dir*delta*speed
	else:
		alert_robot.velocity=Vector3(0,0,0)
	pass

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		can_track=false
