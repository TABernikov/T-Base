package Application

import (
	"T-Base/Brain/Auth"
	"T-Base/Brain/Filer"

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
	a.MakeUserPage(w, user)
}

// Таблица ТМЦ
func (a App) TMCPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var devices []mytypes.DeviceClean
	var err error
	var link string
	if r.FormValue("Search") == "" {
		devices, err = a.Db.TakeCleanDeviceByRequest(a.ctx, "LIMIT 1000")
		if err != nil {
			fmt.Println(err)
		}
	} else if r.FormValue("Search") == "Clean" {
		link = "?Search=Clean"
		req := `WHERE true `
		if r.FormValue("Id") != "" {
			req += `AND "snsId" = ` + r.FormValue("Id") + ` `
			link += "&Id=" + r.FormValue("Id")
		}
		if r.FormValue("Sn") != "" {
			req += `AND "sn" = '` + r.FormValue("Sn") + `' `
			link += "&Sn=" + r.FormValue("Sn")
		}
		if r.FormValue("Mac") != "" {
			req += `AND "mac" = '` + r.FormValue("Mac") + `' `
			link += "&Mac=" + r.FormValue("Mac")
		}
		if r.FormValue("DModel") != "" {
			req += `AND "dmodel" = '` + r.FormValue("DModel") + `' `
			link += "&DModel=" + r.FormValue("DModel")
		}
		if r.FormValue("Rev") != "" {
			req += `AND "rev" = '` + r.FormValue("Rev") + `' `
			link += "&Rev=" + r.FormValue("Rev")
		}
		if r.FormValue("TModel") != "" {
			req += `AND "tmodel" = '` + r.FormValue("TModel") + `' `
			link += "&TModel=" + r.FormValue("TModel")
		}
		if r.FormValue("Name") != "" {
			req += `AND "name" = '` + r.FormValue("Name") + `' `
			link += "&Name=" + r.FormValue("Name")
		}
		if r.FormValue("Condition") != "" {
			req += `AND "condition" = '` + r.FormValue("Condition") + `' `
			link += "&Condition=" + r.FormValue("Condition")
		}
		if r.FormValue("Order") != "" {
			req += `AND "order" = ` + r.FormValue("Order") + ` `
			link += "&Order=" + r.FormValue("Order")
		}
		if r.FormValue("Place") != "" {
			req += `AND "place" = ` + r.FormValue("Place") + ` `
			link += "&Place=" + r.FormValue("Place")
		}
		if r.FormValue("Shiped") != "" {
			req += `AND "shiped" = ` + r.FormValue("Shiped") + ` `
			link += "&Shiped=" + r.FormValue("Shiped")
		}
		if r.FormValue("ShippedDest") != "" {
			req += `AND "shippedDest" = '` + r.FormValue("ShippedDest") + `' `
			link += "&ShippedDest=" + r.FormValue("ShippedDest")
		}
		if r.FormValue("TakenDoc") != "" {
			req += `AND "takenDoc" = '` + r.FormValue("TakenDoc") + `' `
			link += "&TakenDoc=" + r.FormValue("TakenDoc")
		}
		if r.FormValue("TakenOrder") != "" {
			req += `AND "takenOrder" = '` + r.FormValue("TakenOrder") + `' `
			link += "&TakenOrder=" + r.FormValue("TakenOrder")
		}

		if r.FormValue("CondDate") != "" {
			link += "&CondDate=" + r.FormValue("CondDate")
			date, err := time.Parse("02.01.2006", r.FormValue("CondDate"))
			if err == nil {
				req += `AND "condDate" = '` + date.Format("2006-01-02") + `' `
			}
		} else {
			if r.FormValue("CondDateFrom") != "" {
				req += ` AND "condDate" BETWEEN '` + r.FormValue("CondDateFrom")
				link += "&CondDateFrom=" + r.FormValue("CondDateFrom")
			} else {
				req += ` AND "condDate" BETWEEN '2000-01-01`

			}

			if r.FormValue("CondDateTo") != "" {
				req += `' AND '` + r.FormValue("CondDateTo") + `'`
				link += "&CondDateTo=" + r.FormValue("CondDateTo")
			} else {
				req += `' AND '2100-01-01'`

			}
		}

		if r.FormValue("ShipedDate") != "" {
			link += "&ShipedDate=" + r.FormValue("ShipedDate")
			date, err := time.Parse("02.01.2006", r.FormValue("ShipedDate"))
			if err == nil {
				req += `AND "shipedDate" = '` + date.Format("2006-01-02") + `' `
			}
		} else {
			if r.FormValue("ShipedDateFrom") != "" {
				req += ` AND "shipedDate" BETWEEN '` + r.FormValue("ShipedDateFrom")
				link += "&ShipedDateFrom=" + r.FormValue("ShipedDateFrom")
			} else {
				req += ` AND "shipedDate" BETWEEN '2000-01-01`

			}

			if r.FormValue("ShipedDateTo") != "" {
				req += `' AND '` + r.FormValue("ShipedDateTo") + `'`
				link += "&ShipedDateTo=" + r.FormValue("ShipedDateTo")
			} else {
				req += `' AND '2100-01-01'`

			}
		}

		if r.FormValue("TakenDate") != "" {
			link += "&TakenDate=" + r.FormValue("TakenDate")
			date, err := time.Parse("02.01.2006", r.FormValue("TakenDate"))
			if err == nil {
				req += `AND "takenDate" = '` + date.Format("2006-01-02") + `' `
			}
		} else {
			if r.FormValue("TakenDateFrom") != "" {
				req += ` AND "takenDate" BETWEEN '` + r.FormValue("TakenDateFrom")
				link += "&TakenDateFrom=" + r.FormValue("TakenDateFrom")
			} else {
				req += ` AND "takenDate" BETWEEN '2000-01-01`

			}

			if r.FormValue("TakenDateTo") != "" {
				req += `' AND '` + r.FormValue("TakenDateTo") + `'`
				link += "&TakenDateTo=" + r.FormValue("TakenDateTo")
			} else {
				req += `' AND '2100-01-01'`

			}
		}

		devices, err = a.Db.TakeCleanDeviceByRequest(a.ctx, req)
		if err != nil {
			fmt.Println(err)
		}
	} else if r.FormValue("Search") == "Raw" {
		rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM public.sns WHERE true`
		link = "?Search=Raw"
		if r.FormValue("Id") != "" {
			rawSelect += ` AND "snsId" = ` + r.FormValue("Id")
			link += "&Id=" + r.FormValue("Id")
		}
		if r.FormValue("TModel") != "" {
			rawSelect += ` AND tmodel = ` + r.FormValue("TModel")
			link += "&TModel=" + r.FormValue("TModel")
		}

		if r.FormValue("Sn") != "" {
			rawSelect += ` AND sn = '` + r.FormValue("Sn") + `'`
			link += "&Sn=" + r.FormValue("Sn")
		}

		if r.FormValue("Mac") != "" {
			rawSelect += ` AND mac = '` + r.FormValue("Mac") + `'`
			link += "&Mac=" + r.FormValue("Mac")
		}

		if r.FormValue("Order") != "" {
			rawSelect += ` AND "order" = ` + r.FormValue("Order")
			link += "&Order=" + r.FormValue("Order")
		}

		if r.FormValue("Place") != "" {
			rawSelect += ` AND place = ` + r.FormValue("Place")
			link += "&Place=" + r.FormValue("Place")
		}

		if r.FormValue("DModel") != "" {
			rawSelect += ` And dmodel = ` + r.FormValue("DModel")
			link += "&DModel=" + r.FormValue("DModel")
		}

		if r.FormValue("Rev") != "" {
			rawSelect += ` AND rev =  '` + r.FormValue("Rev") + `'`
			link += "&Rev=" + r.FormValue("Rev")
		}

		if r.FormValue("Name") != "" {
			rawSelect += ` AND name = '` + r.FormValue("Name") + `'`
			link += "&Name=" + r.FormValue("Name")
		}

		if r.FormValue("Condition") != "" {
			rawSelect += ` AND condition = ` + r.FormValue("Condition")
			link += "&Condition=" + r.FormValue("Condition")
		}

		if r.FormValue("CondDateFrom") != "" {
			rawSelect += ` AND "condDate" BETWEEN '` + r.FormValue("CondDateFrom")
			link += "&CondDateFrom=" + r.FormValue("CondDateFrom")
		} else {
			rawSelect += ` AND "condDate" BETWEEN '2000-01-01`
			link += "&CondDateFrom=2000-01-01"
		}

		if r.FormValue("CondDateTo") != "" {
			rawSelect += `' AND '` + r.FormValue("CondDateTo") + `'`
			link += "&CondDateTo=" + r.FormValue("CondDateTo")
		} else {
			rawSelect += `' AND '2100-01-01'`
			link += "&CondDateTo=2100-01-01"
		}

		if r.FormValue("Shiped") != "" {
			rawSelect += (` AND shiped = ` + r.FormValue("Shiped"))
			link += "&Shiped=" + r.FormValue("Shiped")
		}

		if r.FormValue("ShippedDest") != "" {
			rawSelect += ` AND "shippedDest" = '` + r.FormValue("ShippedDest") + `'`
			link += "&ShippedDest=" + r.FormValue("ShippedDest")
		}

		if r.FormValue("ShipedDateFrom") != "" {
			rawSelect += ` AND "shipedDate" BETWEEN '` + r.FormValue("ShipedDateFrom")
			link += "&ShipedDateFrom=" + r.FormValue("ShipedDateFrom")
		} else {
			rawSelect += ` AND "shipedDate" BETWEEN '2000-01-01`
			link += "&ShipedDateFrom=2000-01-01"
		}

		if r.FormValue("ShipedDateTo") != "" {
			rawSelect += `' AND '` + r.FormValue("ShipedDateTo") + `'`
			link += "&ShipedDateTo=" + r.FormValue("ShipedDateTo")
		} else {
			rawSelect += `' AND '2100-01-01'`
			link += "&ShipedDateTo=2100-01-01"
		}

		if r.FormValue("TakenDoc") != "" {
			rawSelect += ` AND "takenDoc" = '` + r.FormValue("TakenDoc") + `'`
			link += "&TakenDoc=" + r.FormValue("TakenDoc")
		}

		if r.FormValue("TakenOrder") != "" {
			rawSelect += ` AND "takenOrder" = '` + r.FormValue("TakenOrder") + `'`
			link += "&TakenOrder=" + r.FormValue("TakenOrder")
		}

		if r.FormValue("TakenDateFrom") != "" {
			rawSelect += ` AND "takenDate" BETWEEN '` + r.FormValue("TakenDateFrom")
			link += "&TakenDateFrom=" + r.FormValue("TakenDateFrom")
		} else {
			rawSelect += ` AND "takenDate" BETWEEN '2000-01-01`
			link += "&TakenDateFrom=2000-01-01"
		}

		if r.FormValue("TakenDateTo") != "" {
			rawSelect += `' AND '` + r.FormValue("TakenDateTo") + `'`
			link += "&TakenDateTo=" + r.FormValue("TakenDateTo")
		} else {
			rawSelect += `' AND '2100-01-01'`
			link += "&TakenDateTo=2100-01-01"
		}

		cleanSelect := `SELECT tmp."snsId", tmp.sn, tmp.mac, "dModels"."dModelName" AS dmodel, tmp.rev, "tModels"."tModelsName" AS tmodel, tmp.name, "condNames"."condName" AS condition, tmp."condDate", tmp."order", tmp.place, tmp.shiped, tmp."shipedDate", tmp."shippedDest", tmp."takenDate", tmp."takenDoc", tmp."takenOrder", snscomment.comment FROM (` + rawSelect + `)tmp LEFT JOIN "dModels" ON "dModels"."dModelsId" = tmp.dmodel LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.tmodel LEFT JOIN "condNames" ON "condNames"."condNamesId" = tmp.condition LEFT JOIN snscomment ON snscomment."snsId" = tmp."snsId"`

		devices, err = a.Db.TakeCleanDevice(a.ctx, cleanSelect)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	} else if r.FormValue("Search") == "Sns" {
		snString := r.FormValue("in")
		link = "?Search=Sns&in=" + r.FormValue("in")
		Sns := strings.Fields(snString)
		devices, err = a.Db.TakeCleanDeviceBySn(a.ctx, Sns...)
		if err != nil {
			fmt.Println(err)
		}
	} else if r.FormValue("Search") == "Anything" {
		link = "?Search=Anything&in=" + r.FormValue("in")
		snString := r.FormValue("in")
		Sns := strings.Split(snString, ";")
		devices, err = a.Db.TakeCleanDeviceByAnything(a.ctx, Sns...)
		if err != nil {
			fmt.Println(err)
		}
	}

	MakeTMCPage(w, devices, "ТМЦ показанно устройств: "+strconv.Itoa(len(devices)), link)
}

