package Application

import (
	"T-Base/Brain/Auth"
	"T-Base/Brain/mytypes"
	"fmt"
	"html/template"
	"net/http"
	"strconv"
	"time"

	"github.com/julienschmidt/httprouter"
)

type HandleUser func(http.ResponseWriter, *http.Request, httprouter.Params, mytypes.User)

func (a App) Routs(r *httprouter.Router) {
	// открытые пути
	r.ServeFiles("/works/Face/*filepath", http.Dir("Face"))
	//r.ServeFiles("/works/device/Face/*filepath", http.Dir("Face"))
	r.GET("/", a.startPage)
	r.GET("/works/login", func(w http.ResponseWriter, r *http.Request, pr httprouter.Params) { a.LoginPage(w, "") })
	r.GET("/works/home", a.homePage)

	r.POST("/works/login", a.Login)
	r.POST("/works/Logout", Auth.Logout)

	// пути требующие авторизацию
	r.GET("/works/prof", a.authtorized(a.UserPage))
	//r.GET("/works/komm/:sn", a.authtorized(a.KommPage))
	r.GET("/works/device/mini", a.authtorized(a.DeviceMiniPage))
	r.GET("/works/tmc", a.authtorized(a.TMC))
	//r.GET("/works/new", a.authtorized(a.NewSns))
}

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
	} else {

		if pass == user.Pass {
			Auth.MakeTokens(w, r, user, a.JwtKey, *a.Db) // Записываем токены
			http.Redirect(w, r, "/", http.StatusSeeOther)
		} else {
			a.LoginPage(w, "Неверный пароль")
		}
	}
}

// Страница профиля
func (a App) UserPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	t := template.Must(template.ParseFiles("Face/html/prof.html"))
	t.Execute(w, user)
}

// Таблица ТМЦ
func (a App) TMC(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	devices, err := a.Db.TakeCleanDeviceById(a.ctx)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println(len(devices))

	type tt struct {
		Lable string
		Tab   []mytypes.DeviceClean
	}
	table := tt{"ТМЦ", devices}

	t := template.Must(template.ParseFiles("Face/html/TMC.html"))
	t.Execute(w, table)
}

// Добавление начальных устройств
func (a App) NewSns(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var devices []mytypes.DeviceRaw
	for i := 1; i <= 100; i++ {
		device := mytypes.DeviceRaw{
			Sn:          strconv.Itoa(i + 1000),
			Mac:         "m" + strconv.Itoa(i+1000),
			DModel:      2,
			TModel:      2,
			Rev:         "a1",
			Condition:   1,
			Name:        "Test2",
			CondDate:    time.Now(),
			Order:       0,
			Place:       1,
			Shiped:      false,
			ShipedDate:  time.Now(),
			ShippedDest: "Hjr",
			TakenDate:   time.Now(),
			TakenDoc:    "qawe",
			TakenOrder:  "asd",
		}
		devices = append(devices, device)
	}

	a.Db.InsertDiviceToSns(a.ctx, devices...)
}

func (a App) DeviceMiniPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	var device mytypes.DeviceRaw

	if r.FormValue("Id") == "nil" {
		devices, err := a.Db.TakeDeviceByRequest(a.ctx, " Limit 1")
		if err != nil {
			fmt.Fprintln(w, err)
			return
		}
		device = devices[0]
	} else {

		Id, err := strconv.Atoi(r.FormValue("Id"))
		if err != nil {

			t := template.Must(template.ParseFiles("Face/html/komm.html"))
			t.Execute(w, nil)
			fmt.Fprintln(w, "Устройство не найдено")
			return
		}
		devices, err := a.Db.TakeDeviceById(a.ctx, Id)
		if err != nil {
			fmt.Fprintln(w, "Ошибка поиска устройства: ", err)
			return
		}
		device = devices[0]
	}

	t := template.Must(template.ParseFiles("Face/html/komm.html"))
	t.Execute(w, device)

}
