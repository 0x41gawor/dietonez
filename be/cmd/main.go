package main

import "github.com/0x41gawor/dietonez/internal/handlers"

func main() {
	server := handlers.NewServer(":8080")
	server.Run()
}
