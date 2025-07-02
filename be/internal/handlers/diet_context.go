package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/0x41gawor/dietonez/internal/service"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type HandlerDietContext struct {
	s *service.ServiceDietContext
}

func NewHandlerDietContext() *HandlerDietContext {
	return &HandlerDietContext{
		s: service.NewServiceDietContext(),
	}
}

func (h *HandlerDietContext) handleGet(w http.ResponseWriter, r *http.Request) error {
	ctx := r.Context()

	dc, err := h.s.Get(ctx)
	if err != nil {
		return err
	}
	if dc == nil {
		http.Error(w, "no context set", http.StatusNotFound)
		return nil
	}

	return WriteJSON(w, http.StatusOK, dc)
}

func (h *HandlerDietContext) handlePut(w http.ResponseWriter, r *http.Request) error {
	var payload model.DietContext
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		return WriteJSON(w, http.StatusBadRequest, "invalid JSON body")
	}
	defer r.Body.Close()

	updated, err := h.s.Update(r.Context(), &payload)
	if err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, updated)
}
