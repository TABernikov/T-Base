package Application

import (
	"T-Base/Brain/Auth"
	"T-Base/Brain/mytypes"
	"fmt"
	"html/template"
	"net/http"
	"strconv"
	"strings"
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
	t := template.Must(template.ParseFiles("Face/html/prof.html"))
	t.Execute(w, user)
}

// Таблица ТМЦ
func (a App) TMCPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var devices []mytypes.DeviceClean
	var err error
	if r.FormValue("Search") == "" {
		devices, err = a.Db.TakeCleanDeviceById(a.ctx)
		if err != nil {
			fmt.Println(err)
		}
	} else {
		req := `WHERE true `
		if r.FormValue("Id") != "" {
			req += `AND "snsId" = ` + r.FormValue("Id") + ` `
		}
		if r.FormValue("Sn") != "" {
			req += `AND "sn" = '` + r.FormValue("Sn") + `' `
		}
		if r.FormValue("Mac") != "" {
			req += `AND "mac" = '` + r.FormValue("Mac") + `' `
		}
		if r.FormValue("DModel") != "" {
			req += `AND "dmodel" = '` + r.FormValue("DModel") + `' `
		}
		if r.FormValue("Rev") != "" {
			req += `AND "rev" = '` + r.FormValue("Rev") + `' `
		}
		if r.FormValue("TModel") != "" {
			req += `AND "tmodel" = '` + r.FormValue("TModel") + `' `
		}
		if r.FormValue("Name") != "" {
			req += `AND "name" = '` + r.FormValue("Name") + `' `
		}
		if r.FormValue("Condition") != "" {
			req += `AND "condition" = '` + r.FormValue("Condition") + `' `
		}
		if r.FormValue("Order") != "" {
			req += `AND "order" = ` + r.FormValue("Order") + ` `
		}
		if r.FormValue("Place") != "" {
			req += `AND "place" = ` + r.FormValue("Place") + ` `
		}
		if r.FormValue("Shiped") != "" {
			req += `AND "shiped" = ` + r.FormValue("Shiped") + ` `
		}
		if r.FormValue("ShippedDest") != "" {
			req += `AND "shippedDest" = '` + r.FormValue("ShippedDest") + `' `
		}
		if r.FormValue("TakenDoc") != "" {
			req += `AND "takenDoc" = '` + r.FormValue("TakenDoc") + `' `
		}
		if r.FormValue("TakenOrder") != "" {
			req += `AND "takenOrder" = '` + r.FormValue("TakenOrder") + `' `
		}
		if r.FormValue("CondDate") != "" {
			date, err := time.Parse("01.02.2006", r.FormValue("CondDate"))
			if err == nil {
				req += `AND "condDate" = '` + date.Format("2006-02-01") + `' `
			}
		}
		if r.FormValue("ShipedDate") != "" {
			date, err := time.Parse("01.02.2006", r.FormValue("ShipedDate"))
			if err == nil {
				req += `AND "shipedDate" = '` + date.Format("2006-02-01") + `' `
			}
		}
		if r.FormValue("TakenDate") != "" {
			date, err := time.Parse("01.02.2006", r.FormValue("TakenDate"))
			if err == nil {
				req += `AND "takenDate" = '` + date.Format("2006-02-01") + `' `
			}
		}

		devices, err = a.Db.TakeCleanDeviceByRequest(a.ctx, req)
		if err != nil {
			fmt.Println(err)
		}
	}

	MakeTMCPage(w, devices, "ТМЦ устройств: "+strconv.Itoa(len(devices)))
}

func (a App) TMCSearchPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.MakeTMCAdvanceSearchPage(w)
}

// Таблица ТМЦ для конкретного заказа
func (a App) TMCOrderSearch(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	order, err := strconv.Atoi(r.FormValue("Order"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	devices, err := a.Db.TakeCleanDeviceByOrder(a.ctx, order)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	MakeTMCPage(w, devices, "ТМЦ заказ "+r.FormValue("Order"))
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

	events, err := a.Db.TakeCleanDeviceEvent(a.ctx, device.Id)
	if err != nil {
		fmt.Fprintln(w, err)
		return
	}

	MakeDeviceMiniPage(w, device, events)
}

// Тестовая страница ввода серийных номеров
func (a App) SnSearchPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	MakeImputPage(w, "/works/snsearch", "Поиск по Sn", "Введите серийные номера", "Поиск")
}

// Страница склада по заказам
func (a App) StoragePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	storage, err := a.Db.TakeStorageCount(a.ctx)
	if err != nil {
		return
	}
	MakeStoragePage(w, storage, "Склад заказы")
}

// Страница склада по местам
func (a App) StorageByPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	storage, err := a.Db.TakeStorageCountByPlace(a.ctx)
	if err != nil {
		fmt.Println(err)
		return
	}

	MakeStorageByPlacePage(w, storage, "Склад места")
}

// Страница склада по моделям
func (a App) StorageByTModelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	storage, err := a.Db.TakeStorageByTModelClean(a.ctx)
	if err != nil {
		fmt.Println(err)
		return
	}

	MakeStorageByTModelPage(w, storage, "Склад модели")
}

