package PageTempl

import (
	"T-Base/Brain/Storage"
	"context"
	"time"

	"T-Base/Brain/mytypes"
	"html/template"
	"net/http"
	"strconv"
	"strings"
)

// Объект генератора
type Templ struct {
	ctx context.Context
	Db  *Storage.Base
}

// Инициализация генератора
func NewTempl(ctx context.Context, db *Storage.Base) *Templ {
	return &Templ{ctx, db}
}

// Генерация страницы TMC
func (templ Templ) TMCPage(w http.ResponseWriter, devices []mytypes.DeviceClean, snString string, lable string, excellLink string) {

	type tmcPage struct {
		Lable      string
		Tab        []mytypes.DeviceClean
		SnString   string
		ExcellLink string
	}
	table := tmcPage{lable, devices, snString, excellLink}

	t := template.Must(template.ParseFiles("Face/html/TMC.html"))
	t.Execute(w, table)
}

func (templ Templ) TMCDemoPage(w http.ResponseWriter, devices []mytypes.DeviceClean, snString string, lable string) {

	type demoDevices struct {
		Device        mytypes.DeviceClean
		CurrentReserv string
		NextReserv    string
	}

	type tmcPage struct {
		Lable    string
		Tab      []demoDevices
		SnString string
	}

	var demo []demoDevices
	var currentReserv, nextReserv string
	var time1, time2 time.Time

	for _, device := range devices {
		currentReserv = "нет"
		nextReserv = "нет"
		time1 = time.Now()
		time2 = time.Now()

		err := templ.Db.Db.QueryRow(templ.ctx, `SELECT datestart, dateend FROM public.demoreservation WHERE datestart <= CURRENT_DATE AND dateend >= CURRENT_DATE AND "snsId" = $1 ORDER BY datestart`, device.Id).Scan(&time1, &time2)
		if err != nil {
			currentReserv = "нет"
		} else {
			currentReserv = time1.Format("02.01.2006") + " - " + time2.Format("02.01.2006")
		}

		err = templ.Db.Db.QueryRow(templ.ctx, `SELECT datestart, dateend FROM public.demoreservation WHERE datestart > CURRENT_DATE AND "snsId" = $1 ORDER BY datestart`, device.Id).Scan(&time1, &time2)
		if err != nil {
			nextReserv = "Нет"
		} else {
			nextReserv = time1.Format("02.01.2006") + " - " + time2.Format("02.01.2006")
		}

		demo = append(demo, demoDevices{device, currentReserv, nextReserv})
	}

	table := tmcPage{lable, demo, snString}

	t := template.Must(template.ParseFiles("Face/html/TMC Demo.html"))
	t.Execute(w, table)
}

// Генерация страницы TMC в виде таблицы
func (templ Templ) TableTMCPage(w http.ResponseWriter, devices []mytypes.DeviceClean, snString string, lable string, excellLink string) {

	type tmcPage struct {
		Lable      string
		Tab        []mytypes.DeviceClean
		SnString   string
		ExcellLink string
	}
	table := tmcPage{lable, devices, snString, excellLink}

	t := template.Must(template.ParseFiles("Face/html/TableTMC.html"))
	t.Execute(w, table)
}

// Генерация страницы поиска в TMC
func (templ Templ) TMCAdvanceSearchPage(w http.ResponseWriter) {

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
	rows, err := templ.Db.Db.Query(templ.ctx, `SELECT "tModelsId", "tModelsName" FROM public."tModels";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		tmodelList = append(tmodelList, choise)
	}

	var dmodelList []idChoise
	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "dModelsId", "dModelName" FROM public."dModels";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		dmodelList = append(dmodelList, choise)
	}

	var condList []idChoise
	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "condNamesId", "condName" FROM public."condNames";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		condList = append(condList, choise)
	}

	tmp := search{tmodelList, dmodelList, condList}

	t := template.Must(template.ParseFiles("Face/html/TMCSearch.html"))
	t.Execute(w, tmp)
}

// Генерация страницы устройства компактная
func (templ Templ) DeviceMiniPage(w http.ResponseWriter, device mytypes.DeviceClean, events []mytypes.DeviceEventClean) {
	type devicePage struct {
		Device mytypes.DeviceClean
		Events []mytypes.DeviceEventClean
	}

	page := devicePage{device, events}

	t := template.Must(template.ParseFiles("Face/html/komm.html"))
	t.Execute(w, page)
}

// Генерация страницы заказов
func (templ Templ) OrdersPage(w http.ResponseWriter, orders []mytypes.OrderClean, lable string, link string) {

	type ordersPage struct {
		Lable      string
		Tab        []mytypes.OrderClean
		ExcellLink string
	}
	table := ordersPage{lable, orders, link}

	t := template.Must(template.ParseFiles("Face/html/orders.html"))
	t.Execute(w, table)
}

// Генерация страницы заказа компактная
func (templ Templ) OrderMiniPage(w http.ResponseWriter, order mytypes.OrderClean, orderList []mytypes.OrderListClean, reservs []mytypes.StorageByTModelClean, status []mytypes.OrderStatusClean, User mytypes.User) {
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

// Генерация страницы склада устройств с группировкой по заказам
func (templ Templ) StoragePage(w http.ResponseWriter, storage []mytypes.StorageCount, lable string) {
	type storagePage struct {
		Lable string
		Tab   []mytypes.StorageCount
	}
	table := storagePage{lable, storage}

	t := template.Must(template.ParseFiles("Face/html/storage.html"))
	t.Execute(w, table)
}

// Генерация страницы склада устройств с групировкой по местам
func (templ Templ) StorageByPlacePage(w http.ResponseWriter, storage []mytypes.StorageByPlaceCount, lable string) {
	type storagePage struct {
		Lable string
		Tab   []mytypes.StorageByPlaceCount
	}
	table := storagePage{lable, storage}

	t := template.Must(template.ParseFiles("Face/html/storageByPlace.html"))
	t.Execute(w, table)
}

// Генерация страницы склада устройств с группировкой помоделям и статусам(включая отгруженные)
func (templ Templ) StorageByTModelPage(w http.ResponseWriter, storage []mytypes.StorageByTModelClean, lable string) {
	type storagePage struct {
		Lable string
		Tab   []mytypes.StorageByTModelClean
	}
	table := storagePage{lable, storage}

	t := template.Must(template.ParseFiles("Face/html/storageByTModel.html"))
	t.Execute(w, table)
}

// Генерация страницы ввода текста
func (templ Templ) ImputPage(w http.ResponseWriter, postPath, title, imputText, btnText string) {

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

// Генерация страницы ввода значения фиксированного типа
func (templ Templ) ImputTypePage(w http.ResponseWriter, postPath, title, typein, imputText, btnText string) {

	type imputPage struct {
		Title     string
		InputText string
		BtnText   string
		PostPath  string
		Type      string
	}

	tmp := imputPage{title, imputText, btnText, postPath, typein}

	t := template.Must(template.ParseFiles("Face/html/insert_file.html"))
	t.Execute(w, tmp)
}

// Генерация страницы ввода текста и значения фиксированного типа
func (templ Templ) DobleImputPage(w http.ResponseWriter, postPath, title, imputText1, imputText2, type2, btnText, input2Data string) {

	type imputPage struct {
		Title      string
		InputText1 string
		InputText2 string
		Type2      string
		BtnText    string
		PostPath   string
		Input2Data string
	}

	tmp := imputPage{title, imputText1, imputText2, type2, btnText, postPath, input2Data}

	t := template.Must(template.ParseFiles("Face/html/dobleinsert.html"))
	t.Execute(w, tmp)
}

// Генерация страницы ввода двух значений фиксированного типа
func (templ Templ) DobleImputTypePage(w http.ResponseWriter, postPath, title, imputText1, type1, imputText2, type2, btnText string) {

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

// Генерация страницы с предупреждением
func (templ Templ) AlertPage(w http.ResponseWriter, status int, lable, heading, text, subText, btnText, btnLink string) {
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

// Генерация страницы приемки по моделям
func (templ Templ) TakeDeviceByModelPage(w http.ResponseWriter) {
	type idChoise struct {
		Id   int
		Name string
	}
	type Mach struct {
		TModel string
		DModel string
	}
	type TakeForm struct {
		TModels []idChoise
		DModels []idChoise
		Maching []Mach
	}

	var choise idChoise

	var tmodelList []idChoise
	rows, err := templ.Db.Db.Query(templ.ctx, `SELECT "tModelsId", "tModelsName" FROM public."tModels";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		tmodelList = append(tmodelList, choise)
	}

	var dmodelList []idChoise
	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "dModelsId", "dModelName" FROM public."dModels";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		dmodelList = append(dmodelList, choise)
	}

	var maching []Mach
	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "dModelName", "tModelsName" FROM "cleanModelMatching";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	var m Mach
	for rows.Next() {
		err := rows.Scan(&m.DModel, &m.TModel)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		maching = append(maching, m)
	}
	tmp := TakeForm{tmodelList, dmodelList, maching}
	t := template.Must(template.ParseFiles("Face/html/TakeDeviceByModel.html"))
	t.Execute(w, tmp)
}

