package service

import (
	"context"
	"testing"
	"time"
)

func Test_MenuService_Get(t *testing.T) {
	s := NewServiceMenu()

	ctx := context.Background() // lub context.TODO()
	date := time.Now().Truncate(24 * time.Hour)
	slots := getMenuSlotsRange(22)
	dishIDs, err := s.getDishIDsForSlots(ctx, 2, slots)
	if err != nil {
		t.Fatalf("DishIDs fatal %v", err)
	}
	t.Log(dishIDs)
	err = s.CopyToCounter(ctx, date, dishIDs)
	if err != nil {
		t.Fatalf("CopyToCounter fatal %v", err)
	}
}
