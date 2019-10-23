package main

import (
	"fmt"
	"log"
	"net/http"
)

func IndexServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Pikachu!")
}

func main() {
	handler := http.HandlerFunc(IndexServer)
	log.Println("Listening on :8080...")
	log.Fatal(http.ListenAndServe(":8080", handler))
}
