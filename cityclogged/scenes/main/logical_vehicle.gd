extends MeshInstance3D

var astar:AStar3D=AStar3D.new()
var points_arry:PackedVector3Array
var local_arry:PackedVector3Array
var a:int
var am:int
@onready var grid_map: GridMap = $"../GridMap"

func _ready() -> void:
	points_arry=grid_map.get_used_cells_by_item(1)
	points_arry.sort()

	for i in points_arry:
		a+=1
		local_arry.append(grid_map.map_to_local(i))
		astar.add_point(a,grid_map.map_to_local(i))
	am=a
	for i in local_arry:
		astar.connect_points(a,a-1)
		a-=1
	for i in astar.get_point_path(1,am):
		self.position=i
		await get_tree().create_timer(0.5).timeout

	
func _process(delta: float) -> void:
	pass
