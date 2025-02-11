extends Node

signal player_change_view(view:String)
signal car_is_brealdown(car:Car)

var breakdown_car_array:Array[Car] # 故障车列表
#var maintain_breakdown_car_array:Array[Car] # 维修故障车列表
var jam_car:int # 统计拥堵车辆
var fault_value:int
