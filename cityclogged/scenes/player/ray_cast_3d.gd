extends RayCast3D

var player:Player
var sprite:Sprite3D
var is_first:bool=true

func _ready() -> void:
	await owner.ready
	player=owner
	sprite=player.get_node("Sprite3D")

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
	#self.force_raycast_update()
	pass
