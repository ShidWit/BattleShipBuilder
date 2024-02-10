# Licensed under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International.
# Full license: https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
# Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

extends Camera3D

# Configuration
var target: Node  # The target node for the camera to orbit around.
var distance_to_target = 10.0  # Initial distance from the target.
var zoom_speed = 0.5  # Speed of zooming in and out.
var orbit_speed = 0.005  # Speed of orbiting around the target.
var min_pitch = -0.1  # Minimum pitch angle to prevent camera flipping.
var max_pitch = 1.0  # Maximum pitch angle to prevent camera flipping.
var orbiting = false  # Tracks if the camera is currently orbiting.
var last_mouse_position = Vector2()  # Tracks the last mouse position for delta calculation.
var current_pitch = 0.0  # Current pitch angle of the camera.
var current_yaw = 0.0  # Current yaw angle of the camera.

func _ready():
	# Initialize the camera's target and mouse mode.
	target = get_node("/root/MainScene/Block")  # Adjust the node path as necessary.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide the mouse cursor at start.

func _input(event):
	# Process input events to handle camera controls.
	if event is InputEventMouseButton:
		handle_mouse_button_events(event)
	elif event is InputEventMouseMotion and orbiting:
		handle_mouse_motion_events(event)

func handle_mouse_button_events(event: InputEventMouseButton):
	# Handles mouse button inputs for orbiting and zooming.
	if event.button_index == MOUSE_BUTTON_RIGHT:
		# Toggle orbiting state and mouse mode on right click.
		orbiting = event.pressed
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if orbiting else Input.MOUSE_MODE_HIDDEN)
		last_mouse_position = event.position
	elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
		# Zoom in with mouse wheel up.
		distance_to_target = max(distance_to_target - zoom_speed, 1.0)
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		# Zoom out with mouse wheel down.
		distance_to_target += zoom_speed

func handle_mouse_motion_events(event: InputEventMouseMotion):
	# Update camera orbit based on mouse movement.
	var mouse_delta = event.relative
	update_camera_orbit(-mouse_delta.x, -mouse_delta.y)  # Pass inverted deltas for intuitive control.

func update_camera_orbit(delta_x: float, delta_y: float):
	# Updates the camera's orbit around the target based on mouse movement.
	# Remove the inversion for delta_x to maintain original left/right control direction.
	current_yaw += delta_x * orbit_speed  # Keep the side-to-side direction as originally intended
	current_pitch += delta_y * orbit_speed  # Up and down remains unchanged
	current_pitch = clamp(current_pitch, min_pitch, max_pitch)  # Prevent flipping.

func _process(_delta):
	# Continuously update the camera's position and orientation to orbit around the target.
	if target:
		update_camera_position()

func update_camera_position():
	# Calculate and apply the camera's position based on its orbit around the target.
	var target_pos = target.global_transform.origin
	var rotated_offset = Vector3(cos(current_pitch) * sin(current_yaw), sin(current_pitch), cos(current_pitch) * cos(current_yaw)) * distance_to_target
	global_transform.origin = target_pos + rotated_offset
	look_at(target_pos, Vector3.UP)  # Orient the camera to look at the target.
