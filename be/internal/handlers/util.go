package handlers

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

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
	w.Header().Set("Content-Type", "application/json;charset=utf-8")
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

// ParseIDFromPath extracts the last segment of the URL path and parses it as an integer.
// Example: /api/diets/42 → returns 42
func ParseIDFromPath(resource string, r *http.Request) (int, error) {
	parts := strings.Split(strings.Trim(r.URL.Path, "/"), "/")
	for i := 0; i < len(parts)-1; i++ {
		if parts[i] == resource {
			return strconv.Atoi(parts[i+1])
		}
	}
	return 0, fmt.Errorf("could not find ID for resource '%s' in path", resource)
}

// ParseDateFromQuery parses ?date=YYYY-MM-DD or returns today's date if empty.
// Returns (time.Time, error)
func ParseDateFromQuery(r *http.Request) (time.Time, error) {
	const layout = "2006-01-02"

	dateStr := r.URL.Query().Get("date")
	if dateStr == "" {
		return time.Now().Truncate(24 * time.Hour), nil
	}

	date, err := time.Parse(layout, dateStr)
	if err != nil {
		return time.Time{}, errors.New("invalid date format (expected YYYY-MM-DD)")
	}

	return date, nil
}
