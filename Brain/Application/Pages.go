package Application

import (
	"T-Base/Brain/Auth"
	"T-Base/Brain/mytypes"
	"fmt"
	"html/template"
	"net/http"
	"strconv"
	"strings"

	"github.com/julienschmidt/httprouter"
)

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
func (a App) TMCPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	devices, err := a.Db.TakeCleanDeviceById(a.ctx)
	if err != nil {
		fmt.Println(err)
	}

	MakeTMCPage(w, devices, "ТМЦ")
}

// Компактное представление устройства
func (a App) DeviceMiniPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	var device mytypes.DeviceClean

	if r.FormValue("Id") == "nil" {
		devices, err := a.Db.TakeCleanDeviceByRequest(a.ctx, " Limit 1")
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
		devices, err := a.Db.TakeCleanDeviceById(a.ctx, Id)
		if err != nil {
			fmt.Fprintln(w, "Ошибка поиска устройства: ", err)
			return
		}
		device = devices[0]
	}

	events, _ := a.Db.TakeDeviceEvent(a.ctx, device.Id)

	MakeDeviceMiniPage(w, device, events)
}

// тестовая страница ввода серийных номеров
func (a App) SnSearchPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	MakeImputPage(w, "/works/snsearch", "Поиск по Sn", "Введите серийные номера", "Поиск")
}

// поиск в тмц по серийным ноомерам
func (a App) SnSearch(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	snString := r.FormValue("sn")
	Sns := strings.Fields(snString)
	devices, err := a.Db.TakeCleanDeviceBySn(a.ctx, Sns...)
	if err != nil {
		fmt.Println(err)
	}

	MakeTMCPage(w, devices, "Результаты поиска")
}

func MakeDeviceMiniPage(w http.ResponseWriter, device mytypes.DeviceClean, events []mytypes.DeviceEvent) {
	type devicePage struct {
		Device mytypes.DeviceClean
		Events []mytypes.DeviceEvent
	}

	page := devicePage{device, events}

	t := template.Must(template.ParseFiles("Face/html/komm.html"))
	t.Execute(w, page)
}

func MakeImputPage(w http.ResponseWriter, postPath, title, imputText, btnText string) {

	type imputPage struct {
		Title     string
		InputText string
		BtnText   string
		PostPath  string
	}

	tmp := imputPage{title, imputText, btnText, postPath}

	t := template.Must(template.ParseFiles("Face/html/insert.html"))
	t.Execute(w, tmp)
}

func MakeTMCPage(w http.ResponseWriter, devices []mytypes.DeviceClean, lable string) {

	type tmcPage struct {
		Lable string
		Tab   []mytypes.DeviceClean
	}
	table := tmcPage{lable, devices}

	t := template.Must(template.ParseFiles("Face/html/TMC.html"))
	t.Execute(w, table)
}

func MakeOrdersPage(w http.ResponseWriter, orders []mytypes.OrderRaw, lable string) {

	type ordersPage struct {
		Lable string
		Tab   []mytypes.OrderRaw
	}
	table := ordersPage{lable, orders}

	t := template.Must(template.ParseFiles("Face/html/orders.html"))
	t.Execute(w, table)
}

func MakeStoragePage(w http.ResponseWriter, storage []mytypes.StorageCount, lable string) {
	type storagePage struct {
		Lable string
		Tab   []mytypes.StorageCount
	}
	table := storagePage{lable, storage}

	t := template.Must(template.ParseFiles("Face/html/storage.html"))
	t.Execute(w, table)
}

func (a App) StoragePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	storage, err := a.Db.TakeStorageCount(a.ctx)
	if err != nil {
		return
	}
	MakeStoragePage(w, storage, "Склад")
}

func MakeStorageByPlacePage(w http.ResponseWriter, storage []mytypes.StorageByPlaceCount, lable string) {
	type storagePage struct {
		Lable string
		Tab   []mytypes.StorageByPlaceCount
	}
	table := storagePage{lable, storage}

	t := template.Must(template.ParseFiles("Face/html/storageByPlace.html"))
	t.Execute(w, table)
}

func (a App) StorageByPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	storage, err := a.Db.TakeStorageCountByPlace(a.ctx)
	if err != nil {
		fmt.Println(err)
		return
	}

	MakeStorageByPlacePage(w, storage, "Места")
}

// универсальный поиск в тмц
func (a App) TMCSearch(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	snString := r.FormValue("sn")
	Sns := strings.Split(snString, ";")
	devices, err := a.Db.TakeCleanDeviceByAnything(a.ctx, Sns...)
	if err != nil {
		fmt.Println(err)
	}
	MakeTMCPage(w, devices, "Результаты поиска"+snString)
}

func (a App) OrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	orders, err := a.Db.TakeOrderById(a.ctx)
	if err != nil {
		fmt.Print(err)
	}

	MakeOrdersPage(w, orders, "Заказы")
}

func MakeOrderMiniPage(w http.ResponseWriter, order mytypes.OrderRaw, orderList []mytypes.OrderList) {
	type orderPage struct {
		Order mytypes.OrderRaw
		List  []mytypes.OrderList
	}

	page := orderPage{order, orderList}

	t := template.Must(template.ParseFiles("Face/html/order.html"))
	t.Execute(w, page)
}

func (a App) OrderMiniPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	var order mytypes.OrderRaw
	var err error

	if r.FormValue("Id") == "nil" { // Нужно сделать как в TMCMiniPage
		order, err = a.Db.TakeOrderById(a.ctx, 0)
		if err != nil {
			fmt.Fprintln(w, err)
		}
	}

}
