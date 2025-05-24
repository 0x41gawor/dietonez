package handlers

import (
	"net/http"

	"github.com/0x41gawor/dietonez/internal/service"
)

type HandlerIngredientUnits struct {
	s service.ServiceIngredientUnits
}

func NewHandlerIngredientUnits() *HandlerIngredientUnits {
	s := service.NewServiceIngredientUnits()
	return &HandlerIngredientUnits{
		s: *s,
	}
}

// handles "/ingredient-units" path
func (h *HandlerIngredientUnits) handleBase(w http.ResponseWriter, r *http.Request) error {
	switch r.Method {
	case "GET":
		return h.handleBaseGET(w, r)
	default:
		return WriteJSON(w, http.StatusMethodNotAllowed, "error: method not allowed")
	}
}

// handles GET in /ingredient-units
func (h *HandlerIngredientUnits) handleBaseGET(w http.ResponseWriter, r *http.Request) error {
	// service action
	models, err := h.s.List()
	if err != nil {
		return err
	}
	// return model
	return WriteJSON(w, http.StatusOK, models)
}