// Таблица заказов
func (a App) OrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	orders, err := a.Db.TakeCleanOrderById(a.ctx)
	if err != nil {
		fmt.Print(err)
	}

	MakeOrdersPage(w, orders, "Заказы")
}

// Компактное представление заказа
func (a App) OrderMiniPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	var order mytypes.OrderClean

	if r.FormValue("Id") == "nil" { // Нужно сделать как в TMCMiniPage
		orders, err := a.Db.TakeCleanOrderById(a.ctx, 0)
		if err != nil {
			fmt.Fprintln(w, err)
			return
		}
		order = orders[0]

	} else {
		Id, err := strconv.Atoi(r.FormValue("Id"))
		if err != nil {
			fmt.Fprintln(w, err)
			return
		}
		orders, err := a.Db.TakeCleanOrderById(a.ctx, Id)
		if err != nil {
			fmt.Fprintln(w, err)
			return
		}
		order = orders[0]
	}

	orderList, err := a.Db.TakeCleanOrderList(a.ctx, order.OrderId)
	if err != nil {
		fmt.Fprintln(w, "Ошибка поиска состава заказа", err)
		return
	}

	rows, err := a.Db.Db.Query(a.ctx, ` SELECT public."tModels"."tModelsName" AS tmodel, tmp.name, public."condNames"."condName", tmp.count From
		(SELECT sns.tmodel, sns.name, sns.condition, count(sns."snsId") AS "count" FROM sns WHERE sns.shiped = false AND sns.order = $1 GROUP BY sns.tmodel, sns.condition, sns.name ORDER BY sns.tmodel, sns.condition) tmp
		LEFT JOIN public."condNames" ON public."condNames"."condNamesId" = tmp.condition LEFT JOIN public."tModels" ON public."tModels"."tModelsId" = tmp.tmodel`, order.OrderId)
	if err != nil {
		fmt.Fprintln(w, "Ошибка поиска резерва заказа", err)
		return
	}
	var reservs []mytypes.StorageByTModelClean
	var reserv mytypes.StorageByTModelClean

	for rows.Next() {
		err := rows.Scan(&reserv.Model, &reserv.Name, &reserv.Condition, &reserv.Amout)
		if err != nil {
			fmt.Fprintln(w, "Ошибка поиска резерва заказа", err)
			return
		}
		reservs = append(reservs, reserv)
	}

	fmt.Println(reservs)

	MakeOrderMiniPage(w, order, orderList, reservs)
}

// Страница передачи в производство
func (a App) ToWorkPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	MakeImputPage(w, "/works/towork", "Передать в производство", "Введите серийные номера для передачи", "Передать")
}

// Страница назначения резерва
func (a App) SetOrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	MakeDobleImputPage(w, "/works/setorder", "Назначить заказ/резерв", "Введите серийные номера:", "Номер заказа", "Назначить заказ")
}

func (a App) SetPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	MakeDobleImputPage(w, "/works/setplace", "Установить место", "Введите серийные номера:", "Номер места", "Установить место")
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

// поиск в тмц по серийным ноомерам
func (a App) SnSearch(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	snString := r.FormValue("in")
	Sns := strings.Fields(snString)
	devices, err := a.Db.TakeCleanDeviceBySn(a.ctx, Sns...)
	if err != nil {
		fmt.Println(err)
	}

	MakeTMCPage(w, devices, "Результаты поиска")
}

// универсальный поиск в тмц
func (a App) TMCSearch(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	snString := r.FormValue("in")
	Sns := strings.Split(snString, ";")
	devices, err := a.Db.TakeCleanDeviceByAnything(a.ctx, Sns...)
	if err != nil {
		fmt.Println(err)
	}
	MakeTMCPage(w, devices, "Результаты поиска "+snString)
}

// универсальный поиск в заказах
func (a App) OrderSearch(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	searchString := r.FormValue("in")
	searchs := strings.Split(searchString, ";")
	orders, err := a.Db.TakeCleanOrderByAnything(a.ctx, searchs...)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	MakeOrdersPage(w, orders, "Результаты поиска "+searchString)
}

