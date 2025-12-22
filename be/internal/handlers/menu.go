package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/0x41gawor/dietonez/internal/service"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type HandlerMenu struct {
	sm *service.ServiceMenu
	sc *service.ServiceCounter
}

func NewHandlerMenu() *HandlerMenu {
	return &HandlerMenu{
		sm: service.NewServiceMenu(),
		sc: service.NewServiceCounter(),
	}
}

func (h *HandlerMenu) handleGet(w http.ResponseWriter, r *http.Request) error {
	ctx := r.Context()

	date, err := ParseDateFromQuery(r)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return nil
	}

	dc, err := h.sm.Get(ctx, date)
	if err != nil {
		return err
	}
	if dc == nil {
		http.Error(w, "no context set", http.StatusNotFound)
		return nil
	}

	return WriteJSON(w, http.StatusOK, dc)
}

func (h *HandlerMenu) handlePUT(w http.ResponseWriter, r *http.Request) error {
	var record model.UpsertCounterRecord
	if err := json.NewDecoder(r.Body).Decode(&record); err != nil {
		return err
	}

	if err := h.sc.UpsertCounterRecord(r.Context(), record); err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, map[string]string{"status": "success"})
}

func (h *HandlerMenu) handleDELETE(w http.ResponseWriter, r *http.Request) error {
	var idx model.CounterRecordIndex
	if err := json.NewDecoder(r.Body).Decode(&idx); err != nil {
		return fmt.Errorf("invalid json: %w", err)
	}

	if err := h.sc.DeleteCounterRecord(r.Context(), idx); err != nil {
		return fmt.Errorf("delete counter record: %w", err)
	}

	w.WriteHeader(http.StatusNoContent)
	return nil
}

func (h *HandlerMenu) handleSlotPUT(w http.ResponseWriter, r *http.Request) error {
	var record model.UpsertDietSlotsCounterRecord
	if err := json.NewDecoder(r.Body).Decode(&record); err != nil {
		return err
	}
	if err := h.sc.UpsertDietSlotsCounterRecord(r.Context(), record); err != nil {
		return err
	}

	return WriteJSON(w, http.StatusOK, map[string]string{"status": "success"})
}

func (h *HandlerMenu) handleSlotDELETE(w http.ResponseWriter, r *http.Request) error {
	var record model.DietSlotsCounterRecordIndex
	if err := json.NewDecoder(r.Body).Decode(&record); err != nil {
		return err
	}
	if err := h.sc.DeleteDietSlotsCounterRecord(r.Context(), record); err != nil {
		return err
	}
	return WriteJSON(w, http.StatusOK, map[string]string{"status": "success"})

}
