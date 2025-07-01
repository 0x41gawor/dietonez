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

// handles GET in /ingredients
func (h *HandlerIngredients) handleBaseGET(w http.ResponseWriter, r *http.Request) error {
	slog.Debug("handleBaseGET",
		slog.String("method", r.Method),
		slog.String("url", r.URL.String()),
		slog.String("remote_addr", r.RemoteAddr),
		slog.String("user_agent", r.UserAgent()),
	)

	// parse query params
	q := r.URL.Query()
	page := parseInt(q.Get("page"), 1)
	pageSize := parseInt(q.Get("pageSize"), 30)
	short := parseBool(q.Get("short"), false)

	// get from service
	items, total, err := h.s.ListPaginated(r.Context(), page, pageSize, short)
	if err != nil {
		return err
	}

	// wrap in response object
	resp := map[string]any{
		"total":       total,
		"ingredients": items,
	}
	return WriteJSON(w, http.StatusOK, resp)
}
