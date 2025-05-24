package handlers

import (
	"log/slog"
	"net/http"

	"github.com/0x41gawor/dietonez/internal/service"
)

type HandlerIngredients struct {
	s service.ServiceIngredients
}

func NewHandlerIngredients() *HandlerIngredients {
	service := service.NewServiceIngredients()
	return &HandlerIngredients{
		s: *service,
	}
}

// handles "/ingredients" path
func (h *HandlerIngredients) handleBase(w http.ResponseWriter, r *http.Request) error {
	slog.Debug("")
	switch r.Method {
	case "GET":
		return h.handleBaseGET(w, r)
	default:
		return WriteJSON(w, http.StatusMethodNotAllowed, "error: method not allowed")
	}
}

// handles GET in /ingredients
func (h *HandlerIngredients) handleBaseGET(w http.ResponseWriter, r *http.Request) error {
	// service action
	models, err := h.s.List()
	if err != nil {
		return err
	}
	// return model
	return WriteJSON(w, http.StatusOK, models)
}
