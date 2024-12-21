@tool
extends ConfirmationDialog

@onready var an: AnimationPlayer 
@onready var path: LineEdit = $HBoxContainer/Path
@onready var value: LineEdit = $HBoxContainer/Value
@onready var label:  = %Label
@onready var menu_button: MenuButton = $HBoxContainer/Value/MenuButton
@onready var current_label: Label = $HBoxContainer/Value/CurrentLabel

enum value_type{
	i,
	f,
	s,
	b,
	v2,
}
var current_v_t:=value_type.i
var letter56:PackedStringArray

func _ready() -> void:
	letter56=spawn_56_letters()
	get_ok_button().pressed.connect(_on_ok_pressed)
	
	label.editable=false
	label.placeholder_text="未找到任何动画"
	path.placeholder_text="请输入路径"
	value.placeholder_text="请输入值"
	
	var popup:PopupMenu=menu_button.get_popup()
	popup.id_pressed.connect(_select_type)
	pass
	
func _select_type(id:int):
	match id:
		0:
			current_v_t=value_type.i
			current_label.text="当前类型为int"
		1:
			current_v_t=value_type.f
			current_label.text="当前类型为float"
		2:
			current_v_t=value_type.s
			current_label.text="当前类型为String"
		3:
			current_v_t=value_type.b
			current_label.text="当前类型为bool"
		4:
			current_v_t=value_type.v2
			current_label.text="当前类型为Vector2"
		pass
		
func _on_ok_pressed():
		#遍历动画列表的动画名
	var tracks:PackedStringArray
	for animation_name in an.get_animation_list():	

		var animation :=an.get_animation(animation_name)

		for track in animation.get_track_count():

			var track_path=animation.track_get_path(track)
			tracks.append(track_path)
			#获取指定路径
			var certain_track:=animation.find_track(str(path.text),Animation.TYPE_VALUE)
			#更改指定路径,第一个关键帧的值
			match current_v_t:
				value_type.i:
					has_letter(value.text,"输入的类型不为int")
					animation.track_set_key_value(certain_track,0,int(value.text))
				value_type.f:
					has_letter(value.text,"输入的类型不为float")
					animation.track_set_key_value(certain_track,0,float(value.text))
				value_type.s:
					animation.track_set_key_value(certain_track,0,str(value.text))
				value_type.b:
					if value.text=="true":
						animation.track_set_key_value(certain_track,0,true)
					elif value.text=="false":
						animation.track_set_key_value(certain_track,0,false)
					else:
						return
				value_type.v2:
					if not "," in value.text:
						return
					var splited:PackedStringArray=value.text.split(",")
					var x:float=float(splited[0])
					var y:float=float(splited[1])
					animation.track_set_key_value(certain_track,0,Vector2(x,y))
					pass

func spawn_56_letters()->PackedStringArray:
	var shuzu:PackedStringArray
	for i in range(65,90+1):
		shuzu.append(String.chr(i))
	for i in range(97,122+1):
		shuzu.append(String.chr(i))
	return shuzu

func has_letter(input:String,output:String)->bool:
	for i in input:
		if i in letter56:
			printerr(output)
			return true
	return false
