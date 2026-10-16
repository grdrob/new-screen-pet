extends Node2D

const UP = Vector2(0,-1)
const DOWN = Vector2(0,1)
const LEFT = Vector2(-1,0)
const RIGHT = Vector2(1,0)

var window_position = Vector2(DisplayServer.window_get_position())
var usable = DisplayServer.screen_get_usable_rect()

var speed = 500
var direction = RIGHT
var screen_size = Vector2()
var window_size = Vector2(300, 300)
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	animated_sprite.rotation_degrees = 0
	window_position.y = screen_size.y - window_size.y
	animated_sprite.play("crawl")
	
	

func _physics_process(delta: float) -> void:
	
	window_position += direction * speed * delta
	print(direction, window_position)
	print(DisplayServer.screen_get_usable_rect())
	#print("before: ", window_position)
	window_position.x = clamp(window_position.x, 0, screen_size.x - window_size.x)
	window_position.y = clamp(window_position.y, 0, screen_size.y - window_size.y)
	#print("clamped: ", window_position)
	DisplayServer.window_set_position(Vector2i(window_position))
	
	if  direction != UP and window_position.x >= screen_size.x - window_size.x:
		print("moving UP")
		direction = UP
		animated_sprite.rotation_degrees = 270
		
	elif direction != LEFT and window_position.y <= 50:
		print("moving LEFT")
		direction = LEFT
		animated_sprite.rotation_degrees = 180
		
	elif direction != DOWN and window_position.x <= 0:
		print("moving DOWN")
		direction = DOWN
		animated_sprite.rotation_degrees = 90
		
	elif direction != RIGHT and window_position.y >= screen_size.y - window_size.y:
		print("moving RIGHT")
		direction = RIGHT
		animated_sprite.rotation_degrees = 0
		
	
	