func (a App) TMCSearchPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.MakeTMCAdvanceSearchPage(w)
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
	MakeImputPage(w, "/works/tmc", "Поиск по Sn", "Введите серийные номера", "Поиск")
}

// Страница склада по заказам
func (a App) StoragePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if r.FormValue("Search") != "" {
		in := r.FormValue("in")
		in = strings.TrimSpace(in)
		qq := `SELECT "order", name, count, "orderName" FROM wear Where "orderName" LIKE '%` + in + `%' OR name LIKE '%` + in + `%' `
		_, err := strconv.Atoi(in)
		if err == nil {
			qq += ` OR "order" = ` + in
		}

		storage, err := a.Db.TakeStorageCount(a.ctx, qq)

		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}

		MakeStoragePage(w, storage, "Склад поиск: "+in)

	} else {
		storage, err := a.Db.TakeStorageCount(a.ctx, "")
		if err != nil {
			if err != nil {
				MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
				return
			}
		}
		MakeStoragePage(w, storage, "Склад заказы")
	}
}

// Страница склада по местам
func (a App) StorageByPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if r.FormValue("Search") != "" {
		in := r.FormValue("in")
		in = strings.TrimSpace(in)
		qq := `SELECT place, name, count FROM public."wearByPlace" Where name LIKE '%` + in + `%' `
		_, err := strconv.Atoi(in)
		if err == nil {
			qq += ` OR place = ` + in
		}

		storage, err := a.Db.TakeStorageCountByPlace(a.ctx, qq)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		MakeStorageByPlacePage(w, storage, "Склад места поиск: "+in)
	} else {

		storage, err := a.Db.TakeStorageCountByPlace(a.ctx, "")
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}

		MakeStorageByPlacePage(w, storage, "Склад места")
	}
}

// Страница склада по моделям
func (a App) StorageByTModelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if r.FormValue("Search") != "" {
		if r.FormValue("Condition") != "" {

			_, err := strconv.Atoi(r.FormValue("Condition"))
			if err != nil {
				qq := `SELECT tmodel, name, condition, count, shiped FROM public."cleanWearByTModel" Where condition = '` + r.FormValue("Condition") + `'`
				storage, err := a.Db.TakeStorageByTModelClean(a.ctx, qq)
				if err != nil {
					MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
					return
				}
				MakeStorageByTModelPage(w, storage, "Склад модели "+r.FormValue("Condition"))
				return
			}
			qq := ` SELECT "tModels"."tModelsName" AS tmodel,
			"wearByTModel".name,
			"condNames"."condName" AS condition,
			"wearByTModel".count,
			"wearByTModel".shiped
		   	FROM "wearByTModel"
			LEFT JOIN "tModels" ON "tModels"."tModelsId" = "wearByTModel".tmodel
			LEFT JOIN "condNames" ON "condNames"."condNamesId" = "wearByTModel".condition
			WHERE "wearByTModel".condition = ` + r.FormValue("Condition") + `
		  	ORDER BY "tModels"."tModelsName", "condNames"."condName";`

			storage, err := a.Db.TakeStorageByTModelClean(a.ctx, qq)
			if err != nil {
				MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
				return
			}
			MakeStorageByTModelPage(w, storage, "Склад модели")
			return

		} else {
			in := r.FormValue("in")
			in = strings.TrimSpace(in)
			qq := `SELECT tmodel, name, condition, count, shiped FROM public."cleanWearByTModel" Where tmodel LIKE '%` + in + `%' OR name LIKE '%` + in + `%' `

			storage, err := a.Db.TakeStorageByTModelClean(a.ctx, qq)
			if err != nil {
				MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
				return
			}
			MakeStorageByTModelPage(w, storage, "Склад модели поиск: "+in)
		}
	} else {
		storage, err := a.Db.TakeStorageByTModelClean(a.ctx, "")
		if err != nil {
			fmt.Println(err)
			return
		}

		MakeStorageByTModelPage(w, storage, "Склад модели")
	}
}

// Таблица заказов
func (a App) OrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var orders []mytypes.OrderClean
	var err error
	var link string
	if r.FormValue("Search") == "" {
		orders, err = a.Db.TakeCleanOrderByReqest(a.ctx, `WHERE "isAct" = true`)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		}
	} else if r.FormValue("Search") == "Anything" {
		link = "?Search=Anything&in=" + r.FormValue("in")
		searchString := r.FormValue("in")
		searchs := strings.Split(searchString, ";")
		orders, err = a.Db.TakeCleanOrderByAnything(a.ctx, searchs...)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	MakeOrdersPage(w, orders, "Заказы", link)
}

// Компактное представление заказа
func (a App) OrderMiniPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	var order mytypes.OrderClean

	if r.FormValue("Id") == "" {
		orders, err := a.Db.TakeCleanOrderByReqest(a.ctx, `WHERE "isAct" = true LIMIT 1`)
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

	reqsest := ` SELECT public."tModels"."tModelsName" AS tmodel, tmp.name, public."condNames"."condName", tmp.count, tmp.shiped From
	(SELECT sns.tmodel, sns.name, sns.condition, count(sns."snsId") AS "count", sns.shiped FROM sns WHERE sns.order = ` + strconv.Itoa(order.OrderId) + ` GROUP BY sns.tmodel, sns.condition, sns.shiped, sns.name ORDER BY sns.tmodel, sns.condition) tmp
	LEFT JOIN public."condNames" ON public."condNames"."condNamesId" = tmp.condition LEFT JOIN public."tModels" ON public."tModels"."tModelsId" = tmp.tmodel`

	reservs, err := a.Db.TakeStorageByTModelClean(a.ctx, reqsest)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		reservs = nil
	}

	status, err := a.Db.TakeCleanOrderStatus(a.ctx, order.OrderId)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
	}

	MakeOrderMiniPage(w, order, orderList, reservs, status, user)
}

// Страница передачи в производство
func (a App) ToWorkPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeImputPage(w, "/works/towork", "Передать в производство", "Введите серийные номера для передачи", "Передать")
}

