package Application

import (
	"T-Base/Brain/Auth"
	"T-Base/Brain/mytypes"
	"html/template"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

type HandleUser func(http.ResponseWriter, *http.Request, httprouter.Params, mytypes.User)

func (a App) Routs(r *httprouter.Router) {
	// открытые пути
	r.ServeFiles("/Face/*filepath", http.Dir("Face"))
	r.GET("/", a.startPage)
	r.GET("/works/login", func(w http.ResponseWriter, r *http.Request, pr httprouter.Params) { a.LoginPage(w, "") })

	r.POST("/works/login", a.Login)
	r.POST("/works/Logout", Auth.Logout)

	// пути требующие авторизацию
	r.GET("/works/prof", a.authtorized(a.UserPage))
	//r.GET("/works/komm/:sn", a.authtorized(a.KommPage))
	//r.GET("/works/komm/", a.authtorized(a.KommPage))
	//r.GET("/works/tmc/", a.authtorized(a.TMC))
}

// Стартовая страница
func (a App) startPage(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	http.Redirect(w, r, "/works/prof", http.StatusSeeOther)
}

// Страница авторизации
func (a App) LoginPage(w http.ResponseWriter, in string) {
	type answer struct {
		Message string
	}

	data := answer{in}

	t := template.Must(template.ParseFiles("Face/htmls/auth.html"))
	t.Execute(w, data)

}

// Обработчик авторизации
func (a App) Login(w http.ResponseWriter, r *http.Request, pr httprouter.Params) {
	login := r.FormValue("login")
	pass := r.FormValue("password")

	if login == "" || pass == "" {
		a.LoginPage(w, "Ошибка входа")
		return
	}

	user, err := a.Db.TakeUserByLogin(a.ctx, login)
	if err != nil {
		a.LoginPage(w, "Пользователь не найден")
	}

	if pass == user.Pass {
		Auth.MakeTokens(w, r, user, a.JwtKey, *a.Db) // Записываем токены
		http.Redirect(w, r, "/", http.StatusSeeOther)
	} else {
		a.LoginPage(w, "Неверный пароль")
	}
}

// Страница профиля
func (a App) UserPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	t := template.Must(template.ParseFiles("Face/htmls/prof.html"))
	t.Execute(w, user)
}
