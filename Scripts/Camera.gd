extends Camera

var target: Node
var distance_to_target = 10.0
var zoom_speed = 0.5
var orbit_speed = 0.005
var min_pitch = -1.2  # Minimum pitch angle
var max_pitch = 1.2   # Maximum pitch angle
var orbiting = false
var last_mouse_position = Vector2()
var current_pitch = 0.0
var current_yaw = 0.0

func _ready():
	target = get_node("/root/MainScene/Block")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			orbiting = event.pressed
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if orbiting else Input.MOUSE_MODE_HIDDEN)
			last_mouse_position = event.position

		elif event.button_index == BUTTON_WHEEL_UP:
			distance_to_target = max(distance_to_target - zoom_speed, 1.0)

		elif event.button_index == BUTTON_WHEEL_DOWN:
			distance_to_target += zoom_speed

	elif event is InputEventMouseMotion and orbiting:
		var mouse_delta = event.relative
		update_camera_orbit(-mouse_delta)  # Invert the mouse_delta here

func update_camera_orbit(mouse_delta):
	current_yaw += mouse_delta.x * orbit_speed
	current_pitch += mouse_delta.y * orbit_speed
	current_pitch = clamp(current_pitch, min_pitch, max_pitch)

func _process(_delta):
	if target:
		var target_pos = target.global_transform.origin
		var rotated_offset = Vector3(cos(current_pitch) * sin(current_yaw), sin(current_pitch), cos(current_pitch) * cos(current_yaw)) * distance_to_target
		global_transform.origin = target_pos + rotated_offset
		look_at(target_pos, Vector3.UP)
