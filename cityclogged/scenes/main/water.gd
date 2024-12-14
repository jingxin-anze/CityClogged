@tool 
extends Node3D

const SPLASH_SFX = [
	preload("res://module/water/splash_1.wav"), 
	
	
]
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

const FILL_MARGIN = 1.0
const SUBDIVISION_RATIO = 0.25

@export  var size:Vector2:
		set = set_size 
@export var depth:float:  
	set = set_depth
@export  var mesh:Mesh:
	set =  set_mesh
@export var track_camera:int = 0
@export var show_waterfall:bool: set = set_show_waterfall

#@onready var mesh_instance = $MeshInstance
#@onready var upper_area = $UpperArea
#@onready var lower_area = $LowerArea
#@onready var static_body = $StaticBody
#@onready var upper_shape = upper_area.shape_owner_get_shape(upper_area.get_shape_owners()[0], 0) if not has_node(NodePath("UpperArea/CollisionShape")) else $UpperArea / CollisionShape.shape
#@onready var lower_shape = lower_area.shape_owner_get_shape(lower_area.get_shape_owners()[0], 0) if not has_node(NodePath("LowerArea/CollisionShape")) else $LowerArea / CollisionShape.shape
#@onready var splash_audio_player = $SplashAudioPlayer
#@onready var static_shape = static_body.shape_owner_get_shape(static_body.get_shape_owners()[0], 0) if not has_node(NodePath("StaticBody/CollisionShape")) else $StaticBody / CollisionShape.shape

func _ready():
	set_process(track_camera != 0)
	if Engine.is_editor_hint:
		regenerate_mesh()
	else :
		set_mesh(mesh)

func set_mesh(value:Mesh):
	if not is_inside_tree():
		mesh = value
		return 
	assert (value == null or value is BoxMesh or value is PlaneMesh)
	if Engine.is_editor_hint and is_inside_tree() and get_tree().edited_scene_root == self:
		mesh = null
	else :
		mesh = value
	if value == null:
		return 
	value.custom_aabb = AABB(value.get_aabb().position - Vector3.ONE, value.get_aabb().size + Vector3.ONE * 2.0)
	if mesh_instance_3d:
		mesh_instance_3d.mesh = value
		#mesh_instance_3d.translation.y = - depth / 2.0 if value is BoxMesh else 0.0
	#if lower_shape:
		#lower_shape.extents = Vector3(size.x / 2.0, depth / 2.0 - 0.5, size.y / 2.0)
		#lower_area.translation.y = - depth / 2.0 - 0.5
	#if upper_shape:
		#upper_shape.extents = Vector3(size.x, depth, size.y) / 2.0
		#upper_area.translation.y = - depth / 2.0
	#if static_shape:
		#static_shape.extents.x = size.x / 2.0
		#static_shape.extents.z = size.y / 2.0

#func set_material(mat:Material):
	#mesh_instance.material_override = mat

func regenerate_mesh():
	if show_waterfall:
		mesh = BoxMesh.new()
		mesh.size = Vector3(size.x, depth, size.y)
	else :
		mesh = PlaneMesh.new()
		mesh.size = size
	mesh.subdivide_width = size.x * SUBDIVISION_RATIO - 1
	mesh.subdivide_depth = size.y * SUBDIVISION_RATIO - 1
	set_mesh(mesh)

func set_size(value:Vector2):
	size = value
	if Engine.is_editor_hint():
		regenerate_mesh()

func set_depth(value:float):
	depth = value
	if Engine.is_editor_hint:
		regenerate_mesh()

func set_show_waterfall(value:bool):
	show_waterfall = value
	if Engine.is_editor_hint:
		regenerate_mesh()

func _intersect_xz(cam:Camera3D, view_pos:Vector2)->Vector3:
	var xz_plane = Plane(0, 1, 0, position.y)
	var ray_origin = cam.project_ray_origin(view_pos)
	var ray_normal = cam.project_ray_normal(view_pos)
	return xz_plane.intersects_ray(ray_origin, ray_normal)
#
func _process(_delta):
	if track_camera == 0 or Engine.is_editor_hint:
		return 
	var cam = get_viewport().get_camera()
	if not cam:
		return 
	var pos = _intersect_xz(cam, get_viewport().get_size_override() / 2.0)
	if pos:
		global_transform.origin = pos
	if track_camera > 1:
		var tl = _intersect_xz(cam, Vector2())
		if tl:
			var half_extent = global_transform.origin - tl
			set_size(Vector2(ceil((abs(half_extent.x) + FILL_MARGIN) * 2.0), ceil((abs(half_extent.z) + FILL_MARGIN) * 2.0)))
#
#func _get_water_set(body)->Array:
	#if not body.has_meta("water_set"):
		#return []
	#return body.get_meta("water_set")
#
#func _cmp_water_set(a, b):
	#return a.global_transform.origin.y < b.global_transform.origin.y
#
#func _add_to_water_set(body):
	#if not body.has_meta("water_set"):
		#body.set_meta("water_set", [])
	#var water_set = body.get_meta("water_set") as Array
	#
	#
	#
	#var index = water_set.bsearch_custom(self, self, "_cmp_water_set", false)
	#water_set.insert(index, self)
	#
	#if body is NPC:
		#body.in_water = water_set[water_set.size() - 1]
#
#func _remove_from_water_set(body):
	#if not body.has_meta("water_set"):
		#return 
	#var water_set = body.get_meta("water_set")
	#water_set.erase(self)
	#if body is NPC:
		#if water_set.size() > 0:
			#body.in_water = water_set[water_set.size() - 1]
		#else :
			#body.in_water = null
#
#func _on_UpperArea_body_entered(body):
	#if not (body is PhysicsBody):
		#return 
	#if _get_water_set(body).size() == 0:
		#play_splash(body)
	#_add_to_water_set(body)
#
#func _on_UpperArea_body_exited(body):
	#if not (body is PhysicsBody):
		#return 
	#_remove_from_water_set(body)
#
#func play_splash(body:CollisionObject3D):
	#var velocity:Vector3 = PhysicsServer.body_get_direct_state(body.get_rid()).linear_velocity
	#var volume = clamp(velocity.length() / 40.0, 0.0, 1.0)
	#
	#splash_audio_player.translation = global_transform.xform_inv(body.global_transform.origin)
	#splash_audio_player.max_db = linear2db(volume)
	#splash_audio_player.stream.audio_stream = SPLASH_SFX[randi() % SPLASH_SFX.size()]
	#splash_audio_player.play()
