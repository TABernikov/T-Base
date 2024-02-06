package Application

import (
	"T-Base/Brain/mytypes"
	"net/http"
	"strconv"

	"github.com/julienschmidt/httprouter"
)

func ModelsRouts(a App, r *httprouter.Router) {
	r.GET("/works/tmodels", a.authtorized(a.TModelsPage))
	r.GET("/works/tmodel", a.authtorized(a.TModelPage))
	r.GET("/works/dmodels", a.authtorized(a.DModelsPage))
	r.GET("/works/dmodel", a.authtorized(a.DModelPage))
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
