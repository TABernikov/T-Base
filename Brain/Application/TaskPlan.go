package Application

import (
	"T-Base/Brain/mytypes"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/julienschmidt/httprouter"
)

func TaskPlanRouts(a App, r *httprouter.Router) {
	r.GET("/works/cal", a.authtorized(a.CalendearPage))
	r.GET("/works/createtask", a.authtorized(a.CreateTaskPage))
	r.GET("/works/tasks", a.authtorized(a.TasksPage))
	r.GET("/works/createtasklist", a.authtorized(a.CreateTaskListPage))
	r.GET("/works/changetask", a.authtorized(a.ChangeTaskPage))
	r.GET("/works/task", a.authtorized(a.TaskPage))
	r.GET("/works/planprodstorage", a.authtorized(a.PlanProdStoragePage))
	r.GET("/works/planreprodstorage", a.authtorized(a.PlanReProdStoragePage))
	r.GET("/works/planmatprodstorage", a.authtorized(a.PlanMatProdStoragePage))

	r.POST("/works/createtask", a.authtorized(a.CreateTask))
	r.POST("/works/createtasklist", a.authtorized(a.CreateTaskListPage))
	r.POST("/works/changetask", a.authtorized(a.ChangeTask))
	r.POST("/works/ordertotask", a.authtorized(a.OrderToTask))
	r.POST("/works/hidetask", a.authtorized(a.HideTask))

	r.GET("/works/calNew", a.authtorized(a.CalendearNewPage))
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
		a.Templ.CalendarPage(w, tasks, "List")
		return
	} else if r.FormValue("look") == "Cal" {
		a.Templ.CalendarPage(w, tasks, "Cal")
		return
	} else if r.FormValue("look") == "Jira" {
		a.Templ.CalendarPage(w, tasks, "Jira")
		return
	}
	a.Templ.CalendarPage(w, tasks, "Cal")
}

// Страница создания события
func (a App) CreateTaskPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}
	a.Templ.CreateTaskPage(w)
}

// создать событие
func (a App) CreateTask(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

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
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	TaskId, err := strconv.Atoi(r.FormValue("TaskId"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения номера задачи", err.Error(), "Главная", "/works/prof")
	}

	if r.FormValue("Action") == "Open" {
		a.Templ.CreateTaskListPage(w, TaskId, -1)
	} else if r.FormValue("Action") == "Create" {
		var taskElement mytypes.TaskWorkList
		var err error

		var TModel int
		TModelIn := r.FormValue("TModel")
		err = a.Db.Db.QueryRow(a.Ctx, `SELECT "tModelsId" FROM "tModels" WHERE "tModels"."tModelsName" = $1`, TModelIn).Scan(&TModel)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверная модель", err.Error(), "Главная", "/works/prof")
		}
		taskElement.TModel = TModel

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
		var TModel int
		TModelIn := r.FormValue("TModel")
		err = a.Db.Db.QueryRow(a.Ctx, `SELECT "tModelsId" FROM "tModels" WHERE "tModels"."tModelsName" = $1`, TModelIn).Scan(&TModel)
		if err != nil {
			a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка создания", "Неверная модель", err.Error(), "Главная", "/works/prof")
		}
		taskElement.TModel = TModel

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
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

	var task mytypes.Task
	var err error
	task.Id, err = strconv.Atoi(r.FormValue("Id"))
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка считывания Id", err.Error(), "Главная", "/works/prof")
		return
	}

	tasks, err := a.Db.TakeTasksById(a.Ctx, task.Id)
	task = tasks[0]
	if err != nil {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения задачи", err.Error(), "Главная", "/works/prof")
		return
	}
	if task.Autor != user.UserId {
		a.Templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Нельзя редактировать чужую задачу", "обратитесь к администратору", "Главная", "/works/prof")
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
	if user.Acces != 1 {
		a.Templ.AlertPage(w, 5, "Ошбка доступа", "Ошбка доступа", "У вас не доступа к этой функции", "обратитесь к администратору", "Главная", "/works/prof")
		return
	}

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

// Новый Календарь с событиями
func (a App) CalendearNewPage(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
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

	a.Templ.CalendarNewPage(w, tasks)
}
