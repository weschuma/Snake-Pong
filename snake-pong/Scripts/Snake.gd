extends Node2D

@export var GRID_DIMENSIONS = Vector2(50, 50)
@export var TILE_SIZE = 10
@export var DEBUG_DRAW_GRID := true
@export var player_prefix := "p1"
@export var grid_offset := Vector2.ZERO

var direction = Vector2.RIGHT
var next_direction = direction
var snake_position = []
var segment_sprites = []
var new_segment = false
var direction_changed = false

func _ready() -> void:
	var start_pos = Vector2(GRID_DIMENSIONS.x / 8, GRID_DIMENSIONS.y / 2)
	snake_position = [start_pos, start_pos - Vector2(1, 0), start_pos - Vector2(2, 0)]

	# Create initial visual sprites
	for segment in snake_position:
		var s = Sprite2D.new()
		s.texture = preload("res://icon.svg") # Replace with your own sprite
		s.scale = Vector2(TILE_SIZE, TILE_SIZE) / s.texture.get_size()
		s.position = segment * TILE_SIZE + grid_offset
		add_child(s)
		segment_sprites.append(s)

	draw_borders()
	queue_redraw()

func _input(event):
	if direction_changed:
		return

	if Input.is_action_just_pressed(player_prefix + "_up") and direction != Vector2.DOWN:
		next_direction = Vector2.UP
		direction_changed = true
	elif Input.is_action_just_pressed(player_prefix + "_down") and direction != Vector2.UP:
		next_direction = Vector2.DOWN
		direction_changed = true
	elif Input.is_action_just_pressed(player_prefix + "_left") and direction != Vector2.RIGHT:
		next_direction = Vector2.LEFT
		direction_changed = true
	elif Input.is_action_just_pressed(player_prefix + "_right") and direction != Vector2.LEFT:
		next_direction = Vector2.RIGHT
		direction_changed = true

func move_snake():
	direction_changed = false
	direction = next_direction
	var new_head = snake_position[0] + direction

	if new_head in snake_position or not is_inside_grid(new_head):
		get_tree().reload_current_scene()
		return

	snake_position.insert(0, new_head)
	if not new_segment:
		snake_position.pop_back()
	else:
		new_segment = false

	update_snake_visuals()

func update_snake_visuals():
	while segment_sprites.size() < snake_position.size():
		var s = Sprite2D.new()
		s.texture = preload("res://icon.svg")
		s.scale = Vector2(TILE_SIZE, TILE_SIZE) / s.texture.get_size()
		s.position = Vector2(-TILE_SIZE, -TILE_SIZE)
		add_child(s)
		segment_sprites.append(s)

	for i in snake_position.size():
		var sprite = segment_sprites[i]
		var target_pos = snake_position[i] * TILE_SIZE + grid_offset

		var tween = create_tween()
		tween.tween_property(sprite, "position", target_pos, 0.15).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		sprite.show()

	for i in range(snake_position.size(), segment_sprites.size()):
		segment_sprites[i].hide()

func is_inside_grid(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.x < GRID_DIMENSIONS.x and pos.y >= 0 and pos.y < GRID_DIMENSIONS.y

func _on_move_timer_timeout() -> void:
	move_snake()

func draw_borders():
	var border_thickness = 4
	var screen_size = GRID_DIMENSIONS * TILE_SIZE
	var border_color = Color.BLACK

	var top = ColorRect.new()
	top.color = border_color
	top.size = Vector2(screen_size.x, border_thickness)
	top.position = grid_offset
	add_child(top)

	var bottom = ColorRect.new()
	bottom.color = border_color
	bottom.size = Vector2(screen_size.x, border_thickness)
	bottom.position = grid_offset + Vector2(0, screen_size.y - border_thickness)
	add_child(bottom)

	var left = ColorRect.new()
	left.color = border_color
	left.size = Vector2(border_thickness, screen_size.y)
	left.position = grid_offset
	add_child(left)

	var right = ColorRect.new()
	right.color = border_color
	right.size = Vector2(border_thickness, screen_size.y)
	right.position = grid_offset + Vector2(screen_size.x - border_thickness, 0)
	add_child(right)

func _draw():
	if not DEBUG_DRAW_GRID:
		return

	var size = GRID_DIMENSIONS * TILE_SIZE
	var color = Color(0.7, 0.7, 0.7, 0.4)
	var offset = grid_offset
	var line_offset = TILE_SIZE * 0.05

	for x in range(GRID_DIMENSIONS.x + 1):
		var xpos = x * TILE_SIZE + line_offset
		draw_line(Vector2(xpos, 0) + offset, Vector2(xpos, size.y) + offset, color)

	for y in range(GRID_DIMENSIONS.y + 1):
		var ypos = y * TILE_SIZE + line_offset
		draw_line(Vector2(0, ypos) + offset, Vector2(size.x, ypos) + offset, color)