// передача в работу
func (a App) ToWork(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	snString := r.FormValue("in")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnToWork(a.ctx, Sns...)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		MakeAlertPage(w, 5, "Предупреждение", "Не передано", "Устройства не были переданы в работу", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Передано "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		MakeAlertPage(w, 1, "Готово", "Передано", "Все устройства переданы в работу", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Передано "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		MakeAlertPage(w, 2, "Готово", "Частично", "Часть устройств не передана в работу", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Передано "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

// установка заказа
func (a App) SetOrder(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	snString := r.FormValue("in1")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	order, err := strconv.Atoi(r.FormValue("in2"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "В поле заказ введено не число", err.Error(), "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnSetOrder(a.ctx, order, Sns...)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		MakeAlertPage(w, 5, "Предупреждение", "Не назначено", "Устройствам не был назначен заказ", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		MakeAlertPage(w, 1, "Готово", "Назначено", "Всем устройствам был назначен заказ", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		MakeAlertPage(w, 2, "Готово", "Частично", "Части устройств не был назначен заказ", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

func (a App) SetPlace(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	snString := r.FormValue("in1")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	place, err := strconv.Atoi(r.FormValue("in2"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "В поле место введено не число", err.Error(), "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnSetPlace(a.ctx, place, Sns...)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		MakeAlertPage(w, 5, "Предупреждение", "Не назначено", "Устройствам не было назначено место", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		MakeAlertPage(w, 1, "Готово", "Назначено", "Всем устройствам было назначено место", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		MakeAlertPage(w, 2, "Готово", "Частично", "Части устройств не было назначено место", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

func (a App) AdvanceTMCSearch(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

}

//////////////////////////
// Конструкторы страниц //
//////////////////////////

func MakeTMCPage(w http.ResponseWriter, devices []mytypes.DeviceClean, lable string) {

	type tmcPage struct {
		Lable string
		Tab   []mytypes.DeviceClean
	}
	table := tmcPage{lable, devices}

	t := template.Must(template.ParseFiles("Face/html/TMC.html"))
	t.Execute(w, table)
}

func (a App) MakeTMCAdvanceSearchPage(w http.ResponseWriter) {
	type idChoise struct {
		Id   int
		Name string
	}
	type search struct {
		TModels    []idChoise
		DModels    []idChoise
		Conditions []idChoise
	}

	var choise idChoise

	var tmodelList []idChoise
	rows, err := a.Db.Db.Query(a.ctx, `SELECT "tModelsId", "tModelsName" FROM public."tModels";`)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		tmodelList = append(tmodelList, choise)
	}

	var dmodelList []idChoise
	// тут остановился
	tmp := search{tmodelList, dmodelList, tmodelList}

	t := template.Must(template.ParseFiles("Face/html/TMCSearch.html"))
	t.Execute(w, tmp)
}

func MakeDeviceMiniPage(w http.ResponseWriter, device mytypes.DeviceClean, events []mytypes.DeviceEventClean) {
	type devicePage struct {
		Device mytypes.DeviceClean
		Events []mytypes.DeviceEventClean
	}

	page := devicePage{device, events}

	t := template.Must(template.ParseFiles("Face/html/komm.html"))
	t.Execute(w, page)
}

func MakeOrdersPage(w http.ResponseWriter, orders []mytypes.OrderClean, lable string) {

	type ordersPage struct {
		Lable string
		Tab   []mytypes.OrderClean
	}
	table := ordersPage{lable, orders}

	t := template.Must(template.ParseFiles("Face/html/orders.html"))
	t.Execute(w, table)
}

func MakeOrderMiniPage(w http.ResponseWriter, order mytypes.OrderClean, orderList []mytypes.OrderListClean, reservs []mytypes.StorageByTModelClean) {
	type orderPage struct {
		Order   mytypes.OrderClean
		List    []mytypes.OrderListClean
		Reservs []mytypes.StorageByTModelClean
	}

	page := orderPage{order, orderList, reservs}

	t := template.Must(template.ParseFiles("Face/html/order.html"))
	t.Execute(w, page)
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

func MakeStorageByPlacePage(w http.ResponseWriter, storage []mytypes.StorageByPlaceCount, lable string) {
	type storagePage struct {
		Lable string
		Tab   []mytypes.StorageByPlaceCount
	}
	table := storagePage{lable, storage}

	t := template.Must(template.ParseFiles("Face/html/storageByPlace.html"))
	t.Execute(w, table)
}

func MakeStorageByTModelPage(w http.ResponseWriter, storage []mytypes.StorageByTModelClean, lable string) {
	type storagePage struct {
		Lable string
		Tab   []mytypes.StorageByTModelClean
	}
	table := storagePage{lable, storage}

	t := template.Must(template.ParseFiles("Face/html/storageByTModel.html"))
	t.Execute(w, table)
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

func MakeDobleImputPage(w http.ResponseWriter, postPath, title, imputText1, imputText2, btnText string) {

	type imputPage struct {
		Title      string
		InputText1 string
		InputText2 string
		BtnText    string
		PostPath   string
	}

	tmp := imputPage{title, imputText1, imputText2, btnText, postPath}

	t := template.Must(template.ParseFiles("Face/html/dobleinsert.html"))
	t.Execute(w, tmp)
}

func MakeAlertPage(w http.ResponseWriter, status int, lable, heading, text, subText, btnText, btnLink string) {
	type alertPage struct {
		Lable   string
		Heading string
		Status  int
		Text    string
		SubText string
		BtnText string
		BtnLink string
	}

	tmp := alertPage{
		Lable:   lable,
		Heading: heading,
		Status:  status,
		Text:    text,
		SubText: subText,
		BtnText: btnText,
		BtnLink: btnLink,
	}

	testTemplate := template.Must(template.ParseFiles("Face/html/alert.html"))

	testTemplate.Execute(w, tmp)
}
