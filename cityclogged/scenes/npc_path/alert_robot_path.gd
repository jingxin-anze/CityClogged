extends Area3D

@export var npc:Node
@export var is_follow_z:bool
var p1:Vector3
var p2:Vector3

func _ready() -> void:
	var mi:MeshInstance3D=_init_mesh()
	var coll:CollisionShape3D
	if is_instance_valid(mi):
		coll=_init_collision(mi)
	
	if is_instance_valid(npc):
		npc.global_position=coll.global_position
		await get_tree().create_timer(1).timeout
		_set_p(coll)
		mi.call_deferred("queue_free")


func _set_p(collision:CollisionShape3D):
	if is_follow_z:
		p1.z=collision.global_position.z-collision.shape.size.z/2
		p1.x=0
		p1.y=npc.global_position.y
		
		p2.z=collision.global_position.z+collision.shape.size.z/2
		p2.x=0
		p2.y=npc.global_position.y
	else:
		p1.x=collision.global_position.x-collision.shape.size.x/2
		p1.z=0
		p1.y=npc.global_position.y
		
		p2.x=collision.global_position.x+collision.shape.size.x/2
		p2.z=0
		p2.y=npc.global_position.y
	
	npc.p1=p1
	npc.p2=p2

func _init_mesh()->MeshInstance3D:
	for i in self.get_children():
		if i is MeshInstance3D:
			if i.mesh is BoxMesh:
				return i
	if not is_instance_valid(npc):
		printerr("未设置报警机器人")
		return
	printerr("未设置包含BoxMesh的MeshInstance3D")
	return

func _init_collision(m:MeshInstance3D)->CollisionShape3D:
	var collision:CollisionShape3D=CollisionShape3D.new()
	collision.shape=BoxShape3D.new()
	collision.shape.size=m.mesh.size
	add_child(collision)
	collision.global_position=m.global_position
	return collision
	
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		npc.can_track=true
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		npc.can_track=false
	pass # Replace with function body.
