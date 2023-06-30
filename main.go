package main

import (
	"T-Base/Brain/Application"
	"context"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
	"github.com/julienschmidt/httprouter"
)

func main() {
	println("hello")

	ctx := context.Background()
	var jwtKey = []byte("Kr7yRk7Akv3LaN2G11-Adrrr9on5iyG1djj1K4ola5ider-hfdhswkjuIOUGFedyfhKiFGIoy")

	a, err := Application.NewApp(ctx, jwtKey, "Admin", "Superkim61", "127.0.0.1:3306", "t-base")
	if err != nil {
		panic(err)
	}

	router := httprouter.New()
	a.Routs(router)

	srv := &http.Server{Addr: "127.0.0.1:8080", Handler: router}
	srv.ListenAndServe()
}
