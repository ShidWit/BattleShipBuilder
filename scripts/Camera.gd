# This code is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
# To view a copy of this license, visit https://creativecommons.org/licenses/by-nc/4.0/legalcode
# or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
# See the full text of the license for the specific terms and conditions.

extends Camera3D

# Target node that the camera will orbit around
var target: Node
# Initial distance from the target
var distance_to_target = 10.0
# Speed of zooming in and out
var zoom_speed = 0.5
# Speed of orbiting around the target
var orbit_speed = 0.005
# Minimum pitch angle to prevent flipping
var min_pitch = -1.2
# Maximum pitch angle to prevent flipping
var max_pitch = 1.2
# Flag indicating whether the camera is currently orbiting
var orbiting = false
# Last mouse position for calculating mouse delta
var last_mouse_position = Vector2()
# Current pitch angle of the camera
var current_pitch = 0.0
# Current yaw angle of the camera
var current_yaw = 0.0

func _ready():
	# Set the initial target node (adjust the path accordingly)
	target = get_node("/root/MainScene/Block")
	# Set the initial mouse mode
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	# Handle mouse button events
	if event is InputEventMouseButton:
		# Right mouse button starts/stops orbiting
		if event.button_index == MOUSE_BUTTON_RIGHT:
			orbiting = event.pressed
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if orbiting else Input.MOUSE_MODE_HIDDEN)
			last_mouse_position = event.position

		# Zoom in with the mouse wheel up
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance_to_target = max(distance_to_target - zoom_speed, 1.0)

		# Zoom out with the mouse wheel down
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance_to_target += zoom_speed

	# Handle mouse motion events during orbiting
	elif event is InputEventMouseMotion and orbiting:
		var mouse_delta = event.relative
		update_camera_orbit(-mouse_delta)  # Invert the mouse_delta here

func update_camera_orbit(mouse_delta):
	# Update the camera's yaw and pitch angles based on mouse movement
	current_yaw += mouse_delta.x * orbit_speed
	current_pitch -= mouse_delta.y * orbit_speed  # Invert the sign for up and down movement
	current_pitch = clamp(current_pitch, min_pitch, max_pitch)

func _process(_delta):
	# Update the camera position and orientation
	if target:
		var target_pos = target.global_transform.origin
		var rotated_offset = Vector3(cos(current_pitch) * sin(current_yaw), sin(current_pitch), cos(current_pitch) * cos(current_yaw)) * distance_to_target
		global_transform.origin = target_pos + rotated_offset
		look_at(target_pos, Vector3.UP)