// Генерация страницы создания заказа
func (templ Templ) CreateOrderPage(w http.ResponseWriter) {
	var page bool
	t := template.Must(template.ParseFiles("Face/html/CreateOrder.html"))
	t.Execute(w, page)
}

// Генерация страницы создания состава заказа
func (templ Templ) CreateOrderListPage(w http.ResponseWriter, ListId int, orderId int) {
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

	OrderList, err := templ.Db.TakeCleanOrderList(templ.ctx, orderId)
	if err != nil {
		OrderList = []mytypes.OrderListClean{}
	}

	var choise idChoise
	var tmodelList []idChoise
	rows, err := templ.Db.Db.Query(templ.ctx, `SELECT "tModelsId", "tModelsName" FROM public."tModels";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
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

// Генерация страницы пользователя
func (templ Templ) UserPage(w http.ResponseWriter, user mytypes.User) {
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
		btn = Buton{`<i class="bi bi-table"></i> ТМЦ`, "/works/tmc"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-search"></i> Поиск в ТМЦ`, "/works/tmcadvancesearch"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-house-fill"></i> Склад`, "/works/storage/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-search"></i> Поиск по Sn`, "/works/snsearch"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-house-fill-cutout"></i> Склад материалов`, "/works/storage/mats"}
		block.Btns = append(block.Btns, btn)

		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Сборки"
		btn = Buton{`<i class="bi bi-tools"></i> Сборки`, "/works/buildlist"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-lightbulb"></i> Можно собрать`, "/works/canbebuild"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-plus-lg"></i> Добавить сборку`, "/works/makebuild"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Модели T-KOM`, "/works/tmodels"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Модели поставщиков`, "/works/dmodels"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Маки"
		btn = Buton{`<i class="bi bi-gear-fill"></i> Изменить MAC адрес`, "/works/changemac"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Выпуск"
		btn = Buton{`<i class="bi bi-hammer"></i> Выпуск с производства`, "/works/releaseproduction"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-reply-fill"></i> Вернуть на склад`, "/works/returntostorage"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-person-fill-down"></i> Установить сборщика`, "/works/changeassembler"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Заказы"
		btn = Buton{`<i class="bi bi-briefcase-fill"></i> Заказы`, "/works/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-calendar-plus-fill"></i> Задать срок`, "/works/setpromdate"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "В работе"
		btn = Buton{`<i class="bi bi-table"></i> SN в работе`, "/works/tmc?Search=Clean&Condition=В работе"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-house-fill"></i> Модели в работе`, "/works/storage/models?Search=1&Condition=3"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Материалы в работе`, "/works/matsinwork"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Задачи"
		btn = Buton{`<i class="bi bi-card-list"></i> Задачи`, "/works/tasks"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-calendar-plus-fill"></i> Создать задачу`, "/works/createtask"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-graph-up"></i> Отчет о планировании производства`, "/works/planprodstorage"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-graph-up"></i> Отчет о планировании выроботки`, "/works/planreprodstorage"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-graph-up"></i> Отчет о планировании материалов`, "/works/planmatprodstorage"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

	case 2:
		block = Block{}
		block.Title = "Склад"
		btn = Buton{`<i class="bi bi-table"></i> ТМЦ`, "/works/tmc"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-search"></i> Поиск в ТМЦ`, "/works/tmcadvancesearch"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-house-fill"></i> Склад`, "/works/storage/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-search"></i> Поиск по Sn`, "/works/snsearch"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-pencil-fill"></i> Коментарий по Sn`, "/works/addcommentbysn"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-house-fill-cutout"></i> Склад материалов`, "/works/storage/mats"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Приемка"
		btn = Buton{`<i class="bi bi-plus-lg"></i> Приемка по моделям`, "/works/takedevicebymodel"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-filetype-xls"></i> Приемка файлом`, "/works/takedevicebyxlsx"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-reply-fill"></i> Возврат`, "/works/takedemo"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-plus-lg"></i> Принять материалы`, "/works/takemat"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Складская логистика"
		btn = Buton{`<i class="bi bi-hammer"></i> Передать в производство`, "/works/towork"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-box-arrow-in-down"></i> Установить место`, "/works/setplace"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-box-arrow-right"></i> Изменить № паллета`, "/works/cangeplacenum"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Заказы"
		btn = Buton{`<i class="bi bi-briefcase-fill"></i> Заказы`, "/works/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-tag-fill"></i> Назначить заказ/резерв`, "/works/setorder"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Отгрузки"
		btn = Buton{`<i class="bi bi-truck"></i> Отгрузка`, "/works/toship"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Сборки"
		btn = Buton{`<i class="bi bi-tools"></i> Сборки`, "/works/buildlist"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Модели T-KOM`, "/works/tmodels"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`Модели поставщиков`, "/works/dmodels"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Управление материалами"
		btn = Buton{`<i class="bi bi-file-earmark-plus-fill"></i> Добавить материал`, "/works/createmat"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

	case 3:
		block = Block{}
		block.Title = "Заказы"
		btn = Buton{`<i class="bi bi-file-earmark-plus-fill"></i> Создать заказ`, "/works/createorder"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-clipboard2-fill"></i> Мои заказы`, "/works/orders"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-briefcase-fill"></i> Все заказы`, "/works/orders"}
		block.Btns = append(block.Btns, btn)
		Blocks = append(Blocks, block)

		block = Block{}
		block.Title = "Склад"
		btn = Buton{`<i class="bi bi-table"></i> ТМЦ`, "/works/tmc"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-search"></i> Поиск в ТМЦ`, "/works/tmcadvancesearch"}
		block.Btns = append(block.Btns, btn)
		btn = Buton{`<i class="bi bi-house-fill"></i> Склад`, "/works/storage/orders"}
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

// Генерация страницы изменения пароля
func (templ Templ) ChangePassPage(w http.ResponseWriter, ans string, p1, p2, p3 string) {

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

// Генерация страницы создания материала
func (templ Templ) CreateMatPage(w http.ResponseWriter) {
	var page bool
	t := template.Must(template.ParseFiles("Face/html/CreateMat.html"))
	t.Execute(w, page)
}

// Генерация страницы приемки материала
func (templ Templ) TakeMatPage(w http.ResponseWriter) {
	type TakeForm struct {
		NameList   []string
		NameList1C []string
	}
	var NameList []string
	var NameList1C []string
	var Name string

	rows, err := templ.Db.Db.Query(templ.ctx, `SELECT "name" FROM public."matsName" GROUP BY name ORDER BY name;`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		NameList = append(NameList, Name)
	}

	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "1CName" FROM public."mats" GROUP BY "1CName" ORDER BY "1CName";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		NameList1C = append(NameList1C, Name)
	}

	tmp := TakeForm{NameList, NameList1C}
	t := template.Must(template.ParseFiles("Face/html/TakeMat.html"))
	t.Execute(w, tmp)
}

// Генерация страницы подробного склада материалов
func (templ Templ) StorageMatsPage(w http.ResponseWriter, user mytypes.User) {
	Mats, err := templ.Db.TakeMatsById(templ.ctx)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	type storagePage struct {
		Lable string
		Mats  []mytypes.Mat
		User  mytypes.User
	}
	table := storagePage{"Материалы", Mats, user}

	t := template.Must(template.ParseFiles("Face/html/storage_mats.html"))
	t.Execute(w, table)
}

// Генерация страницы склада материалов с групировкой по реальным моделям
func (templ Templ) StorageMatsByNamePage(w http.ResponseWriter) {
	Mats, err := templ.Db.TakeAmoutMatsByName(templ.ctx)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	type storagePage struct {
		Lable string
		Mats  []mytypes.Mat
	}
	table := storagePage{"Материалы", Mats}

	t := template.Must(template.ParseFiles("Face/html/storage_matsbyname.html"))
	t.Execute(w, table)
}

// Генерация страницы склада материалов с групировкой по наименованиям 1С
func (templ Templ) StorageMatsBy1CPage(w http.ResponseWriter) {
	Mats, err := templ.Db.TakeAmoutMatsBy1C(templ.ctx)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	type storagePage struct {
		Lable string
		Mats  []mytypes.Mat
	}
	table := storagePage{"Материалы", Mats}

	t := template.Must(template.ParseFiles("Face/html/storage_matsby1c.html"))
	t.Execute(w, table)
}

// Генерация страницы создания новой сборки
func (templ Templ) CreateBuildPage(w http.ResponseWriter) {
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

	rows, err := templ.Db.Db.Query(templ.ctx, `SELECT "tModelsName" FROM "tModels" ORDER BY "tModelsName"`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		ModelListT = append(ModelListT, Name)
	}

	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "dModelName" FROM "dModels" ORDER BY "dModelName"`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		ModelListD = append(ModelListD, Name)
	}

	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '1'`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		CaseList = append(CaseList, choise)
	}

	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '2'`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		StikerList = append(StikerList, choise)
	}

	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '3'`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		BoxList = append(BoxList, choise)
	}

	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '4'`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		BoxholderList = append(BoxholderList, choise)
	}

	rows, err = templ.Db.Db.Query(templ.ctx, `SELECT "matNameId", name FROM public."matsName" WHERE type = '7'`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		AnotherList = append(AnotherList, choise)
	}

	tmp := TakeForm{ModelListT, ModelListD, CaseList, StikerList, BoxList, BoxholderList, AnotherList}
	t := template.Must(template.ParseFiles("Face/html/MakeBuild.html"))
	t.Execute(w, tmp)
}

// Генерация страницы сборок (корточки)
func (templ Templ) BuildsPage(w http.ResponseWriter, builds []mytypes.BuildClean) {
	type BPage struct {
		Build    mytypes.BuildClean
		Canbuild int
	}

	canbuld, err := templ.Db.TakeCanBuildMap(templ.ctx)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	var table []BPage

	for _, build := range builds {
		table = append(table, BPage{Build: build, Canbuild: canbuld[build.Id]})
	}
	t := template.Must(template.ParseFiles("Face/html/builds.html"))
	t.Execute(w, table)
}

// Генерация страницы моделей T-KOM
func (templ Templ) TModelsPage(w http.ResponseWriter, TModels []mytypes.TModel) {
	type TModelsPage struct {
		Tab []mytypes.TModel
	}
	table := TModelsPage{Tab: TModels}

	t := template.Must(template.ParseFiles("Face/html/tmodels.html"))
	t.Execute(w, table)
}

// Генерация страницы модели T-KOM
func (templ Templ) TModelPage(w http.ResponseWriter, TModel mytypes.TModel, builds []mytypes.BuildClean) {
	type Page struct {
		Model  mytypes.TModel
		Builds []mytypes.BuildClean
	}

	tmp := Page{Model: TModel, Builds: builds}
	t := template.Must(template.ParseFiles("Face/html/tmodel.html"))
	t.Execute(w, tmp)
}

// Генерация страницы материалов в работе
func (templ Templ) StorageMatsInWorkPage(w http.ResponseWriter) {
	Mats, err := templ.Db.TakeMatsInWorkById(templ.ctx)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	type storagePage struct {
		Lable string
		Mats  []mytypes.Mat
	}
	table := storagePage{"Материалы", Mats}

	t := template.Must(template.ParseFiles("Face/html/storage_matsinwork.html"))
	t.Execute(w, table)
}

// Генерация страницы моделей поставщиков
func (templ Templ) DModelsPage(w http.ResponseWriter, DModels []mytypes.DModel) {
	type DModelsPage struct {
		Tab []mytypes.DModel
	}
	table := DModelsPage{Tab: DModels}
	t := template.Must(template.ParseFiles("Face/html/dmodels.html"))
	t.Execute(w, table)
}

// Генерация страницы модели поставщика
func (templ Templ) DModelPage(w http.ResponseWriter, DModel mytypes.DModel, builds []mytypes.BuildClean) {
	type Page struct {
		Model  mytypes.DModel
		Builds []mytypes.BuildClean
	}
	tmp := Page{Model: DModel, Builds: builds}
	t := template.Must(template.ParseFiles("Face/html/dmodel.html"))
	t.Execute(w, tmp)
}

// Генерация страницы утверждения сборки во время преобразования
func (templ Templ) BuildAceptPage(w http.ResponseWriter, builds []mytypes.BuildClean, inSn ...string) {
	type BPage struct {
		Builds []mytypes.BuildClean
		InSn   []string
	}

	table := BPage{Builds: builds, InSn: inSn}
	t := template.Must(template.ParseFiles("Face/html/builds_acept.html"))
	t.Execute(w, table)
}

// Генерация страницы событий материала
func (templ Templ) MatEventPage(w http.ResponseWriter, events []mytypes.MatEventClean, lable string) {
	type storagePage struct {
		Lable string
		Tab   []mytypes.MatEventClean
	}
	table := storagePage{lable, events}

	t := template.Must(template.ParseFiles("Face/html/mateventpage.html"))
	t.Execute(w, table)
}

// Генерация страницы календаря
func (templ Templ) CalendarPage(w http.ResponseWriter, tasks []mytypes.TaskJs) {
	t := template.Must(template.ParseFiles("Face/html/calendar.html"))
	t.Execute(w, tasks)
}

// Генерация страницы календаря (список)
func (templ Templ) CalendarListPage(w http.ResponseWriter, tasks []mytypes.TaskJs) {

	t := template.Must(template.ParseFiles("Face/html/calendarlist.html"))

	t.Execute(w, tasks)
}

// Генерация страницы создания задачи
func (templ Templ) CreateTaskPage(w http.ResponseWriter) {
	t := template.Must(template.ParseFiles("Face/html/CreateTask.html"))
	t.Execute(w, 1)
}

// Генерация страницы создания состава задачи
func (templ Templ) CreateTaskListPage(w http.ResponseWriter, taskId int, redElementId int) {
	type idChoise struct {
		Id   int
		Name string
	}
	type TakeForm struct {
		Task       mytypes.CleanTask
		TModels    []idChoise
		RedElement mytypes.CleanTaskWorkList
	}

	task, err := templ.Db.TakeCleanTasksById(templ.ctx, taskId)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения задачи", err.Error(), "Главная", "/works/prof")
		return
	}
	if len(task) != 1 {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения задачи", strconv.Itoa(len(task)), "Главная", "/works/prof")
		return
	}

	var choise idChoise
	var tmodelList []idChoise
	rows, err := templ.Db.Db.Query(templ.ctx, `SELECT "tModelsId", "tModelsName" FROM public."tModels";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		tmodelList = append(tmodelList, choise)
	}

	var redElement mytypes.CleanTaskWorkList
	if redElementId >= 0 {
		rows, err := templ.Db.Db.Query(templ.ctx, `SELECT id, tmodel, amout, done, datechange FROM public."CleanTaskWorkList" WHERE "id" = $1;`, redElementId)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		for rows.Next() {
			err := rows.Scan(&redElement.Id, &redElement.TModel, &redElement.Amout, &redElement.Done, &redElement.Date)
			if err != nil {
				templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
				return
			}
		}
	} else {
		redElement.Id = -1
	}

	tmp := TakeForm{task[0], tmodelList, redElement}

	t := template.Must(template.ParseFiles("Face/html/CreateTaskList.html"))
	t.Execute(w, tmp)
}

// Генерация страницы задач (карточки)
func (templ Templ) TasksPage(w http.ResponseWriter, tasks []mytypes.CleanTask) {
	type BPage struct {
		Tasks []mytypes.CleanTask
	}

	table := BPage{Tasks: tasks}
	t := template.Must(template.ParseFiles("Face/html/tasks.html"))
	t.Execute(w, table)
}

// Генерация страницы изменения задачи
func (templ Templ) ChangeTaskPage(w http.ResponseWriter, taskId string) {
	tasks, err := templ.Db.TakeJsTaskByReqest(templ.ctx, "WHERE id = '"+taskId+"'")
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	if len(tasks) != 1 {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка поиска", "", "Главная", "/works/prof")
		return
	}
	t := template.Must(template.ParseFiles("Face/html/ChangeTask.html"))
	t.Execute(w, tasks[0])
}

// Генерация страницы задачи
func (templ Templ) TaskPage(w http.ResponseWriter, taskId int) {
	type taskPage struct {
		Task    mytypes.CleanTask
		MatList []mytypes.BuildListElementClean
	}
	tasks, err := templ.Db.TakeCleanTasksById(templ.ctx, taskId)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}
	if len(tasks) != 1 {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка поиска", "", "Главная", "/works/prof")
		return
	}

	matList, err := templ.Db.TakeCleanMatForTask(templ.ctx, taskId)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	TaskPage := taskPage{
		Task:    tasks[0],
		MatList: matList,
	}

	t := template.Must(template.ParseFiles("Face/html/task.html"))
	t.Execute(w, TaskPage)
}

// Генерация страницы отчета (колво готовой продукции на складе через 1, 2, 3 месяца исходя из задач)
func (templ Templ) PlanProdStoragePage(w http.ResponseWriter) {
	type prodStorage struct {
		Name    string
		Current int
		Done1   int
		Plan1   int
		Done2   int
		Plan2   int
		Done3   int
		Plan3   int
	}

	qq := `SELECT
	stor."tModelsName",
	stor.amout,
	(COALESCE(monthone.amout, 0) - COALESCE(monthone.done, 0)) AS plan1,
	(COALESCE(monthone.amout, 0) - COALESCE(monthone.done, 0)) + stor.amout AS done1,
	(COALESCE(monthto.amout, 0) - COALESCE(monthto.done, 0)) AS plan2,
	(COALESCE(monthto.amout, 0) - COALESCE(monthto.done, 0)) + (COALESCE(monthone.amout, 0) - COALESCE(monthone.done, 0)) + stor.amout AS done2,
	(COALESCE(monththre.amout, 0) - COALESCE(monththre.done, 0)) AS plan3,
	(COALESCE(monththre.amout, 0) - COALESCE(monththre.done, 0)) + (COALESCE(monthto.amout, 0) - COALESCE(monthto.done, 0)) + (COALESCE(monthone.amout, 0) - COALESCE(monthone.done, 0)) + stor.amout AS done3
FROM
	(SELECT
		"tModels"."tModelsId",
	 	"tModels"."tModelsName",
		count(snsn.sn) AS amout
	FROM "tModels"
		LEFT JOIN (SELECT sn, tmodel FROM sns WHERE condition = 1 AND shiped = false)snsn ON snsn.tmodel = "tModels"."tModelsId"
	GROUP BY "tModelsId")stor
	LEFT JOIN 
		(SELECT 
			"taskWorkList".tmodel, 
			sum("taskWorkList".amout) AS amout, 
			sum("taskWorkList".done) AS done
		FROM public."taskWorkList"
			LEFT JOIN tasks ON tasks.id = "taskWorkList"."taskId"
		WHERE dateend >= CURRENT_DATE AND dateend <= date_trunc('month',CURRENT_DATE + '1 month'::interval)
		GROUP BY tmodel
		)monthone ON monthone.tmodel = stor."tModelsId"
	LEFT JOIN
		(SELECT 
			"taskWorkList".tmodel, 
			sum("taskWorkList".amout) AS amout, 
			sum("taskWorkList".done) AS done
		FROM public."taskWorkList"
			LEFT JOIN tasks ON tasks.id = "taskWorkList"."taskId"
		WHERE dateend > date_trunc('month',CURRENT_DATE + '1 month'::interval) AND dateend <= date_trunc('month',CURRENT_DATE + '2 month'::interval)
		GROUP BY tmodel
		)monthto ON monthto.tmodel = stor."tModelsId"
	LEFT JOIN
		(SELECT 
			"taskWorkList".tmodel, 
			sum("taskWorkList".amout) AS amout, 
			sum("taskWorkList".done) AS done
		FROM public."taskWorkList"
			LEFT JOIN tasks ON tasks.id = "taskWorkList"."taskId"
		WHERE dateend > date_trunc('month',CURRENT_DATE + '2 month'::interval) AND dateend <= date_trunc('month',CURRENT_DATE + '3 month'::interval)
		GROUP BY tmodel
		)monththre ON monththre.tmodel = stor."tModelsId"
ORDER BY "tModelsName"`

	temp := []prodStorage{}
	data := prodStorage{}
	rows, err := templ.Db.Db.Query(templ.ctx, qq)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&data.Name, &data.Current, &data.Plan1, &data.Done1, &data.Plan2, &data.Done2, &data.Plan3, &data.Done3)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
			return
		}
		temp = append(temp, data)
	}

	t := template.Must(template.ParseFiles("Face/html/storage_planprd.html"))
	t.Execute(w, temp)
}

// Генерация страницы отчета (кол-во не произведенной продукции на складе через 1, 2, 3 месяца исходя из задач)
func (templ Templ) PlanReProdStoragePage(w http.ResponseWriter) {
	type prodStorage struct {
		Name    string
		Current int
		Done1   int
		Plan1   int
		Done2   int
		Plan2   int
		Done3   int
		Plan3   int
	}

	qq := `SELECT
		stor."dModelName",
		stor.amout,
		0 - (COALESCE(dmonthone.amout, 0) - COALESCE(dmonthone.done, 0)) AS plan1,
		(COALESCE(dmonthone.done, 0) - COALESCE(dmonthone.amout, 0)) + stor.amout AS done1,
		0 - (COALESCE(dmonthto.amout, 0) - COALESCE(dmonthto.done, 0)) AS plan2,
		(((COALESCE(dmonthone.done, 0) - COALESCE(dmonthone.amout, 0)) + stor.amout) - (COALESCE(dmonthto.amout, 0) - COALESCE(dmonthto.done, 0))) AS done2,
		0 - (COALESCE(dmonththre.amout, 0) - COALESCE(dmonththre.done, 0)) AS plan3,
		((((COALESCE(dmonthone.done, 0) - COALESCE(dmonthone.amout, 0)) + stor.amout) - (COALESCE(dmonthto.amout, 0) - COALESCE(dmonthto.done, 0))) - (COALESCE(dmonththre.amout, 0) - COALESCE(dmonththre.done, 0))) AS done3
	FROM
		(SELECT
			"dModels"."dModelsId",
			"dModels"."dModelName",
			count(snsn.sn) AS amout
		FROM "dModels"
			LEFT JOIN (SELECT sn, dmodel FROM sns WHERE condition = 2 AND shiped = false)snsn ON snsn.dmodel = "dModels"."dModelsId"
		GROUP BY "dModelsId")stor
		LEFT JOIN
		(SELECT 
			COALESCE(eq."dModel", 0) AS dmodel,
			SUM(monthone.amout) AS amout,
			SUM(monthone.done) AS done
		FROM
		(SELECT 
			"taskWorkList".tmodel, 
			sum("taskWorkList".amout) AS amout, 
			sum("taskWorkList".done) AS done
		FROM public."taskWorkList"
			LEFT JOIN tasks ON tasks.id = "taskWorkList"."taskId"
		WHERE dateend >= CURRENT_DATE AND dateend <= date_trunc('month',CURRENT_DATE + '1 month'::interval)
		GROUP BY tmodel
		)monthone
		LEFT JOIN
			(SELECT 
				"dModels"."dModelsId",
				builds."dModel",
				builds."tModel"
			FROM "dModels"
				LEFT JOIN builds on builds."buildId" = "dModels"."build")eq ON monthone.tmodel = eq."tModel"
		GROUP BY dmodel)dmonthone ON dmonthone.dmodel = stor."dModelsId"
		LEFT JOIN 
		(SELECT 
			COALESCE(eq."dModel", 0) AS dmodel,
			SUM(monthone.amout) AS amout,
			SUM(monthone.done) AS done
		FROM
		(SELECT 
			"taskWorkList".tmodel, 
			sum("taskWorkList".amout) AS amout, 
			sum("taskWorkList".done) AS done
		FROM public."taskWorkList"
			LEFT JOIN tasks ON tasks.id = "taskWorkList"."taskId"
		WHERE dateend > date_trunc('month',CURRENT_DATE + '1 month'::interval) AND dateend <= date_trunc('month',CURRENT_DATE + '2 month'::interval)
		GROUP BY tmodel
		)monthone
		LEFT JOIN
			(SELECT 
				"dModels"."dModelsId",
				builds."dModel",
				builds."tModel"
			FROM "dModels"
				LEFT JOIN builds on builds."buildId" = "dModels"."build")eq ON monthone.tmodel = eq."tModel"
		GROUP BY dmodel)dmonthto ON dmonthto.dmodel = stor."dModelsId"
		LEFT JOIN 
		(SELECT 
			COALESCE(eq."dModel", 0) AS dmodel,
			SUM(monthone.amout) AS amout,
			SUM(monthone.done) AS done
		FROM
		(SELECT 
			"taskWorkList".tmodel, 
			sum("taskWorkList".amout) AS amout, 
			sum("taskWorkList".done) AS done
		FROM public."taskWorkList"
			LEFT JOIN tasks ON tasks.id = "taskWorkList"."taskId"
		WHERE dateend > date_trunc('month',CURRENT_DATE + '2 month'::interval) AND dateend <= date_trunc('month',CURRENT_DATE + '3 month'::interval)
		GROUP BY tmodel
		)monthone
		LEFT JOIN
			(SELECT 
				"dModels"."dModelsId",
				builds."dModel",
				builds."tModel"
			FROM "dModels"
				LEFT JOIN builds on builds."buildId" = "dModels"."build")eq ON monthone.tmodel = eq."tModel"
		GROUP BY dmodel)dmonththre ON dmonththre.dmodel = stor."dModelsId"
	ORDER BY stor."dModelName"`

	temp := []prodStorage{}
	data := prodStorage{}
	rows, err := templ.Db.Db.Query(templ.ctx, qq)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&data.Name, &data.Current, &data.Plan1, &data.Done1, &data.Plan2, &data.Done2, &data.Plan3, &data.Done3)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
			return
		}
		temp = append(temp, data)
	}

	t := template.Must(template.ParseFiles("Face/html/storage_planprd.html"))
	t.Execute(w, temp)
}

