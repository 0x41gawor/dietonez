package repo

type RepositoryDietSlots struct {
	db *PostgresDB
}

func NewRepositoryDietSlots() *RepositoryDietSlots {
	db := GetDatabaseInstance()
	return &RepositoryDietSlots{db: db}
}

func (r *RepositoryDietSlots) GetMaxSlotNumByDietId(dietID int) (int, error) {
	var maxSlotNum int
	err := r.db.DB.QueryRow(`
		SELECT MAX(slot_num)
		FROM diet_slots
		WHERE diet_id = $1
	`, dietID).Scan(&maxSlotNum)

	if err != nil {
		return 0, err
	}
	return maxSlotNum, nil
}
