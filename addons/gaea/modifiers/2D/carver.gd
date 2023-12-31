@tool
@icon("carver.svg")
class_name Carver
extends ChunkAwareModifier2D
## Uses noise to remove certain tiles from the map.
##@tutorial(Carver Modifier): https://benjatk.github.io/Gaea/#/modifiers?id=-carver


@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var random_noise_seed := true
## Any values in the noise texture that go above this threshold
## will be deleted from the map. (-1.0 is black, 1.0 is white)[br]
## Lower values mean more empty areas.
@export_range(-1.0, 1.0) var threshold := 0.15
@export_group("Bounds", "bounds_")
@export var bounds_enabled: bool = false
@export var bounds_max := Vector2(0, 0)
@export var bounds_min := Vector2(-0, -0)


func _apply_area(area: Rect2i, grid: GaeaGrid, _generator: GaeaGenerator) -> void:
	for x in range(area.position.x, area.end.x + 1):
		for y in range(area.position.y, area.end.y + 1):
			for layer in affected_layers:
				var cell := Vector2i(x, y)
				if not grid.has_cell(cell, layer) or _is_out_of_bounds(cell):
					continue

				if not _passes_filter(grid, cell):
					continue

				if noise.get_noise_2d(cell.x, cell.y) > threshold:
					grid.erase(cell, layer)


func _is_out_of_bounds(cell: Vector2i) -> bool:
	if not bounds_enabled:
		return false
	return (cell.x > bounds_max.x or cell.y > bounds_max.y or
			cell.x < bounds_min.x or cell.y < bounds_min.y)
