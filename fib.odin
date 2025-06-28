package main

// import "core:fmt"

// main :: proc() {
// 	fmt.println("fib 100:", fibonacci_iter(100))
// 	// fmt.println("fib 10:", fibonacci_recursive_trivial(10))
// 	fmt.println("fib 100:", fibonacci_recursive_fast(100))
// }

fibonacci_iter :: proc(n: int) -> int {
	if n <= 1 do return n
	f1, f0 := 0, 1
	for _ in 2..=(n + 1) {
		f1, f0 = f1 + f0, f1
	}
	return f1
}

fibonacci_recursive_trivial :: proc(n: int) -> int {
	if n <= 1 do return n
	else do return fibonacci_recursive_trivial(n - 1) + fibonacci_recursive_trivial(n - 2)
}

fibonacci_recursive_fast :: proc(n: int, memo: ^[]int = nil) -> int {
	if memo == nil {
		m := make([]int, n + 1)
		if n > 1 do m[1] = 1
		return fibonacci_recursive_fast(n, &m)
	}
	if n <= 1 do return n
	if memo[n] != 0 do return memo[n]
	memo[n] = fibonacci_recursive_fast(n - 1, memo) + fibonacci_recursive_fast(n - 2, memo)
	return memo[n]
}

