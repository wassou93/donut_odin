package example

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

main :: proc() {
	// reading a string
	fmt.print("Enter something: ")
	buffer: string
	read_input(&buffer)
	fmt.println(buffer)

	// reading a number
	fmt.print("Enter a number: ")
	read_input(&buffer)
	number, ok := strconv.parse_int(buffer); assert(ok)
	fmt.printf("The number entered is %d\n", number)
}

read_input :: proc(output: ^string) {
	buf: [256]byte
	num_bytes, err := os.read(os.stdin, buf[:]); assert(err == nil)
	output^ = strings.clone(strings.trim_space(string(buf[:num_bytes])))
}
