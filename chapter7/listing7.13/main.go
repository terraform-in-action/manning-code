package main

import (
	"fmt"
	"log"
	"net/http"
)

func IndexServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Automate all the things!")
}

func main() {
	handler := http.HandlerFunc(IndexServer)
	log.Fatal(http.ListenAndServe(":8080", handler))
}