// Генерация страницы отчета (кол-во не произведенной продукции на складе через 1, 2, 3 месяца исходя из задач)
func (templ Templ) PlanMatProdStoragePage(w http.ResponseWriter) {
	type prodStorage struct {
		Name    string
		Current int
		Done1   int
		Plan1   int
		Done2   int
		Plan2   int
		Done3   int
		Plan3   int
	}

	qq := `SELECT 
		"matsByName".name,
		"matsByName".sum,
		COALESCE(month1.amout,0)AS plan1,
		"matsByName".sum - (COALESCE(month1.amout, 0)) AS done1,
		COALESCE(month2.amout,0)AS plan2,
		"matsByName".sum - ((COALESCE(month1.amout, 0)) + (COALESCE(month2.amout, 0))) AS done2,
		COALESCE(month3.amout,0)AS plan3,
		"matsByName".sum - ((COALESCE(month1.amout, 0)) + (COALESCE(month2.amout, 0)) + (COALESCE(month3.amout, 0))) AS done3
	FROM "matsByName"
	LEFT JOIN (
		SELECT "buildMatList".AMOUT * SUM(BUILDEQ.AMOUT) AS AMOUT,
			"buildMatList".MAT,
			"matsName".NAME
		FROM PUBLIC."buildMatList"
		INNER JOIN
			(SELECT COALESCE(EQ."build",-1) AS BUILD,
					SUM(MONTHONE.AMOUT) - SUM(MONTHONE.DONE) AS AMOUT
				FROM
					(SELECT "taskWorkList".TMODEL,
							SUM("taskWorkList".AMOUT) AS AMOUT,
							SUM("taskWorkList".DONE) AS DONE
						FROM PUBLIC."taskWorkList"
						LEFT JOIN TASKS ON TASKS.ID = "taskWorkList"."taskId"
						WHERE dateend >= CURRENT_DATE AND dateend <= date_trunc('month',CURRENT_DATE + '1 month'::interval) /*условие выбора задач*/
						GROUP BY TMODEL)MONTHONE
				LEFT JOIN
					(SELECT "dModels"."build",
							BUILDS."tModel"
						FROM "dModels"
						LEFT JOIN BUILDS ON BUILDS."buildId" = "dModels"."build")EQ ON MONTHONE.TMODEL = EQ."tModel"
				GROUP BY BUILD)BUILDEQ ON BUILDEQ.BUILD = "buildMatList"."billdId"
		LEFT JOIN PUBLIC."matsName" ON "matsName"."matNameId" = "buildMatList".MAT
		GROUP BY MAT,"buildMatList".AMOUT, NAME)month1 ON month1.name = "matsByName".name
	LEFT JOIN (
		SELECT "buildMatList".AMOUT * SUM(BUILDEQ.AMOUT) AS AMOUT,
			"buildMatList".MAT,
			"matsName".NAME
		FROM PUBLIC."buildMatList"
		INNER JOIN
			(SELECT COALESCE(EQ."build",-1) AS BUILD,
					SUM(MONTHONE.AMOUT) - SUM(MONTHONE.DONE) AS AMOUT
				FROM
					(SELECT "taskWorkList".TMODEL,
							SUM("taskWorkList".AMOUT) AS AMOUT,
							SUM("taskWorkList".DONE) AS DONE
						FROM PUBLIC."taskWorkList"
						LEFT JOIN TASKS ON TASKS.ID = "taskWorkList"."taskId"
						WHERE dateend > date_trunc('month',CURRENT_DATE + '1 month'::interval) AND dateend <= date_trunc('month',CURRENT_DATE + '2 month'::interval) /*условие выбора задач*/
						GROUP BY TMODEL)MONTHONE
				LEFT JOIN
					(SELECT "dModels"."build",
							BUILDS."tModel"
						FROM "dModels"
						LEFT JOIN BUILDS ON BUILDS."buildId" = "dModels"."build")EQ ON MONTHONE.TMODEL = EQ."tModel"
				GROUP BY BUILD)BUILDEQ ON BUILDEQ.BUILD = "buildMatList"."billdId"
		LEFT JOIN PUBLIC."matsName" ON "matsName"."matNameId" = "buildMatList".MAT
		GROUP BY MAT,"buildMatList".AMOUT, NAME)month2 ON month2.name = "matsByName".name
	LEFT JOIN (
		SELECT "buildMatList".AMOUT * SUM(BUILDEQ.AMOUT) AS AMOUT,
			"buildMatList".MAT,
			"matsName".NAME
		FROM PUBLIC."buildMatList"
		INNER JOIN
			(SELECT COALESCE(EQ."build",-1) AS BUILD,
					SUM(MONTHONE.AMOUT) - SUM(MONTHONE.DONE) AS AMOUT
				FROM
					(SELECT "taskWorkList".TMODEL,
							SUM("taskWorkList".AMOUT) AS AMOUT,
							SUM("taskWorkList".DONE) AS DONE
						FROM PUBLIC."taskWorkList"
						LEFT JOIN TASKS ON TASKS.ID = "taskWorkList"."taskId"
						WHERE dateend > date_trunc('month',CURRENT_DATE + '2 month'::interval) AND dateend <= date_trunc('month',CURRENT_DATE + '3 month'::interval) /*условие выбора задач*/
						GROUP BY TMODEL)MONTHONE
				LEFT JOIN
					(SELECT "dModels"."build",
							BUILDS."tModel"
						FROM "dModels"
						LEFT JOIN BUILDS ON BUILDS."buildId" = "dModels"."build")EQ ON MONTHONE.TMODEL = EQ."tModel"
				GROUP BY BUILD)BUILDEQ ON BUILDEQ.BUILD = "buildMatList"."billdId"
		LEFT JOIN PUBLIC."matsName" ON "matsName"."matNameId" = "buildMatList".MAT
		GROUP BY MAT,"buildMatList".AMOUT, NAME)month3 ON month3.name = "matsByName".name
	ORDER BY name`

	temp := []prodStorage{}
	data := prodStorage{}
	rows, err := templ.Db.Db.Query(templ.ctx, qq)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		return
	}
	for rows.Next() {
		err := rows.Scan(&data.Name, &data.Current, &data.Plan1, &data.Done1, &data.Plan2, &data.Done2, &data.Plan3, &data.Done3)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
			return
		}
		temp = append(temp, data)
	}

	t := template.Must(template.ParseFiles("Face/html/storage_planprd.html"))
	t.Execute(w, temp)
}

