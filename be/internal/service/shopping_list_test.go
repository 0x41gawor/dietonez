package service

import (
	"context"
	"testing"
	"time"
)

func Test_ShoppingListService_Get(t *testing.T) {
	s := NewServiceShoppingList()

	ctx := context.Background() // lub context.TODO()
	shoppingList, err := s.Get(ctx, time.Now())

	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	t.Log(shoppingList)
}
