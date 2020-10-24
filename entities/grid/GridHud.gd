extends Node2D

onready var grid: Grid = get_parent() as Grid

func _draw():
	var line: int = 2
	var line_color: Color
	
	for x in range(grid.grid_size.x):
		draw_line(Vector2(x * grid.cell_size.x, 0), Vector2(x * grid.cell_size.x, grid.grid_size.y * grid.cell_size.y), line_color, line)
	
	for y in range(grid.grid_size.y):
		draw_line(Vector2(0, y * grid.cell_size.y), Vector2(grid.grid_size.x * grid.cell_size.x, y * grid.cell_size.y), line_color, line)
