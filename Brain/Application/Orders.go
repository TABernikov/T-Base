package Application

import (
	"T-Base/Brain/mytypes"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/julienschmidt/httprouter"
)

func OrderRouts(a App, r *httprouter.Router) {
	r.GET("/works/orders", a.authtorized(a.OrderPage))
	r.GET("/works/order/mini", a.authtorized(a.OrderMiniPage))
	r.GET("/works/createorder", a.authtorized(a.CreateOrderPage))
	r.GET("/works/setpromdate", a.authtorized(a.SetPromDatePage))
	r.GET("/works/draft", a.authtorized(a.Draft))

	r.POST("/works/orders", a.authtorized(a.OrderPage))
	r.POST("/works/createorder", a.authtorized(a.CreateOrder))
	r.POST("/works/dellorder", a.authtorized(a.DelOrder))
	r.POST("/works/change1cnumorder", a.authtorized(a.Change1CNumOrder))
	r.POST("/works/createorderlist", a.authtorized(a.CreateOrderListPage))
	r.POST("/works/setpromdate", a.authtorized(a.SetPromDate))
	r.POST("/works/draft", a.authtorized(a.Draft))
}

// Таблица заказов
func (a App) OrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var orders []mytypes.OrderClean
	var err error
	var link string
	if r.FormValue("Search") == "" {
		orders, err = a.Db.TakeCleanOrderByReqest(a.Ctx, `WHERE "isAct" = true`)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	} else if r.FormValue("Search") == "Anything" {
		link = "?Search=Anything&in=" + r.FormValue("in")
		searchString := r.FormValue("in")
		searchs := strings.Split(searchString, ";")
		orders, err = a.Db.TakeCleanOrderByAnything(a.Ctx, searchs...)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	a.Templ.OrdersPage(w, orders, "Заказы", link)
}

// удаление заказа
func (a App) DelOrder(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Не существующее число", err.Error(), "Главная", "/works/prof")
		return
	}

	order, err := a.Db.TakeOrderById(a.Ctx, id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Ваш заказ пропал!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.UserId != order[0].Meneger {
		a.Templ.AlertPage(w, 5, "Ошибка", "Нельзя удалить чужой заказ", "Плохо так делать", "Не надо так", "Главная", "/works/prof")
		return
	}

	err = a.Db.DellOrder(a.Ctx, id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка удаления заказа", "Удаление прошло не корректно", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Заказ успешно удален", "Отличная работа", "Главная", "/works/prof")
}

// изменить № 1С у заказа
func (a App) Change1CNumOrder(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Не существующее число", err.Error(), "Главная", "/works/prof")
		return
	}

	order, err := a.Db.TakeOrderById(a.Ctx, id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Ваш заказ пропал!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.UserId != order[0].Meneger {
		a.Templ.AlertPage(w, 5, "Ошибка", "Нельзя изменить чужой заказ", "Плохо так делать", "Не надо так", "Главная", "/works/prof")
		return
	}

	new1CId, err := strconv.Atoi(r.FormValue("1CNum"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Не число", "Новый номер 1С должен быть числом", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.Change1CNumOrder(a.Ctx, id, new1CId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка изменения номера", "Чтото пошло не так", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Номер успешно изменен", "Отличная работа", "Главная", "/works/prof")
}

// Компактное представление заказа
func (a App) OrderMiniPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	var order mytypes.OrderClean

	if r.FormValue("Id") == "" {
		orders, err := a.Db.TakeCleanOrderByReqest(a.Ctx, `WHERE "isAct" = true LIMIT 1`)
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
		orders, err := a.Db.TakeCleanOrderById(a.Ctx, Id)
		if err != nil {
			fmt.Fprintln(w, err)
			return
		}
		order = orders[0]
	}

	orderList, err := a.Db.TakeCleanOrderList(a.Ctx, order.OrderId)
	if err != nil {
		fmt.Fprintln(w, "Ошибка поиска состава заказа", err)
		return
	}

	reqsest := ` SELECT public."tModels"."tModelsName" AS tmodel, tmp.name, public."condNames"."condName", tmp.count, tmp.shiped From
	(SELECT sns.tmodel, sns.name, sns.condition, count(sns."snsId") AS "count", sns.shiped FROM sns WHERE sns.order = ` + strconv.Itoa(order.OrderId) + ` GROUP BY sns.tmodel, sns.condition, sns.shiped, sns.name ORDER BY sns.tmodel, sns.condition) tmp
	LEFT JOIN public."condNames" ON public."condNames"."condNamesId" = tmp.condition LEFT JOIN public."tModels" ON public."tModels"."tModelsId" = tmp.tmodel`

	reservs, err := a.Db.TakeStorageByTModelClean(a.Ctx, reqsest)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		reservs = nil
	}

	status, err := a.Db.TakeCleanOrderStatus(a.Ctx, order.OrderId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
	}

	a.Templ.OrderMiniPage(w, order, orderList, reservs, status, user)
}

