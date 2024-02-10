# Licensed under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International.
# Full license: https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
# Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

extends Area3D

# Constants to control physics behavior
const BUOYANCY_STRENGTH = 5.0  # The upward force applied to submerged objects.
const DAMPENING_FACTOR = 0.20  # Reduces bouncing by applying a counter force based on velocity.

func _ready():
	# Initializes area monitoring to detect objects entering or leaving the water.
	set_monitoring(true)
	set_monitorable(false)  # Tzhis area doesn't need to be detected by other areas.

func _physics_process(_delta):
	# Process physics interactions for each frame.
	apply_buoyancy_to_submerged_bodies()

func apply_buoyancy_to_submerged_bodies():
	# Applies buoyancy forces to all RigidBody3D objects that are submerged in the water.
	var bodies = get_overlapping_bodies()  # Detect all physics bodies within the water area.
	for body in bodies:
		if body is RigidBody3D:
			var depth = calculate_submersion_depth(body)
			if depth > 0:  # Check if the body is actually submerged.
				var force = calculate_buoyancy_force(body, depth)
				body.apply_central_impulse(force)

func calculate_submersion_depth(body: RigidBody3D) -> float:
	# Determines how deep the body is submerged in water.
	return global_transform.origin.y - body.global_transform.origin.y

func calculate_buoyancy_force(body: RigidBody3D, depth: float) -> Vector3:
	# Calculates the force to apply based on the depth of submersion and body velocity.
	var submerged_volume = min(depth, 1.0)  # Simplified volume calculation.
	var upward_force = Vector3(0, BUOYANCY_STRENGTH * submerged_volume, 0)
	var dampening_force = body.linear_velocity * DAMPENING_FACTOR
	return upward_force - dampening_force
