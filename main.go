package main

import (
	"T-Base/Brain/Application"
	"context"
	"log"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

const (
	mainIp       = "192.168.0.139:2020"
	testIp       = "127.0.0.1:8080"
	testGlobalIp = "192.168.0.139:2021"
	mainPostgres = "tbase"
	testPostgres = "tbasetestingdata"
)

func main() {

	log.Println("hello")

	ctx := context.Background()
	var jwtKey = []byte("Kr7yRk7Akv3LaN2G11-Adrrr9on5iyG1djj1K4ola5ider-hfdhswkjuIOUGFedyfhKiFGIoy")

	a, err := Application.NewApp(ctx, jwtKey, "postgres", "Superkim61", "localhost:5432", mainPostgres, testIp)
	if err != nil {
		panic(err)
	}

	router := httprouter.New()
	a.Routs(router)

	srv := &http.Server{Addr: a.AppIp, Handler: router}
	http.HandleFunc("/service-worker.js", Application.SendSW)
	http.HandleFunc("/manifest.json", Application.SendManifest)
	srv.ListenAndServe()

}
