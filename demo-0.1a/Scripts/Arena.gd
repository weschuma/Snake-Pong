extends Node2D


func _ready():
	draw_top()
	draw_bottom()
	draw_left()
	draw_right()
	draw_border()
	draw_grid()

func draw_top():
	var top = ColorRect.new()
	top.color = Global.color
	top.size = Vector2(Global.width,Global.gap_top)
	top.position = Vector2(0,0)
	add_child(top)

func draw_bottom():
	pass
	
func draw_left():
	pass
	
func draw_right():
	pass

func draw_border():
	pass
	
func draw_grid():
	pass
