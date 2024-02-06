package Application

import (
	"T-Base/Brain/mytypes"
	"net/http"
	"strconv"

	"github.com/julienschmidt/httprouter"
)

func BuildsRouts(a App, r *httprouter.Router) {
	r.GET("/works/makebuild", a.authtorized(a.CreateBuildPage))
	r.GET("/works/buildlist", a.authtorized(a.BuildsPage))
	r.GET("/works/canbebuild", a.authtorized(a.CreateCanBeBuildPage))
	r.GET("/works/canbebuildorders", a.authtorized(a.CreateCanBeBuildOrdersPage))
	r.POST("/works/makebuild", a.authtorized(a.MakeBuild))
	r.POST("/works/changedefbuild", a.authtorized(a.ChangeDefBuild))
}

// Страница создания сборки
func (a App) CreateBuildPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateBuildPage(w)
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

// Страница сборок
func (a App) BuildsPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	Builds, err := a.Db.TakeCleanBuildByTModel(a.Ctx)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения сборок", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.BuildsPage(w, Builds)
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

func (a App) CreateCanBeBuildPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.CanBeBuildPage(w)
}

func (a App) CreateCanBeBuildOrdersPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.CanBeBuildOrdersPage(w)
}
