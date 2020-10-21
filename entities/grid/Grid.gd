extends TileMap

class_name Grid

export var speed = 300

# Sinais
signal game_over
signal moved_into_outside_screen(new_grid_pos)
signal earn_points(food_entity, entity)

# Variáveis
onready var grid_size = Vector2(32, 24)
var grid
onready var half_cell_size = get_cell_size() / 2

func set_entity_in_position(entity, grid_pos):
	grid[grid_pos.x][grid_pos.y] = entity
	
func get_entity_of_position(grid_pos):
	return grid[grid_pos.x][grid_pos.y] as Node2D
	
func setup_grid(): 
	grid = []
	
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			

func place_entity(entity, grid_pos):
	set_entity_in_position(entity, grid_pos)
	entity.set_position(map_to_world(grid_pos) + half_cell_size)

func _ready():
	setup_grid()

# Movimenta o player
# Validações: próxima posição é dentro da janela, 
# se a próxima posição é o do grupo Player ou Food
func move_snake(snake, direction):
	var old_grid_pos: Vector2 = world_to_map(snake.position)
	var new_grid_pos: Vector2 = old_grid_pos + direction
	
	# Atravessa parede
	if !is_cell_inside_the_screen(new_grid_pos):
		print("snake_cross_the_wall")
		print(new_grid_pos)
		var new_grid_pos_cross_the_wall: Vector2
		if new_grid_pos.x + 1 > grid_size.x:
			new_grid_pos_cross_the_wall = Vector2(-1, new_grid_pos.y)
		if new_grid_pos.x <= -1:
			new_grid_pos_cross_the_wall = Vector2(grid_size.x - 1, new_grid_pos.y)
		print(new_grid_pos_cross_the_wall)
		set_entity_in_position(null, old_grid_pos)
		
		place_entity(snake, new_grid_pos_cross_the_wall)
		return
	
	var new_position = get_entity_of_position(new_grid_pos)
	#if new_position != null:
		#if new_position.is_in_group("Player"):
			#setup_grid()
			#emit_signal("game_over")
			#return
		#elif new_position.is_in_group("Food"):
			#emit_signal("earn_points", new_position, snake)
			#return
	set_entity_in_position(null, old_grid_pos)
	
	place_entity(snake, new_grid_pos)

func is_cell_inside_the_screen(cell_pos):
	if(cell_pos.x < grid_size.x and cell_pos.x >= 0 \
		and cell_pos.y < grid_size.y and cell_pos.y >= 0):
			return true
	else:
		return false
