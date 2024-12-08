extends CharacterBody2D


@export var speed = 100
@export var acceleration = 2

func get_input() -> Vector2:
	return  Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	

func _physics_process(delta):
	var input = Vector2.ZERO
	input = get_input()
	velocity = lerp(velocity,input * speed,acceleration* delta)
	move_and_slide()
	if input != Vector2.ZERO:
		$SpriteStack.set_rotation_sprites(velocity.angle())
