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

func TMCRouts(a App, r *httprouter.Router) {
	r.GET("/works/device/mini", a.authtorized(a.DeviceMiniPage))
	r.GET("/works/tmc", a.authtorized(a.TMCPage))
	r.GET("/works/tmcadvancesearch", a.authtorized(a.TMCSearchPage))
	r.GET("/works/snsearch", a.authtorized(a.SnSearchPage))
	r.GET("/works/tmcdemo", a.authtorized(a.TMCDemoPage))
	r.GET("/works/storage", a.authtorized(a.StoragePage))
	r.GET("/works/storage/orders", a.authtorized(a.StoragePage))
	r.GET("/works/storage/places", a.authtorized(a.StorageByPlacePage))
	r.GET("/works/storage/models", a.authtorized(a.StorageByTModelPage))
	r.GET("/works/prodout", a.authtorized(a.ProdOutTablePage))

	r.POST("/works/tmc", a.authtorized(a.TMCPage))
	r.POST("/works/tmcdemo", a.authtorized(a.TMCDemoPage))
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
		rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", assembler FROM public.sns WHERE true`
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

		cleanSelect := `SELECT tmp."snsId", tmp.sn, tmp.mac, "dModels"."dModelName" AS dmodel, tmp.rev, "tModels"."tModelsName" AS tmodel, tmp.name, "condNames"."condName" AS condition, tmp."condDate", tmp."order", tmp.place, tmp.shiped, tmp."shipedDate", tmp."shippedDest", tmp."takenDate", tmp."takenDoc", tmp."takenOrder", snscomment.comment, users.name AS assembler  FROM (` + rawSelect + `)tmp LEFT JOIN "dModels" ON "dModels"."dModelsId" = tmp.dmodel LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.tmodel LEFT JOIN "condNames" ON "condNames"."condNamesId" = tmp.condition LEFT JOIN snscomment ON snscomment."snsId" = tmp."snsId" LEFT JOIN users ON tmp.assembler = users.userid`

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

// Таблица ТМЦ только демо оборудования
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

func (a App) ProdOutTablePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var err error
	var fromDate time.Time
	if r.FormValue("from") == "" {
		fromDate = time.Date(2020, 1, 1, 1, 1, 1, 1, time.Local)
	} else {
		fromDate, err = time.Parse("2006-01-02", r.FormValue("from"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания даты начала периода", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	var toDate time.Time
	if r.FormValue("to") == "" {
		toDate = time.Now()
	} else {
		toDate, err = time.Parse("2006-01-02", r.FormValue("to"))
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания даты окончания периода", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	if r.FormValue("view") == "report" {
		prodOut, models, dates, err := a.Db.TakeProdOutByDate(a.Ctx, fromDate, toDate)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		}

		a.Templ.ProdOutReport(w, prodOut, models, dates)
	} else {

		prodOut, models, dates, err := a.Db.TakeProdOutByModel(a.Ctx, fromDate, toDate)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		}

		a.Templ.ProdOutTable(w, prodOut, models, dates)
	}
}
