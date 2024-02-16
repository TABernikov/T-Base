package Application

import (
	"T-Base/Brain/Auth"

	"T-Base/Brain/mytypes"
	"html/template"
	"net/http"
	"strconv"
	"time"

	"github.com/julienschmidt/httprouter"
)

/////////////////////

// Обработчики GET //

/////////////////////

// Стартовая страница
func (a App) startPage(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	http.Redirect(w, r, "/works/prof", http.StatusSeeOther)
}

// Домашння страница
func (a App) homePage(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	t := template.Must(template.ParseFiles("Face/html/Шаблон обложки.html"))
	t.Execute(w, nil)
}

// Страница авторизации
func (a App) LoginPage(w http.ResponseWriter, in string) {
	type answer struct {
		Message string
	}

	data := answer{in}

	t := template.Must(template.ParseFiles("Face/html/auth.html"))
	t.Execute(w, data)
}

// Страница профиля
func (a App) UserPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.UserPage(w, user)
}

// Страница смены пароля
func (a App) ChangePassPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.ChangePassPage(w, "", "", "", "")
}

func (a App) ReservCalendarPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	snsId, err := strconv.Atoi(r.FormValue("snsId"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не верно задано Id устройства", err.Error(), "Главная", "/works/prof")
		return
	}
	reservs, err := a.Db.TakeJSReservatios(a.Ctx, snsId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения резервов", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.ReservCalendarPage(w, reservs, snsId)
}

func (a App) CreateReservPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	SnsId := r.FormValue("SnsId")
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateReservPage(w, SnsId)
}

func (a App) TestTablePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.TestTable(w)
}

//////////////////////

// Обработчики POST //

//////////////////////

// Обработчик авторизации
func (a App) Login(w http.ResponseWriter, r *http.Request, pr httprouter.Params) {
	login := r.FormValue("login")
	pass := r.FormValue("password")

	if login == "" || pass == "" {
		a.LoginPage(w, "Ошибка входа")
		return
	}

	user, err := a.Db.TakeUserByLogin(a.Ctx, login)
	if err != nil {
		a.LoginPage(w, "Пользователь не найден")
	} else {

		if pass == user.Pass {
			Auth.MakeTokens(w, r, user, a.JwtKey, *a.Db) // Записываем токены
			http.Redirect(w, r, "/", http.StatusSeeOther)
		} else {
			a.LoginPage(w, "Неверный пароль")
		}
	}
}

// Изменить пароль
func (a App) ChangePass(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	oldPass := r.FormValue("old")
	newPass := r.FormValue("new")
	chekPass := r.FormValue("chek")

	if oldPass == "" || newPass == "" || chekPass == "" {
		a.Templ.AlertPage(w, 5, "Ошибка", "Заполните форму", "", "", "Главная", "/")
		return
	}

	if newPass != chekPass {
		a.Templ.ChangePassPage(w, "Пароли не совпадают", oldPass, newPass, chekPass)
		return
	}

	users, err := a.Db.TakeUserById(a.Ctx, user.UserId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Пользователь не найден", "", err.Error(), "Главная", "/")
		return
	}
	user = users[0]

	if oldPass != user.Pass {
		a.Templ.ChangePassPage(w, "Не верный пароль", oldPass, newPass, chekPass)
		return
	}

	res, err := a.Db.Db.Exec(a.Ctx, "UPDATE public.users SET  pass=$1 WHERE userid=$2;", newPass, user.UserId)
	if err != nil || res.RowsAffected() == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка смены пароля", "", err.Error(), "Главная", "/")
		return
	}
	a.Templ.AlertPage(w, 1, "Успешно", "Успешно", "Изменено ", "", "Главная", "/works/prof")
}

func (a App) CreateReserv(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	var reserv mytypes.ReservTask
	reserv.Autor = user.UserId
	var err error
	reserv.SnsId, err = strconv.Atoi(r.FormValue("SnsId"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id", err.Error(), "Главная", "/works/prof")
		return
	}
	reserv.DateStart, err = time.Parse("2006-01-02", r.FormValue("Start"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания даты начала", err.Error(), "Главная", "/works/prof")
		return
	}
	reserv.DateEnd, err = time.Parse("2006-01-02", r.FormValue("End"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания даты окончания", err.Error(), "Главная", "/works/prof")
		return
	}
	reserv.Dest = r.FormValue("Dest")

	err = a.Db.InsertReservation(a.Ctx, reserv)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка создания резерва", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 1, "Успешно", "Успешно", "Созданно", "Резерв создан", "Главная", "/works/prof")
}

//
//
//

/*
func (a App) PrintPassportPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	a.Templ.ImputPage(w, "", "Напечатать паспорт", "Серийные номера", "Печать")
}

func (a App) PrintPassport(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	snString := r.FormValue("in")
	Sns := strings.Fields(snString)

	Devices, err := a.Db.TakeCleanDeviceBySn(a.Ctx, Sns...)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		return
	}

	t := template.Must(template.ParseFiles("Face/html/passportprint.html"))
	t.Execute(w, Devices)
}

func (a App) PrintingPassport(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	type Info struct {
		Sn   string
		Date string
	}

	Data := Info{
		Sn:   r.FormValue("Sn"),
		Date: r.FormValue("Date"),
	}

	t := template.Must(template.ParseFiles("Face/html/pass/ТГК-313-48_6д-П_Руководство по установке.html"))
	t.Execute(w, Data)
}

*/
