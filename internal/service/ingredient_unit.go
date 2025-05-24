package service

import (
	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceIngredientUnits struct {
	r repo.RepositoryIngredientUnit
}

func NewServiceIngredientUnits() *ServiceIngredientUnits {
	r := *repo.NewRepositoryIngredientUnit(repo.GetDatabaseInstance().DB)

	return &ServiceIngredientUnits{
		r: r,
	}
}

func (s *ServiceIngredientUnits) List() ([]*model.IngredientUnit, error) {
	// read entities from repo
	e, err := s.r.ReadAll()
	if err != nil {
		return nil, err
	}
	// map to model
	var m []*model.IngredientUnit
	for _, e := range e {
		temp := &model.IngredientUnit{
			Id:   e.Id,
			Name: e.Name,
		}
		m = append(m, temp)
	}

	return m, nil
}
