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
	router.HandleFunc("/api/v1/ingredients", makeHTTPHandleFunc(apiIngredients.handleBasePOST)).Methods("POST")
	router.HandleFunc("/api/v1/ingredients/bulk", makeHTTPHandleFunc(apiIngredients.handleBulkPOST)).Methods("POST")
	router.HandleFunc("/api/v1/ingredients/bulk", makeHTTPHandleFunc(apiIngredients.handleBasePUT)).Methods("PUT")
	router.HandleFunc("/api/v1/ingredients/{id}", makeHTTPHandleFunc(apiIngredients.handleGetByID)).Methods("GET")
	router.HandleFunc("/api/v1/ingredients/{id}", makeHTTPHandleFunc(apiIngredients.handleDeleteByID)).Methods("DELETE")
	apiDishes := NewHandlerDishes()
	router.HandleFunc("/api/v1/dishes", makeHTTPHandleFunc(apiDishes.handleBaseGET)).Methods("GET")
	router.HandleFunc("/api/v1/dishes/{id}", makeHTTPHandleFunc(apiDishes.handleGetByID)).Methods("GET")
	router.HandleFunc("/api/v1/dishes", makeHTTPHandleFunc(apiDishes.handleBasePOST)).Methods("POST")
	router.HandleFunc("/api/v1/dishes/{id}", makeHTTPHandleFunc(apiDishes.handlePutByID)).Methods("PUT")
	router.HandleFunc("/api/v1/dishes/{id}", makeHTTPHandleFunc(apiDishes.handleDeleteByID)).Methods("DELETE")
	apiDiets := NewHandlerDiets()
	router.HandleFunc("/api/v1/diets", makeHTTPHandleFunc(apiDiets.handleBaseGET)).Methods("GET")
	router.HandleFunc("/api/v1/diets", makeHTTPHandleFunc(apiDiets.handleBasePOST)).Methods("POST")
	router.HandleFunc("/api/v1/diets/{id}", makeHTTPHandleFunc(apiDiets.handleGetByID)).Methods("GET")
	router.HandleFunc("/api/v1/diets/{id}", makeHTTPHandleFunc(apiDiets.handlePutByID)).Methods("PUT")
	router.HandleFunc("/api/v1/diets/{id}", makeHTTPHandleFunc(apiDiets.handleDeleteByID)).Methods("DELETE")
	apiDietContext := NewHandlerDietContext()
	router.HandleFunc("/api/v1/diet-context", makeHTTPHandleFunc(apiDietContext.handleGet)).Methods("GET")
	router.HandleFunc("/api/v1/diet-context", makeHTTPHandleFunc(apiDietContext.handlePut)).Methods("PUT")

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
