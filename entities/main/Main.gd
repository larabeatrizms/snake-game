extends Node

# Scenes
const food = preload("res://entities/food/Food.tscn")
const snake = preload("res://entities/snakeHead/SnakeHead.tscn")

onready var grid: Grid = get_node("Grid") as Grid

# Player
var snake_head: Node2D

# Inicialização 
func setup():
	snake_head = snake.instance() as Node2D
	snake_head.connect("move", self, "_on_SnakeHead_move")
	add_child(snake_head)

func _ready():
	setup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_SnakeHead_move(snake, direction):
	grid.move_snake(snake, direction)

func _on_Grid_game_over():
	pass # Replace with function body.

