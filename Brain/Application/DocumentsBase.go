package Application

import (
	"T-Base/Brain/mytypes"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/julienschmidt/httprouter"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func DocumentsBaseRouts(a App, r *httprouter.Router) {
	r.GET("/works/filesbase", a.authtorized(a.FilesBase))
	r.GET("/works/doc", a.authtorized(a.DocPage))
	r.GET("/works/docs", a.authtorized(a.DocsPage))
	r.GET("/works/createdoc", a.authtorized(a.CreateDocPage))
	r.POST("/works/createdoc", a.authtorized(a.CreateDoc))
	r.POST("/works/addfile", a.authtorized(a.AddDocFile))
	r.POST("/works/deletefile", a.authtorized(a.DellDocFile))
	r.POST("/works/deletedoc", a.authtorized(a.DellDoc))
	r.POST("/works/editdocpage", a.authtorized(a.EditDocPage))
	r.POST("/works/editdoc", a.authtorized(a.EditDoc))
	r.POST("/works/changetmodelkig", a.authtorized(a.ChangeTModelKig))
	r.POST("/works/changetmodelds", a.authtorized(a.ChangeTModelDs))
	r.GET("/works/customdocs", a.authtorized(a.DocsCustomPage))

}

func (a App) DocsPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	mainDocs, err := a.DocBase.TakeDocs(a.Ctx, "main")
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось получить документы", err.Error(), "Главная", "/works/prof")
		return
	}
	privateDocs, err := a.DocBase.TakeDocsByUser(a.Ctx, "private", user)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось получить документы", err.Error(), "Главная", "/works/prof")
		return
	}

	otherDocs, err := a.DocBase.TakeDocs(a.Ctx, "other")
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось получить документы", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.DocsPage(w, mainDocs, otherDocs, privateDocs)
}

func (a App) DocsCustomPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	typesString := r.FormValue("types")
	if typesString == "" {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не заданы типы документов", "", "Главная", "/works/prof")
		return
	}
	types := strings.Split(typesString, ",")

	docsByTypes := [][]mytypes.Document{}

	for _, t := range types {
		if t == "" {
			continue
		}
		var docs []mytypes.Document
		err := error(nil)
		if t == "private" {
			docs, err = a.DocBase.TakeDocsByUser(a.Ctx, t, user)
			if err != nil {
				a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось получить документы", err.Error(), "Главная", "/works/prof")
				return
			}
		} else {
			docs, err = a.DocBase.TakeDocs(a.Ctx, t)
			if err != nil {
				a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось получить документы", err.Error(), "Главная", "/works/prof")
				return
			}
		}

		docsByTypes = append(docsByTypes, docs)
	}
	a.Templ.CustomDocsPage(w, docsByTypes...)
}

func (a App) DocPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	docType := r.FormValue("type")
	if docType == "" {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не задан тип документа", "обратитесь к администратору", "Главная", "/works/prof")
		return

	}
	docId := r.FormValue("id")
	if docId == "" {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не задан Id документа", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	objID, err := primitive.ObjectIDFromHex(docId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не верно задан Id документа", err.Error(), "Главная", "/works/prof")
		return
	}
	doc, err := a.DocBase.TakeDoc(a.Ctx, docType, objID)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось получить документ", err.Error(), "Главная", "/works/prof")
		return
	}

	if len(doc.Access) > 0 {
		for _, approved := range doc.Access {
			if approved == user.Login {
				a.Templ.DocPage(w, doc, docId, docType)
				return
			}
		}
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Доступ запрещен", "обратитесь к администратору", "Главная", "/works/prof")
	} else {
		a.Templ.DocPage(w, doc, docId, docType)
	}
}

func (a App) CreateDocPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	a.Templ.DocCreatePage(w)
}

func (a App) CreateDoc(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	docType := r.FormValue("type")
	docContent := r.FormValue("inContent")
	docName := r.FormValue("name")

	var acces []string
	acces = []string{}
	if docType == "private" {
		acces = []string{user.Login}
	}

	_, err := a.DocBase.NewDoc(a.Ctx, docType, docName, user, docContent, acces)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось создать документ", err.Error(), "Главная", "/works/prof")
		return
	}
	a.Templ.AlertPage(w, 1, "Успех", "Успех", "Документ успешно создан", "", "Главная", "/works/prof")
}

