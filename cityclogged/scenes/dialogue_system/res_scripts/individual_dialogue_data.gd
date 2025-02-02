extends Resource
class_name IndividualDialogueData

##人物名称
@export var character_name:String
##阵营
@export var faction:String
##内容
@export_multiline var content:String
##角色图片
@export var avatar_pic:Texture
##是否显示在左侧
@export var show_on_left:bool
##全局位置
@export var target_position:Vector2
