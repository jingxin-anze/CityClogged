extends Node3D
@onready var shi_zi_lu_kou: Node3D = $ShiZiLuKou

var road_gridmap: GridMap

func _ready() -> void:
	road_gridmap = shi_zi_lu_kou.get_child(0)                    
