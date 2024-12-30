extends Area3D

@onready var alert_robot:CharacterBody3D=self.get_parent()
@onready var player:Player=get_tree().get_first_node_in_group("player")

var speed:int=80
var can_track:bool
var dir:Vector3


func _on_body_entered(body: Node3D) -> void:
		pass
		
func _physics_process(delta: float) -> void:
	pass