// Страница назначения резерва
func (a App) SetOrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeDobleImputPage(w, "/works/setorder", "Назначить заказ/резерв", "Введите серийные номера:", "Номер заказа", "number", "Назначить заказ")
}

// Страница установки места
func (a App) SetPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeDobleImputPage(w, "/works/setplace", "Установить место", "Введите серийные номера:", "Номер места", "number", "Установить место")
}

// Страница приемки демо
func (a App) TakeDemoPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeImputPage(w, "", "Приемка демо", "Введите серийные номера", "Принять")
}

// Страница отгрузки
func (a App) ToShipPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeDobleImputPage(w, "", "Отгрузка", "Введите серийные номера", "Место отгрузки", "text", "Отгрузить")
}

// Страница изменения номера паллета
func (a App) ChangeNumPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeDobleImputTypePage(w, "/works/cangeplacenum", "Установить номер места", "Введите старый номер:", "number", "Введите новый номер", "number", "Изменить")
}

// Страница приемки помодельно
func (a App) TakeDeviceByModelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.MakeTakeDeviceByModelPage(w)
}

// Страница создания заказа
func (a App) CreateOrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeCreateOrderPage(w)
}

// Страница изменения мак адреса устройства
func (a App) ChangeMACPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeImputPage(w, "", "Изменить маки", "Введите последовательно серийный номер и мак для каждого устройства", "Изменить")
}

// Страница выпуска устройств с производства
func (a App) ReleaseProductionPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeImputPage(w, "", "Выпуск с производства", "Введите серийные номера", "Выпуск")
}

// Страница возврата не собраных устройств на производство
func (a App) ReturnToStoragePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeImputPage(w, "", "Вернуть на склад", "Введите серийные номера через пробез или с новой стрроки", "Вернуть")
}

// Страница установки обещаной даты выхода заказа с производства
func (a App) SetPromDatePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeDobleImputTypePage(w, "", "Задать дату", "Введите ID заказа "+r.FormValue("Order"), "number", "Введите дату готовности", "date", "Задать дату")
}

// Страница смены пароля
func (a App) ChangePassPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	MakeChangePassPage(w, "", "", "", "")
}

func (a App) AddCommentToSnsBySnPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	MakeDobleImputPage(w, "/works/addcommentbysn", "Дополнить комментарии", "Серийные номера", "Коментарий", "text", "Добавить коментарий")
}

func (a App) TakeDeviceByExcelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeImputTypePage(w, "", "Приемка файлом", "file", "Выберете файл", "Отправить")
}

func (a App) CreateMatPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	MakeCreateMatPage(w)
}

func (a App) TakeMatPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	a.MakeTakeMatPage(w)
}

func (a App) StorageMatsPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.MakeStorageMatsPage(w)
}

func (a App) StorageMatsByNamePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.MakeStorageMatsByNamePage(w)
}

func (a App) StorageMatsBy1CPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.MakeStorageMatsBy1CPage(w)
}

func (a App) CreateBuildPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.MakeCreateBuildPage(w)
}

func (a App) BuildsPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	Builds, err := a.Db.TakeCleanBuildByTModel(a.ctx)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения сборок", err.Error(), "Главная", "/works/prof")
		return
	}
	a.MakeBuildsPage(w, Builds)
}

func (a App) TModelsPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	models, err := a.Db.TakeTModelsById(a.ctx)

	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения моделей", err.Error(), "Главная", "/works/prof")
		return
	}
	MakeTModelsPage(w, models)
}

func (a App) TModelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка преобразования ID", err.Error(), "Главная", "/works/prof")
		return
	}

	model, err := a.Db.TakeTModelsById(a.ctx, id)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения модели", err.Error(), "Главная", "/works/prof")
		return
	}

	builds, err := a.Db.TakeCleanBuildByTModel(a.ctx, id)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения сборок", err.Error(), "Главная", "/works/prof")
		return
	}

	MakeTModelPage(w, model[0], builds)
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

