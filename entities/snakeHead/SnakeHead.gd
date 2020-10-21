extends Node2D

class_name SnakeHead

# Var
onready var direction = Vector2()

var delta_counter = 0

# Signals
signal move(entity, direction)

func _ready():
	$Player.connect("input_detected", self, "_on_Player_input_detected")

func _process(delta):
	if(delta_counter > 20):
		if direction != Vector2():
			emit_signal("move", self, direction)
		delta_counter = 0
			
	delta_counter += 1

func _on_Player_input_detected(new_direction):
	if new_direction != direction * -1:
		direction = new_direction
	print(direction)
