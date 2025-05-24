package repo

import (
	"database/sql"
	"fmt"
	"sync"

	_ "github.com/jackc/pgx/v5/stdlib"
)

type PostgresDB struct {
	DB *sql.DB
}

// <  SINGLETON PATTERN >

var once sync.Once
var instance *PostgresDB

func GetDatabaseInstance() *PostgresDB {
	once.Do(func() {
		instance = NewPostgresDB()
	})
	return instance
}

// </ SINGLETON PATTERN >

func NewPostgresDB() *PostgresDB {
	dsn := "postgres://dietonez:dietonez123@localhost:5432/dietonez_db"

	db, err := sql.Open("pgx", dsn)
	if err != nil {
		panic(fmt.Sprintf("Failed to open DB: %v", err))
	}

	if err := db.Ping(); err != nil {
		panic(fmt.Sprintf("Failed to ping DB: %v", err))
	}

	return &PostgresDB{
		DB: db,
	}
}
