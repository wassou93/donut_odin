package quaternions


import "core:fmt"
import "core:math"

// A simple struct to hold our quaternion
Quaternion :: struct {
	w, x, y, z: f64,
}

// Helper procedure to multiply two quaternions (q_a * q_b)
multiply_quaternions :: proc(a, b: Quaternion) -> Quaternion {
	res: Quaternion
	res.w = a.w*b.w - a.x*b.x - a.y*b.y - a.z*b.z
	res.x = a.w*b.x + a.x*b.w + a.y*b.z - a.z*b.y
	res.y = a.w*b.y - a.x*b.z + a.y*b.w + a.z*b.x
	res.z = a.w*b.z + a.x*b.y - a.y*b.x + a.z*b.w
	return res
}

main :: proc() {
	// Start with the identity quaternion (no rotation)
	q := Quaternion{1.0, 0.0, 0.0, 0.0}

	// --- Create the small rotation quaternion ---
	d_theta := 0.02
	half_angle := d_theta / 2.0
	// This quaternion represents a small rotation around the Z-axis
	delta_q := Quaternion{
		w = math.cos(half_angle),
		x = 0.0,
		y = 0.0,
		z = math.sin(half_angle),
	}

	target_angle := math.PI * 2.0
	num_steps := int(target_angle / d_theta)

	fmt.printf("Target angle: %.4f\n", target_angle)
	fmt.printf("Total steps needed: %d\n", num_steps)

	for i in 1..=num_steps {
		// Apply the small rotation by multiplying quaternions
		q = multiply_quaternions(delta_q, q)

		// --- Normalization (identical logic, just with 4 components) ---
		length_squared := q.w*q.w + q.x*q.x + q.y*q.y + q.z*q.z

		correction_factor := (3.0 - length_squared) * 0.5

		q.w *= correction_factor
		q.x *= correction_factor
		q.y *= correction_factor
		q.z *= correction_factor

		// --- Option print progress ---
		if i % 25 == 0 {
			current_angle := f64(i) * d_theta
			
			// For a rotation around the Z-axis, we can extract the equivalent 2D cos/sin
			// This allows for direct comparison with your previous program!
			// cos(angle) = w*w - z*z
			// sin(angle) = 2*w*z
			c_equiv := q.w*q.w - q.z*q.z
			s_equiv := 2 * q.w * q.z

			fmt.printf("Step %d (Angle=%.2f): c=%.6f, s=%.6f, q_len^2=%.8f\n", i, current_angle, c_equiv, s_equiv, length_squared)
		}
	}

	// --- Final result ---
	final_angle := f64(num_steps) * d_theta
	c_final := q.w*q.w - q.z*q.z
	s_final := 2 * q.w * q.z
	fmt.println("Final Results:")
	fmt.printf("Calculated cos(%.4f) = %.6f\n", final_angle, c_final)
	fmt.printf("Calculated sin(%.4f) = %.6f\n", final_angle, s_final)

	// --- Verification ---
	fmt.println("Verification:")
	fmt.printf("math.cos(%.4f) = %.6f\n", final_angle, math.cos(final_angle))
	fmt.printf("math.sin(%.4f) = %.6f\n", final_angle, math.sin(final_angle))
}

