package Application

import (
	"T-Base/Brain/mytypes"
	"net/http"
	"strconv"

	"github.com/julienschmidt/httprouter"
)

func MaterialsRouts(a App, r *httprouter.Router) {
	r.GET("/works/createmat", a.authtorized(a.CreateMatPage))
	r.GET("/works/takemat", a.authtorized(a.TakeMatPage))
	r.GET("/works/storage/mats", a.authtorized(a.StorageMatsPage))
	r.GET("/works/storage/matsbyname", a.authtorized(a.StorageMatsByNamePage))
	r.GET("/works/storage/matsby1c", a.authtorized(a.StorageMatsBy1CPage))
	r.GET("/works/matsinwork", a.authtorized(a.StorageMatsInWorkPage))
	r.GET("/works/matevents", a.authtorized(a.MatEventPage))

	r.POST("/works/createmat", a.authtorized(a.CreateMat))
	r.POST("/works/takemat", a.authtorized(a.TakeMat))
	r.POST("/works/mattowork", a.authtorized(a.MatToWork))
	r.POST("/works/matfromwork", a.authtorized(a.MatFromWork))
}

// Страница добавления материала
func (a App) CreateMatPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateMatPage(w)
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

// Страница приемки материала
func (a App) TakeMatPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 2 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	a.Templ.TakeMatPage(w)
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

	matId, err := a.Db.AddMat(a.Ctx, name, name1c, price, amout, place)
	if err != nil {
		if err.Error() == "критическая ошибка" {
			a.Templ.AlertPage(w, 5, "Ошибка", "КРИТИЧЕСКАЯ ОШИБКА !!!", "ОБРАТИТЕСЬ К АДМИНЕСТРАТОРУ ДЛЯ ВНЕСЕНИЯ ИСПРАВЛЕНИЙ", err.Error(), "Главная", "/works/prof")
		} else {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка внесения", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	err = a.Db.AddMatLog(a.Ctx, matId, amout, 2, "Приемка на склад", user.UserId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка записи логов", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Готово", "Готово", "Успешно", "Отличная работа", "Главная", "/works/prof")
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

// Страница списка материалов в работе
func (a App) StorageMatsInWorkPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.StorageMatsInWorkPage(w)
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