func (templ Templ) ReservCalendarPage(w http.ResponseWriter, reservs []mytypes.ReservTaskJS, snsId int) {
	type reservcall struct {
		Reservs []mytypes.ReservTaskJS
		SnsId   int
	}
	call := reservcall{Reservs: reservs, SnsId: snsId}
	t := template.Must(template.ParseFiles("Face/html/Reserv calendar.html"))
	t.Execute(w, call)
}

func (templ Templ) CreateReservPage(w http.ResponseWriter, snsId string) {
	t := template.Must(template.ParseFiles("Face/html/CreateReserv.html"))
	t.Execute(w, snsId)
}

func (templ Templ) CanBeBuildPage(w http.ResponseWriter) {
	type canByild struct {
		Name  string
		Build int
		Amout int
	}

	type Page struct {
		AllD     []canByild
		CurrentD []canByild
		AllT     []canByild
		CurrentT []canByild
	}

	var allbuildsD []canByild
	qq := `SELECT "dModel", "buildId", amout FROM "cleanCanbebuilded"`

	rows, err := templ.Db.Db.Query(templ.ctx, qq)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		var element canByild
		err := rows.Scan(&element.Name, &element.Build, &element.Amout)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
			return
		}
		allbuildsD = append(allbuildsD, element)
	}

	qq = `SELECT "dModel", "buildId", amout FROM "cleanCurrentcanbebuilded"`
	var currentBuildsD []canByild
	rows, err = templ.Db.Db.Query(templ.ctx, qq)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		var element canByild
		err := rows.Scan(&element.Name, &element.Build, &element.Amout)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
			return
		}
		currentBuildsD = append(currentBuildsD, element)
	}

	var allbuildsT []canByild
	qq = `SELECT "tModel", "buildId", amout FROM "cleanCanbebuilded"`

	rows, err = templ.Db.Db.Query(templ.ctx, qq)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		var element canByild
		err := rows.Scan(&element.Name, &element.Build, &element.Amout)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
			return
		}
		allbuildsT = append(allbuildsT, element)
	}

	qq = `SELECT "tModel", "buildId", amout FROM "cleanCurrentcanbebuilded"`
	var currentBuildsT []canByild
	rows, err = templ.Db.Db.Query(templ.ctx, qq)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		var element canByild
		err := rows.Scan(&element.Name, &element.Build, &element.Amout)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
			return
		}
		currentBuildsT = append(currentBuildsT, element)
	}

	page := Page{AllD: allbuildsD, CurrentD: currentBuildsD, AllT: allbuildsT, CurrentT: currentBuildsT}

	t := template.Must(template.ParseFiles("Face/html/canbebuilded.html"))
	t.Execute(w, page)
}

