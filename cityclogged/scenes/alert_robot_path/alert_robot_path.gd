extends Area3D

@export var alert_robot:AlertRobot
@export var is_follow_z:bool
var p1:Vector3
var p2:Vector3

func _ready() -> void:
	var mi:MeshInstance3D
	for i in self.get_children():
		if i is MeshInstance3D:
			if i.mesh is BoxMesh:
				mi=i
				break
	if not is_instance_valid(mi):
		printerr("不存在含有BoxMesh的MeshInstance3D")
		return
	if not is_instance_valid(alert_robot):
		printerr("未设置报警机器人")
		return
	var collision:CollisionShape3D=CollisionShape3D.new()
	var shape:BoxShape3D=BoxShape3D.new()
	collision.shape=shape
	collision.shape.size=mi.mesh.size
	add_child(collision)
	collision.global_position=mi.global_position
	
	alert_robot.global_position=collision.global_position
	await get_tree().create_timer(1).timeout
	_set_p(collision)
	mi.call_deferred("queue_free")


func _set_p(collision:CollisionShape3D):
	if is_follow_z:
		p1.z=collision.global_position.z-collision.shape.size.z/2
		p1.x=0
		p1.y=alert_robot.global_position.y
		
		p2.z=collision.global_position.z+collision.shape.size.z/2
		p2.x=0
		p2.y=alert_robot.global_position.y
	else:
		p1.x=collision.global_position.x-collision.shape.size.x/2
		p1.z=0
		p1.y=alert_robot.global_position.y
		
		p2.x=collision.global_position.x+collision.shape.size.x/2
		p2.z=0
		p2.y=alert_robot.global_position.y
	
	alert_robot.p1=p1
	alert_robot.p2=p2


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		alert_robot.can_track=true
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		alert_robot.can_track=false
	pass # Replace with function body.
