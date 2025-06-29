package main

import "core:math"
import "base:runtime"
import "core:time"
import "core:fmt"

screen_width :: 80
screen_height :: 32

main :: proc() {
	// Constants
	r1 :f32 = 1.0
	r2 :f32 = 2.0
	k2 :f32 = 5


	k1x := f32(screen_width) * k2 * 2.0 / (8.0 * (r1 + r2))
	k1y := f32(screen_height) * k2 * 2.0 / (8.0 * r2)

	brightness_chars := ".,-~:=!*#$@"

	// Rotation angles
	angleA: f32 = 0.0
	angleB: f32 = 0.0

	// Output and depth buffers
	oBuffer: [screen_width][screen_height]u8
	zBuffer: [screen_width][screen_height]f32

	// Clear screen
	runtime.print_string("\x1b[2J")

	for {
		// Clear buffers
		for x in 0..<screen_width {
			for y in 0..<screen_height {
				oBuffer[x][y] = ' '
				zBuffer[x][y] = 0.0
			}
		}

		sinA, cosA := math.sin_f32(angleA), math.cos_f32(angleA)
		sinB, cosB := math.sin_f32(angleB), math.cos_f32(angleB)

		for theta: f32 = 0.0; theta < 2.0 * math.PI; theta += 0.07 {
			sinTheta, cosTheta := math.sin_f32(theta), math.cos_f32(theta)

			for phi: f32 = 0.0; phi < 2.0 * math.PI; phi += 0.02 {
				sinPhi, cosPhi := math.sin_f32(phi), math.cos_f32(phi)

				// Compute 3D position of the donut point
				circle_x := r2 + r1 * cosTheta
				circle_y := r1 * sinTheta

				// 3D rotation
				x := circle_x * (cosB * cosPhi + sinA * sinB * sinPhi) - circle_y * cosA * sinB
				y := circle_x * (sinB * cosPhi - sinA * cosB * sinPhi) + circle_y * cosA * cosB
				z := k2 + cosA * circle_x * sinPhi + circle_y * sinA
				invZ := 1.0 / z

				// Project to 2D
				xp := int(f32(screen_width) / 2.0 + k1x * invZ * x)
				yp := int(f32(screen_height) / 2.0 + k1y * invZ * y)

				// Luminance
				luminance := cosPhi * cosTheta * sinB - cosA * cosTheta * sinPhi - 
							 sinA * sinTheta + cosB * (cosA * sinTheta - cosTheta * sinA * sinPhi)

				if 	0 <= xp && xp < screen_width &&
					0 <= yp && yp < screen_height &&
					invZ > zBuffer[xp][yp] {
						zBuffer[xp][yp] = invZ
						// Set the correct ASCII based on brightness
						luminance_index := int(luminance * 8.0)
						if 0 <= luminance_index && luminance_index < len(brightness_chars) {
							oBuffer[xp][yp] = brightness_chars[luminance_index]
					}
				}
			}
		}

		// Clear screen and move cursor to top
		runtime.print_string("\x1b[2J\x1b[H")

		// Render frame
		for y in 0..<screen_height {
			for x in 0..<screen_width {
				runtime.print_byte(oBuffer[x][y])
			}
			runtime.print_byte('\n')
		}

		// Animate rotation
		angleA += 0.02
		angleB += 0.04

		time.sleep(16 * time.Millisecond)
		// fmt.printf("\x1b[23A")
	}
}

