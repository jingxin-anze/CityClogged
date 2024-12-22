@tool
extends ConfirmationDialog

#获取节点引用
@onready var an: AnimationPlayer 
@onready var path: LineEdit = $HBoxContainer/Path
@onready var value: LineEdit = $HBoxContainer/Value
@onready var label:  = %Label
@onready var menu_button: MenuButton = $HBoxContainer/Value/MenuButton
@onready var current_label: Label = $HBoxContainer/Value/CurrentLabel

#枚举值类型
enum value_type{
	i,
	f,
	s,
	b,
	v2,
}
#给current_v_t赋初值
var current_v_t:=value_type.i
#定义52大小写字母数组
var letter52:PackedStringArray

func _ready() -> void:
	#给letter52赋值
	letter52=spawn_52_letters()
	#给ok_button连接pressed信号
	get_ok_button().pressed.connect(_on_ok_pressed)
	#赋初值
	label.editable=false
	label.placeholder_text="未找到任何动画"
	path.placeholder_text="请输入路径"
	value.placeholder_text="请输入值"
	#获取menu_button的popup
	var popup:PopupMenu=menu_button.get_popup()
	#让popup连接id_pressed信号
	popup.id_pressed.connect(_select_type)
	pass

#匹配id。match相当于一些语言的switch
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

#替换该路径的第一个关键帧的值
func _on_ok_pressed():
	var tracks:PackedStringArray
	#遍历动画名
	for animation_name in an.get_animation_list():	
		var animation :=an.get_animation(animation_name)
		#获取该动画的指定路径
		var certain_track:=animation.find_track(str(path.text),Animation.TYPE_VALUE)
		#若此动画无该路径则返回
		if certain_track==-1:
			continue
		#更改指定路径的第一个关键帧的值
		match current_v_t:
			value_type.i:
				if not has_letter(value.text,"输入的类型不为int"):
					animation.track_set_key_value(certain_track,0,int(value.text))
			value_type.f:
				if not has_letter(value.text,"输入的类型不为float"):
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
				if not has_letter(value.text,"输入的类型不为Vector2"):
					var splited:PackedStringArray=value.text.split(",")
					var x:float=float(splited[0])
					var y:float=float(splited[1])
					animation.track_set_key_value(certain_track,0,Vector2(x,y))
				pass

#获取52大小写字母
func spawn_52_letters()->PackedStringArray:
	var shuzu:PackedStringArray
	for i in range(65,90+1):
		shuzu.append(String.chr(i))
	for i in range(97,122+1):
		shuzu.append(String.chr(i))
	return shuzu

#判定是否含有字母
func has_letter(input:String,output:String)->bool:
	for i in input:
		if i in letter52:
			printerr(output)
			return true
	return false
