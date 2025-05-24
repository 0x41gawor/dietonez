package service

import (
	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceIngredients struct {
	ri repo.RepositoryIngredient
	ru repo.RepositoryIngredientUnit
	rs repo.RepositoryIngredientShopStyle
}

func NewServiceIngredients() *ServiceIngredients {
	ri := *repo.NewRepositoryIngredients(repo.GetDatabaseInstance().DB)
	ru := *repo.NewRepositoryIngredientUnit(repo.GetDatabaseInstance().DB)
	rs := *repo.NewRepositoryIngredientShopStyle(repo.GetDatabaseInstance().DB)

	return &ServiceIngredients{
		ri: ri,
		ru: ru,
		rs: rs,
	}
}

func (s *ServiceIngredients) Read(id int64) (*model.Ingredient, error) {
	// read entity from repo
	e, err := s.ri.Read(id)
	if err != nil {
		return nil, err
	}
	// read unit
	unitStr, err := s.ru.ReadNameById(e.UnitId)
	if err != nil {
		return nil, err
	}
	// read shop style
	shopStyleStr, err := s.rs.ReadNameById(e.ShopStyleId)
	if err != nil {
		return nil, err
	}

	m := &model.Ingredient{
		Id:            e.Id,
		Name:          e.Name,
		DefaultAmount: e.DefaultAmount,
		Unit:          unitStr,
		ShopStyle:     shopStyleStr,
	}

	return m, nil
}

func (s *ServiceIngredients) List() ([]*model.Ingredient, error) {
	ids, err := s.ri.FindAllIds()
	if err != nil {
		return nil, err
	}

	var result []*model.Ingredient
	for _, id := range ids {
		ingredient, err := s.Read(id)
		if err != nil {
			continue
		}
		result = append(result, ingredient)
	}

	return result, nil
}
