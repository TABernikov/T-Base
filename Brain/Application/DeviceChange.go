package Application

import (
	"T-Base/Brain/Filer"
	"T-Base/Brain/mytypes"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	"github.com/julienschmidt/httprouter"
)

func DeviceChangeRouts(a App, r *httprouter.Router) {
	r.GET("/works/towork", a.authtorized(a.ToWorkPage))
	r.GET("/works/setorder", a.authtorized(a.SetOrderPage))
	r.GET("/works/setplace", a.authtorized(a.SetPlacePage))
	r.GET("/works/takedemo", a.authtorized(a.TakeDemoPage))
	r.GET("/works/toship", a.authtorized(a.ToShipPage))
	r.GET("/works/cangeplacenum", a.authtorized(a.ChangeNumPlacePage))
	r.GET("/works/takedevicebymodel", a.authtorized(a.TakeDeviceByModelPage))
	r.GET("/works/changemac", a.authtorized(a.ChangeMACPage))
	r.GET("/works/releaseproduction", a.authtorized(a.ReleaseProductionPage))
	r.GET("/works/returntostorage", a.authtorized(a.ReturnToStoragePage))
	r.GET("/works/addcommentbysn", a.authtorized(a.AddCommentToSnsBySnPage))
	r.GET("/works/takedevicebyxlsx", a.authtorized(a.TakeDeviceByExcelPage))
	r.GET("/works/changeassembler", a.authtorized(a.CreateChangeAssemblerPage))

	r.POST("/works/towork", a.authtorized(a.ToWork))
	r.POST("/works/setorder", a.authtorized(a.SetOrder))
	r.POST("/works/setplace", a.authtorized(a.SetPlace))
	r.POST("/works/takedemo", a.authtorized(a.TakeDemo))
	r.POST("/works/toship", a.authtorized(a.ToShip))
	r.POST("/works/cangeplacenum", a.authtorized(a.ChangeNumPlace))
	r.POST("/works/addcomment", a.authtorized(a.AddCommentToSns))
	r.POST("/works/takedevicebymodel", a.authtorized(a.TakeDeviceByModel))
	r.POST("/works/changemac", a.authtorized(a.ChangeMAC))
	r.POST("/works/releaseproductionacept", a.authtorized(a.BuildAceptPage))
	r.POST("/works/releaseproduction", a.authtorized(a.ReleaseProduction))
	r.POST("/works/returntostorage", a.authtorized(a.ReturnToStorage))
	r.POST("/works/addcommentbysn", a.authtorized(a.AddCommentToSnsBySn))
	r.POST("/works/takedevicebyxlsx", a.authtorized(a.TakeDeviceByExcel))
	r.POST("/works/changeassembler", a.authtorized(a.ChangeAssembler))
}

// Страница передачи в производство
func (a App) ToWorkPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "/works/towork", "Передать в производство", "Введите серийные номера для передачи", "Передать")
}

// передача в производство
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

// Страница назначения резерва
func (a App) SetOrderPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	orderId := r.FormValue("order")
	a.Templ.ChangeDeviceOrder(w, orderId)
}

// Назначение резерва
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

// Страница установки места
func (a App) SetPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.DobleImputPage(w, "/works/setplace", "Установить место", "Введите серийные номера:", "Номер места", "number", "Установить место", "")
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

// Страница приемки демо
func (a App) TakeDemoPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "", "Приемка демо", "Введите серийные номера", "Принять")
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

// Страница отгрузки
func (a App) ToShipPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	place := r.FormValue("place")
	a.Templ.DobleImputPage(w, "", "Отгрузка", "Введите серийные номера", "Место отгрузки", "text", "Отгрузить", place)
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

// Страница изменения номера паллета
func (a App) ChangeNumPlacePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.DobleImputTypePage(w, "/works/cangeplacenum", "Установить номер места", "Введите старый номер:", "number", "Введите новый номер", "number", "Изменить")
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

// Страница приемки помодельно
func (a App) TakeDeviceByModelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.TakeDeviceByModelPage(w)
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
	err = a.Db.Db.QueryRow(a.Ctx, `SELECT "tModelsId" FROM "tModels" WHERE "tModels"."tModelsName" = $1`, TModelIn).Scan(&TModel)
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

	logCount := a.Db.AddDeviceEventBySn(a.Ctx, 1, "Принято на склад", user.UserId, Sns...)
	if logCount != len(Sns) {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка записи логов", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Все устройства внесены", "Отличная работа", "Главная", "/works/prof")
}

// Страница изменения мак адреса устройства
func (a App) ChangeMACPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "", "Изменить маки", "Введите последовательно серийный номер и мак для каждого устройства", "Изменить")
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
				a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Недостаточно материалов ID: "+strconv.Itoa(element.MatId), "", "Главная", "/works/prof")
				return
			}
		}
	}

	a.Templ.BuildAceptPage(w, buildsClean, inSn...)
}