func (templ Templ) CanBeBuildOrdersPage(w http.ResponseWriter) {

	type CanOrder struct {
		BuildID int
		DModel  string
		TModel  string
		InOrder int
		Amout   int
	}

	type orders struct {
		Id   int
		Name string
		Tab  []CanOrder
	}

	qq := `SELECT "orderId", name FROM public.orders WHERE "isAct" = true`

	rows, err := templ.Db.Db.Query(templ.ctx, qq)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
		return
	}

	var OrdersList []orders
	for rows.Next() {
		var element orders
		err := rows.Scan(&element.Id, &element.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
			return
		}

		var allbuilds []CanOrder

		qqq := `SELECT builds."buildId",
			"dModels"."dModelName",
			"tModels"."tModelsName",
			ordermodel.amout AS inorder,
			LEAST(COALESCE(modelcount.count, 0::bigint), COALESCE(matcount.minmat, 0::bigint)) AS amout
		FROM builds
			LEFT JOIN ( SELECT sns.dmodel,
					count(sns."snsId") AS count
				FROM sns
				WHERE sns.condition = 2 AND sns.shiped = false AND sns.order = $1
				GROUP BY sns.dmodel) modelcount ON builds."dModel" = modelcount.dmodel
			LEFT JOIN ( SELECT "buildMatList"."billdId" AS build,
					min(matsamout.sum / "buildMatList".amout) AS minmat
				FROM "buildMatList"
					LEFT JOIN ( SELECT mats.name,
							sum(mats.amout) AS sum
						FROM mats
						GROUP BY mats.name) matsamout ON "buildMatList".mat = matsamout.name
				GROUP BY "buildMatList"."billdId") matcount ON matcount.build = builds."buildId"
				INNER JOIN (SELECT model, amout FROM "orderList"
						WHERE "orderId" = $1 )ordermodel ON ordermodel.model = builds."tModel"
						INNER JOIN "dModels" ON "dModels".build = builds."buildId"
		LEFT JOIN "tModels" ON "tModels"."tModelsId" = builds."tModel"
		WHERE builds."buildId" <> '-1'::integer `

		rows, err := templ.Db.Db.Query(templ.ctx, qqq, element.Id)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Ошибка получения данных", err.Error(), "Главная", "/works/prof")
			return
		}

		for rows.Next() {
			var element CanOrder
			rows.Scan(&element.BuildID, &element.DModel, &element.TModel, &element.InOrder, &element.Amout)

			allbuilds = append(allbuilds, element)
		}

		element.Tab = allbuilds
		OrdersList = append(OrdersList, element)
	}

	t := template.Must(template.ParseFiles("Face/html/canbebuildedOrders.html"))
	t.Execute(w, OrdersList)
}

