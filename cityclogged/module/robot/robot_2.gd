extends Node3D

@onready var anim_down: AnimationPlayer = $robot2/AnimDown
@onready var animated_sprite_3d: AnimatedSprite3D = $robot2/AnimatedSprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trigger() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func trigger():
	anim_down.play("down")
	


func _on_anim_down_animation_finished(anim_name: StringName) -> void:
	animated_sprite_3d.visible = true
