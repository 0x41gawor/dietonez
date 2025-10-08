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
	min := parseBool(r.URL.Query().Get("min"), false)
	if min {
		diets, err := h.s.ListMinAll(r.Context())
		if err != nil {
			return err
		}
		return WriteJSON(w, http.StatusOK, diets)
	}
	diets, err := h.s.ListAll(r.Context())
	if err != nil {
		return err
	}
	return WriteJSON(w, http.StatusOK, diets)
}

func (h *HandlerDiets) handleGetByID(w http.ResponseWriter, r *http.Request) error {
	// zakładamy pattern typu /api/v1/diets/{id}
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

	diet, err := h.s.GetByID(r.Context(), id)
	if err != nil {
		return fmt.Errorf("get diet: %w", err)
	}

	return WriteJSON(w, http.StatusOK, diet)
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

func (h *HandlerDiets) handlePatchShortByID(w http.ResponseWriter, r *http.Request) error {
	id, err := ParseIDFromPath("diets", r)
	if err != nil {
		http.Error(w, "invalid ID", http.StatusBadRequest)
		return nil
	}

	var in model.DietShort
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		return fmt.Errorf("decode: %w", err)
	}
	if in.ID != id {
		http.Error(w, "id mismatch", http.StatusBadRequest)
		return nil
	}

	err = h.s.UpdateShort(r.Context(), &in)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			http.Error(w, "diet not found", http.StatusNotFound)
			return nil
		}
		return fmt.Errorf("update short: %w", err)
	}

	w.WriteHeader(http.StatusNoContent)
	return nil
}

func (h *HandlerDiets) handleDeleteByID(w http.ResponseWriter, r *http.Request) error {
	id, err := ParseIDFromPath("diets", r)
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

func (h *HandlerDiets) handlePatchSlotByID(w http.ResponseWriter, r *http.Request) error {
	dietId, err := ParseIDFromPath("diets", r)
	if err != nil {
		http.Error(w, "invalid ID", http.StatusBadRequest)
		return nil
	}

	var in model.DietSlotPut
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		return fmt.Errorf("decode: %w", err)
	}

	err = h.s.UpdateSlot(r.Context(), dietId, &in)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			http.Error(w, "diet not found", http.StatusNotFound)
			return nil
		}
		return fmt.Errorf("update slot: %w", err)
	}

	w.WriteHeader(http.StatusNoContent)
	return nil
}

func (h *HandlerDiets) handleExportByID(w http.ResponseWriter, r *http.Request) error {
	// --- Parse diet ID from path ---
	dietId, err := ParseIDFromPath("diets", r)
	if err != nil {
		http.Error(w, "invalid ID", http.StatusBadRequest)
		return nil
	}

	// --- Parse query parameters: start, end ---
	startStr := r.URL.Query().Get("start")
	endStr := r.URL.Query().Get("end")

	if startStr == "" || endStr == "" {
		http.Error(w, "missing start or end parameter", http.StatusBadRequest)
		return nil
	}

	start, err := strconv.Atoi(startStr)
	if err != nil {
		http.Error(w, "invalid start parameter", http.StatusBadRequest)
		return nil
	}

	end, err := strconv.Atoi(endStr)
	if err != nil {
		http.Error(w, "invalid end parameter", http.StatusBadRequest)
		return nil
	}

	// --- Optional sanity check ---
	if end < start {
		http.Error(w, "end must be >= start", http.StatusBadRequest)
		return nil
	}

	// --- Call service ---
	exportData, err := h.s.Export(r.Context(), dietId, start, end)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			http.Error(w, "diet not found", http.StatusNotFound)
			return nil
		}
		return fmt.Errorf("export diet: %w", err)
	}

	// --- Return JSON response (can be changed to CSV if needed) ---
	return WriteJSON(w, http.StatusOK, exportData)
}
