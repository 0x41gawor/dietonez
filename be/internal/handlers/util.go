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
