class_name SLSystem extends Resource

@export var archives_file:Dictionary={
}

var game_data_path:String="user://game_data.tres"
var data:SLSystem

##保存数据
func save_data(key:String,value):
	_init_file()
	data.archives_file[key]=value
	ResourceSaver.save(data, game_data_path)
 
##加载数据
func load_data(key:String):
	if FileAccess.file_exists(game_data_path):
		data=ResourceLoader.load(game_data_path) as SLSystem
		if not (key in data.archives_file):
			printerr("键 "+key+" 不存在")
			return
	else:
		printerr("文件不存在")
	return data.archives_file[key]

##打印出所有数据
func show_all_content():
	_init_file()
	if data.archives_file:
		print(data.archives_file)
	else:
		printerr("存档未写入任何内容")

##打印出特定的键值对
func show_certain_content(key:String):
	_init_file()
	if key in data.archives_file:
		print(key+" : "+"%d"%data.archives_file[key])
	else:
		printerr("键<"+key+">不存在")

##清空字典里的所有内容
func clear_content():
	_init_file()
	data.archives_file.clear()
	ResourceSaver.save(data, game_data_path)

##清除字典里的特定内容
func clear_certain_content(key:String):
	_init_file()
	if key in data.archives_file:
		data.archives_file.erase(key)
		ResourceSaver.save(data, game_data_path)
	else:
		printerr("键<"+key+">不存在")

##初始化文件，一般来说外界无需刻意调用
func _init_file():
	if FileAccess.file_exists(game_data_path):
		data = ResourceLoader.load(game_data_path) as SLSystem
	else:
		data = SLSystem.new()
		ResourceSaver.save(data, game_data_path)
