# This code is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
# To view a copy of this license, visit https://creativecommons.org/licenses/by-nc/4.0/legalcode
# or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
# See the full text of the license for the specific terms and conditions.

extends Area3D

# Strength of the buoyancy force (adjust as needed)
var buoyancy_strength = 5.0
# Dampening factor to counteract bouncing
var dampening_factor = 0.3

func _ready():
	# Enable monitoring for the area
	set_monitoring(true)
	set_monitorable(false)

func _physics_process(_delta):
	# Get a list of bodies overlapping with the area
	var bodies = get_overlapping_bodies()
	# Apply buoyancy force to overlapping RigidBody3D bodies
	for body in bodies:
		if body is RigidBody3D:
			# Calculate the depth of submersion
			var depth = global_transform.origin.y - body.global_transform.origin.y
			# Check if the body is submerged
			if depth > 0:
				# Calculate the submerged volume (assuming a simple case)
				var submerged_volume = min(depth, 1.0)
				# Calculate buoyancy force
				var force = Vector3(0, buoyancy_strength * submerged_volume, 0) - body.linear_velocity * dampening_factor
				# Apply the buoyancy force as a central impulse to the body
				body.apply_central_impulse(force)
