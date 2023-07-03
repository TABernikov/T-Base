package Application

import (
	"T-Base/Brain/Auth"
	"T-Base/Brain/Storage"
	"context"
	"fmt"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

type App struct {
	ctx    context.Context
	Db     *Storage.Base
	JwtKey []byte
}

func NewApp(ctx context.Context, jwtKey []byte, user, pass, ip, baseName string) (*App, error) {
	db, err := Storage.NewBase(user, pass, ip, baseName)
	return &App{ctx, db, jwtKey}, err
}

// Проверка авторизации
func (a App) authtorized(nestedFunction HandleUser) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		authToken, err := Auth.ReadCookie("Lolijoyu", r)
		if err != nil { // нет токена авторизации
			println("нет токена авторизации " + err.Error())

			http.Redirect(w, r, "/works/login", http.StatusSeeOther)
			return

		}

		user, err := Auth.ParseJWT(authToken, a.JwtKey)
		if err != nil {
			println("Ошибка авторизации 11 " + err.Error())
			gentoken, err := Auth.ReadCookie("Korikasa", r)
			if err != nil { //нет токена генерации
				http.Redirect(w, r, "/works/login", http.StatusSeeOther)
				return
			}
			regenUser, err := Auth.ParseJWT(gentoken, []byte(authToken))
			fmt.Println("Тут обшибка", user, "имя ", regenUser.Name)
			if err != nil {
				fmt.Println("Зашел в ошибку проверки токена")
				http.Redirect(w, r, "/works/login", http.StatusSeeOther)
				return
			}
			println("Делаю новый токен")
			Auth.MakeTokens(w, r, user, a.JwtKey, *a.Db) //генерировать токен
			http.Redirect(w, r, r.RequestURI, http.StatusSeeOther)
			return
		}

		println(user.Name + " подтвердил себя")

		// функция с логикой
		nestedFunction(w, r, ps, user)

	}
}
