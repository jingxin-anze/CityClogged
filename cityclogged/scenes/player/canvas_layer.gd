extends CanvasLayer

@onready var jam_value: RichTextLabel = %JamValue
@onready var fault_value: RichTextLabel = %FaultValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	jam_value.text= "拥堵值为："+str(Global.jam_car)
	fault_value.text="故障值为："+str(Global.fault_value)
	
	pass
