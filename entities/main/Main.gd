extends Node

# Scenes
const food = preload("res://entities/food/Food.tscn")
const snake = preload("res://entities/snakeHead/SnakeHead.tscn")

onready var grid: Grid = get_node("Grid") as Grid

# Player
var snake_head: Node2D

# Inicialização de entidades
func setup():
	snake_head = snake.instance() as Node2D
	snake_head.connect("move", self, "_on_SnakeHead_move")
	snake_head.connect("snake_body_move", self, "_on_Snake_body_move")
	snake_head.connect("snake_increases", self, "_on_Snake_increases")
	snake_head.connect("size_of_snake_changed", self, "_on_Size_of_snake_changed")
	add_child(snake_head)
	move_child(snake_head, 0)
	grid.set_at_random_position(snake_head)
	
	var food_node: Node2D = food.instance() as Node2D
	add_child_below_node(snake_head, food_node)
	grid.set_at_random_position(food_node)

func _ready():
	randomize()
	setup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_SnakeHead_move(snake, direction):
	grid.move_snake(snake, direction)

func _on_Grid_game_over():
	var entities_snake = get_tree().get_nodes_in_group("Player")
	for entity in entities_snake:
		entity.queue_free()
	var entities_food = get_tree().get_nodes_in_group("Food")
	for entity in entities_food:
		entity.queue_free()
	
	setup()

func _on_Grid_earn_points(food_entity, entity):
	if entity.has_method("earn_points"):
		entity.earn_points()
		food_entity.queue_free()
		var food_node: Node2D = food.instance() as Node2D
		add_child_below_node(snake_head, food_node)
		grid.set_at_random_position(food_node)

func _on_Snake_increases(snake_body: Node2D, snake_body_position: Vector2):
	add_child_below_node(snake_head, snake_body)
	grid.place_entity(snake_body, grid.world_to_map(snake_body_position))
	
func _on_Snake_body_move(snake_body: Node2D, snake_body_position: Vector2) -> void:
	grid.move_to_position(snake_body, snake_body_position)

func _on_Size_of_snake_changed(points: int):
	$MainHud/Points.set_text(str(points))
