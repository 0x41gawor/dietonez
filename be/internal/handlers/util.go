package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

type Response struct {
	Res string `json:"res"`
}

func NewResponse(res string) *Response {
	return &Response{
		Res: res,
	}
}

func WriteJSON(w http.ResponseWriter, status int, v any) error {
	w.Header().Add("Content-Type", "application/json;charset=utf-8")
	w.WriteHeader(status)
	return json.NewEncoder(w).Encode(v)
}

func getID(r *http.Request) (int64, error) {
	idStr := mux.Vars(r)["id"]
	id, err := strconv.Atoi(idStr)
	id64 := int64(id)
	if err != nil {
		return id64, fmt.Errorf("parsing id from path error: `%s` is not a valid id", idStr)
	}
	return id64, nil
}

// When deletion requires to pass a name of object to delete (to raise a level of awareness of what user is doing) this model serves as a way to carry it
type DeleteBody struct {
	Name string
}

// parseInt próbuje sparsować string do int, w razie błędu zwraca wartość domyślną.
func parseInt(s string, fallback int) int {
	if val, err := strconv.Atoi(s); err == nil {
		return val
	}
	return fallback
}

// parseBool próbuje sparsować string do bool (true/false), w razie błędu zwraca fallback.
func parseBool(s string, fallback bool) bool {
	if s == "" {
		return fallback
	}
	val, err := strconv.ParseBool(s)
	if err != nil {
		return fallback
	}
	return val
}
