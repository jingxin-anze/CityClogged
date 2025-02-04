extends Sprite2D

@onready var center:= $".."
var r:float=400
var speed:float=100
var is_positive:bool=true
var frames:int=0

func _ready() -> void:
	self.position=center.position+Vector2(r,0)

func _physics_process(delta: float) -> void:
	if is_positive:
		self.global_position.x-=delta*speed
		#根据数学原理，y始终为正
		var y:float=pow(pow(r,2)-pow((self.global_position.x-center.global_position.x),2),0.5)+center.global_position.y
		self.global_position.y=y
		
		#根据数学原理，若x超过界限则无法得到y值，所以要多加限制
		if self.global_position.x<=center.global_position.x-r+5:
			is_positive=false
	else:
		self.global_position.x+=delta*speed
		var y:float=pow(pow(r,2)-pow((self.global_position.x-center.global_position.x),2),0.5)+center.global_position.y
		self.global_position.y=-y
		printt(self.global_position.x,-y)
		if self.global_position.x>=center.global_position.x+r-5:
			is_positive=true