func (templ Templ) DraftPage(w http.ResponseWriter, drafts []mytypes.DraftClean, redId int) {

	type idChoise struct {
		Id   int
		Name string
	}

	type ExtendedDraft struct {
		Draft           mytypes.DraftClean
		CanBuildCurrent []mytypes.CanBuild
		DoneFree        int
		BlackFree       int
	}
	type DraftPage struct {
		List       []ExtendedDraft
		TModels    []idChoise
		RedElement mytypes.DraftClean
	}

	var choise idChoise
	var tmodelList []idChoise
	rows, err := templ.Db.Db.Query(templ.ctx, `SELECT "tModelsId", "tModelsName" FROM public."tModels" ORDER BY "tModelsName";`)
	if err != nil {
		templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
		return
	}

	for rows.Next() {
		err := rows.Scan(&choise.Id, &choise.Name)
		if err != nil {
			templ.AlertPage(w, 5, "Ошибка", "Ошибка", "Непредвиденная ошибка", err.Error(), "Главная", "/works/prof")
			return
		}
		tmodelList = append(tmodelList, choise)
	}

	var redElement mytypes.DraftClean
	if redId != -1 {
		for _, a := range drafts {
			if a.Id == redId {
				redElement = a
			}
		}
	} else {
		redElement = mytypes.DraftClean{Id: -1, DraftId: -1, Model: -1, Amout: 0}
	}

	var ExtendedDrafts []ExtendedDraft
	for _, draft := range drafts {

		canBuildCurrent, err := templ.Db.TakeCanBuildByOrderTmodel(templ.ctx, 2, draft.Model, true)
		if err != nil {
			canBuildCurrent = []mytypes.CanBuild{}
		}

		var doneFree int
		err = templ.Db.Db.QueryRow(templ.ctx, `SELECT count("snsId") FROM public.sns WHERE tmodel = $1 AND condition = 1 AND "order" = 1 AND shiped = false`, draft.Model).Scan(&doneFree)
		if err != nil {
			doneFree = 0
		}

		var blackFree int
		err = templ.Db.Db.QueryRow(templ.ctx, `SELECT count("snsId") FROM public.sns WHERE tmodel = $1 AND condition = 2 AND "order" = 2 AND shiped = false`, draft.Model).Scan(&blackFree)
		if err != nil {
			blackFree = 0
		}

		element := ExtendedDraft{Draft: draft, CanBuildCurrent: canBuildCurrent, DoneFree: doneFree, BlackFree: blackFree}
		ExtendedDrafts = append(ExtendedDrafts, element)
	}

	tmp := DraftPage{List: ExtendedDrafts, TModels: tmodelList, RedElement: redElement}
	t := template.Must(template.ParseFiles("Face/html/Draft.html"))
	t.Execute(w, tmp)
}

