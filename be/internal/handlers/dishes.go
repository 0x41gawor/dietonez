package handlers

import (
	"log/slog"
	"net/http"

	"github.com/0x41gawor/dietonez/internal/service"
	"github.com/gorilla/mux"
)

type HandlerDishes struct {
	s *service.ServiceDishes
}

func NewHandlerDishes() *HandlerDishes {
	s := service.NewServiceDishes()
	return &HandlerDishes{s: s}
}

func (h *HandlerDishes) handleBaseGET(w http.ResponseWriter, r *http.Request) error {
	meal := r.URL.Query().Get("meal")
	if meal == "" {
		return WriteJSON(w, http.StatusBadRequest, map[string]string{"error": "missing 'meal' query param"})
	}

	dishes, err := h.s.ListByMeal(r.Context(), meal)
	if err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, dishes)
}

func (h *HandlerDishes) handleGetByID(w http.ResponseWriter, r *http.Request) error {
	slog.Debug("handleGetByID", slog.String("url", r.URL.String()))

	id := parseInt(mux.Vars(r)["id"], 0)

	dish, err := h.s.GetByID(r.Context(), id)
	if err != nil {
		return err
	}
	if dish == nil {
		return WriteJSON(w, http.StatusNotFound, "dish not found")
	}

	return WriteJSON(w, http.StatusOK, dish)
}