// выводит файл из франилища
func (a App) FilesBase(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	docType := r.FormValue("type")
	if docType == "" {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не задан тип документа", "обратитесь к администратору", "Главная", "/works/prof")
		return

	}
	docId := r.FormValue("id")
	if docId == "" {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не задан Id документа", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	objID, err := primitive.ObjectIDFromHex(docId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не верно задан Id документа", err.Error(), "Главная", "/works/prof")
		return
	}
	doc, err := a.DocBase.TakeDoc(a.Ctx, docType, objID)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не удалось получить документ", err.Error(), "Главная", "/works/prof")
		return
	}

	filepath := r.FormValue("filepath")
	if filepath == "" && len(doc.Files) == 0 {
		w.Header()["Date"] = nil
		http.Error(w, "Ошибка 404. Файл не найден 1", 404)
		return

	} else if filepath == "" && len(doc.Files) > 0 {
		filepath = doc.Files[0]
	}

	p := "Files/DocStor/" + strings.ReplaceAll(docType, ".", "/") + "/" + filepath
	file, err := os.Open(p)
	if err != nil {
		w.Header()["Date"] = nil
		http.Error(w, "Ошибка 404. Файл не найден 2", 404)
		return
	}
	defer file.Close()

	info, err := file.Stat()
	if err != nil {
		w.Header()["Date"] = nil
		http.Error(w, "Ошибка 404. Файл не найден 3", 404)
		return
	}

	if len(doc.Access) > 0 {
		for _, approved := range doc.Access {
			if approved == user.Login {
				w.Header().Add("Content-Type", "text/plain; charset=UTF-8")
				w.Header().Add("content-disposition", `inline; filename=`+filepath)
				http.ServeContent(w, r, p, info.ModTime(), file)
				return
			}
		}
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Доступ запрещен", "обратитесь к администратору", "Главная", "/works/prof")
	} else {
		w.Header().Add("Content-Type", "text/plain; charset=UTF-8")
		w.Header().Add("content-disposition", `inline; filename=`+filepath)
		http.ServeContent(w, r, p, info.ModTime(), file)
	}
}

func (a App) AddDocFile(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
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

	docId, err := primitive.ObjectIDFromHex(r.FormValue("docid"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка преобразования", err.Error(), "Главная", "/works/prof")
		return
	}
	docType := r.FormValue("doctype")

	doc, err := a.DocBase.TakeDoc(a.Ctx, docType, docId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка получения", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.Name != doc.Authtor {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Доступ запрещен", "Изменять вложения может только автор", "Главная", "/works/prof")
		return
	}

	f, name, err := takeDocFile(src, hdr, docType)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка записи в хранилище", err.Error(), "Главная", "/works/prof")
		return
	}
	f.Close()

	doc.Files = append(doc.Files, name)
	err = a.DocBase.UpdateDoc(a.Ctx, docType, doc)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка записи в документ", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Успех", "Успех", "Файл добавлен", "", "Главная", "/works/prof")
}

func (a App) DellDocFile(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	docid, err := primitive.ObjectIDFromHex(r.FormValue("docid"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не верно задан Id документа", err.Error(), "Главная", "/works/prof")
		return
	}

	docType := r.FormValue("doctype")
	filepath := r.FormValue("filepath")

	doc, err := a.DocBase.TakeDoc(a.Ctx, docType, docid)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска документа", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.Name != doc.Authtor {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Доступ запрещен", "Изменять вложения может только автор", "Главная", "/works/prof")
		return
	}

	var files []string
	for _, file := range doc.Files {
		if file != filepath {
			files = append(files, file)
		}
	}
	doc.Files = files

	err = a.DocBase.UpdateDoc(a.Ctx, docType, doc)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка удаления из документа", err.Error(), "Главная", "/works/prof")
		return
	}

	err = dellDocFile(docType, filepath)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка удаления из хранилища", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Успех", "Успех", "Файл удален", "", "Главная", "/works/prof")
}

func (a App) DellDoc(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	docid, err := primitive.ObjectIDFromHex(r.FormValue("id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не верно задан Id документа", err.Error(), "Главная", "/works/prof")
		return
	}
	docType := r.FormValue("type")

	doc, err := a.DocBase.TakeDoc(a.Ctx, docType, docid)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска документа", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.Name != doc.Authtor {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Доступ запрещен", "Удалить документ может только автор или администратор", "Главная", "/works/prof")
		return
	}

	for _, file := range doc.Files {
		err = dellDocFile(docType, file)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка удаления из хранилища", err.Error(), "Главная", "/works/prof")
			return
		}
	}

	err = a.DocBase.DeleteDoc(a.Ctx, docType, docid)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка удаления документа", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Успех", "Успех", "Документ удален", "", "Главная", "/works/prof")
}

