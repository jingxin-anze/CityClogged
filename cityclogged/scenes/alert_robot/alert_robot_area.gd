extends Area3D

@onready var alert_robot:RigidBody3D=self.get_parent()

var speed:int=10
var can_track:bool
var dir:Vector3
var player:Player

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		player=body
		can_track=true
		pass
		

func _physics_process(delta: float) -> void:
	if can_track:
		dir=-(player.position-self.position).normalized()
		alert_robot.apply_central_force(dir*speed*delta)
	else:
		alert_robot.apply_central_force(Vector3(0,0,0))
	pass

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		can_track=false
