extends Area3D

@onready var panel: Panel = %Panel

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("can_dropped"):
		_on_target_entered_exited(true)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("can_dropped"):
		_on_target_entered_exited(false)

func _on_target_entered_exited(is_enter:bool):
	if is_enter:
		owner.can_pick=true
		panel.visible=true
	else:
		owner.can_pick=false
		panel.visible=false