func (a App) EditDocPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	docId, err := primitive.ObjectIDFromHex(r.FormValue("id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не верно задан Id документа", err.Error(), "Главная", "/works/prof")
		return
	}
	docType := r.FormValue("type")

	doc, err := a.DocBase.TakeDoc(a.Ctx, docType, docId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска документа", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.Name != doc.Authtor {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Доступ запрещен", "Изменять документ может только автор", "Главная", "/works/prof")
		return
	}

	a.Templ.EditDocPage(w, doc, r.FormValue("id"), docType)
}

func (a App) EditDoc(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {

	docid, err := primitive.ObjectIDFromHex(r.FormValue("id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Не верно задан Id документа", err.Error(), "Главная", "/works/prof")
		return
	}
	doctype := r.FormValue("type")
	newContent := r.FormValue("inContent")

	doc, err := a.DocBase.TakeDoc(a.Ctx, doctype, docid)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка поиска документа", err.Error(), "Главная", "/works/prof")
		return
	}

	if user.Name != doc.Authtor {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Доступ запрещен", "Изменять документ может только автор", "Главная", "/works/prof")
		return
	}

	doc.Content = newContent

	err = a.DocBase.UpdateDoc(a.Ctx, doctype, doc)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка обновления документа", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Успех", "Успех", "Документ обновлен", "", "Главная", "/works/prof")
}

func (a App) ChangeTModelKig(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	src, hdr, err := r.FormFile("newFile")
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка загрузки", "Ошбка загрузки", "Непредвиденная ошибка загрузки", err.Error(), "Главная", "/works/prof")
		return
	}
	defer src.Close()

	tmodelId, err := strconv.Atoi(r.FormValue("modelId"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка загрузки", "Ошбка загрузки", "Неверный ID модели", err.Error(), "Главная", "/works/prof")
		return
	}

	tmodels, err := a.Db.TakeTModelsById(a.Ctx, tmodelId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка поиска модели", "Ошбка поиска модели", "!!!", err.Error(), "Главная", "/works/prof")
		return
	}
	tmodel := tmodels[0]

	acces := []string{}
	user.Name = "Берников Т. А."
	hdr.Filename = "Паспорт для " + strings.ReplaceAll(tmodel.Name, "/", "_") + " от " + time.Now().Format("02.01.2006 15.04.05") + hdr.Filename
	file, fileName, err := takeDocFile(src, hdr, "komm.kigs")
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка записи файла", "Ошбка записи файла", "!!!", err.Error(), "Главная", "/works/prof")
		return
	}
	file.Close()
	docid, err := a.DocBase.NewDoc(a.Ctx, "komm.kigs", "Паспорт для "+tmodel.Name+" от "+time.Now().Format("02.01.2006 15:04:05"), user, "", acces, fileName)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка создания документа", "Ошбка создания документа", "!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.ChangeTModelKig(a.Ctx, tmodelId, docid.Hex())
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка изменения паспорта модели", "Ошбка изменения паспорта модели", "!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Успех", "Успех", "Паспорт обновлен", "", "Главная", "/works/prof")
}

func (a App) ChangeTModelDs(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	src, hdr, err := r.FormFile("newFile")
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка загрузки", "Ошбка загрузки", "Непредвиденная ошибка загрузки", err.Error(), "Главная", "/works/prof")
		return
	}
	defer src.Close()

	tmodelId, err := strconv.Atoi(r.FormValue("modelId"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка загрузки", "Ошбка загрузки", "Неверный ID модели", err.Error(), "Главная", "/works/prof")
		return
	}

	tmodels, err := a.Db.TakeTModelsById(a.Ctx, tmodelId)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка поиска модели", "Ошбка поиска модели", "!!!", err.Error(), "Главная", "/works/prof")
		return
	}
	tmodel := tmodels[0]

	acces := []string{}
	realname := user.Name
	user.Name = "Берников Т. А."
	hdr.Filename = "Даташит для " + strings.ReplaceAll(tmodel.Name, "/", "_") + " от " + time.Now().Format("02.01.2006 15.04.05") + hdr.Filename
	file, fileName, err := takeDocFile(src, hdr, "komm.ds")
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка записи файла", "Ошбка записи файла", "!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	file.Close()
	docid, err := a.DocBase.NewDoc(a.Ctx, "komm.ds", "Даташит для "+tmodel.Name+" от "+time.Now().Format("02.01.2006 15:04:05"), user, "Документ добавлен : **"+realname+"**", acces, fileName)
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка создания документа", "Ошбка создания документа", "!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	err = a.Db.ChangeTModelDs(a.Ctx, tmodelId, docid.Hex())
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошбка изменения даташита модели", "Ошбка изменения даташита модели", "!!!", err.Error(), "Главная", "/works/prof")
		return
	}

	a.Templ.AlertPage(w, 1, "Успех", "Успех", "Даташит обновлен", "", "Главная", "/works/prof")
}
