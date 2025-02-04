extends Control

@export_group("UI")
@export var character_name_text : Label
@export var text_box : Label
@export var left_avatar : TextureRect
@export var right_avatar : TextureRect

@export_group("对话")
@export var main_dialogue : DialogueGroup

var dialogue_index := 0

func display_next_dialogue():
	if dialogue_index>=len(main_dialogue.dialogue_array):
		return
		
	var individual_dialogue:IndividualDialogueData = main_dialogue.dialogue_array[dialogue_index]
	character_name_text.text=individual_dialogue.character_name 
	text_box.text=individual_dialogue.content
	if individual_dialogue.show_on_left:
		left_avatar.texture=individual_dialogue.avatar_pic
	else:
		right_avatar.texture=individual_dialogue.avatar_pic
	dialogue_index+=1

func _ready() -> void:

	var list:PackedInt32Array=DisplayServer.get_window_list()
	var size:Vector2i=Vector2i(1920,1080)
	var ss:Vector2i=DisplayServer.screen_get_size()
	DisplayServer.window_set_size(size,list[0])
	DisplayServer.window_set_position(Vector2(ss.x/2-1920/2,ss.y/2-1080/2),list[0])

	display_next_dialogue()
	
	
	


func _on_root_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			display_next_dialogue()
