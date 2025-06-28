package calc_fast

import "core:fmt"
import "core:math"

main :: proc() {
		
	c := 1.0
	s := 0.0

	d_theta := 0.02
	d_cos := math.cos(d_theta)
	d_sin := math.sin(d_theta)

	// Using tan = sin/cos propery and the fact that 1/cos is very close to 1 we can further simplify our d_rotation to this
	// d_tan := math.tan(d_theta)

	target_angle := math.PI * 2.0
	num_steps := int(target_angle / d_theta)

	fmt.printf("Target angle: %.4f\n", target_angle)
	fmt.printf("Total steps needed: %d\n", num_steps)

	for i in 1..=num_steps {
		c, s = c * d_cos - s * d_sin, c * d_sin + s * d_cos
		// c, s = c - s * d_tan, s + c * d_tan

		// Normalisation
		length_squared := c*c + s*s

		// Newton solution for the correction factor 1/sqrt(a)
		correction_factor := (3.0 - length_squared) * 0.5	

		c, s = c * correction_factor, s * correction_factor

		// Option print progress
		if i % 25 == 0 {
			current_angle := f64(i) * d_theta
			fmt.printf("Step %d (Angle=%.2f): c=%.6f, s=%.6f, c^2+s^2=%.8f\n", i, current_angle, c, s, length_squared)
		} 
	}

	// Final result
	final_angle := f64(num_steps) * d_theta
	fmt.println("Final Results:")
	fmt.printf("Calculated cos(%.4f) = %.6f\n", final_angle, c)
	fmt.printf("Calculated sin(%.4f) = %.6f\n", final_angle, s)

	// verification
	fmt.println("Verification:")
	fmt.printf("math.cos(%.4f) = %.6f\n", final_angle, math.cos(final_angle))
	fmt.printf("math.sin(%.4f) = %.6f\n", final_angle, math.sin(final_angle))

}

// optimizations source: https://www.a1k0n.net/2021/01/13/optimizing-donut.html
