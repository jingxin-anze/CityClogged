extends Node3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var well_out: MeshInstance3D = $a/WellOut


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_3d.visible = false
	well_out.material_overlay = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	animated_sprite_3d.visible = true
	well_out.material_overlay = preload("res://module/well/well.tres")

func _on_area_3d_body_exited(body: Node3D) -> void:
	animated_sprite_3d.visible = false
	well_out.material_overlay = null



	
