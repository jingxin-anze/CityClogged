extends RayCast3D

var player:Player
var is_change: bool = true
func _ready() -> void:
	await owner.ready
	player=owner
	
func _process(delta: float) -> void:
	self.force_raycast_update()
	
	
	if self.is_colliding():
		var colled_entity:=self.get_collider()
		if (colled_entity  is not Player) && is_change:
			player.rotation_degrees.y=90.0
			is_change = false
			return
		#elif (colled_entity is Player):
			#player.rotation_degrees.y=0.0
	
	if 	!is_change:
		camera_raycast_player()


func  camera_raycast_player():
	var colled_entity:=self.get_collider()
	if colled_entity  is Player:
		is_change = true
