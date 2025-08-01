package repo

import (
	"database/sql"
	"fmt"
	"os"
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
	user := os.Getenv("NOME")
	password := os.Getenv("AGANDSKODE")
	port := os.Getenv("HAVN")
	if user == "" || password == "" || port == "" {
		panic("NOME and AGANDSKODE environment variables must be set")
	}
	dsn := fmt.Sprintf("user=%s password=%s host=localhost port=%s dbname=dietonez_db sslmode=disable", user, password, port)

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
