extends Area

var buoyancy_strength = 10.0  # Adjust as needed
var dampening_factor = 0.3    # To counteract the bouncing

func _ready():
	set_monitoring(true)
	set_monitorable(false)

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is RigidBody:
			var depth = global_transform.origin.y - body.global_transform.origin.y
			if depth > 0:
				var submerged_volume = min(depth, 1.0)  # Assuming a simple case
				var force = Vector3(0, buoyancy_strength * submerged_volume, 0) - body.linear_velocity * dampening_factor
				body.apply_central_impulse(force)
