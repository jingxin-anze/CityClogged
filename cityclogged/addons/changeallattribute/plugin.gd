@tool
extends EditorPlugin

#定义item_id
const ITEM_ID:int=44
#定义播放器
var an:AnimationPlayer
#定义menubutton
var cached_button: MenuButton

#该函数在插件进入节点树时起效
func _enter_tree() -> void:
	#选出选中节点中的最后一个AnimationPlayer，并给an赋值
	for node in EditorInterface.get_selection().get_selected_nodes():
		if node is AnimationPlayer:
			an=node
	#获得menubutton
	var button:MenuButton=get_animation_button()
	#给menubutton连接信号
	button.pressed.connect(_on_button_pressed)
	#获得menubutton的popupmenu
	var popup:PopupMenu=button.get_popup()
	#给popupmenu链接is_pressed信号
	popup.id_pressed.connect(_on_id_pressed)
	#若该id的索引不为-1，即存在该item则return
	if popup.get_item_index(ITEM_ID) !=-1:
		return
	#给popupmenu添加item
	popup.add_item("弹出更改菜单",ITEM_ID)
	pass

#该函数在插件退出节点树时起效
func _exit_tree() -> void:
	#获取menubutton和popupmenu
	var button:MenuButton=get_animation_button()
	var popup:PopupMenu=button.get_popup()
	#若该id的inde不为-1，即item存在，则移除item
	if popup.get_item_index(ITEM_ID) !=-1:
		popup.remove_item(popup.get_item_index(ITEM_ID))

#当选中任意含有句柄的任意物品时触发，返回该句柄的对象
func _handles(object: Object) -> bool:
	#当对象是AnimationPlayer返回true，并调用_edit
	return object is AnimationPlayer
	
#若object为空则return，否则给an赋值
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

#当item被按下时触发，参数为该item的id
func _on_id_pressed(id:int)-> void:
	#若此id不为ITEM_ID则return
	if id!=ITEM_ID:
		return
	#若不存在AnimationPlayer则return
	if not an:
		return
	#实例化edit_menu并初始化
	var edit_menu:=preload("res://addons/changeallattribute/tracks.tscn").instantiate()
	EditorInterface.get_base_control().add_child(edit_menu)
	edit_menu.popup_centered_ratio(0.4)
	edit_menu.an=an
	edit_menu.label.text=animation_tracks_path()
	edit_menu.visibility_changed.connect(edit_menu.queue_free)

func _on_button_pressed():
	var button:MenuButton=get_animation_button()
	var popup:PopupMenu=button.get_popup()
	if an:
		popup.set_item_disabled(ITEM_ID,false)
		popup.set_item_tooltip(ITEM_ID,"")
	else:
		popup.set_item_disabled(ITEM_ID,true)
		popup.set_item_tooltip(ITEM_ID,"请确认选中了AnimationPlayer")
	
#获取所有动画的轨道路径
func animation_tracks_path()->String:
	var tracks:PackedStringArray
	#获取所有的动画名称
	for animation_name in an.get_animation_list():	
		tracks.append("\n"+str(animation_name)+"\n")
		var animation :=an.get_animation(animation_name)
		#获取该动画的所有轨道路径
		for track in animation.get_track_count():
			var track_path=animation.track_get_path(track)
			tracks.append(str(track_path)+"\n")
	#最终以字符串的形式返回
	var final_string:String
	for i in tracks:
		final_string=final_string+i
	return final_string
			
#获取第一个特定类型的节点
func get_first_typed_child(parent: Node, klass: String) -> Node:
	#遍历parent的所有的子节点的数量
	for i in parent.get_child_count():
		var node := parent.get_child(i) as Node
		#若该节点是klass则返回该节点
		if node.get_class() == klass:
			return node
	#若没有找到特定节点则返回null
	return null

	
	
