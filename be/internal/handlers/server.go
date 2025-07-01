package handlers

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rs/cors"
)

type Server struct {
	listenPort string
}

func NewServer(listenPort string) *Server {
	return &Server{
		listenPort: listenPort,
	}
}

func (s *Server) Run() {
	router := mux.NewRouter()

	apiIngredients := NewHandlerIngredients()

	router.HandleFunc("/api/v1/ingredients", makeHTTPHandleFunc(apiIngredients.handleBaseGET)).Methods("GET")

	c := cors.New(cors.Options{
		AllowedOrigins: []string{"*"},
		AllowedMethods: []string{"GET", "POST", "DELETE", "PUT"},
		AllowedHeaders: []string{"*"},
	})
	routerWithCors := c.Handler(router)

	log.Println("JSON API server running on port:", s.listenPort)
	http.ListenAndServe(s.listenPort, routerWithCors)
}

type apiFunc func(http.ResponseWriter, *http.Request) error

func makeHTTPHandleFunc(f apiFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// just calling the func
		err := f(w, r)
		if err != nil {
			WriteJSON(w, http.StatusInternalServerError, fmt.Sprintf("error: %s", err.Error()))
		}
	}
}
