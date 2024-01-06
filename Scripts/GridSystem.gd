# GridSystem.gd
extends Node

var grid_size = 1.0  # Adjust based on your block size

# Converts a world position to a grid-aligned position
func world_to_grid(world_position: Vector3) -> Vector3:
	return (world_position / grid_size).round() * grid_size
