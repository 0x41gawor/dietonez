package handlers

import (
	"database/sql"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"

	"github.com/0x41gawor/dietonez/internal/service"
	"github.com/0x41gawor/dietonez/internal/service/model"
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

func (h *HandlerDishes) handleBasePOST(w http.ResponseWriter, r *http.Request) error {
	var payload model.DishPost
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		return WriteJSON(w, http.StatusBadRequest, "invalid JSON body")
	}
	defer r.Body.Close()

	// minimalna walidacja
	if payload.Name == "" || payload.Meal == "" || len(payload.Ingredients) == 0 {
		return WriteJSON(w, http.StatusBadRequest, "missing required fields")
	}

	dish, err := h.s.Create(r.Context(), &payload)
	if err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, dish)
}

func (h *HandlerDishes) handlePutByID(w http.ResponseWriter, r *http.Request) error {
	id := parseInt(mux.Vars(r)["id"], 0)
	if id <= 0 {
		return WriteJSON(w, http.StatusBadRequest, "invalid id")
	}

	var payload model.DishPut
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		return WriteJSON(w, http.StatusBadRequest, "invalid JSON body")
	}
	defer r.Body.Close()

	if payload.ID != id {
		return WriteJSON(w, http.StatusBadRequest, "mismatched id in URL vs body")
	}

	updated, err := h.s.Update(r.Context(), id, &payload)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return WriteJSON(w, http.StatusNotFound, "dish not found")
		}
		return err
	}

	return WriteJSON(w, http.StatusOK, updated)
}

func (h *HandlerDishes) handleDeleteByID(w http.ResponseWriter, r *http.Request) error {
	id := parseInt(mux.Vars(r)["id"], 0)
	if id <= 0 {
		return WriteJSON(w, http.StatusBadRequest, "invalid id")
	}

	err := h.s.DeleteByID(r.Context(), id)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return WriteJSON(w, http.StatusNotFound, "dish not found")
		}
		if err.Error() == "used_in_diet" {
			return WriteJSON(w, http.StatusBadRequest, "dish is used in a diet and cannot be deleted")
		}
		return err
	}

	w.WriteHeader(http.StatusNoContent)
	return nil
}
