extends Node3D

var count:int=32
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var m:MultiMeshInstance3D=MultiMeshInstance3D.new()
	#var mm:MultiMesh=MultiMesh.new()
	#mm.transform_format=MultiMesh.TRANSFORM_3D
	#mm.instance_count=32*32*32
	#mm.visible_instance_count=32*32*32
	#mm.mesh=BoxMesh.new()
	#var id:int
	#for x in count:
		#for y in count:
			#for z in count:
				#id+=1
				#var t:Transform3D
				#t.origin=Vector3(x,y,z)
				#mm.set_instance_transform(id,t)
	#m.multimesh=mm
	#add_child(m)
	
	#for x in count:
		#for y in count:
			#for z in count:
				#var m:MeshInstance3D=MeshInstance3D.new()
				#m.mesh=BoxMesh.new()
				#add_child(m)
				#m.position=Vector3(x,y,z)
	
	var m:MultiMeshInstance3D=MultiMeshInstance3D.new()
	var mm:MultiMesh=MultiMesh.new()
	mm.transform_format=MultiMesh.TRANSFORM_3D
	mm.use_colors=true
	mm.instance_count=2
	mm.visible_instance_count=2
	mm.mesh=BoxMesh.new()
	mm.mesh.material=StandardMaterial3D.new()
	mm.mesh.material.vertex_color_use_as_albedo = true
	for i in 2:
		var t:Transform3D
		t.origin=Vector3(0,i,0)
		mm.set_instance_transform(i,t)
	mm.set_instance_color(0,Color.BLACK)
	mm.set_instance_color(1,Color.RED)
	m.multimesh=mm
	add_child(m)
	
func _process(delta: float) -> void:
	pass
