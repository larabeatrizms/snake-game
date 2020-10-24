extends Node2D

class_name SnakeHead

# Var
onready var direction = Vector2()

var delta_counter = 0

# Signals
signal move(entity, direction)
signal snake_increases(segment, segment_position)
signal snake_body_move(segment, segment_position)
signal size_of_snake_changed(length)

# Corpo da cobrinha
const scene_snake_body = preload("res://entities/snakeBody/SnakeBody.tscn")
onready var snake_body: Array = [self]


func _ready():
	$Player.connect("input_detected", self, "_on_Player_input_detected")
	emit_signal("size_of_snake_changed", snake_body.size())

func _process(delta):
	if(delta_counter > 20):
		if direction != Vector2():
			var old_position_of_body_in_front: Vector2 = self.position
			emit_signal("move", self, direction)
			if snake_body.size() > 1:
				for i in range(1, snake_body.size()):
					var temp_pos: Vector2 = snake_body[i].position
					emit_signal("snake_body_move", snake_body[i], old_position_of_body_in_front)
					old_position_of_body_in_front = temp_pos
		delta_counter = 0
			
	delta_counter += 1


func _on_Player_input_detected(new_direction):
	if new_direction != direction * -1:
		direction = new_direction
	print(direction)

func earn_points():
	var snake_body_instance: Node2D = scene_snake_body.instance() as Node2D
	snake_body.append(snake_body_instance)
	
	emit_signal("snake_increases", snake_body_instance, snake_body[-2].position)
	emit_signal("size_of_snake_changed", snake_body.size())
