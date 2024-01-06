extends Node

var block_scene: PackedScene
var grid_node: Node
var placed_blocks = {}  # Dictionary to keep track of placed blocks

func _ready():
	block_scene = preload("res://Scenes/Block.tscn")  # Load your block scene
	grid_node = get_node("GridSystem")  # Get the GridSystem node
	var ui = get_node("Control")  # Replace "Control" with the actual path to your Control node

	# Connect UI signals to the respective functions
	ui.connect("add_block", self, "_on_add_block")
	ui.connect("remove_block", self, "_on_remove_block")
	ui.connect("switch_to_test_mode", self, "_on_switch_to_test_mode")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			handle_block_interaction(event.global_position, true)
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			handle_block_interaction(event.global_position, false)

func handle_block_interaction(mouse_position, is_adding_block):
	var camera = $Camera  # Make sure this path points to your Camera node
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 1000
	var space_state = camera.get_world().direct_space_state
	var result = space_state.intersect_ray(ray_origin, ray_end)
	
	if result:
		var grid_position = grid_node.world_to_grid(result.position)
		if is_adding_block:
			add_block(grid_position)
		else:
			remove_block(grid_position)

func add_block(grid_position):
	if grid_position in placed_blocks or not is_adjacent_to_existing_block(grid_position):
		return  # Block already exists or is not adjacent to an existing block

	var new_block = block_scene.instance()
	new_block.global_transform.origin = grid_position
	add_child(new_block)
	placed_blocks[grid_position] = new_block

func remove_block(grid_position):
	if grid_position in placed_blocks:
		var block = placed_blocks[grid_position]
		remove_child(block)
		block.queue_free()
		placed_blocks.erase(grid_position)

func is_adjacent_to_existing_block(grid_position: Vector3) -> bool:
	var adjacent_offsets = [Vector3(1, 0, 0), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(0, 0, -1)]
	for offset in adjacent_offsets:
		if grid_position + offset in placed_blocks:
			return true
	return false

func _on_add_block():
	var default_position = Vector3(0, 0, 0)
	add_block(default_position)

func _on_remove_block():
	var default_position = Vector3(0, 0, 0)
	remove_block(default_position)

func switch_to_test_mode():
	print("Switching to test mode...")