// передача в работу
func (a App) ToWork(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	snString := r.FormValue("in")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnToWork(a.ctx, Sns...)
	logCount := a.Db.AddDeviceEventBySn(a.ctx, 2, "Передано в работу", user.UserId, Sns...)
	if logCount != count {
		fmt.Println("Ошибка записи логов")
	}
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
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

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
	logCount := a.Db.AddDeviceEventBySn(a.ctx, 3, "Установлен заказ "+strconv.Itoa(order), user.UserId, Sns...)
	if logCount != count {
		fmt.Println("Ошибка записи логов")
	}

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

// установка места
func (a App) SetPlace(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

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
	logCount := a.Db.AddDeviceEventBySn(a.ctx, 6, "Установлено место "+strconv.Itoa(place), user.UserId, Sns...)
	if logCount != count {
		fmt.Println("Ошибка записи логов")
	}
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

// приемка демо
func (a App) TakeDemo(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	snString := r.FormValue("in")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnTakeDemo(a.ctx, Sns...)
	logCount := a.Db.AddDeviceEventBySn(a.ctx, 1, "Принято демо", user.UserId, Sns...)
	if logCount != count {
		fmt.Println("Ошибка записи логов")
	}
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		MakeAlertPage(w, 5, "Предупреждение", "Не передано", "Устройства приняты", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Принято "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		MakeAlertPage(w, 1, "Готово", "Принято", "Все устройства приняты", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Принято "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		MakeAlertPage(w, 2, "Готово", "Частично", "Часть устройств не принята", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Принято "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

// отгрузка
func (a App) ToShip(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	snString := r.FormValue("in1")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnToShip(a.ctx, r.FormValue("in2"), Sns...)
	logCount := a.Db.AddDeviceEventBySn(a.ctx, 5, "Отгрузка "+r.FormValue("in2"), user.UserId, Sns...)
	if logCount != count {
		fmt.Println("Ошибка записи логов")
	}
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		MakeAlertPage(w, 5, "Предупреждение", "Не передано", "Устройства отгружены", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Отгружено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		MakeAlertPage(w, 1, "Готово", "Отгружено", "Все устройства отгружены", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Отгружено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		MakeAlertPage(w, 2, "Готово", "Частично", "Часть устройств не отгружена", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Отгружено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

// изменение номера паллета
func (a App) ChangeNumPlace(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	old, err := strconv.Atoi(r.FormValue("in1"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	new, err := strconv.Atoi(r.FormValue("in2"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.ChangeNumPlace(a.ctx, old, new)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	MakeAlertPage(w, 1, "Готово", "Измененно", "Номер паллета успешно изменен", "Старый номер "+strconv.Itoa(old)+" ->	Новый "+strconv.Itoa(new), "Главная", "/works/prof")
}

// добавить комментарий по Id
func (a App) AddCommentToSns(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		a.OrderMiniPage(w, r, pr, user)
		return
	}

	text := r.FormValue("text")
	text = strings.TrimSpace(text)
	if text == "" {
		a.DeviceMiniPage(w, r, pr, user)
		return
	}

	err = a.Db.AddCommentToSns(a.ctx, id, text, user)
	if err != nil {
		fmt.Println(err)
		a.DeviceMiniPage(w, r, pr, user)
		return
	}

	a.DeviceMiniPage(w, r, pr, user)
}

// Добавить комментарий по серийным номерам
func (a App) AddCommentToSnsBySn(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	snString := r.FormValue("in1")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	text := r.FormValue("in2")

	devices, err := a.Db.TakeDeviceBySn(a.ctx, Sns...)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска устройств", "", "Главная", "/works/prof")
	}
	var count int
	for _, device := range devices {
		if a.Db.AddCommentToSns(a.ctx, device.Id, text, user) == nil {
			count++
		}
	}

	if count == 0 {
		MakeAlertPage(w, 5, "Предупреждение", "Не назначено", "Устройствам не было назначен коментарий", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		MakeAlertPage(w, 1, "Готово", "Назначено", "Всем устройствам было назначен коментарий", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		MakeAlertPage(w, 2, "Готово", "Частично", "Части устройств не было назначен коментарий", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
	MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденая ошибка", "", "Главная", "/works/prof")
}

// приемка по модельно
func (a App) TakeDeviceByModel(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	var DModel int
	DModelIn := r.FormValue("DModel")
	err := a.Db.Db.QueryRow(a.ctx, `SELECT "dModelsId" FROM "dModels" WHERE "dModelName" = $1`, DModelIn).Scan(&DModel)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Не указана модель", "Укажите модель поставщика", err.Error(), "Главная", "/works/prof")
		return
	}
	Name := DModelIn

	var TModel int
	TModelIn := r.FormValue("TModel")
	err = a.Db.Db.QueryRow(a.ctx, `SELECT "tModelsId" FROM "tModels" WHERE "tModelName" = $1`, TModelIn).Scan(&TModel)
	if err != nil {
		TModel = 0
	}

	Rev := r.FormValue("Rev")
	Place, err := strconv.Atoi(r.FormValue("Place"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Не указано место", "Укажите место", err.Error(), "Главная", "/works/prof")
		return
	}
	Doc := r.FormValue("Doc")
	Order := r.FormValue("Order")

	snString := r.FormValue("Sn")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	i, SnErr, err := a.Db.InsetDeviceByModel(a.ctx, DModel, Name, TModel, Rev, Place, Doc, Order, Sns...)

	if err != nil {
		errString := ""
		for _, a := range SnErr {
			errString += a + "\n"
		}
		MakeAlertPage(w, 5, "Ошибка", "Ошибка внесения усройств", "Было внесено "+strconv.Itoa(i)+" из "+strconv.Itoa(len(Sns)), errString, "Главная", "/works/prof")
		return
	}
	MakeAlertPage(w, 1, "Готово", "Готово", "Все устройства внесены", "Отличная работа", "Главная", "/works/prof")
}

// создание заказа
func (a App) CreateOrder(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	Id1C, err := strconv.Atoi(r.FormValue("1C"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Номер 1С не число", "Номер 1С не число", err.Error(), "Главная", "/works/prof")
		return
	}
	Name := r.FormValue("Name")

	fmt.Println(r.FormValue("Req"))
	ReqDate, err := time.Parse("2006-01-02", r.FormValue("Req"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Требуемая дата не дата", "", err.Error(), "Главная", "/works/prof")
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

	Id, err := a.Db.InsertOrder(a.ctx, order)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка создания заказа", "Заказ не создан", err.Error(), "Главная", "/works/prof")
		return
	}

	MakeAlertPage(w, 1, "Готово", "Готово", "Заказ "+strconv.Itoa(Id1C)+" "+Name+"создан", "Не забудьте внести состав заказа", "К заказу", "/works/order/mini?Id="+strconv.Itoa(Id))
}

// удаление заказа
func (a App) DelOrder(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Не существующее число", err.Error(), "Главная", "/works/prof")
		return
	}

	order, err := a.Db.TakeOrderById(a.ctx, id)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Ваш заказ пропал!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.UserId != order[0].Meneger {
		MakeAlertPage(w, 5, "Ошибка", "Нельзя удалить чужой заказ", "Плохо так делать", "Не надо так", "Главная", "/works/prof")
		return
	}

	err = a.Db.DellOrder(a.ctx, id)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка удаления заказа", "Удаление прошло не корректно", err.Error(), "Главная", "/works/prof")
		return
	}
	MakeAlertPage(w, 1, "Готово", "Готово", "Заказ успешно удален", "Отличная работа", "Главная", "/works/prof")
}

// изменить № 1С у заказа
func (a App) Change1CNumOrder(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Не существующее число", err.Error(), "Главная", "/works/prof")
		return
	}

	order, err := a.Db.TakeOrderById(a.ctx, id)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Ваш заказ пропал!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.UserId != order[0].Meneger {
		MakeAlertPage(w, 5, "Ошибка", "Нельзя изменить чужой заказ", "Плохо так делать", "Не надо так", "Главная", "/works/prof")
		return
	}

	new1CId, err := strconv.Atoi(r.FormValue("1CNum"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Не число", "Новый номер 1С должен быть числом", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.Change1CNumOrder(a.ctx, id, new1CId)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка изменения номера", "Чтото пошло не так", err.Error(), "Главная", "/works/prof")
		return
	}
	MakeAlertPage(w, 1, "Готово", "Готово", "Номер успешно изменен", "Отличная работа", "Главная", "/works/prof")
}

// изменение состава заказа (Страница)
func (a App) CreateOrderListPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Не существующее число", err.Error(), "Главная", "/works/prof")
		return
	}

	order, err := a.Db.TakeOrderById(a.ctx, id)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Не существующий Id заказа", "Ваш заказ пропал!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.UserId != order[0].Meneger {
		MakeAlertPage(w, 5, "Ошибка", "Нельзя редактировать чужой заказ", "Плохо так делать", "Не надо так", "Главная", "/works/prof")
		return
	}

	if r.FormValue("Action") == "Open" {
		a.MakeCreateOrderListPage(w, -1, id)

	} else if r.FormValue("Action") == "OpenRedact" {
		listId, err := strconv.Atoi(r.FormValue("ListId"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Не существующий элемент заказа", "Не существующее число", err.Error(), "Главная", "/works/prof")
			return
		}
		a.MakeCreateOrderListPage(w, listId, id)

	} else if r.FormValue("Action") == "Create" {
		var newPos mytypes.OrderList
		newPos.Model, err = strconv.Atoi(r.FormValue("TModel"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверная модель", err.Error(), "Главная", "/works/prof")
		}
		newPos.Amout, err = strconv.Atoi(r.FormValue("Amout"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверное кол-во", err.Error(), "Главная", "/works/prof")
		}
		newPos.ServType, err = strconv.Atoi(r.FormValue("Serv"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверный тип сервиса", err.Error(), "Главная", "/works/prof")
		}
		newPos.ServActDate, err = time.Parse("2006-01-02", r.FormValue("ServActDate"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверная дата начала сервиса", err.Error(), "Главная", "/works/prof")
		}
		newPos.Order = id

		err = a.Db.InsertOrderList(a.ctx, newPos)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка создания", "Что-то пошло не так", err.Error(), "Главная", "/works/prof")
		}

		a.MakeCreateOrderListPage(w, -1, id)
	} else if r.FormValue("Action") == "Redact" {
		var redPos mytypes.OrderList
		redPos.Model, err = strconv.Atoi(r.FormValue("TModel"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверная модель", err.Error(), "Главная", "/works/prof")
		}
		redPos.Amout, err = strconv.Atoi(r.FormValue("Amout"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверное кол-во", err.Error(), "Главная", "/works/prof")
		}
		redPos.ServType, err = strconv.Atoi(r.FormValue("Serv"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверный тип сервиса", err.Error(), "Главная", "/works/prof")
		}
		redPos.ServActDate, err = time.Parse("2006-01-02", r.FormValue("ServActDate"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверная дата начала сервиса", err.Error(), "Главная", "/works/prof")
		}
		redPos.Order = id
		redPos.Id, err = strconv.Atoi(r.FormValue("ListId"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка изменения", "Неверный ID элемента", err.Error(), "Главная", "/works/prof")
		}

		redPos.LastRed = time.Now()

		err = a.Db.ChangeOrderList(a.ctx, redPos)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка изменения", "Что-то пошло не так", err.Error(), "Главная", "/works/prof")
		}

		a.MakeCreateOrderListPage(w, -1, id)
	}
}

// Изменение мак адреса устройства
func (a App) ChangeMAC(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	in := strings.Fields(r.FormValue("in"))
	if len(in)%2 == 1 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Серийников больше чем маков", "(или наоборот)", "Главная", "/works/prof")
	}

	var count int
	for i := 0; i < len(in); i = i + 2 {
		_, err := a.Db.ChangeMAC(a.ctx, in[i], in[i+1])
		logCount := a.Db.AddDeviceEventBySn(a.ctx, 6, "Установлен mac "+in[i+1], user.UserId, in[i])
		if logCount != 1 {
			fmt.Println("Ошибка записи логов")
		}
		if err != nil {
			MakeAlertPage(w, 2, "Ошибка", "Частично", "Изменнено только часть MAC", "Изменены "+strconv.Itoa(count)+" устройств, до "+in[i], "Главная", "/works/prof")
		}
		count++
	}
	MakeAlertPage(w, 1, "Успешно", "Успешно", "Изменено "+strconv.Itoa(count)+" устройств", "", "Главная", "/works/prof")
}

// Выпуск устройств с производства
func (a App) ReleaseProduction(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	in := strings.Fields(r.FormValue("in"))

	if len(in) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	counter := a.Db.ReleaseProduction(a.ctx, in...)
	logCount := a.Db.AddDeviceEventBySn(a.ctx, 4, "Преобразование", user.UserId, in...)
	if logCount != counter {
		fmt.Println("Ошибка записи логов")
	}
	if counter == 0 {
		MakeAlertPage(w, 5, "Предупреждение", "Не передано", "Устройства не перобразованы", "Внесено "+strconv.Itoa(len(in))+" серийных номеров	Преобразовано "+strconv.Itoa(counter)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(in)-counter == 0 {
		MakeAlertPage(w, 1, "Готово", "Преобразованно", "Все устройства преобразованы", "Внесено "+strconv.Itoa(len(in))+" серийных номеров	Преобразовано "+strconv.Itoa(counter)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(in)-counter > 0 {
		MakeAlertPage(w, 2, "Готово", "Частично", "Часть устройств не преобразована", "Внесено "+strconv.Itoa(len(in))+" серийных номеров	Преобразовано "+strconv.Itoa(counter)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
	MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", "", "Главная", "/works/prof")
}

// Вернуть не собраные устройства на склад
func (a App) ReturnToStorage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	in := strings.Fields(r.FormValue("in"))

	if len(in) == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	counter := a.Db.ReturnToStorage(a.ctx, in...)
	logCount := a.Db.AddDeviceEventBySn(a.ctx, 9, "Возврат", user.UserId, in...)
	if logCount != counter {
		fmt.Println("Ошибка записи логов")
	}

	if counter == 0 {
		MakeAlertPage(w, 5, "Предупреждение", "Не передано", "Устройства не переданы", "Внесено "+strconv.Itoa(len(in))+" серийных номеров	Преобразовано "+strconv.Itoa(counter)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(in)-counter == 0 {
		MakeAlertPage(w, 1, "Готово", "Передано", "Все устройства переданы", "Внесено "+strconv.Itoa(len(in))+" серийных номеров	Преобразовано "+strconv.Itoa(counter)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(in)-counter > 0 {
		MakeAlertPage(w, 2, "Готово", "Частично", "Часть устройств не передона", "Внесено "+strconv.Itoa(len(in))+" серийных номеров	Преобразовано "+strconv.Itoa(counter)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
	MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", "", "Главная", "/works/prof")
}

// Установить обещаную дату производства заказа
func (a App) SetPromDate(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	order, err := strconv.Atoi(r.FormValue("in1"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	date, err := time.Parse("2006-01-02", r.FormValue("in2"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.SetPromDate(a.ctx, order, date)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка присвоения даты", "Вероятно неверно задан ID заказа", err.Error(), "Главная", "/works/prof")
		return
	}
	MakeAlertPage(w, 1, "Готово", "Установленно", "Заказу с ID "+strconv.Itoa(order)+" назначена новая дата производства", "", "Главная", "/works/prof")
}

// Изменить пароль
func (a App) ChangePass(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	oldPass := r.FormValue("old")
	newPass := r.FormValue("new")
	chekPass := r.FormValue("chek")

	if oldPass == "" || newPass == "" || chekPass == "" {
		MakeAlertPage(w, 5, "Ошибка", "Заполните форму", "", "", "Главная", "/")
		return
	}

	if newPass != chekPass {
		MakeChangePassPage(w, "Пароли не совпадают", oldPass, newPass, chekPass)
		return
	}

	users, err := a.Db.TakeUserById(a.ctx, user.UserId)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Пользователь не найден", "", err.Error(), "Главная", "/")
		return
	}
	user = users[0]

	if oldPass != user.Pass {
		MakeChangePassPage(w, "Не верный пароль", oldPass, newPass, chekPass)
		return
	}

	res, err := a.Db.Db.Exec(a.ctx, "UPDATE public.users SET  pass=$1 WHERE userid=$2;", newPass, user.UserId)
	if err != nil || res.RowsAffected() == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка смены пароля", "", err.Error(), "Главная", "/")
		return
	}
	MakeAlertPage(w, 1, "Успешно", "Успешно", "Изменено ", "", "Главная", "/works/prof")
}

func (a App) TakeDeviceByExcel(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	src, hdr, err := r.FormFile("in")
	if err != nil {
		if err.Error() == "http: no such file" {
			sendFile(w, r, "Files/Templ/Приемка файлом шаблон.xlsx", "Приемка файлом шаблон.xlsx")
			return
		}

		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка получения", err.Error(), "Главная", "/works/prof")
		return
	}
	defer src.Close()

	f, name, err := takeFile(src, hdr, user)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка записи", err.Error(), "Главная", "/works/prof")
		return
	}
	f.Close()

	devices, err, litleErr := Filer.ReadNewDevice(f.Name(), *a.Db)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка чтения", err.Error(), "Главная", "/works/prof")
		return
	}
	insertCount, err := a.Db.InsertDivice(a.ctx, devices...)
	if litleErr {
		err := sendFile(w, r, f.Name(), name)
		if err != nil {
			fmt.Fprintln(w, err)
		}
	}
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка внесения", err.Error(), "Главная", "/works/prof")
		return
	}

	if insertCount == 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Устройства небыли приняты", err.Error(), "Главная", "/works/prof")
		return
	} else if insertCount < len(devices) {
		MakeAlertPage(w, 2, "Готово", "Частично", "Часть устройств не было принято", "Внесено "+strconv.Itoa(insertCount), "Главная", "/works/prof")
		return
	} else if insertCount > len(devices) {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	MakeAlertPage(w, 1, "Готово", "Готово", "Все "+strconv.Itoa(insertCount)+" устройств внесены", "Отличная работа", "Главная", "/works/prof")
}

// Создание новых материалов
func (a App) CreateMat(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	name := r.FormValue("Name")
	matType, err := strconv.Atoi(r.FormValue("Type"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка получения", err.Error(), "Главная", "/works/prof")
		return
	}
	err = a.Db.InsertMat(a.ctx, name, matType)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка внесения", err.Error(), "Главная", "/works/prof")
		return
	}

	MakeAlertPage(w, 1, "Готово", "Готово", "Успешно", "Отличная работа", "Главная", "/works/prof")
}

// Приемка метериалов
func (a App) TakeMat(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		MakeAlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	name := r.FormValue("Name")
	name1c := r.FormValue("Name1C")
	amout, err := strconv.Atoi(r.FormValue("Amout"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка получения", err.Error(), "Главная", "/works/prof")
		return
	}
	if amout < 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Нельзя принять отрицательное число материала", "Это называется списание", "Главная", "/works/prof")
		return
	}

	price, err := strconv.Atoi(r.FormValue("Price"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка получения", err.Error(), "Главная", "/works/prof")
		return
	}
	if price < 0 {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Цена не может быть отрицательной", "Это называется списание", "Главная", "/works/prof")
		return
	}

	err = a.Db.AddMat(a.ctx, name, name1c, price, amout)
	if err != nil {
		if err.Error() == "критическая ошибка" {
			MakeAlertPage(w, 5, "Ошибка", "КРИТИЧЕСКАЯ ОШИБКА !!!", "ОБРАТИТЕСЬ К АДМИНЕСТРАТОРУ ДЛЯ ВНЕСЕНИЯ ИСПРАВЛЕНИЙ", err.Error(), "Главная", "/works/prof")
		} else {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка внесения", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	MakeAlertPage(w, 1, "Готово", "Готово", "Успешно", "Отличная работа", "Главная", "/works/prof")
}

// Создание сборки
func (a App) MakeBuild(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var build mytypes.Build
	dModelstr := r.FormValue("DModel")
	tModelstr := r.FormValue("TModel")

	err := a.Db.Db.QueryRow(a.ctx, `SELECT "dModelsId" FROM public."dModels" WHERE "dModelName" = $1`, dModelstr).Scan(&build.DModel)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", "", "Главная", "/works/prof")
		return
	}

	err = a.Db.Db.QueryRow(a.ctx, `SELECT "tModelsId" FROM public."tModels" WHERE "tModelsName" = $1`, tModelstr).Scan(&build.TModel)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", "", "Главная", "/works/prof")
		return
	}

	type buildPoint struct {
		Id    string
		Amout string
	}

	buildPoints := []buildPoint{{Id: "case", Amout: "caseAmout"}, {Id: "stiker", Amout: "stikerAmout"}, {Id: "box", Amout: "boxAmout"}, {Id: "boxholder", Amout: "boxholderAmout"}, {Id: "another1", Amout: "another1Amout"}, {Id: "another2", Amout: "another2Amout"}, {Id: "another3", Amout: "another3Amout"}}

	for _, point := range buildPoints {
		tmp := r.FormValue(point.Id)

		elId, err := strconv.Atoi(tmp)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка 1", "", "Главная", "/works/prof")
			return
		}
		tmp = r.FormValue(point.Amout)

		if tmp == "" {
			continue
		}
		elAmout, err := strconv.Atoi(tmp)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка 2", "", "Главная", "/works/prof")
			return
		}
		if elId != -1 && elAmout > 0 {
			element := mytypes.BuildListElement{MatId: elId, Amout: elAmout}
			build.BuildList = append(build.BuildList, element)
		}
	}

	count, err := a.Db.InsertBuild(a.ctx, build)
	if count != 1 || err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка заведения", strconv.Itoa(count)+err.Error(), "Главная", "/works/prof")
	}

	MakeAlertPage(w, 1, "Успешно", "Успешно", "Сборка создана", "не забудьте что сборку нужно указывать в параметрах модели", "Главная", "/works/prof")
}

// изменить стандартную сборку для модели
func (a App) ChangeDefBuild(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	tModel, err := strconv.Atoi(r.FormValue("TModel"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	newBuild, err := strconv.Atoi(r.FormValue("NewBuild"))
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.ChangeDefBuild(a.ctx, tModel, newBuild)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	http.Redirect(w, r, "/works/tmodel?Id="+strconv.Itoa(tModel), http.StatusSeeOther)
}

//////////////////////

// Отправка отчетов //

//////////////////////

// Тестовый файл
func (a App) TestFile(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	order, err := a.Db.TakeCleanOrderById(a.ctx)
	if err != nil {
		fmt.Println(err)
	}

	path, name, err := Filer.OrderExceller(*a.Db, a.AppIp, "http://"+a.AppIp+"/works/orders", order...)
	fmt.Println(path)
	if err != nil {
		fmt.Println(err)
	}

	err = sendTMPFile(w, r, path, name)
	if err != nil {
		fmt.Println(err)
	}
}

func (a App) TMCExcell(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	var devices []mytypes.DeviceClean
	var link string
	var err error
	if r.FormValue("Search") == "" {
		devices, err = a.Db.TakeCleanDeviceById(a.ctx)
		if err != nil {
			fmt.Println(err)
		}
	} else if r.FormValue("Search") == "Clean" {
		req := `WHERE true `
		link = "?Search=Clean"
		if r.FormValue("Id") != "" {
			req += `AND "snsId" = ` + r.FormValue("Id") + ` `
			link += "&Id=" + r.FormValue("Id")
		}
		if r.FormValue("Sn") != "" {
			req += `AND "sn" = '` + r.FormValue("Sn") + `' `
			link += "&Sn=" + r.FormValue("Sn")
		}
		if r.FormValue("Mac") != "" {
			req += `AND "mac" = '` + r.FormValue("Mac") + `' `
			link += "&Mac=" + r.FormValue("Mac")
		}
		if r.FormValue("DModel") != "" {
			req += `AND "dmodel" = '` + r.FormValue("DModel") + `' `
			link += "&DModel=" + r.FormValue("DModel")
		}
		if r.FormValue("Rev") != "" {
			req += `AND "rev" = '` + r.FormValue("Rev") + `' `
			link += "&Rev=" + r.FormValue("Rev")
		}
		if r.FormValue("TModel") != "" {
			req += `AND "tmodel" = '` + r.FormValue("TModel") + `' `
			link += "&TModel=" + r.FormValue("TModel")
		}
		if r.FormValue("Name") != "" {
			req += `AND "name" = '` + r.FormValue("Name") + `' `
			link += "&Name=" + r.FormValue("Name")
		}
		if r.FormValue("Condition") != "" {
			req += `AND "condition" = '` + r.FormValue("Condition") + `' `
			link += "&Condition=" + r.FormValue("Condition")
		}
		if r.FormValue("Order") != "" {
			req += `AND "order" = ` + r.FormValue("Order") + ` `
			link += "&Order=" + r.FormValue("Order")
		}
		if r.FormValue("Place") != "" {
			req += `AND "place" = ` + r.FormValue("Place") + ` `
			link += "&Place=" + r.FormValue("Place")
		}
		if r.FormValue("Shiped") != "" {
			req += `AND "shiped" = ` + r.FormValue("Shiped") + ` `
			link += "&Shiped=" + r.FormValue("Shiped")
		}
		if r.FormValue("ShippedDest") != "" {
			req += `AND "shippedDest" = '` + r.FormValue("ShippedDest") + `' `
			link += "&ShippedDest=" + r.FormValue("ShippedDest")
		}
		if r.FormValue("TakenDoc") != "" {
			req += `AND "takenDoc" = '` + r.FormValue("TakenDoc") + `' `
			link += "&TakenDoc=" + r.FormValue("TakenDoc")
		}
		if r.FormValue("TakenOrder") != "" {
			req += `AND "takenOrder" = '` + r.FormValue("TakenOrder") + `' `
			link += "&TakenOrder=" + r.FormValue("TakenOrder")
		}
		if r.FormValue("CondDate") != "" {
			link += "&CondDate=" + r.FormValue("CondDate")
			date, err := time.Parse("02.01.2006", r.FormValue("CondDate"))
			if err == nil {
				req += `AND "condDate" = '` + date.Format("2006-01-02") + `' `
			}
		} else {
			if r.FormValue("CondDateFrom") != "" {
				req += ` AND "condDate" BETWEEN '` + r.FormValue("CondDateFrom")
				link += "&CondDateFrom=" + r.FormValue("CondDateFrom")
			} else {
				req += ` AND "condDate" BETWEEN '2000-01-01`

			}

			if r.FormValue("CondDateTo") != "" {
				req += `' AND '` + r.FormValue("CondDateTo") + `'`
				link += "&CondDateTo=" + r.FormValue("CondDateTo")
			} else {
				req += `' AND '2100-01-01'`

			}
		}

		if r.FormValue("ShipedDate") != "" {
			link += "&ShipedDate=" + r.FormValue("ShipedDate")
			date, err := time.Parse("02.01.2006", r.FormValue("ShipedDate"))
			if err == nil {
				req += `AND "shipedDate" = '` + date.Format("2006-01-02") + `' `
			}
		} else {
			if r.FormValue("ShipedDateFrom") != "" {
				req += ` AND "shipedDate" BETWEEN '` + r.FormValue("ShipedDateFrom")
				link += "&ShipedDateFrom=" + r.FormValue("ShipedDateFrom")
			} else {
				req += ` AND "shipedDate" BETWEEN '2000-01-01`

			}

			if r.FormValue("ShipedDateTo") != "" {
				req += `' AND '` + r.FormValue("ShipedDateTo") + `'`
				link += "&ShipedDateTo=" + r.FormValue("ShipedDateTo")
			} else {
				req += `' AND '2100-01-01'`

			}
		}

		if r.FormValue("TakenDate") != "" {
			link += "&TakenDate=" + r.FormValue("TakenDate")
			date, err := time.Parse("02.01.2006", r.FormValue("TakenDate"))
			if err == nil {
				req += `AND "takenDate" = '` + date.Format("2006-01-02") + `' `
			}
		} else {
			if r.FormValue("TakenDateFrom") != "" {
				req += ` AND "takenDate" BETWEEN '` + r.FormValue("TakenDateFrom")
				link += "&TakenDateFrom=" + r.FormValue("TakenDateFrom")
			} else {
				req += ` AND "takenDate" BETWEEN '2000-01-01`

			}

			if r.FormValue("TakenDateTo") != "" {
				req += `' AND '` + r.FormValue("TakenDateTo") + `'`
				link += "&TakenDateTo=" + r.FormValue("TakenDateTo")
			} else {
				req += `' AND '2100-01-01'`

			}
		}

		devices, err = a.Db.TakeCleanDeviceByRequest(a.ctx, req)
		if err != nil {
			fmt.Println(err)
		}
	} else if r.FormValue("Search") == "Raw" {
		rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM public.sns WHERE true`
		link = "?Search=Raw"
		if r.FormValue("Id") != "" {
			rawSelect += ` AND "snsId" = ` + r.FormValue("Id")
			link += "&Id=" + r.FormValue("Id")
		}
		if r.FormValue("TModel") != "" {
			rawSelect += ` AND tmodel = ` + r.FormValue("TModel")
			link += "&TModel=" + r.FormValue("TModel")
		}

		if r.FormValue("Sn") != "" {
			rawSelect += ` AND sn = '` + r.FormValue("Sn") + `'`
			link += "&Sn=" + r.FormValue("Sn")
		}

		if r.FormValue("Mac") != "" {
			rawSelect += ` AND mac = '` + r.FormValue("Mac") + `'`
			link += "&Mac=" + r.FormValue("Mac")
		}

		if r.FormValue("Order") != "" {
			rawSelect += ` AND "order" = ` + r.FormValue("Order")
			link += "&Order=" + r.FormValue("Order")
		}

		if r.FormValue("Place") != "" {
			rawSelect += ` AND place = ` + r.FormValue("Place")
			link += "&Place=" + r.FormValue("Place")
		}

		if r.FormValue("DModel") != "" {
			rawSelect += ` And dmodel = ` + r.FormValue("DModel")
			link += "&DModel=" + r.FormValue("DModel")
		}

		if r.FormValue("Rev") != "" {
			rawSelect += ` AND rev =  '` + r.FormValue("Rev") + `'`
			link += "&Rev=" + r.FormValue("Rev")
		}

		if r.FormValue("Name") != "" {
			rawSelect += ` AND name = '` + r.FormValue("Name") + `'`
			link += "&Name=" + r.FormValue("Name")
		}

		if r.FormValue("Condition") != "" {
			rawSelect += ` AND condition = ` + r.FormValue("Condition")
			link += "&Condition=" + r.FormValue("Condition")
		}

		if r.FormValue("CondDateFrom") != "" {
			rawSelect += ` AND "condDate" BETWEEN '` + r.FormValue("CondDateFrom")
			link += "&CondDateFrom=" + r.FormValue("CondDateFrom")
		} else {
			rawSelect += ` AND "condDate" BETWEEN '2000-01-01`
			link += "&CondDateFrom=2000-01-01"
		}

		if r.FormValue("CondDateTo") != "" {
			rawSelect += `' AND '` + r.FormValue("CondDateTo") + `'`
			link += "&CondDateTo=" + r.FormValue("CondDateTo")
		} else {
			rawSelect += `' AND '2100-01-01'`
			link += "&CondDateTo=2100-01-01"
		}

		if r.FormValue("Shiped") != "" {
			rawSelect += (` AND shiped = ` + r.FormValue("Shiped"))
			link += "&Shiped=" + r.FormValue("Shiped")
		}

		if r.FormValue("ShippedDest") != "" {
			rawSelect += ` AND "shippedDest" = '` + r.FormValue("ShippedDest") + `'`
			link += "&ShippedDest=" + r.FormValue("ShippedDest")
		}

		if r.FormValue("ShipedDateFrom") != "" {
			rawSelect += ` AND "shipedDate" BETWEEN '` + r.FormValue("ShipedDateFrom")
			link += "&ShipedDateFrom=" + r.FormValue("ShipedDateFrom")
		} else {
			rawSelect += ` AND "shipedDate" BETWEEN '2000-01-01`
			link += "&ShipedDateFrom=2000-01-01"
		}

		if r.FormValue("ShipedDateTo") != "" {
			rawSelect += `' AND '` + r.FormValue("ShipedDateTo") + `'`
			link += "&ShipedDateTo=" + r.FormValue("ShipedDateTo")
		} else {
			rawSelect += `' AND '2100-01-01'`
			link += "&ShipedDateTo=2100-01-01"
		}

		if r.FormValue("TakenDoc") != "" {
			rawSelect += ` AND "takenDoc" = '` + r.FormValue("TakenDoc") + `'`
			link += "&TakenDoc=" + r.FormValue("TakenDoc")
		}

		if r.FormValue("TakenOrder") != "" {
			rawSelect += ` AND "takenOrder" = '` + r.FormValue("TakenOrder") + `'`
			link += "&TakenOrder=" + r.FormValue("TakenOrder")
		}

		if r.FormValue("TakenDateFrom") != "" {
			rawSelect += ` AND "takenDate" BETWEEN '` + r.FormValue("TakenDateFrom")
			link += "&TakenDateFrom=" + r.FormValue("TakenDateFrom")
		} else {
			rawSelect += ` AND "takenDate" BETWEEN '2000-01-01`
			link += "&TakenDateFrom=2000-01-01"
		}

		if r.FormValue("TakenDateTo") != "" {
			rawSelect += `' AND '` + r.FormValue("TakenDateTo") + `'`
			link += "&TakenDateTo=" + r.FormValue("TakenDateTo")
		} else {
			rawSelect += `' AND '2100-01-01'`
			link += "&TakenDateTo=2100-01-01"
		}

		cleanSelect := `SELECT tmp."snsId", tmp.sn, tmp.mac, "dModels"."dModelName" AS dmodel, tmp.rev, "tModels"."tModelsName" AS tmodel, tmp.name, "condNames"."condName" AS condition, tmp."condDate", tmp."order", tmp.place, tmp.shiped, tmp."shipedDate", tmp."shippedDest", tmp."takenDate", tmp."takenDoc", tmp."takenOrder", snscomment.comment FROM (` + rawSelect + `)tmp LEFT JOIN "dModels" ON "dModels"."dModelsId" = tmp.dmodel LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.tmodel LEFT JOIN "condNames" ON "condNames"."condNamesId" = tmp.condition LEFT JOIN snscomment ON snscomment."snsId" = tmp."snsId"`

		devices, err = a.Db.TakeCleanDevice(a.ctx, cleanSelect)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	} else if r.FormValue("Search") == "Sns" {
		snString := r.FormValue("in")
		link = "?Search=Sns&in=" + r.FormValue("in")
		Sns := strings.Fields(snString)
		devices, err = a.Db.TakeCleanDeviceBySn(a.ctx, Sns...)
		if err != nil {
			fmt.Println(err)
		}
	} else if r.FormValue("Search") == "Anything" {
		link = "?Search=Anything&in=" + r.FormValue("in")
		snString := r.FormValue("in")
		Sns := strings.Split(snString, ";")
		devices, err = a.Db.TakeCleanDeviceByAnything(a.ctx, Sns...)
		if err != nil {
			fmt.Println(err)
		}
	}

	path, name, err := Filer.TMCExceller("http://"+a.AppIp+"/works/tmc"+link, devices...)
	fmt.Println(path)
	if err != nil {
		fmt.Println(err)
	}

	err = sendTMPFile(w, r, path, name)
	if err != nil {
		fmt.Println(err)
	}
}

func (a App) OrdersExcell(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var orders []mytypes.OrderClean
	var link string
	var err error

	if r.FormValue("Search") == "" {
		orders, err = a.Db.TakeCleanOrderByReqest(a.ctx, `WHERE "isAct" = true`)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	} else if r.FormValue("Search") == "Anything" {
		link = "?Search=Anything&in=" + r.FormValue("in")
		searchString := r.FormValue("in")
		searchs := strings.Split(searchString, ";")
		orders, err = a.Db.TakeCleanOrderByAnything(a.ctx, searchs...)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	} else if r.FormValue("Search") == "Raw" {
		link = "&Search=Raw&in=" + r.FormValue("in")
		id, err := strconv.Atoi(r.FormValue("in"))
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		orders, err = a.Db.TakeCleanOrderById(a.ctx, id)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	path, name, err := Filer.OrderExceller(*a.Db, a.AppIp, "http://"+a.AppIp+"/works/orders"+link, orders...)
	fmt.Println(path)
	if err != nil {
		fmt.Println(err)
	}

	err = sendTMPFile(w, r, path, name)
	if err != nil {
		fmt.Println(err)
	}
}

func (a App) OrdersShortExcell(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var orders []mytypes.OrderClean
	var link string
	var err error

	if r.FormValue("Search") == "" {
		orders, err = a.Db.TakeCleanOrderByReqest(a.ctx, `WHERE "isAct" = true`)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	} else if r.FormValue("Search") == "Anything" {
		link = "?Search=Anything&in=" + r.FormValue("in")
		searchString := r.FormValue("in")
		searchs := strings.Split(searchString, ";")
		orders, err = a.Db.TakeCleanOrderByAnything(a.ctx, searchs...)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	path, name, err := Filer.ShortOrdersExceller("http://"+a.AppIp+"/works/orders"+link, orders...)
	fmt.Println(path)
	if err != nil {
		fmt.Println(err)
	}

	err = sendTMPFile(w, r, path, name)
	if err != nil {
		fmt.Println(err)
	}
}

//////////////////////////

// Конструкторы страниц //

//////////////////////////

func MakeTMCPage(w http.ResponseWriter, devices []mytypes.DeviceClean, lable string, excellLink string) {

	type tmcPage struct {
		Lable      string
		Tab        []mytypes.DeviceClean
		SnString   string
		ExcellLink string
	}
	table := tmcPage{lable, devices, GetSnfromCleanDevices(devices...), excellLink}

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
	rows, err = a.Db.Db.Query(a.ctx, `SELECT "dModelsId", "dModelName" FROM public."dModels";`)
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
		dmodelList = append(dmodelList, choise)
	}

	var condList []idChoise
	rows, err = a.Db.Db.Query(a.ctx, `SELECT "condNamesId", "condName" FROM public."condNames";`)
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
		condList = append(condList, choise)
	}

	tmp := search{tmodelList, dmodelList, condList}

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

func MakeOrdersPage(w http.ResponseWriter, orders []mytypes.OrderClean, lable string, link string) {

	type ordersPage struct {
		Lable      string
		Tab        []mytypes.OrderClean
		ExcellLink string
	}
	table := ordersPage{lable, orders, link}

	t := template.Must(template.ParseFiles("Face/html/orders.html"))
	t.Execute(w, table)
}

func MakeOrderMiniPage(w http.ResponseWriter, order mytypes.OrderClean, orderList []mytypes.OrderListClean, reservs []mytypes.StorageByTModelClean, status []mytypes.OrderStatusClean, User mytypes.User) {
	type orderPage struct {
		Order   mytypes.OrderClean
		List    []mytypes.OrderListClean
		Reservs []mytypes.StorageByTModelClean
		Status  []mytypes.OrderStatusClean
		User    mytypes.User
	}

	page := orderPage{order, orderList, reservs, status, User}

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

func MakeImputTypePage(w http.ResponseWriter, postPath, title, typein, imputText, btnText string) {

	type imputPage struct {
		Title     string
		InputText string
		BtnText   string
		PostPath  string
		Type      string
	}

	tmp := imputPage{title, imputText, btnText, postPath, typein}

	t := template.Must(template.ParseFiles("Face/html/insert file.html"))
	t.Execute(w, tmp)
}

func MakeDobleImputPage(w http.ResponseWriter, postPath, title, imputText1, imputText2, type2, btnText string) {

	type imputPage struct {
		Title      string
		InputText1 string
		InputText2 string
		Type2      string
		BtnText    string
		PostPath   string
	}

	tmp := imputPage{title, imputText1, imputText2, type2, btnText, postPath}

	t := template.Must(template.ParseFiles("Face/html/dobleinsert.html"))
	t.Execute(w, tmp)
}

func MakeDobleImputTypePage(w http.ResponseWriter, postPath, title, imputText1, type1, imputText2, type2, btnText string) {

	type imputPage struct {
		Title      string
		InputText1 string
		Type1      string
		InputText2 string
		Type2      string
		BtnText    string
		PostPath   string
	}

	tmp := imputPage{title, imputText1, type1, imputText2, type2, btnText, postPath}

	t := template.Must(template.ParseFiles("Face/html/dobleInserttType.html"))
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

func (a App) MakeTakeDeviceByModelPage(w http.ResponseWriter) {
	type idChoise struct {
		Id   int
		Name string
	}
	type TakeForm struct {
		TModels []idChoise
		DModels []idChoise
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
	rows, err = a.Db.Db.Query(a.ctx, `SELECT "dModelsId", "dModelName" FROM public."dModels";`)
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
		dmodelList = append(dmodelList, choise)
	}

	tmp := TakeForm{tmodelList, dmodelList}
	t := template.Must(template.ParseFiles("Face/html/TakeDeviceByModel.html"))
	t.Execute(w, tmp)
}

func MakeCreateOrderPage(w http.ResponseWriter) {
	var page bool
	t := template.Must(template.ParseFiles("Face/html/CreateOrder.html"))
	t.Execute(w, page)
}

func (a App) MakeCreateOrderListPage(w http.ResponseWriter, ListId int, orderId int) {
	type idChoise struct {
		Id   int
		Name string
	}
	type TakeForm struct {
		List       []mytypes.OrderListClean
		TModels    []idChoise
		ListId     int
		OrderId    int
		RedElement mytypes.OrderListClean
	}

	OrderList, err := a.Db.TakeCleanOrderList(a.ctx, orderId)
	if err != nil {
		OrderList = []mytypes.OrderListClean{}
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

	var redElement mytypes.OrderListClean
	if ListId != -1 {
		for _, a := range OrderList {
			if a.Id == ListId {
				redElement = a
				s := strings.Split(redElement.ServActDate, ".")
				redElement.ServActDate = s[2] + "-" + s[1] + "-" + s[0]
			}
		}
	}
	tmp := TakeForm{OrderList, tmodelList, ListId, orderId, redElement}

	t := template.Must(template.ParseFiles("Face/html/CreateOrderList.html"))
	t.Execute(w, tmp)
}

func (a App) MakeUserPage(w http.ResponseWriter, user mytypes.User) {
	type Buton struct {
		Text template.HTML
		Url  string
	}
	type Block struct {
		Title string
		Btns  []Buton
	}
	type Page struct {
		Bl   []Block
		User mytypes.User
	}

	var Blocks []Block
	var block Block
	var btn Buton

	switch user.Acces {
	case 1:
		block = Block{}
		block.Title = "Склад"
		btn = Buton{`<i class="icon-table"></i>ТМЦ`, "/works/tmc"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-search"></i>Поиск в ТМЦ`, "/works/tmcadvancesearch"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-home-1"></i>Склад`, "/works/storage/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-search"></i>Поиск по Sn`, "/works/snsearch"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Маки"
		btn = Buton{`<i class="icon-cog"></i>Изменить MAC адрес`, "/works/changemac"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Выпуск"
		btn = Buton{`<i class="icon-industry"></i>Выпуск с производства`, "/works/releaseproduction"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-reply"></i>Вернуть на склад`, "/works/returntostorage"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Заказы"
		btn = Buton{`<i class="icon-briefcase"></i>Заказы`, "/works/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-calendar-plus-o"></i>Задать срок`, "/works/setpromdate"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "В работе"
		btn = Buton{`<i class="icon-table"></i>SN в работе`, "/works/tmc?Search=1&Condition=В работе"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-home-1"></i>Модели в работе`, "/works/storage/models?Search=1&Condition=3"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

	case 2:
		block = Block{}
		block.Title = "Склад"
		btn = Buton{`<i class="icon-table"></i>ТМЦ`, "/works/tmc"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-search"></i>Поиск в ТМЦ`, "/works/tmcadvancesearch"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-home-1"></i>Склад`, "/works/storage/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-search"></i>Поиск по Sn`, "/works/snsearch"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-pencil"></i>Коментарий по Sn`, "/works/addcommentbysn"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Приемка"
		btn = Buton{`<i class="icon-plus"></i>Приемка по моделям`, "/works/takedevicebymodel"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-file-excel"></i>Приемка файлом`, "/works/takedevicebyxlsx"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-forward"></i>Приемка демо`, "/works/takedemo"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Складская логистика"
		btn = Buton{`<i class="icon-industry"></i>Передать в производство`, "/works/towork"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-down-big"></i>Установить место`, "/works/setplace"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-cog"></i>Изменить № паллета`, "/works/cangeplacenum"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Заказы"
		btn = Buton{`<i class="icon-briefcase"></i>Заказы`, "/works/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-tag"></i>Назначить заказ/резерв`, "/works/setorder"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Отгрузки"
		btn = Buton{`<i class="icon-truck"></i>Отгрузка`, "/works/toship"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Материалы"
		btn = Buton{`Склад материалов`, "/works/storage/mats"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Сборки`, "/works/buildlist"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Добавить сборку`, "/works/makebuild"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Добавить материал`, "/works/createmat"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Принять материалы`, "/works/takemat"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Модели`, "/works/tmodels"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

	case 3:
		block = Block{}
		block.Title = "Заказы"
		btn = Buton{`<i class="icon-plus"></i>Создать заказ`, "/works/createorder"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-handshake-o"></i> Мои заказы`, "/works/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-briefcase"></i>Все заказы`, "/works/orders"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Склад"
		btn = Buton{`<i class="icon-table"></i>ТМЦ`, "/works/tmc"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-search"></i>Поиск в ТМЦ`, "/works/tmcadvancesearch"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="icon-home-1"></i>Склад`, "/works/storage/orders"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)
	default:
		block.Title = "Вас тут не ждали"
		btn = Buton{"Идите нахуй", "/works/Logout"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)
	}

	tmp := Page{Blocks, user}
	t := template.Must(template.ParseFiles("Face/html/prof.html"))
	t.Execute(w, tmp)
}

func MakeChangePassPage(w http.ResponseWriter, ans string, p1, p2, p3 string) {

	type page struct {
		Ans string
		P1  string
		P2  string
		P3  string
	}
	tmp := page{ans, p1, p2, p3}
	t := template.Must(template.ParseFiles("Face/html/ChangePass.html"))
	t.Execute(w, tmp)
}

func MakeCreateMatPage(w http.ResponseWriter) {
	var page bool
	t := template.Must(template.ParseFiles("Face/html/CreateMat.html"))
	t.Execute(w, page)
}

func (a App) MakeTakeMatPage(w http.ResponseWriter) {
	type TakeForm struct {
		NameList   []string
		NameList1C []string
	}
	var NameList []string
	var NameList1C []string
	var Name string

	rows, err := a.Db.Db.Query(a.ctx, `SELECT "name" FROM public."matsName" GROUP BY name ORDER BY name;`)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&Name)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		NameList = append(NameList, Name)
	}

	rows, err = a.Db.Db.Query(a.ctx, `SELECT "1CName" FROM public."mats" GROUP BY "1CName" ORDER BY "1CName";`)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&Name)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		NameList1C = append(NameList1C, Name)
	}

	tmp := TakeForm{NameList, NameList1C}
	t := template.Must(template.ParseFiles("Face/html/TakeMat.html"))
	t.Execute(w, tmp)
}

func (a App) MakeStorageMatsPage(w http.ResponseWriter) {
	Mats, err := a.Db.TakeMatsById(a.ctx)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	type storagePage struct {
		Lable string
		Mats  []mytypes.Mat
	}
	table := storagePage{"Материалы", Mats}

	t := template.Must(template.ParseFiles("Face/html/storage mats.html"))
	t.Execute(w, table)
}

func (a App) MakeStorageMatsByNamePage(w http.ResponseWriter) {
	Mats, err := a.Db.TakeAmoutMatsByName(a.ctx)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	type storagePage struct {
		Lable string
		Mats  []mytypes.Mat
	}
	table := storagePage{"Материалы", Mats}

	t := template.Must(template.ParseFiles("Face/html/storage matsbyname.html"))
	t.Execute(w, table)
}

func (a App) MakeStorageMatsBy1CPage(w http.ResponseWriter) {
	Mats, err := a.Db.TakeAmoutMatsBy1C(a.ctx)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	type storagePage struct {
		Lable string
		Mats  []mytypes.Mat
	}
	table := storagePage{"Материалы", Mats}

	t := template.Must(template.ParseFiles("Face/html/storage matsby1c.html"))
	t.Execute(w, table)
}

func (a App) MakeCreateBuildPage(w http.ResponseWriter) {
	type SelectList struct {
		Id   int
		Name string
	}
	type TakeForm struct {
		ModelListT    []string
		ModelListD    []string
		CaseList      []SelectList
		StikerList    []SelectList
		BoxList       []SelectList
		BoxholderList []SelectList
		AnotherList   []SelectList
	}
	var ModelListT []string
	var ModelListD []string
	var CaseList []SelectList
	var StikerList []SelectList
	var BoxList []SelectList
	var BoxholderList []SelectList
	var AnotherList []SelectList
	var Name string
	var choise SelectList

	rows, err := a.Db.Db.Query(a.ctx, `SELECT "tModelsName" FROM "tModels" ORDER BY "tModelsName"`)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&Name)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		ModelListT = append(ModelListT, Name)
	}

	rows, err = a.Db.Db.Query(a.ctx, `SELECT "dModelName" FROM "dModels" ORDER BY "dModelName"`)
	if err != nil {
		MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&Name)
		if err != nil {
			MakeAlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		ModelListD = append(ModelListD, Name)
	}

	rows, err = a.Db.Db.Query(a.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '1'`)
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
		CaseList = append(CaseList, choise)
	}

	rows, err = a.Db.Db.Query(a.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '2'`)
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
		StikerList = append(StikerList, choise)
	}

	rows, err = a.Db.Db.Query(a.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '3'`)
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
		BoxList = append(BoxList, choise)
	}

	rows, err = a.Db.Db.Query(a.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '4'`)
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
		BoxholderList = append(BoxholderList, choise)
	}

	rows, err = a.Db.Db.Query(a.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '7'`)
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
		AnotherList = append(AnotherList, choise)
	}

	tmp := TakeForm{ModelListT, ModelListD, CaseList, StikerList, BoxList, BoxholderList, AnotherList}
	t := template.Must(template.ParseFiles("Face/html/MakeBuild.html"))
	t.Execute(w, tmp)
}

func (a App) MakeBuildsPage(w http.ResponseWriter, builds []mytypes.BuildClean) {
	type BPage struct {
		Builds []mytypes.BuildClean
	}

	table := BPage{Builds: builds}
	t := template.Must(template.ParseFiles("Face/html/builds.html"))
	t.Execute(w, table)
}

func MakeTModelsPage(w http.ResponseWriter, TModels []mytypes.TModel) {
	type TModelPage struct {
		Tab []mytypes.TModel
	}
	table := TModelPage{Tab: TModels}

	t := template.Must(template.ParseFiles("Face/html/tmodels.html"))
	t.Execute(w, table)
}

func MakeTModelPage(w http.ResponseWriter, TModel mytypes.TModel, builds []mytypes.BuildClean) {
	type Page struct {
		Model  mytypes.TModel
		Builds []mytypes.BuildClean
	}

	tmp := Page{Model: TModel, Builds: builds}
	t := template.Must(template.ParseFiles("Face/html/tmodel.html"))
	t.Execute(w, tmp)
}
