package handlers

import (
	"net/http"

	"github.com/0x41gawor/dietonez/internal/service"
)

type HandlerShoppingList struct {
	s *service.ServiceShoppingList
}

func NewHandlerShoppingList() *HandlerShoppingList {
	return &HandlerShoppingList{
		s: service.NewServiceShoppingList(),
	}
}

func (h *HandlerShoppingList) handleGet(w http.ResponseWriter, r *http.Request) error {
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

	return WriteJSON(w, http.StatusOK, dc)
}
