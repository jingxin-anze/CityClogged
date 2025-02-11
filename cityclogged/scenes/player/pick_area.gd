extends Area3D

@onready var projectiles: Node3D = %Projectiles
@onready var panel: Panel = %Panel
var projectile:Node3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("can_dropped"):
		projectile=body
		_on_target_entered_exited(true)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("can_dropped"):
		_on_target_entered_exited(false)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pick_drop"):
		if is_instance_valid(projectile):
			projectile.global_position=owner.global_position+Vector3(0,0.3,0)
			projectile.get_parent().remove_child(projectile)
			projectiles.add_child(projectile)

func _on_target_entered_exited(is_enter:bool):
	if is_enter:
		owner.can_pick=true
		panel.visible=true
	else:
		owner.can_pick=false
		panel.visible=false
