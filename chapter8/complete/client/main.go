package main

import (
	"fmt"
	"log"
	"net/http"
)

func IndexServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Hello World!")
}

func main() {
	handler := http.HandlerFunc(IndexServer)
	log.Println("Listening on :8080...")
	http.ListenAndServe(":8080", handler)
}
