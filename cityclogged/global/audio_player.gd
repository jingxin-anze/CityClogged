extends Node

var audio_array:Array[AudioStreamPlayer]

##播放音频
func play(stream:AudioStream, single:bool=false,is_release:bool=true,volume:float=0,) -> AudioStreamPlayer:
	if single:
		# 获取所有的audio节点
		var audio_list = get_children()
		for audio_node in audio_list:
			if audio_node.stream.resource_path == stream.resource_path:
				audio_node.stream_paused=false
				return audio_node
				
	#创建播放器
	var audio=AudioStreamPlayer.new()
	#调整音量
	audio.volume_db=volume
	#传入音频文件
	audio.stream=stream
	#连接finished信号
	audio.finished.connect(_finished.bind(audio,is_release))
	#添加到场景树
	add_child(audio)
	#播放音频
	audio.playing=true
	#返回该音频节点
	return audio


##暂停此播放器
func pause(audio):
	audio.stream_paused=true

##让暂停的播放器继续播放
func contine(audio):
	audio.stream_paused=false

##销毁此播放器
func destory(audio):
	audio.stop()
	audio.queue_free()

#此函数的参数是在连接信号的的时候传入的
##音乐播放完自动执行
func _finished(audio,is_release):
	if is_release:
		audio.queue_free()
	audio.play()

##清除所有音乐
func clear():
	if not get_children().is_empty():
		var count=get_child_count()
		for i in range(count):
			var child=get_child(count-i-1)
			child.call_deferred("queue_free")
	else:
		return

##返回当前线程的线性音量 
func get_volume(bus_index:int):
	var db:=AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(db)

##需要注意传入的值是线性的。
func set_volume(bus_index:int,v:float):
	var db:=linear_to_db(v)
	AudioServer.set_bus_volume_db(bus_index,db)
