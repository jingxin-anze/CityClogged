extends RayCast3D

var player:Player

func _ready() -> void:
	await owner.ready
	player=owner
	
func _process(delta: float) -> void:
	self.force_raycast_update()
	
	
	if self.is_colliding():
		var colled_entity:=self.get_collider()
		if (colled_entity  is not Player) :
			player.rotation_degrees.y=90.0

			return
		#elif (colled_entity is Player):
			#player.rotation_degrees.y=0.0
	
			
		pass