// Страница создания заказа
func (a App) CreateOrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateOrderPage(w)
}

// создание заказа
func (a App) CreateOrder(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	Id1C, err := strconv.Atoi(r.FormValue("1C"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Номер 1С не число", "Номер 1С не число", err.Error(), "Главная", "/works/prof")
		return
	}
	Name := r.FormValue("Name")

	log.Println(r.FormValue("Req"))
	ReqDate, err := time.Parse("2006-01-02", r.FormValue("Req"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Требуемая дата не дата", "", err.Error(), "Главная", "/works/prof")
		return
	}
	Customer := r.FormValue("Customer")
	Partner := r.FormValue("Partner")
	Distributor := r.FormValue("Distributor")

	var order mytypes.OrderRaw
	order.Id1C = Id1C
	order.Name = Name
	order.ReqDate = ReqDate
	order.Customer = Customer
	order.Partner = Partner
	order.Distributor = Distributor
	order.Meneger = user.UserId

	Id, err := a.Db.InsertOrder(a.Ctx, order)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка создания заказа", "Заказ не создан", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Заказ "+strconv.Itoa(Id1C)+" "+Name+"создан", "Не забудьте внести состав заказа", "К заказу", "/works/order/mini?Id="+strconv.Itoa(Id))
}

// изменение состава заказа (Страница)
func (a App) CreateOrderListPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Не существующее число", err.Error(), "Главная", "/works/prof")
		return
	}

	order, err := a.Db.TakeOrderById(a.Ctx, id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Ваш заказ пропал!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.UserId != order[0].Meneger {
		a.Templ.AlertPage(w, 5, "Ошибка", "Нельзя редактировать чужой заказ", "Плохо так делать", "Не надо так", "Главная", "/works/prof")
		return
	}

	if r.FormValue("Action") == "Open" {
		a.Templ.CreateOrderListPage(w, -1, id)

	} else if r.FormValue("Action") == "OpenRedact" {
		listId, err := strconv.Atoi(r.FormValue("ListId"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Не существующий элемент заказа", "Не существующее число", err.Error(), "Главная", "/works/prof")
			return
		}
		a.Templ.CreateOrderListPage(w, listId, id)

	} else if r.FormValue("Action") == "Create" {
		var newPos mytypes.OrderList
		newPos.Model, err = strconv.Atoi(r.FormValue("TModel"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверная модель", err.Error(), "Главная", "/works/prof")
		}
		newPos.Amout, err = strconv.Atoi(r.FormValue("Amout"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверное кол-во", err.Error(), "Главная", "/works/prof")
		}
		newPos.ServType, err = strconv.Atoi(r.FormValue("Serv"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверный тип сервиса", err.Error(), "Главная", "/works/prof")
		}
		newPos.ServActDate, err = time.Parse("2006-01-02", r.FormValue("ServActDate"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверная дата начала сервиса", err.Error(), "Главная", "/works/prof")
		}
		newPos.Order = id

		err = a.Db.InsertOrderList(a.Ctx, newPos)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка создания", "Что-то пошло не так", err.Error(), "Главная", "/works/prof")
		}

		a.Templ.CreateOrderListPage(w, -1, id)
	} else if r.FormValue("Action") == "Redact" {
		var redPos mytypes.OrderList
		redPos.Model, err = strconv.Atoi(r.FormValue("TModel"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверная модель", err.Error(), "Главная", "/works/prof")
		}
		redPos.Amout, err = strconv.Atoi(r.FormValue("Amout"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверное кол-во", err.Error(), "Главная", "/works/prof")
		}
		redPos.ServType, err = strconv.Atoi(r.FormValue("Serv"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверный тип сервиса", err.Error(), "Главная", "/works/prof")
		}
		redPos.ServActDate, err = time.Parse("2006-01-02", r.FormValue("ServActDate"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверная дата начала сервиса", err.Error(), "Главная", "/works/prof")
		}
		redPos.Order = id
		redPos.Id, err = strconv.Atoi(r.FormValue("ListId"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверный ID элемента", err.Error(), "Главная", "/works/prof")
		}

		redPos.LastRed = time.Now()

		err = a.Db.ChangeOrderList(a.Ctx, redPos)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка изменения", "Что-то пошло не так", err.Error(), "Главная", "/works/prof")
		}

		a.Templ.CreateOrderListPage(w, -1, id)
	}
}

// Страница установки обещаной даты выхода заказа с производства
func (a App) SetPromDatePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.DobleImputTypePage(w, "", "Задать дату", "Введите ID заказа "+r.FormValue("Order"), "number", "Введите дату готовности", "date", "Задать дату")
}

// Установить обещаную дату производства заказа
func (a App) SetPromDate(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	order, err := strconv.Atoi(r.FormValue("in1"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	date, err := time.Parse("2006-01-02", r.FormValue("in2"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.SetPromDate(a.Ctx, order, date)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка присвоения даты", "Вероятно неверно задан ID заказа", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 1, "Готово", "Установленно", "Заказу с ID "+strconv.Itoa(order)+" назначена новая дата производства", "", "Главная", "/works/prof")
}

// Драфт заказа
func (a App) Draft(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if r.FormValue("DraftId") == "" {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Отсутствует Id драфта", "Отсутствует Id драфта", "Главная", "/works/prof")
		return
	}
	drftId, err := strconv.Atoi(r.FormValue("DraftId"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id", err.Error(), "Главная", "/works/prof")
		return
	}
	action := r.FormValue("Action")
	switch action {
	case "Open":

		draft, err := a.Db.TakeClenDrafts(a.Ctx, drftId)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения драфта", err.Error(), "Главная", "/works/prof")
			return
		}
		a.Templ.DraftPage(w, draft, -1)

	case "Redact":

		redId, err := strconv.Atoi(r.FormValue("Id"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id редактируемой позиции", err.Error(), "Главная", "/works/prof")
			return
		}
		draft, err := a.Db.TakeClenDrafts(a.Ctx, drftId)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения драфта", err.Error(), "Главная", "/works/prof")
			return
		}
		a.Templ.DraftPage(w, draft, redId)
	case "Update":
		redId, err := strconv.Atoi(r.FormValue("Id"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id редактируемой позиции", err.Error(), "Главная", "/works/prof")
			return
		}
		model, err := strconv.Atoi(r.FormValue("Model"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id модели", err.Error(), "Главная", "/works/prof")
			return
		}
		amout, err := strconv.Atoi(r.FormValue("Amout"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания количества", err.Error(), "Главная", "/works/prof")
			return
		}

		err = a.Db.UpdateDraft(a.Ctx, redId, amout, model)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка обновления драфта", err.Error(), "Главная", "/works/prof")
			return
		}

		draft, err := a.Db.TakeClenDrafts(a.Ctx, drftId)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения драфта", err.Error(), "Главная", "/works/prof")
			return
		}
		a.Templ.DraftPage(w, draft, redId)
	case "Create":
		model, err := strconv.Atoi(r.FormValue("Model"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id модели", err.Error(), "Главная", "/works/prof")
			return
		}
		amout, err := strconv.Atoi(r.FormValue("Amout"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания количества", err.Error(), "Главная", "/works/prof")
			return
		}

		err = a.Db.InsertDraft(a.Ctx, mytypes.Draft{DraftId: drftId, Model: model, Amout: amout})
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка создания драфта", err.Error(), "Главная", "/works/prof")
			return
		}

		draft, err := a.Db.TakeClenDrafts(a.Ctx, drftId)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения драфта", err.Error(), "Главная", "/works/prof")
			return
		}

		a.Templ.DraftPage(w, draft, -1)

	default:
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Неизвестное действие", "", "Главная", "/works/prof")
		return
	}
}
