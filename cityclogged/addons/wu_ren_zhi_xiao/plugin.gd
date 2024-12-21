@tool
extends EditorPlugin

const ITEM_ID:int=44

var an:AnimationPlayer
var cached_button: MenuButton


func _enter_tree() -> void:
	for node in EditorInterface.get_selection().get_selected_nodes():
		if node is AnimationPlayer:
			an=node

	var button=get_animation_button()
	var popup=button.get_popup()
	popup.id_pressed.connect(_on_id_pressed)
	if popup.get_item_index(ITEM_ID) !=-1:
		return

	popup.add_item("弹出更改菜单",44)
	pass

func _handles(object: Object) -> bool:
	return object is AnimationPlayer
	
func _edit(object: Object) -> void:
	if not object:
		return
	an=object as AnimationPlayer

#获取MenuButton
func get_animation_button() -> MenuButton:
	if not cached_button:
		var editor := get_animation_player_editor()
		if not editor:
			return null
		
		var hb := get_first_typed_child(editor, "HBoxContainer")
		if not hb:
			return null
		
		var button := get_first_typed_child(hb, "MenuButton")
		if not button:
			return null
	
		cached_button = button
	
	return cached_button

#获取AnimationPlayerEditor并返回
func get_animation_player_editor() -> Node:
	var nodes := [EditorInterface.get_base_control()]
	while nodes:
		var node := nodes.pop_front() as Node
		if node.get_class() == "AnimationPlayerEditor":
			return node
		nodes.append_array(node.get_children())
	return null


func _on_id_pressed(id:int)-> void:
	if id!=ITEM_ID:
		return
	
	if not an:
		return

	var edit_menu:=preload("res://addons/wu_ren_zhi_xiao/Tracks.tscn").instantiate()
	EditorInterface.get_base_control().add_child(edit_menu)

	edit_menu.popup_centered_ratio(0.4)
	edit_menu.an=an
	edit_menu.label.text=animation_tracks_path()
	edit_menu.visibility_changed.connect(edit_menu.queue_free)

func animation_tracks_path()->String:
	var tracks:PackedStringArray
	for animation_name in an.get_animation_list():	
		tracks.append("\n"+str(animation_name)+"\n")
		var animation :=an.get_animation(animation_name)

		for track in animation.get_track_count():
			#获取轨道路径
			var track_path=animation.track_get_path(track)

			tracks.append(str(track_path)+"\n")
	
	var final_string:String
	for i in tracks:
		final_string=final_string+i

	return final_string
			
			
func get_first_typed_child(parent: Node, klass: String) -> Node:
	for i in parent.get_child_count():
		var node := parent.get_child(i) as Node
		if node.get_class() == klass:
			return node
	return null