// Страница выпуска устройств с производства
func (a App) ReleaseProductionPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "/works/releaseproductionacept", "Выпуск с производства", "Введите серийные номера", "Выпуск")
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
	BuildMap := make(mytypes.Map5int)
	TmodelSn := make(map[int][]string)
	DmodelCount := make(map[int]int)
	for _, sn := range in {
		// Преобразование устройства
		build, tmodel, dmodel, matToProdus, err := a.Db.ReleaseProduction(a.Ctx, sn)
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

		// Добавляем материалы для этого устройства в общий лист списаия
		for i, a := range matToProdus {
			matList[i] += a
			BuildMap.Sum(tmodel, dmodel, build, i, a)
		}
		TmodelSn[tmodel] = append(TmodelSn[tmodel], sn)
		DmodelCount[dmodel] += 1
	}
	for matId, amout := range matList {
		err := a.Db.AddMatLog(a.Ctx, matId, amout, 4, "Преобразование", user.UserId)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка записи логов материала", "", "Главная", "/works/prof")

		}
	}

	tmodelMap := make(map[int]string)
	qq := `SELECT "tModelsId", "tModelsName" FROM public."tModels";`
	rows, err := a.Db.Db.Query(a.Ctx, qq)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска устройств", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		var tmodelId int
		var tmodelName string
		err = rows.Scan(&tmodelId, &tmodelName)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска устройств", err.Error(), "Главная", "/works/prof")
			return
		}
		tmodelMap[tmodelId] = tmodelName
	}

	dModelMap := make(map[int]string)
	qq = `SELECT "dModelsId", "dModelName" FROM public."dModels";`
	rows, err = a.Db.Db.Query(a.Ctx, qq)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска имен устройств", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		var dmodelId int
		var dmodelName string
		err = rows.Scan(&dmodelId, &dmodelName)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска имен устройств", err.Error(), "Главная", "/works/prof")
			return
		}
		dModelMap[dmodelId] = dmodelName
	}

	mModelMap := make(map[int]string)
	qq = `SELECT "matId", "1CName" FROM public.mats;`
	rows, err = a.Db.Db.Query(a.Ctx, qq)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска имен материалов", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		var matId int
		var matName string
		err = rows.Scan(&matId, &matName)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска имен материалов", err.Error(), "Главная", "/works/prof")
			return
		}
		mModelMap[matId] = matName
	}

	docId, err := a.DocBase.CreateProductionDoc(a.Ctx, BuildMap, TmodelSn, DmodelCount, user, tmodelMap, dModelMap, mModelMap)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка создания документа", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Успешно", "Успешно", "Преобразовано "+strconv.Itoa(counter)+" устройств", "", "Отчет", "/works/doc?type=production.out&id="+docId)
}

// Страница возврата не собраных устройств на производство
func (a App) ReturnToStoragePage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputPage(w, "", "Вернуть на склад", "Введите серийные номера через пробез или с новой стрроки", "Вернуть")
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

// Страница добавления комментария по серийным номерам
func (a App) AddCommentToSnsBySnPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.DobleImputPage(w, "/works/addcommentbysn", "Дополнить комментарии", "Серийные номера", "Коментарий", "text", "Добавить коментарий", "")
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

// Страница приемка файлом
func (a App) TakeDeviceByExcelPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ImputTypePage(w, "", "Приемка файлом", "file", "Выберете файл", "Отправить")
}

// Приемка файлом
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
		err := sendTMPFile(w, r, f.Name(), name+"ОШИБКИ")
		if err != nil {
			fmt.Fprintln(w, err)
		}
	}
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка внесения", err.Error(), "Главная", "/works/prof")
		return
	}

	if insertCount == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Устройства небыли приняты", "insertCount = 0", "Главная", "/works/prof")
		return
	} else if insertCount < len(devices) {
		a.Templ.AlertPage(w, 2, "Готово", "Частично", "Часть устройств не было принято", "Внесено "+strconv.Itoa(insertCount), "Главная", "/works/prof")
		return
	} else if insertCount > len(devices) {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", "insertCount > len(devices)", "Главная", "/works/prof")
		return
	}

	var Ids []int
	for _, device := range devices {
		Ids = append(Ids, device.Id)
	}

	logCount := a.Db.AddDeviceEventById(a.Ctx, 1, "Принято на склад", user.UserId, Ids...)
	if logCount != len(Ids) {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка записи логов", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Все "+strconv.Itoa(insertCount)+" устройств внесены", "Отличная работа", "Главная", "/works/prof")
}

// Страница устоновки сборщика устройства
func (a App) CreateChangeAssemblerPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.ChangeAssemblerPage(w)
}

// Установка сборщика устройства
func (a App) ChangeAssembler(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	snString := r.FormValue("sn")
	Sns := strings.Fields(snString)
	if len(Sns) == 0 {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не ввседены серийные номера", "", "Главная", "/works/prof")
		return
	}

	ass, err := strconv.Atoi(r.FormValue("assembler"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не выбран сборщик", err.Error(), "Главная", "/works/prof")
		return
	}

	for _, sn := range Sns {
		err := a.Db.ChangeDeviceAssembler(a.Ctx, sn, ass)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось изменить сборщика", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	a.Templ.AlertPage(w, 1, "Успех", "Успех", "Сборщик успешно изменен", "", "Главная", "/works/prof")
}
