class_name ShiZiLuKou extends Node3D

var traffic_signal_array: Array[Street]
var min_density_street:Street
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init()
	
func _init() -> void:
	var children = get_children()
	for i in children:
		if i is TrafficSignal:
			i.street_is_ready.connect(_appen_street_array)

#func _process(delta: float) -> void:
	#if traffic_signal_array != null:
		

func _appen_street_array(street:Street):
	traffic_signal_array.append(street)
	remove_duplicate_streets(traffic_signal_array)
	
func remove_duplicate_streets(streets: Array[Street]) -> Array[Street]:
	var unique_dict = {}
	var unique_streets: Array[Street] = []
	
	for street in streets:
		# 使用街道的某个唯一标识作为键
		var key = street.name  # 或其他唯一标识符
		if not unique_dict.has(key):
			unique_dict[key] = true
			unique_streets.append(street)
	
	return unique_streets
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Car:
		body.go_to_next_point()
