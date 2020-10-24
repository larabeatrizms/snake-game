extends TileMap

class_name Grid

# Sinais
signal game_over
signal earn_points(food_entity, entity)

# Variáveis
onready var grid_size = Vector2(32, 18)
var grid: Array

# Inicializa o Grid
func setup_grid(): 
	grid = []
	
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

# Função auxiliar q Coloca entidade em uma posição
func set_object_in_position(entity, grid_pos):
	grid[grid_pos.x][grid_pos.y] = entity	

func get_object_of_position(grid_pos):
	return grid[grid_pos.x][grid_pos.y] as Node2D
	
# Coloca entidade em uma posição
func place_entity(entity, grid_pos):
	set_object_in_position(entity, grid_pos)
	entity.set_position(map_to_world(grid_pos))

func _ready():
	setup_grid()

# Movimenta o player
# Validações: próxima posição é dentro da janela, 
# se a próxima posição é o do grupo Player ou Food
# se for do grupo Player emite sinal gameover
# se for do grupo Food emite sinal earn_points
func move_snake(snake, direction):
	var temp_aux: Vector2
	var old_position = world_to_map(snake.position)
	var pos: Vector2 = old_position + direction
	
	# Quando atravessa a parede
	if !is_cell_inside_the_screen(pos):
		if pos.x >= grid_size.x:
			temp_aux = Vector2(0, pos.y)
		if pos.x < 0:
			temp_aux = Vector2(grid_size.x - 1, pos.y)
		if pos.y >= grid_size.y:
			temp_aux = Vector2(pos.x, 0)
		if pos.y < 0:
			temp_aux = Vector2(pos.x, grid_size.y - 1)
		pos = temp_aux
	var object_in_position: Node2D = get_object_of_position(pos)
	if object_in_position != null:
		if object_in_position.is_in_group("Player"):
			setup_grid()
			emit_signal("game_over")
			return
		elif object_in_position.is_in_group("Food"):
			emit_signal("earn_points", object_in_position, snake)
	grid[old_position.x][old_position.y] = null
	grid[pos.x][pos.y] = snake
	snake.position = map_to_world(pos)

# Função boleana se a entidade está ou não na tela
func is_cell_inside_the_screen(cell_pos):
	if(cell_pos.x < grid_size.x and cell_pos.x >= 0 \
		and cell_pos.y < grid_size.y and cell_pos.y >= 0):
			return true
	else:
		return false

# Posiciona em uma posição randomica
func set_at_random_position(entity: Node2D):
	var has_random_pos= false
	var random_grid_pos: Vector2
	
	while has_random_pos == false:
		var temp_pos: Vector2 = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if get_object_of_position(temp_pos) == null:
			random_grid_pos = temp_pos
			has_random_pos = true
	
	place_entity(entity, random_grid_pos)

# Movimenta uma entidade
func move_to_position(entity: Node2D, new_pos: Vector2):
	var old_position = world_to_map(entity.position)
	var new_position = world_to_map(new_pos)
	
	set_object_in_position(null, old_position)
	place_entity(entity, new_position)
	entity.set_position(new_pos)
