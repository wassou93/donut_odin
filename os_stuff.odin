package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

read_input :: proc(output: ^string) {
	buf: [256]byte
	num_bytes, err := os.read(os.stdin, buf[:]); assert(err == nil)
	output^ = strings.clone(strings.trim_space(string(buf[:num_bytes])))
}


// ... (keep the read_line_manually function exactly as it is) ...

get_screen_size :: proc() -> (width: int, height: int) {
	width = 80
	height = 40

	fmt.printf("Default terminal size is %vx%v\n", width, height)
	fmt.print("Would you like to enter a custom size? (y/n): ")

	trimmed_response: string
	read_input(&trimmed_response)

	if len(trimmed_response) > 0 && (trimmed_response[0] == 'Y' || trimmed_response[0] == 'y') {
		fmt.print("Enter width: ")

		width_str: string
		read_input(&width_str)
		width, ok_w:= strconv.parse_int(strings.trim_space(width_str)); assert(ok_w)

		fmt.print("Enter height: ")
		height_str: string
		read_input(&height_str)
		height, ok_h:= strconv.parse_int(strings.trim_space(height_str)); assert(ok_h)
	}

	return
}

