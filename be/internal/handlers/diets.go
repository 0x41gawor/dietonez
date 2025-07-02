package handlers

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"github.com/0x41gawor/dietonez/internal/service"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type HandlerDiets struct {
	s *service.ServiceDiets
}

func NewHandlerDiets() *HandlerDiets {
	return &HandlerDiets{
		s: service.NewServiceDiets(),
	}
}

func (h *HandlerDiets) handleBaseGET(w http.ResponseWriter, r *http.Request) error {
	diets, err := h.s.ListAll(r.Context())
	if err != nil {
		return err
	}
	return WriteJSON(w, http.StatusOK, diets)
}

func (h *HandlerDiets) handleBasePOST(w http.ResponseWriter, r *http.Request) error {
	var in model.DietPost
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		return fmt.Errorf("decode: %w", err)
	}

	diet, err := h.s.Create(r.Context(), &in)
	if err != nil {
		return fmt.Errorf("create diet: %w", err)
	}

	return WriteJSON(w, http.StatusCreated, diet)
}

func (h *HandlerDiets) handlePutByID(w http.ResponseWriter, r *http.Request) error {
	parts := strings.Split(r.URL.Path, "/")
	if len(parts) < 5 {
		http.Error(w, "invalid path", http.StatusBadRequest)
		return nil
	}
	id, err := strconv.Atoi(parts[4])
	if err != nil {
		http.Error(w, "invalid id", http.StatusBadRequest)
		return nil
	}

	var in model.DietPut
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		return fmt.Errorf("decode: %w", err)
	}
	if in.ID != id {
		http.Error(w, "id mismatch", http.StatusBadRequest)
		return nil
	}

	diet, err := h.s.Update(r.Context(), &in)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			http.Error(w, "diet not found", http.StatusNotFound)
			return nil
		}
		return fmt.Errorf("update diet: %w", err)
	}

	return WriteJSON(w, http.StatusOK, diet)
}

func (h *HandlerDiets) handleDeleteByID(w http.ResponseWriter, r *http.Request) error {
	id, err := ParseIDFromPath(r)
	if err != nil {
		http.Error(w, "invalid ID", http.StatusBadRequest)
		return nil
	}

	err = h.s.Delete(r.Context(), id)
	if err != nil {
		if strings.Contains(err.Error(), "active") {
			http.Error(w, "cannot delete active diet", http.StatusBadRequest)
			return nil
		}
		return err
	}

	w.WriteHeader(http.StatusNoContent)
	return nil
}
