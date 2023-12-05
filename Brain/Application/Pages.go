package Application

import (
	"T-Base/Brain/Auth"
	"T-Base/Brain/Filer"
	"log"

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
	a.Templ.UserPage(w, user)
}

// Таблица ТМЦ
func (a App) TMCPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var devices []mytypes.DeviceClean
	var link string
	var err error

	link = "?"
	if r.FormValue("Search") == "" {
		devices, err = a.Db.TakeCleanDeviceByRequest(a.Ctx, "LIMIT 1000")
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
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

		devices, err = a.Db.TakeCleanDeviceByRequest(a.Ctx, req)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		}
	} else if r.FormValue("Search") == "Raw" {
		rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM public.sns WHERE true`
		link += "Search=Raw"
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

		devices, err = a.Db.TakeCleanDevice(a.Ctx, cleanSelect)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	} else if r.FormValue("Search") == "Sns" {
		snString := r.FormValue("in")
		link += "Search=Sns&in=" + r.FormValue("in")
		Sns := strings.Fields(snString)
		devices, err = a.Db.TakeCleanDeviceBySn(a.Ctx, Sns...)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		}
	} else if r.FormValue("Search") == "Anything" {
		link += "Search=Anything&in=" + r.FormValue("in")
		snString := r.FormValue("in")
		Sns := strings.Split(snString, ";")
		devices, err = a.Db.TakeCleanDeviceByAnything(a.Ctx, Sns...)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		}
	}
	if r.FormValue("Veiw") == "table" {
		a.Templ.TableTMCPage(w, devices, GetSnfromCleanDevices(devices...), "ТМЦ показанно устройств: "+strconv.Itoa(len(devices)), link)
	} else {
		a.Templ.TMCPage(w, devices, GetSnfromCleanDevices(devices...), "ТМЦ показанно устройств: "+strconv.Itoa(len(devices)), link)
	}
}

func (a App) TMCDemoPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var devices []mytypes.DeviceClean
	var err error

	devices, err = a.Db.TakeCleanDeviceByRequest(a.Ctx, ` WHERE "cleanSns"."order" = 3 Limit 1000`)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.TMCDemoPage(w, devices, GetSnfromCleanDevices(devices...), "ДЕМО показанно устройств: "+strconv.Itoa(len(devices)))

}

func (a App) TMCSearchPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.TMCAdvanceSearchPage(w)
}

// Компактное представление устройства
func (a App) DeviceMiniPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	var device mytypes.DeviceClean

	if r.FormValue("Id") == "nil" {
		devices, err := a.Db.TakeCleanDeviceByRequest(a.Ctx, " Limit 1")
		if err != nil {
			fmt.Fprintln(w, err)
			return
		}
		device = devices[0]
	} else {

		Id, err := strconv.Atoi(r.FormValue("Id"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Устройство не найдено", "ID должно быть числом", "Главная", "/works/prof")
			return
		}
		devices, err := a.Db.TakeCleanDeviceById(a.Ctx, Id)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Устройство не найдено", err.Error(), "Главная", "/works/prof")
			return
		}
		device = devices[0]
	}

	events, err := a.Db.TakeCleanDeviceEvent(a.Ctx, device.Id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска событий устройства", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.DeviceMiniPage(w, device, events)
}

// Тестовая страница ввода серийных номеров
func (a App) SnSearchPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.ImputPage(w, "/works/tmc", "Поиск по Sn", "Введите серийные номера", "Поиск")
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

		storage, err := a.Db.TakeStorageCount(a.Ctx, qq)

		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}

		a.Templ.StoragePage(w, storage, "Склад поиск: "+in)

	} else {
		storage, err := a.Db.TakeStorageCount(a.Ctx, "")
		if err != nil {
			if err != nil {
				a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
				return
			}
		}
		a.Templ.StoragePage(w, storage, "Склад заказы")
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

		storage, err := a.Db.TakeStorageCountByPlace(a.Ctx, qq)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		a.Templ.StorageByPlacePage(w, storage, "Склад места поиск: "+in)
	} else {

		storage, err := a.Db.TakeStorageCountByPlace(a.Ctx, "")
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}

		a.Templ.StorageByPlacePage(w, storage, "Склад места")
	}
}

// Страница склада по моделям
func (a App) StorageByTModelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if r.FormValue("Search") != "" {
		if r.FormValue("Condition") != "" {

			_, err := strconv.Atoi(r.FormValue("Condition"))
			if err != nil {
				qq := `SELECT tmodel, name, condition, count, shiped FROM public."cleanWearByTModel" Where condition = '` + r.FormValue("Condition") + `'`
				storage, err := a.Db.TakeStorageByTModelClean(a.Ctx, qq)
				if err != nil {
					a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
					return
				}
				a.Templ.StorageByTModelPage(w, storage, "Склад модели "+r.FormValue("Condition"))
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

			storage, err := a.Db.TakeStorageByTModelClean(a.Ctx, qq)
			if err != nil {
				a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
				return
			}
			a.Templ.StorageByTModelPage(w, storage, "Склад модели")
			return

		} else {
			in := r.FormValue("in")
			in = strings.TrimSpace(in)
			qq := `SELECT tmodel, name, condition, count, shiped FROM public."cleanWearByTModel" Where tmodel LIKE '%` + in + `%' OR name LIKE '%` + in + `%' `

			storage, err := a.Db.TakeStorageByTModelClean(a.Ctx, qq)
			if err != nil {
				a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
				return
			}
			a.Templ.StorageByTModelPage(w, storage, "Склад модели поиск: "+in)
		}
	} else {
		storage, err := a.Db.TakeStorageByTModelClean(a.Ctx, "")
		if err != nil {
			log.Println(err)
			return
		}

		a.Templ.StorageByTModelPage(w, storage, "Склад модели")
	}
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

// Страница передачи в производство
func (a App) ToWorkPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "/works/towork", "Передать в производство", "Введите серийные номера для передачи", "Передать")
}

// Страница назначения резерва
func (a App) SetOrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.DobleImputPage(w, "/works/setorder", "Назначить заказ/резерв", "Введите серийные номера:", "Номер заказа", "number", "Назначить заказ")
}

// Страница установки места
func (a App) SetPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.DobleImputPage(w, "/works/setplace", "Установить место", "Введите серийные номера:", "Номер места", "number", "Установить место")
}

// Страница приемки демо
func (a App) TakeDemoPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "", "Приемка демо", "Введите серийные номера", "Принять")
}

// Страница отгрузки
func (a App) ToShipPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.DobleImputPage(w, "", "Отгрузка", "Введите серийные номера", "Место отгрузки", "text", "Отгрузить")
}

// Страница изменения номера паллета
func (a App) ChangeNumPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.DobleImputTypePage(w, "/works/cangeplacenum", "Установить номер места", "Введите старый номер:", "number", "Введите новый номер", "number", "Изменить")
}

// Страница приемки помодельно
func (a App) TakeDeviceByModelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.TakeDeviceByModelPage(w)
}

// Страница создания заказа
func (a App) CreateOrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateOrderPage(w)
}

// Страница изменения мак адреса устройства
func (a App) ChangeMACPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "", "Изменить маки", "Введите последовательно серийный номер и мак для каждого устройства", "Изменить")
}

// Страница выпуска устройств с производства
func (a App) ReleaseProductionPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "/works/releaseproductionacept", "Выпуск с производства", "Введите серийные номера", "Выпуск")
}

// Страница возврата не собраных устройств на производство
func (a App) ReturnToStoragePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "", "Вернуть на склад", "Введите серийные номера через пробез или с новой стрроки", "Вернуть")
}

// Страница установки обещаной даты выхода заказа с производства
func (a App) SetPromDatePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.DobleImputTypePage(w, "", "Задать дату", "Введите ID заказа "+r.FormValue("Order"), "number", "Введите дату готовности", "date", "Задать дату")
}

// Страница смены пароля
func (a App) ChangePassPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.ChangePassPage(w, "", "", "", "")
}

// Страница добавления комментария по серийным номерам
func (a App) AddCommentToSnsBySnPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.DobleImputPage(w, "/works/addcommentbysn", "Дополнить комментарии", "Серийные номера", "Коментарий", "text", "Добавить коментарий")
}

// Страница приемка файлом
func (a App) TakeDeviceByExcelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputTypePage(w, "", "Приемка файлом", "file", "Выберете файл", "Отправить")
}

// Страница добавления материала
func (a App) CreateMatPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateMatPage(w)
}

// Страница приемки материала
func (a App) TakeMatPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	a.Templ.TakeMatPage(w)
}

// Страница склада материалов
func (a App) StorageMatsPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.StorageMatsPage(w, user)
}

// Страница склада материалов по имени
func (a App) StorageMatsByNamePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.StorageMatsByNamePage(w)
}

// Страница склада материалов по 1С
func (a App) StorageMatsBy1CPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.StorageMatsBy1CPage(w)
}

// Страница создания сборки
func (a App) CreateBuildPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateBuildPage(w)
}

// Страница сборок
func (a App) BuildsPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	Builds, err := a.Db.TakeCleanBuildByTModel(a.Ctx)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения сборок", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.BuildsPage(w, Builds)
}

// Страница моделей Т-КОМ
func (a App) TModelsPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	models, err := a.Db.TakeTModelsById(a.Ctx)

	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения моделей", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.TModelsPage(w, models)
}

// Страница моделей поставщиков
func (a App) DModelsPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	models, err := a.Db.TakeDModelsById(a.Ctx)

	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения моделей", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.DModelsPage(w, models)
}

// Страница модели Т-КОМ
func (a App) TModelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка преобразования ID", err.Error(), "Главная", "/works/prof")
		return
	}

	model, err := a.Db.TakeTModelsById(a.Ctx, id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения модели", err.Error(), "Главная", "/works/prof")
		return
	}

	builds, err := a.Db.TakeCleanBuildByTModel(a.Ctx, id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения сборок", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.TModelPage(w, model[0], builds)
}

// Страница модели поставщика
func (a App) DModelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	id, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка преобразования ID", err.Error(), "Главная", "/works/prof")
		return
	}

	model, err := a.Db.TakeDModelsById(a.Ctx, id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения модели", err.Error(), "Главная", "/works/prof")
		return
	}

	builds, err := a.Db.TakeCleanBuildByDModel(a.Ctx, id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения сборок", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.DModelPage(w, model[0], builds)
}

// Страница списка материалов в работе
func (a App) StorageMatsInWorkPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.StorageMatsInWorkPage(w)
}

// Страница подтверждения сборок
func (a App) BuildAceptPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	inSn := strings.Fields(r.FormValue("in"))

	if len(inSn) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	devices, err := a.Db.TakeDeviceBySn(a.Ctx, inSn...)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска устройств", err.Error(), "Главная", "/works/prof")
		return
	}

	if len(devices) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Устройства не найдены", "", "Главная", "/works/prof")
		return
	}

	if mytypes.ChekInWork(devices...) {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Часть устройств не было передано в работу", "", "Главная", "/works/prof")
		return
	}

	dmodeCount := mytypes.CountByDModel(devices...)

	var buildsClean []mytypes.BuildClean
	var buildsRaw []mytypes.Build
	for model, count := range dmodeCount {
		var buildId int
		err := a.Db.Db.QueryRow(a.Ctx, `Select build FROM public."dModels" WHERE "dModelsId" = $1`, model).Scan(&buildId)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения номера сборки", err.Error(), "Главная", "/works/prof")
			return
		}
		buildClean, err := a.Db.TakeCleanBuildById(a.Ctx, buildId)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения сборки", err.Error(), "Главная", "/works/prof")
			return
		}
		for i := range buildClean.BuildList {
			buildClean.BuildList[i].Amout = buildClean.BuildList[i].Amout * count
		}
		buildRaw, err := a.Db.TakeBuildById(a.Ctx, buildId)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения сборки", err.Error(), "Главная", "/works/prof")
			return
		}
		for i := range buildRaw.BuildList {
			buildRaw.BuildList[i].Amout = buildRaw.BuildList[i].Amout * count
		}
		buildsRaw = append(buildsRaw, buildRaw)
		buildsClean = append(buildsClean, buildClean)
	}

	matInWork := make(map[int]int)
	rows, err := a.Db.Db.Query(a.Ctx, `SELECT name, SUM("inWork") FROM public.mats GROUP BY name`)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска материалов", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		var name int
		var inWork int
		err := rows.Scan(&name, &inWork)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска материалов", err.Error(), "Главная", "/works/prof")
			return
		}
		matInWork[name] = inWork
	}

	for _, build := range buildsRaw {
		for _, element := range build.BuildList {
			matInWork[element.MatId] = matInWork[element.MatId] - element.Amout
			if matInWork[element.MatId] < 0 {
				a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Недостаточно материалов", "", "Главная", "/works/prof")
				return
			}
		}
	}

	a.Templ.BuildAceptPage(w, buildsClean, inSn...)
}

// Страница истории материала
func (a App) MatEventPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if r.FormValue("Id") != "" {
		id, err := strconv.Atoi(r.FormValue("Id"))
		name := r.FormValue("Name")
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка преобразования ID", err.Error(), "Главная", "/works/prof")
			return
		}
		events, err := a.Db.TakeCleanMatLog(a.Ctx, id)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения событий", err.Error(), "Главная", "/works/prof")
			return
		}
		a.Templ.MatEventPage(w, events, name)
	} else {
		name := r.FormValue("Name")
		events, err := a.Db.TakeCleanMatLog(a.Ctx)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения событий", err.Error(), "Главная", "/works/prof")
			return
		}
		a.Templ.MatEventPage(w, events, name)
	}
}

// Календарь с событиями
func (a App) CalendearPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if a.Db.ChekTaks(a.Ctx) != nil {
		log.Println(a.Db.ChekTaks(a.Ctx).Error())
	}
	var tasks []mytypes.TaskJs
	var err error
	if user.Acces == 1 {
		tasks, err = a.Db.TakeJsTaskByReqest(a.Ctx, "WHERE complete = false ORDER BY dateend")
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	}
	if r.FormValue("look") == "List" {
		a.Templ.CalendarListPage(w, tasks)
		return
	} else if r.FormValue("look") == "Cal" {
		a.Templ.CalendarPage(w, tasks)
		return
	}
	a.Templ.CalendarPage(w, tasks)
}

// Страница создания события
func (a App) CreateTaskPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateTaskPage(w)
}

// Страница карточек событий
func (a App) TasksPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Db.ChekTaks(a.Ctx)
	tasks, err := a.Db.TakeCleanTasksById(a.Ctx)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения задач", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.TasksPage(w, tasks)
}

// Страница редактирования событий
func (a App) ChangeTaskPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	taskId := r.FormValue("Id")
	a.Templ.ChangeTaskPage(w, taskId)
}

// Страница соытия
func (a App) TaskPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	taskId, err := strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не верно задано Id задачи", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.TaskPage(w, taskId)
}

// Страница отчета о планировании
func (a App) PlanProdStoragePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.PlanProdStoragePage(w)
}

func (a App) PlanReProdStoragePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.PlanReProdStoragePage(w)
}

func (a App) PlanMatProdStoragePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.PlanMatProdStoragePage(w)
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
	SnsId := r.FormValue("SnsId")
	if user.Acces != 3 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateReservPage(w, SnsId)
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

// передача в работу
func (a App) ToWork(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	snString := r.FormValue("in")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnToWork(a.Ctx, Sns...)
	logCount := a.Db.AddDeviceEventBySn(a.Ctx, 2, "Передано в работу", user.UserId, Sns...)
	if logCount != count {
		log.Println("Ошибка записи логов")
	}
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		a.Templ.AlertPage(w, 5, "Предупреждение", "Не передано", "Устройства не были переданы в работу", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Передано "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		a.Templ.AlertPage(w, 1, "Готово", "Передано", "Все устройства переданы в работу", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Передано "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		a.Templ.AlertPage(w, 2, "Готово", "Частично", "Часть устройств не передана в работу", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Передано "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

// установка заказа
func (a App) SetOrder(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	snString := r.FormValue("in1")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	order, err := strconv.Atoi(r.FormValue("in2"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "В поле заказ введено не число", err.Error(), "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnSetOrder(a.Ctx, order, Sns...)
	logCount := a.Db.AddDeviceEventBySn(a.Ctx, 3, "Установлен заказ "+strconv.Itoa(order), user.UserId, Sns...)
	if logCount != count {
		log.Println("Ошибка записи логов")
	}

	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		a.Templ.AlertPage(w, 5, "Предупреждение", "Не назначено", "Устройствам не был назначен заказ", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		a.Templ.AlertPage(w, 1, "Готово", "Назначено", "Всем устройствам был назначен заказ", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		a.Templ.AlertPage(w, 2, "Готово", "Частично", "Части устройств не был назначен заказ", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

// установка места
func (a App) SetPlace(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	snString := r.FormValue("in1")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	place, err := strconv.Atoi(r.FormValue("in2"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "В поле место введено не число", err.Error(), "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnSetPlace(a.Ctx, place, Sns...)
	logCount := a.Db.AddDeviceEventBySn(a.Ctx, 6, "Установлено место "+strconv.Itoa(place), user.UserId, Sns...)
	if logCount != count {
		log.Println("Ошибка записи логов")
	}
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		a.Templ.AlertPage(w, 5, "Предупреждение", "Не назначено", "Устройствам не было назначено место", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		a.Templ.AlertPage(w, 1, "Готово", "Назначено", "Всем устройствам было назначено место", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		a.Templ.AlertPage(w, 2, "Готово", "Частично", "Части устройств не было назначено место", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

// приемка демо
func (a App) TakeDemo(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	snString := r.FormValue("in")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnTakeDemo(a.Ctx, Sns...)
	logCount := a.Db.AddDeviceEventBySn(a.Ctx, 1, "Принято демо", user.UserId, Sns...)
	if logCount != count {
		log.Println("Ошибка записи логов")
	}
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		a.Templ.AlertPage(w, 5, "Предупреждение", "Не передано", "Устройства приняты", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Принято "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		a.Templ.AlertPage(w, 1, "Готово", "Принято", "Все устройства приняты", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Принято "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		a.Templ.AlertPage(w, 2, "Готово", "Частично", "Часть устройств не принята", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Принято "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

// отгрузка
func (a App) ToShip(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	snString := r.FormValue("in1")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	count, err := a.Db.SnToShip(a.Ctx, r.FormValue("in2"), Sns...)
	logCount := a.Db.AddDeviceEventBySn(a.Ctx, 5, "Отгрузка "+r.FormValue("in2"), user.UserId, Sns...)
	if logCount != count {
		log.Println("Ошибка записи логов")
	}
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	if count == 0 {
		a.Templ.AlertPage(w, 5, "Предупреждение", "Не передано", "Устройства отгружены", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Отгружено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		a.Templ.AlertPage(w, 1, "Готово", "Отгружено", "Все устройства отгружены", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Отгружено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		a.Templ.AlertPage(w, 2, "Готово", "Частично", "Часть устройств не отгружена", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Отгружено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
}

// изменение номера паллета
func (a App) ChangeNumPlace(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	old, err := strconv.Atoi(r.FormValue("in1"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	new, err := strconv.Atoi(r.FormValue("in2"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.ChangeNumPlace(a.Ctx, old, new)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Готово", "Измененно", "Номер паллета успешно изменен", "Старый номер "+strconv.Itoa(old)+" ->	Новый "+strconv.Itoa(new), "Главная", "/works/prof")
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

	err = a.Db.AddCommentToSns(a.Ctx, id, text, user)
	if err != nil {
		log.Println(err)
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
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	text := r.FormValue("in2")

	devices, err := a.Db.TakeDeviceBySn(a.Ctx, Sns...)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска устройств", "", "Главная", "/works/prof")
	}
	var count int
	for _, device := range devices {
		if a.Db.AddCommentToSns(a.Ctx, device.Id, text, user) == nil {
			count++
		}
	}

	if count == 0 {
		a.Templ.AlertPage(w, 5, "Предупреждение", "Не назначено", "Устройствам не было назначен коментарий", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count == 0 {
		a.Templ.AlertPage(w, 1, "Готово", "Назначено", "Всем устройствам было назначен коментарий", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(Sns)-count > 0 {
		a.Templ.AlertPage(w, 2, "Готово", "Частично", "Части устройств не было назначен коментарий", "Внесено "+strconv.Itoa(len(Sns))+" серийных номеров	Назначено "+strconv.Itoa(count)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденая ошибка", "", "Главная", "/works/prof")
}

// приемка по модельно
func (a App) TakeDeviceByModel(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	var DModel int
	DModelIn := r.FormValue("DModel")
	err := a.Db.Db.QueryRow(a.Ctx, `SELECT "dModelsId" FROM "dModels" WHERE "dModelName" = $1`, DModelIn).Scan(&DModel)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Не указана модель", "Укажите модель поставщика", err.Error(), "Главная", "/works/prof")
		return
	}
	Name := DModelIn

	var TModel int
	TModelIn := r.FormValue("TModel")
	err = a.Db.Db.QueryRow(a.Ctx, `SELECT "tModelsId" FROM "tModels" WHERE "tModelName" = $1`, TModelIn).Scan(&TModel)
	if err != nil {
		TModel = 0
	}

	Rev := r.FormValue("Rev")
	Place, err := strconv.Atoi(r.FormValue("Place"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Не указано место", "Укажите место", err.Error(), "Главная", "/works/prof")
		return
	}
	Doc := r.FormValue("Doc")
	Order := r.FormValue("Order")

	snString := r.FormValue("Sn")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	i, SnErr, err := a.Db.InsetDeviceByModel(a.Ctx, DModel, Name, TModel, Rev, Place, Doc, Order, Sns...)

	if err != nil {
		errString := ""
		for _, a := range SnErr {
			errString += a + "\n"
		}
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка внесения усройств", "Было внесено "+strconv.Itoa(i)+" из "+strconv.Itoa(len(Sns)), errString, "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Все устройства внесены", "Отличная работа", "Главная", "/works/prof")
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

// Изменение мак адреса устройства
func (a App) ChangeMAC(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	in := strings.Fields(r.FormValue("in"))
	if len(in)%2 == 1 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Серийников больше чем маков", "(или наоборот)", "Главная", "/works/prof")
	}

	var count int
	for i := 0; i < len(in); i = i + 2 {
		_, err := a.Db.ChangeMAC(a.Ctx, in[i], in[i+1])
		logCount := a.Db.AddDeviceEventBySn(a.Ctx, 6, "Установлен mac "+in[i+1], user.UserId, in[i])
		if logCount != 1 {
			log.Println("Ошибка записи логов")
		}
		if err != nil {
			a.Templ.AlertPage(w, 2, "Ошибка", "Частично", "Изменнено только часть MAC", "Изменены "+strconv.Itoa(count)+" устройств, до "+in[i], "Главная", "/works/prof")
		}
		count++
	}
	a.Templ.AlertPage(w, 1, "Успешно", "Успешно", "Изменено "+strconv.Itoa(count)+" устройств", "", "Главная", "/works/prof")
}

// Выпуск устройств с производства
func (a App) ReleaseProduction(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	in := strings.Fields(r.FormValue("inSn"))

	if len(in) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не внесены серийные номера", "", "Главная", "/works/prof")
		return
	}

	var counter int
	matList := make(map[int]int)
	for _, sn := range in {
		// Преобразование устройства
		build, tmodel, matToProdus, err := a.Db.ReleaseProduction(a.Ctx, sn)
		if err != nil {
			if err.Error() == "не девайс" {
				continue
			}
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось выпустить устройство с производства", err.Error(), "Главная", "/works/prof")
			return
		}
		counter++

		taskId, taskElId, err := a.Db.TakeRelevantTaskByTModel(a.Ctx, tmodel)
		if err != nil {
			if err.Error() != "no rows in result set" {
				a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска задачи", err.Error(), "Главная", "/works/prof")
			}
			taskId = -1
		}
		if taskId != -1 {
			err = a.Db.ProdToTask(a.Ctx, taskId, taskElId)
			if err != nil {
				a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка обновления задачи", err.Error(), "Главная", "/works/prof")

			}
		}
		logstr := "Выпуск по сборке №" + strconv.Itoa(build)
		if taskId != -1 {
			logstr += " для задачи №" + strconv.Itoa(taskId)
		}

		// Запись лога устройства
		log := a.Db.AddDeviceEventBySn(a.Ctx, 4, logstr, user.UserId, sn)
		if log != 1 {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка записи логов", "", "Главная", "/works/prof")

		}

		// Добавляем материалы для этого устройства в облий лист списаия
		for i, a := range matToProdus {
			matList[i] += a
		}

	}
	for matId, amout := range matList {
		err := a.Db.AddMatLog(a.Ctx, matId, amout, 4, "Преобразование", user.UserId)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка записи логов материала", "", "Главная", "/works/prof")

		}
	}

	a.Templ.AlertPage(w, 1, "Успешно", "Успешно", "Преобразовано "+strconv.Itoa(counter)+" устройств", "", "Главная", "/works/prof")
}

// Вернуть не собраные устройства на склад
func (a App) ReturnToStorage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	in := strings.Fields(r.FormValue("in"))

	if len(in) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	counter := a.Db.ReturnToStorage(a.Ctx, in...)
	logCount := a.Db.AddDeviceEventBySn(a.Ctx, 9, "Возврат", user.UserId, in...)
	if logCount != counter {
		log.Println("Ошибка записи логов")
	}

	if counter == 0 {
		a.Templ.AlertPage(w, 5, "Предупреждение", "Не передано", "Устройства не переданы", "Внесено "+strconv.Itoa(len(in))+" серийных номеров	Преобразовано "+strconv.Itoa(counter)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(in)-counter == 0 {
		a.Templ.AlertPage(w, 1, "Готово", "Передано", "Все устройства переданы", "Внесено "+strconv.Itoa(len(in))+" серийных номеров	Преобразовано "+strconv.Itoa(counter)+"  серийных номеров", "Главная", "/works/prof")
		return
	} else if len(in)-counter > 0 {
		a.Templ.AlertPage(w, 2, "Готово", "Частично", "Часть устройств не передона", "Внесено "+strconv.Itoa(len(in))+" серийных номеров	Преобразовано "+strconv.Itoa(counter)+"  серийных номеров", "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", "", "Главная", "/works/prof")
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

func (a App) TakeDeviceByExcel(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	src, hdr, err := r.FormFile("in")
	if err != nil {
		if err.Error() == "http: no such file" {
			sendFile(w, r, "Files/Templ/Приемка файлом шаблон.xlsx", "Приемка файлом шаблон.xlsx")
			return
		}

		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка получения", err.Error(), "Главная", "/works/prof")
		return
	}
	defer src.Close()

	f, name, err := takeFile(src, hdr, user)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка записи", err.Error(), "Главная", "/works/prof")
		return
	}
	f.Close()

	devices, err, litleErr := Filer.ReadNewDevice(f.Name(), *a.Db)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка чтения", err.Error(), "Главная", "/works/prof")
		return
	}
	insertCount, err := a.Db.InsertDivice(a.Ctx, devices...)
	if litleErr {
		err := sendFile(w, r, f.Name(), name)
		if err != nil {
			fmt.Fprintln(w, err)
		}
	}
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка внесения", err.Error(), "Главная", "/works/prof")
		return
	}

	if insertCount == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Устройства небыли приняты", err.Error(), "Главная", "/works/prof")
		return
	} else if insertCount < len(devices) {
		a.Templ.AlertPage(w, 2, "Готово", "Частично", "Часть устройств не было принято", "Внесено "+strconv.Itoa(insertCount), "Главная", "/works/prof")
		return
	} else if insertCount > len(devices) {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Все "+strconv.Itoa(insertCount)+" устройств внесены", "Отличная работа", "Главная", "/works/prof")
}

// Создание новых материалов
func (a App) CreateMat(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	name := r.FormValue("Name")
	matType, err := strconv.Atoi(r.FormValue("Type"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка получения", err.Error(), "Главная", "/works/prof")
		return
	}
	err = a.Db.InsertMat(a.Ctx, name, matType)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка внесения", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Успешно", "Отличная работа", "Главная", "/works/prof")
}

// Приемка метериалов
func (a App) TakeMat(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	name := r.FormValue("Name")
	name1c := r.FormValue("Name1C")
	amout, err := strconv.Atoi(r.FormValue("Amout"))

	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка получения", err.Error(), "Главная", "/works/prof")
		return
	}
	if amout < 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Нельзя принять отрицательное число материала", "Это называется списание", "Главная", "/works/prof")
		return
	}

	price, err := strconv.Atoi(r.FormValue("Price"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка получения", err.Error(), "Главная", "/works/prof")
		return
	}
	if price < 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Цена не может быть отрицательной", "Это называется списание", "Главная", "/works/prof")
		return
	}
	place, err := strconv.Atoi(r.FormValue("Place"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная получения места", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.AddMat(a.Ctx, name, name1c, price, amout, place)
	if err != nil {
		if err.Error() == "критическая ошибка" {
			a.Templ.AlertPage(w, 5, "Ошибка", "КРИТИЧЕСКАЯ ОШИБКА !!!", "ОБРАТИТЕСЬ К АДМИНЕСТРАТОРУ ДЛЯ ВНЕСЕНИЯ ИСПРАВЛЕНИЙ", err.Error(), "Главная", "/works/prof")
		} else {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка внесения", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Успешно", "Отличная работа", "Главная", "/works/prof")
}

// Создание сборки
func (a App) MakeBuild(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	var build mytypes.Build
	dModelstr := r.FormValue("DModel")
	tModelstr := r.FormValue("TModel")

	err := a.Db.Db.QueryRow(a.Ctx, `SELECT "dModelsId" FROM public."dModels" WHERE "dModelName" = $1`, dModelstr).Scan(&build.DModel)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", "", "Главная", "/works/prof")
		return
	}

	err = a.Db.Db.QueryRow(a.Ctx, `SELECT "tModelsId" FROM public."tModels" WHERE "tModelsName" = $1`, tModelstr).Scan(&build.TModel)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", "", "Главная", "/works/prof")
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
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка 1", "", "Главная", "/works/prof")
			return
		}
		tmp = r.FormValue(point.Amout)

		if tmp == "" {
			continue
		}
		elAmout, err := strconv.Atoi(tmp)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка 2", "", "Главная", "/works/prof")
			return
		}
		if elId != -1 && elAmout > 0 {
			element := mytypes.BuildListElement{MatId: elId, Amout: elAmout}
			build.BuildList = append(build.BuildList, element)
		}
	}

	count, err := a.Db.InsertBuild(a.Ctx, build)
	if count != 1 || err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка заведения", strconv.Itoa(count)+err.Error(), "Главная", "/works/prof")
	}

	a.Templ.AlertPage(w, 1, "Успешно", "Успешно", "Сборка создана", "не забудьте что сборку нужно указывать в параметрах модели", "Главная", "/works/prof")
}

// изменить стандартную сборку для модели
func (a App) ChangeDefBuild(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	dModel, err := strconv.Atoi(r.FormValue("DModel"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	newBuild, err := strconv.Atoi(r.FormValue("NewBuild"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.ChangeDefBuild(a.Ctx, dModel, newBuild)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	http.Redirect(w, r, "/works/dmodel?Id="+strconv.Itoa(dModel), http.StatusSeeOther)
}

// передать материал в работу
func (a App) MatToWork(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	matId, err := strconv.Atoi(r.FormValue("toworkid"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	toWorkAmout, err := strconv.Atoi(r.FormValue("toworkamout"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.AddMatToWork(a.Ctx, matId, toWorkAmout)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка передачи материала", err.Error(), "Главная", "/works/prof")
		return
	}
	err = a.Db.AddMatLog(a.Ctx, matId, toWorkAmout, 2, "Предано в производство", user.UserId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка записи логов", err.Error(), "Главная", "/works/prof")
		return
	}
	http.Redirect(w, r, "/works/storage/mats", http.StatusSeeOther)
}

// передать материал из работы
func (a App) MatFromWork(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	matId, err := strconv.Atoi(r.FormValue("toworkid"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	fromWorkAmout, err := strconv.Atoi(r.FormValue("toworkamout"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.RemuveMatFromWork(a.Ctx, matId, fromWorkAmout)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка передачи материала", err.Error(), "Главная", "/works/prof")
		return
	}
	err = a.Db.AddMatLog(a.Ctx, matId, fromWorkAmout, 2, "Возвращено на склад", user.UserId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка записи логов", err.Error(), "Главная", "/works/prof")
		return
	}
	http.Redirect(w, r, "/works/matsinwork", http.StatusSeeOther)
}

// создать событие
func (a App) CreateTask(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var task mytypes.Task
	task.Autor = user.UserId
	task.Name = r.FormValue("Name")
	task.Description = r.FormValue("Description")
	task.Color = r.FormValue("Color")
	var err error
	task.Priority, err = strconv.Atoi(r.FormValue("Priority"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания приоритета", err.Error(), "Главная", "/works/prof")
		return
	}
	task.DateStart, err = time.Parse("2006-01-02", r.FormValue("Start"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания даты начала", err.Error(), "Главная", "/works/prof")
		return
	}
	task.DateEnd, err = time.Parse("2006-01-02", r.FormValue("End"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания даты окончания", err.Error(), "Главная", "/works/prof")
		return
	}
	task.Complete = false

	err = a.Db.InsertTask(a.Ctx, task)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка создания задачи", err.Error(), "Главная", "/works/prof")
		return
	}

	http.Redirect(w, r, "/works/tasks", http.StatusSeeOther)
}

// создать задачи события
func (a App) CreateTaskListPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	TaskId, err := strconv.Atoi(r.FormValue("TaskId"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения номера задачи", err.Error(), "Главная", "/works/prof")
	}

	if r.FormValue("Action") == "Open" {
		a.Templ.CreateTaskListPage(w, TaskId, -1)
	} else if r.FormValue("Action") == "Create" {
		var taskElement mytypes.TaskWorkList
		var err error
		taskElement.TModel, err = strconv.Atoi(r.FormValue("TModel"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения модели", err.Error(), "Главная", "/works/prof")
		}
		taskElement.Amout, err = strconv.Atoi(r.FormValue("Amout"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения кол-ва", err.Error(), "Главная", "/works/prof")
		}
		taskElement.Done = 0
		taskId, err := strconv.Atoi(r.FormValue("TaskId"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения номера задачи", err.Error(), "Главная", "/works/prof")
		}
		err = a.Db.InsertTaskWorkList(a.Ctx, taskId, taskElement)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка создания эл-та задачи", err.Error(), "Главная", "/works/prof")
		}
		a.Templ.CreateTaskListPage(w, TaskId, -1)
	} else if r.FormValue("Action") == "OpenRedact" {
		redId, err := strconv.Atoi(r.FormValue("ListId"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка номера подзадачи", err.Error(), "Главная", "/works/prof")
		}
		a.Templ.CreateTaskListPage(w, TaskId, redId)
	} else if r.FormValue("Action") == "Redact" {
		var taskElement mytypes.TaskWorkList
		var err error
		taskElement.TModel, err = strconv.Atoi(r.FormValue("TModel"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения модели", err.Error(), "Главная", "/works/prof")
		}
		taskElement.Amout, err = strconv.Atoi(r.FormValue("Amout"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения кол-ва", err.Error(), "Главная", "/works/prof")
		}
		taskElement.Id, err = strconv.Atoi(r.FormValue("ListId"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения номера подзадачи", err.Error(), "Главная", "/works/prof")
		}
		taskElement.Done = 0
		taskElement.Date = time.Now()
		err = a.Db.ChangeTaskList(a.Ctx, taskElement)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка изменения эл-та задачи", err.Error(), "Главная", "/works/prof")
		}
		a.Templ.CreateTaskListPage(w, TaskId, -1)
	}
}

// редактирование событий
func (a App) ChangeTask(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var task mytypes.Task
	var err error
	task.Id, err = strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id", err.Error(), "Главная", "/works/prof")
		return
	}
	task.Priority, err = strconv.Atoi(r.FormValue("Priority"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания приоритета", err.Error(), "Главная", "/works/prof")
		return
	}
	task.DateStart, err = time.Parse("2006-01-02", r.FormValue("Start"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания даты начала", err.Error(), "Главная", "/works/prof")
		return
	}
	task.DateEnd, err = time.Parse("2006-01-02", r.FormValue("End"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания даты окончания", err.Error(), "Главная", "/works/prof")
		return
	}
	task.Color = r.FormValue("Color")

	err = a.Db.ChangeTask(a.Ctx, task)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка изменения", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 1, "Успешно", "Успешно", "Изменено", "Новые данные внесены", "Главная", "/works/prof")
}

// Авто создание задачи из заказа
func (a App) OrderToTask(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	orderId, err := strconv.Atoi(r.FormValue("order"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id", err.Error(), "Главная", "/works/prof")
		return
	}

	list, err := a.Db.TakeOrderList(a.Ctx, orderId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска состава", err.Error(), "Главная", "/works/prof")
		return
	}

	orders, err := a.Db.TakeOrderById(a.Ctx, orderId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения заказа", err.Error(), "Главная", "/works/prof")
		return
	}
	order := orders[0]

	endDate := order.ReqDate
	if order.PromDate != time.Date(2000, 1, 1, 0, 0, 0, 0, time.UTC) {
		endDate = order.PromDate
	}

	task := mytypes.Task{
		Name:        "Заказ " + order.Name + "#" + strconv.Itoa(order.Id1C),
		Autor:       user.UserId,
		Description: "Автоматическая задача для заказа",
		Color:       "#0d6efd",
		Priority:    10,
		DateStart:   time.Now(),
		DateEnd:     endDate,
		Complete:    false,
	}
	err = a.Db.InsertTask(a.Ctx, task)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка создания задачи", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.Db.QueryRow(a.Ctx, `SELECT id FROM public.tasks WHERE name = $1 AND autor = $2 AND complete = $3 ORDER BY datestart DESC`, task.Name, task.Autor, task.Complete).Scan(&task.Id)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения номера задачи", err.Error(), "Главная", "/works/prof")
		return
	}
	for _, listEl := range list {
		taskEl := mytypes.TaskWorkList{
			TModel: listEl.Model,
			Amout:  listEl.Amout,
			Done:   0,
		}
		err = a.Db.InsertTaskWorkList(a.Ctx, task.Id, taskEl)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка добовления в лист задачи", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	a.Templ.AlertPage(w, 1, "Успешно", "Успешно", "Созданно", "Новая задача создана", "Главная", "/works/prof")
}

// Скрыть (завершить) событие
func (a App) HideTask(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	taskId, err := strconv.Atoi(r.FormValue("TaskId"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id", err.Error(), "Главная", "/works/prof")
		return
	}
	task, err := a.Db.TakeTasksById(a.Ctx, taskId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка писка задачи", err.Error(), "Главная", "/works/prof")
		return
	}

	if task[0].Autor != user.UserId {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Нельзя удалить чужую задачу", "Не надо так", "Главная", "/works/prof")
		return
	}

	err = a.Db.CompleatTask(a.Ctx, taskId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка скрытия задачи", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 1, "Успешно", "Успешно", "Созданно", "Задача скрыта", "Главная", "/works/prof")
}

func (a App) CreateReserv(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
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

//////////////////////

// Отправка отчетов //

//////////////////////

// Тестовый файл
func (a App) TestFile(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	order, err := a.Db.TakeCleanOrderById(a.Ctx)
	if err != nil {
		log.Println(err)
	}

	path, name, err := Filer.OrderExceller(*a.Db, a.AppIp, "http://"+a.AppIp+"/works/orders", order...)
	log.Println(path)
	if err != nil {
		log.Println(err)
	}

	err = sendTMPFile(w, r, path, name)
	if err != nil {
		log.Println(err)
	}
}

// представление TMC в excell
func (a App) TMCExcell(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	var devices []mytypes.DeviceClean
	var link string
	var err error
	if r.FormValue("Search") == "" {
		devices, err = a.Db.TakeCleanDeviceById(a.Ctx)
		if err != nil {
			log.Println(err)
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

		devices, err = a.Db.TakeCleanDeviceByRequest(a.Ctx, req)
		if err != nil {
			log.Println(err)
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

		devices, err = a.Db.TakeCleanDevice(a.Ctx, cleanSelect)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	} else if r.FormValue("Search") == "Sns" {
		snString := r.FormValue("in")
		link = "?Search=Sns&in=" + r.FormValue("in")
		Sns := strings.Fields(snString)
		devices, err = a.Db.TakeCleanDeviceBySn(a.Ctx, Sns...)
		if err != nil {
			log.Println(err)
		}
	} else if r.FormValue("Search") == "Anything" {
		link = "?Search=Anything&in=" + r.FormValue("in")
		snString := r.FormValue("in")
		Sns := strings.Split(snString, ";")
		devices, err = a.Db.TakeCleanDeviceByAnything(a.Ctx, Sns...)
		if err != nil {
			log.Println(err)
		}
	}

	path, name, err := Filer.TMCExceller("http://"+a.AppIp+"/works/tmc"+link, devices...)
	log.Println(path)
	if err != nil {
		log.Println(err)
	}

	err = sendTMPFile(w, r, path, name)
	if err != nil {
		log.Println(err)
	}
}

// представление заказов в excell
func (a App) OrdersExcell(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var orders []mytypes.OrderClean
	var link string
	var err error

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
	} else if r.FormValue("Search") == "Raw" {
		link = "&Search=Raw&in=" + r.FormValue("in")
		id, err := strconv.Atoi(r.FormValue("in"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		orders, err = a.Db.TakeCleanOrderById(a.Ctx, id)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	path, name, err := Filer.OrderExceller(*a.Db, a.AppIp, "http://"+a.AppIp+"/works/orders"+link, orders...)
	log.Println(path)
	if err != nil {
		log.Println(err)
	}

	err = sendTMPFile(w, r, path, name)
	if err != nil {
		log.Println(err)
	}
}

// представление списка заказов в excell
func (a App) OrdersShortExcell(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var orders []mytypes.OrderClean
	var link string
	var err error

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

	path, name, err := Filer.ShortOrdersExceller("http://"+a.AppIp+"/works/orders"+link, orders...)
	log.Println(path)
	if err != nil {
		log.Println(err)
	}

	err = sendTMPFile(w, r, path, name)
	if err != nil {
		log.Println(err)
	}
}
