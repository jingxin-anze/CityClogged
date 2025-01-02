extends RayCast3D

var player:Player
var sprite:Sprite3D
var is_first:bool=true

func _ready() -> void:
	await owner.ready
	player=owner
	sprite=player.get_node("Sprite3D")
	self.hit_from_inside=true

func _process(delta: float) -> void:
	#if self.is_colliding():
		#var colled_entity:=self.get_collider()
		#if (colled_entity  is not Player) and is_first:
			#sprite.no_depth_test=true
			#sprite.modulate=Color.BLACK
			#is_first=false
			#return
		#elif (colled_entity is Player):
			#is_first=true
			#sprite.no_depth_test=false
			#sprite.modulate=Color(1,1,1)
		#if colled_entity is GridMap:
			#var local=colled_entity.to_local(self.get_collision_point())
			#print(colled_entity.get_cell_item(colled_entity.local_to_map(local)))
		#if colled_entity.has_meta("is_white"):
			#print("aaa")
	#self.force_raycast_update()
	pass
