package handlers

import (
	"net/http"

	"github.com/0x41gawor/dietonez/internal/service"
)

type HandlerMenu struct {
	s *service.ServiceMenu
}

func NewHandlerMenu() *HandlerMenu {
	return &HandlerMenu{
		s: service.NewServiceMenu(),
	}
}

func (h *HandlerMenu) handleGet(w http.ResponseWriter, r *http.Request) error {
	ctx := r.Context()

	date, err := ParseDateFromQuery(r)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return nil
	}

	dc, err := h.s.Get(ctx, date)
	if err != nil {
		return err
	}
	if dc == nil {
		http.Error(w, "no context set", http.StatusNotFound)
		return nil
	}

	return WriteJSON(w, http.StatusOK, dc)
}
