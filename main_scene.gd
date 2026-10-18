extends Node2D

const UP = Vector2(0,-1)
const DOWN = Vector2(0,1)
const LEFT = Vector2(-1,0)
const RIGHT = Vector2(1,0)

var window_position = Vector2(DisplayServer.window_get_position())
var usable = DisplayServer.screen_get_usable_rect()
var taskbar_bottom_y = usable.end.y
var taskbar_top_y = usable.position.y

var speed = 50
var direction = RIGHT
var screen_size = Vector2()
var window_size = Vector2(300, 300)
@onready var animated_sprite = $AnimatedSprite2D
@onready var area = $Area2D

var is_dragging = false
var drag_offset = Vector2()

var idle_timer = 0.0
var is_idling = false

var falling = false
@onready var sound = $AudioStreamPlayer

func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	animated_sprite.rotation_degrees = 0
	window_position.y = screen_size.y - window_size.y
	animated_sprite.play("crawl")
	area.input_event.connect(_on_area_input)
	
func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		
		
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = true
			sound.play()
			var mouse_pos = Vector2(DisplayServer.mouse_get_position())
			var win_pos = Vector2(DisplayServer.window_get_position())
			drag_offset = mouse_pos - win_pos
		else: 
			is_dragging = false
		
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT: 
			OS.shell_open('https://en.wikipedia.org/wiki/Snail')

func _physics_process(delta: float) -> void:
	
	if is_dragging:
		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		window_position = new_win_pos
		print(new_win_pos)
		return
	
	if !window_position.y >= screen_size.y - window_size.y and !window_position.x <= 0 and !window_position.y <= 50 and !window_position.x >= screen_size.x - window_size.x:
		falling = true
		window_position.y += delta * 1500
		speed = 0
		animated_sprite.rotate(0.2)
	else:
		speed = 50
		falling = false
		rotated()
	
	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = 50
			animated_sprite.play("crawl")
		return
	
	window_position += direction * speed * delta
	print(direction, window_position)
	print('taskbars: ', taskbar_bottom_y, ',', taskbar_top_y)
	print('falling: ', falling)
	print('vector 0: ', window_position.is_zero_approx())
	window_position.x = clamp(window_position.x, 0, screen_size.x - window_size.x)
	window_position.y = clamp(window_position.y, 0, screen_size.y - window_size.y)
	DisplayServer.window_set_position(Vector2i(window_position))
	
	
	if  direction != UP and window_position.x >= screen_size.x - window_size.x:
		print("moving UP")
		direction = UP
		animated_sprite.rotation_degrees = 270
		idle_maybe()
		
	elif direction != LEFT and window_position.y <= taskbar_top_y:
		print("moving LEFT")
		direction = LEFT
		animated_sprite.rotation_degrees = 180
		idle_maybe()
		
	elif direction != DOWN and window_position.x <= 0:
		print("moving DOWN")
		direction = DOWN
		animated_sprite.rotation_degrees = 90
		idle_maybe()
		
	elif direction != RIGHT and window_position.y >= taskbar_bottom_y - window_size.y:
		print("moving RIGHT")
		direction = RIGHT
		animated_sprite.rotation_degrees = 0
		idle_maybe()
		
	
func idle_maybe():
	if randf() < 0.3:
		is_idling = true
		idle_timer = randf_range(1.0, 3.0)
		animated_sprite.play("rest")
		speed = 0
	
func rotated():
	if direction == UP:
		animated_sprite.rotation_degrees = 270
	if direction == LEFT:
		animated_sprite.rotation_degrees = 180
	if direction == DOWN:
		animated_sprite.rotation_degrees = 90
	if direction == RIGHT:
		animated_sprite.rotation_degrees = 0
