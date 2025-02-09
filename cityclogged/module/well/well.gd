extends Node3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_3d.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animated_sprite_3d.visible:
		if Input.is_action_pressed("tigger_prop"):
			pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	animated_sprite_3d.visible = true
	

func _on_area_3d_body_exited(body: Node3D) -> void:
	animated_sprite_3d.visible = false



	