func (templ Templ) DocsPage(w http.ResponseWriter, mainDocs []mytypes.Document, otherDocs []mytypes.Document, privateDocs []mytypes.Document) {

	type DocAndId struct {
		Doc mytypes.Document
		Id  string
	}

	type Page struct {
		OtherDocs   []DocAndId
		MainDocs    []DocAndId
		PrivateDocs []DocAndId
	}
	var OtherDocsAndId []DocAndId
	for _, doc := range otherDocs {
		strinId := doc.Id.Hex()
		OtherDocsAndId = append(OtherDocsAndId, DocAndId{Doc: doc, Id: strinId})
	}

	var MainDocsAndId []DocAndId
	for _, doc := range mainDocs {
		strinId := doc.Id.Hex()
		MainDocsAndId = append(MainDocsAndId, DocAndId{Doc: doc, Id: strinId})
	}

	var PrivateDocsAndId []DocAndId
	for _, doc := range privateDocs {
		strinId := doc.Id.Hex()
		PrivateDocsAndId = append(PrivateDocsAndId, DocAndId{Doc: doc, Id: strinId})
	}

	tmp := Page{OtherDocs: OtherDocsAndId, MainDocs: MainDocsAndId, PrivateDocs: PrivateDocsAndId}
	t := template.Must(template.ParseFiles("Face/html/DocsPage.html"))
	t.Execute(w, tmp)
}

