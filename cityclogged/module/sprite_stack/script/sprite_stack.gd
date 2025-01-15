@tool
class_name Cars extends Sprite2D


@export var show_sprites:bool:
	set = set_show_sprites

@export var rotate_sprites:float = 0



func set_rotation_sprites(_rotation):
	for sprite in get_children():
		sprite.rotation = _rotation
	

func set_rotate_sprites_now(_rotate_sprites):
	for sprite in get_children():
		sprite.rotation = _rotate_sprites


func _process(delta: float) -> void:
	set_rotate_sprites_now(rotate_sprites)

func set_show_sprites(_show_sprites):
	show_sprites = _show_sprites
	if show_sprites:
		render_sprites()
	else:
		clear_sprites()

func clear_sprites():
	for sprite in get_children():
		sprite.queue_free()
		
func _ready() -> void:
	render_sprites()
	pass # Replace with function body.

	
func render_sprites():
	clear_sprites()
	for i in range(0, hframes):
		var next_sprite = Sprite2D.new()
		next_sprite.texture = texture
		next_sprite.hframes = hframes
		next_sprite.frame = i
		next_sprite.position.y = -i
		add_child(next_sprite)
