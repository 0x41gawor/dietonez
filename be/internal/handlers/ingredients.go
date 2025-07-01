package handlers

import (
	"database/sql"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"
	"strconv"

	"github.com/0x41gawor/dietonez/internal/service"
	"github.com/0x41gawor/dietonez/internal/service/model"
	"github.com/gorilla/mux"
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

func (h *HandlerIngredients) handleBasePOST(w http.ResponseWriter, r *http.Request) error {
	slog.Debug("handleBasePOST",
		slog.String("method", r.Method),
		slog.String("url", r.URL.String()),
		slog.String("remote_addr", r.RemoteAddr),
		slog.String("user_agent", r.UserAgent()),
	)

	// Decode request body to IngredientPost
	var payload model.IngredientPost
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		return WriteJSON(w, http.StatusBadRequest, "invalid JSON body")
	}
	defer r.Body.Close()

	// Validate minimal required fields (you can expand this)
	if payload.Name == "" || payload.Unit == "" || payload.ShopStyle == "" {
		return WriteJSON(w, http.StatusBadRequest, "missing required fields")
	}

	// Call service to insert into DB
	id, err := h.s.Create(r.Context(), &payload)
	if err != nil {
		slog.Error("failed to create ingredient", "err", err)
		return err
	}

	// Return 201 Created with new ID
	return WriteJSON(w, http.StatusCreated, map[string]any{
		"id": id,
	})
}

func (h *HandlerIngredients) handleBulkPOST(w http.ResponseWriter, r *http.Request) error {
	slog.Debug("handleBulkPOST",
		slog.String("method", r.Method),
		slog.String("url", r.URL.String()),
		slog.String("remote_addr", r.RemoteAddr),
		slog.String("user_agent", r.UserAgent()),
	)

	var payload []model.IngredientPost
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		return WriteJSON(w, http.StatusBadRequest, "invalid JSON array")
	}
	defer r.Body.Close()

	if len(payload) == 0 {
		return WriteJSON(w, http.StatusBadRequest, "no ingredients provided")
	}

	created, err := h.s.CreateBulk(r.Context(), payload)
	if err != nil {
		slog.Error("bulk insert failed", "err", err)
		return err
	}

	return WriteJSON(w, http.StatusOK, map[string]any{
		"created": created,
	})
}

func (h *HandlerIngredients) handleBasePUT(w http.ResponseWriter, r *http.Request) error {
	slog.Debug("handleBasePUT",
		slog.String("method", r.Method),
		slog.String("url", r.URL.String()),
		slog.String("remote_addr", r.RemoteAddr),
		slog.String("user_agent", r.UserAgent()),
	)

	var payload []model.IngredientGetPut
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		return WriteJSON(w, http.StatusBadRequest, "invalid JSON array")
	}
	defer r.Body.Close()

	if len(payload) == 0 {
		return WriteJSON(w, http.StatusBadRequest, "no ingredients provided")
	}

	updated, err := h.s.UpdateBulk(r.Context(), payload)
	if err != nil {
		slog.Error("bulk update failed", "err", err)
		return err
	}

	return WriteJSON(w, http.StatusOK, map[string]any{
		"updated": updated,
	})
}

func (h *HandlerIngredients) handleGetByID(w http.ResponseWriter, r *http.Request) error {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil || id <= 0 {
		return WriteJSON(w, http.StatusBadRequest, "invalid id")
	}

	ing, err := h.s.GetByID(r.Context(), id)
	if err != nil {
		return err
	}
	if ing == nil {
		return WriteJSON(w, http.StatusNotFound, "ingredient not found")
	}

	return WriteJSON(w, http.StatusOK, ing)
}

func (h *HandlerIngredients) handleDeleteByID(w http.ResponseWriter, r *http.Request) error {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil || id <= 0 {
		return WriteJSON(w, http.StatusBadRequest, "invalid id")
	}

	err = h.s.DeleteByID(r.Context(), id)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return WriteJSON(w, http.StatusNotFound, "ingredient not found")
		}
		if err.Error() == "used_in_dish" {
			return WriteJSON(w, http.StatusBadRequest, "ingredient used in dish")
		}
		return err
	}

	w.WriteHeader(http.StatusNoContent)
	return nil
}
