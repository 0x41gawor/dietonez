package handlers

import (
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"

	"github.com/0x41gawor/dietonez/internal/service"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type HandlerTools struct {
	s service.ServiceTools
}

func NewHandlerTools() *HandlerTools {
	service := service.NewServiceTools()
	return &HandlerTools{
		s: *service,
	}
}

// handles POST in /tools/nutrition-summary
func (h *HandlerTools) handleNutritionSummaryPOST(w http.ResponseWriter, r *http.Request) error {
	slog.Debug("handleNutritionSummaryPOST",
		slog.String("method", r.Method),
		slog.String("url", r.URL.String()),
		slog.String("remote_addr", r.RemoteAddr),
		slog.String("user_agent", r.UserAgent()),
	)

	// parse JSON body
	var input []model.IngredientInDishPut
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		return errors.New("invalid JSON body")
	}

	// calculate
	summary, err := h.s.CalculateSummary(r.Context(), input)
	if err != nil {
		return err
	}

	// respond
	return WriteJSON(w, http.StatusOK, summary)
}

// handles POST in /tools/day-summary
func (h *HandlerTools) handleDaySummaryPOST(w http.ResponseWriter, r *http.Request) error {
	slog.Debug("handleDaySummaryPOST",
		slog.String("method", r.Method),
		slog.String("url", r.URL.String()),
		slog.String("remote_addr", r.RemoteAddr),
		slog.String("user_agent", r.UserAgent()),
	)

	// parse request body
	var req model.DaySummaryRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		return errors.New("invalid JSON body")
	}

	// call service
	resp, err := h.s.CalculateDaySummary(r.Context(), req.Dishes, req.Goal)
	if err != nil {
		return err
	}

	// respond
	return WriteJSON(w, http.StatusOK, resp)
}
