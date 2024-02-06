package Application

import (
	"T-Base/Brain/Filer"
	"T-Base/Brain/mytypes"
	"log"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/julienschmidt/httprouter"
)

func ReportsRouts(a App, r *httprouter.Router) {
	r.GET("/works/tmcexcell", a.authtorized(a.TMCExcell))
	r.POST("/works/tmcexcell", a.authtorized(a.TMCExcell))
	r.GET("/works/ordersexcell", a.authtorized(a.OrdersExcell))
	r.POST("/works/ordersexcell", a.authtorized(a.OrdersExcell))
	r.GET("/works/shortordersexcell", a.authtorized(a.OrdersShortExcell))
	r.POST("/works/shortordersexcell", a.authtorized(a.OrdersShortExcell))
	r.GET("/works/file", a.authtorized(a.TestFile))
}

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
