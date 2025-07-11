extends Node


# Arena
var tile_size = 32 # each tile will be n x n pixels
var tile_x = 42 # number of tiles along x-axis
var tile_y = 42 # number of tiles along y-axis
var border_thickness = 1 # borders will be n pixels thick
var gap_middle = 64 # each grid will be spaced n pixels apart
var gap_top = 64 # grid will start n pixels from top of screen
var gap_bottom = 64 # grid will start n pixels from bottom of screen
var gap_left = 64 # left grid will start n pixels from left
var gap_right = 64 # right grid will end n pixels from right

var grid_width = (tile_size + border_thickness)*tile_x
var grid_height = (tile_size + border_thickness)*tile_y
var width = gap_left + grid_width + gap_middle + grid_width + gap_right
var height = gap_top + grid_height + gap_bottom

var color = Color.BLACK


func _ready():
	DisplayServer.window_set_size(Vector2i(width,height))