func (templ Templ) DocPage(w http.ResponseWriter, doc mytypes.Document, docId string, docType string) {
	type Page struct {
		Doc  mytypes.Document
		Id   string
		Type string
	}
	t := template.Must(template.ParseFiles("Face/html/DocPage.html"))
	t.Execute(w, Page{Doc: doc, Id: docId, Type: docType})
}

func (templ Templ) DocCreatePage(w http.ResponseWriter) {

	t := template.Must(template.ParseFiles("Face/html/DocCreatePage.html"))
	t.Execute(w, nil)
}

func (templ Templ) EditDocPage(w http.ResponseWriter, doc mytypes.Document, docId string, docType string) {

	type Page struct {
		Doc  mytypes.Document
		Id   string
		Type string
	}
	t := template.Must(template.ParseFiles("Face/html/ChangeDocPage.html"))
	t.Execute(w, Page{Doc: doc, Id: docId, Type: docType})
}

func (templ Templ) ChangeAssemblerPage(w http.ResponseWriter) {
	type Assembler struct {
		Id   int
		Name string
	}

	var Assemblers []Assembler

	rows, err := templ.Db.Db.Query(templ.ctx, `SELECT userid, name FROM public.users WHERE access = 1;`)
	if err != nil {
		return
	}
	for rows.Next() {
		var assembler Assembler
		err := rows.Scan(&assembler.Id, &assembler.Name)
		if err != nil {
			return
		}
		Assemblers = append(Assemblers, assembler)
	}

	t := template.Must(template.ParseFiles("Face/html/changeAssembler.html"))
	t.Execute(w, Assemblers)
}
