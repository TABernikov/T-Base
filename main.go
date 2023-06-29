package main

import (
	"database/sql"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	println("hello")

	db, err := sql.Open("mysql", "Admin:Superkim61@tcp(127.0.0.1:3306)/t-base")
	if err != nil {
		log.Println("ListenErr: ", err.Error())
	}
	defer db.Close()

}
