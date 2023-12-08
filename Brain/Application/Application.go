package Application

import (
	"T-Base/Brain/Auth"
	PageTempl "T-Base/Brain/PageTemplates"
	"T-Base/Brain/Storage"
	"T-Base/Brain/mytypes"
	"context"
	"io"
	"log"
	"mime/multipart"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"time"

	"github.com/julienschmidt/httprouter"
)

// Объект приложения
type App struct {
	Ctx    context.Context
	Db     *Storage.Base
	Templ  *PageTempl.Templ
	JwtKey []byte
	AppIp  string
}

type HandleUser func(http.ResponseWriter, *http.Request, httprouter.Params, mytypes.User)

// Инициализация приложения
func NewApp(ctx context.Context, jwtKey []byte, user, pass, ip, baseName, appIp string) (*App, error) {
	db, err := Storage.NewBase(user, pass, ip, baseName)
	templ := PageTempl.NewTempl(ctx, db)

	return &App{ctx, db, templ, jwtKey, appIp}, err
}

// Роутер
func (a App) Routs(r *httprouter.Router) {
	// открытые пути
	r.ServeFiles("/works/Face/*filepath", http.Dir("Face"))
	r.ServeFiles("/works/device/Face/*filepath", http.Dir("Face"))
	r.ServeFiles("/works/order/Face/*filepath", http.Dir("Face"))
	r.ServeFiles("/works/storage/Face/*filepath", http.Dir("Face"))
	r.GET("/", a.startPage)
	r.GET("/works/login", func(w http.ResponseWriter, r *http.Request, pr httprouter.Params) { a.LoginPage(w, "") })
	r.GET("/works/home", a.homePage)

	r.POST("/works/login", a.Login)
	r.GET("/works/Logout", Auth.Logout)
	r.POST("/works/Logout", Auth.Logout)

	// пути требующие авторизацию
	r.GET("/works/prof", a.authtorized(a.UserPage))
	r.GET("/works/device/mini", a.authtorized(a.DeviceMiniPage))
	r.GET("/works/tmc", a.authtorized(a.TMCPage))
	r.GET("/works/tmcadvancesearch", a.authtorized(a.TMCSearchPage))
	r.GET("/works/snsearch", a.authtorized(a.SnSearchPage))
	r.GET("/works/storage", a.authtorized(a.StoragePage))
	r.GET("/works/storage/orders", a.authtorized(a.StoragePage))
	r.GET("/works/storage/places", a.authtorized(a.StorageByPlacePage))
	r.GET("/works/storage/models", a.authtorized(a.StorageByTModelPage))
	r.GET("/works/orders", a.authtorized(a.OrderPage))
	r.GET("/works/order/mini", a.authtorized(a.OrderMiniPage))
	r.GET("/works/towork", a.authtorized(a.ToWorkPage))
	r.GET("/works/setorder", a.authtorized(a.SetOrderPage))
	r.GET("/works/setplace", a.authtorized(a.SetPlacePage))
	r.GET("/works/takedemo", a.authtorized(a.TakeDemoPage))
	r.GET("/works/toship", a.authtorized(a.ToShipPage))
	r.GET("/works/cangeplacenum", a.authtorized(a.ChangeNumPlacePage))
	r.GET("/works/takedevicebymodel", a.authtorized(a.TakeDeviceByModelPage))
	r.GET("/works/createorder", a.authtorized(a.CreateOrderPage))
	r.GET("/works/changemac", a.authtorized(a.ChangeMACPage))
	r.GET("/works/releaseproduction", a.authtorized(a.ReleaseProductionPage))
	r.GET("/works/returntostorage", a.authtorized(a.ReturnToStoragePage))
	r.GET("/works/setpromdate", a.authtorized(a.SetPromDatePage))
	r.GET("/works/changepass", a.authtorized(a.ChangePassPage))
	r.GET("/works/addcommentbysn", a.authtorized(a.AddCommentToSnsBySnPage))
	r.GET("/works/takedevicebyxlsx", a.authtorized(a.TakeDeviceByExcelPage))
	r.GET("/works/createmat", a.authtorized(a.CreateMatPage))
	r.GET("/works/takemat", a.authtorized(a.TakeMatPage))
	r.GET("/works/storage/mats", a.authtorized(a.StorageMatsPage))
	r.GET("/works/storage/matsbyname", a.authtorized(a.StorageMatsByNamePage))
	r.GET("/works/storage/matsby1c", a.authtorized(a.StorageMatsBy1CPage))
	r.GET("/works/makebuild", a.authtorized(a.CreateBuildPage))
	r.GET("/works/buildlist", a.authtorized(a.BuildsPage))
	r.GET("/works/tmodels", a.authtorized(a.TModelsPage))
	r.GET("/works/tmodel", a.authtorized(a.TModelPage))
	r.GET("/works/dmodels", a.authtorized(a.DModelsPage))
	r.GET("/works/dmodel", a.authtorized(a.DModelPage))
	r.GET("/works/matsinwork", a.authtorized(a.StorageMatsInWorkPage))
	r.GET("/works/matevents", a.authtorized(a.MatEventPage))
	r.GET("/works/cal", a.authtorized(a.CalendearPage))
	r.GET("/works/createtask", a.authtorized(a.CreateTaskPage))
	r.GET("/works/tasks", a.authtorized(a.TasksPage))
	r.GET("/works/createtasklist", a.authtorized(a.CreateTaskListPage))
	r.GET("/works/changetask", a.authtorized(a.ChangeTaskPage))
	r.GET("/works/task", a.authtorized(a.TaskPage))
	r.GET("/works/planprodstorage", a.authtorized(a.PlanProdStoragePage))
	r.GET("/works/planreprodstorage", a.authtorized(a.PlanReProdStoragePage))
	r.GET("/works/planmatprodstorage", a.authtorized(a.PlanMatProdStoragePage))
	r.GET("/works/tmcdemo", a.authtorized(a.TMCDemoPage))
	r.GET("/works/reservcal", a.authtorized(a.ReservCalendarPage))
	r.GET("/works/createreserv", a.authtorized(a.CreateReservPage))
	r.GET("/works/canbebuild", a.authtorized(a.CreateCanBeBuildPage))
	r.GET("/works/canbebuildorders", a.authtorized(a.CreateCanBeBuildOrdersPage))

	r.POST("/works/tmc", a.authtorized(a.TMCPage))
	r.POST("/works/orders", a.authtorized(a.OrderPage))
	r.POST("/works/towork", a.authtorized(a.ToWork))
	r.POST("/works/setorder", a.authtorized(a.SetOrder))
	r.POST("/works/setplace", a.authtorized(a.SetPlace))
	r.POST("/works/takedemo", a.authtorized(a.TakeDemo))
	r.POST("/works/toship", a.authtorized(a.ToShip))
	r.POST("/works/cangeplacenum", a.authtorized(a.ChangeNumPlace))
	r.POST("/works/addcomment", a.authtorized(a.AddCommentToSns))
	r.POST("/works/takedevicebymodel", a.authtorized(a.TakeDeviceByModel))
	r.POST("/works/createorder", a.authtorized(a.CreateOrder))
	r.POST("/works/dellorder", a.authtorized(a.DelOrder))
	r.POST("/works/change1cnumorder", a.authtorized(a.Change1CNumOrder))
	r.POST("/works/createorderlist", a.authtorized(a.CreateOrderListPage))
	r.POST("/works/changemac", a.authtorized(a.ChangeMAC))
	r.POST("/works/releaseproductionacept", a.authtorized(a.BuildAceptPage))
	r.POST("/works/releaseproduction", a.authtorized(a.ReleaseProduction))
	r.POST("/works/returntostorage", a.authtorized(a.ReturnToStorage))
	r.POST("/works/setpromdate", a.authtorized(a.SetPromDate))
	r.POST("/works/changepass", a.authtorized(a.ChangePass))
	r.POST("/works/addcommentbysn", a.authtorized(a.AddCommentToSnsBySn))
	r.POST("/works/takedevicebyxlsx", a.authtorized(a.TakeDeviceByExcel))
	r.POST("/works/createmat", a.authtorized(a.CreateMat))
	r.POST("/works/takemat", a.authtorized(a.TakeMat))
	r.POST("/works/makebuild", a.authtorized(a.MakeBuild))
	r.POST("/works/changedefbuild", a.authtorized(a.ChangeDefBuild))
	r.POST("/works/mattowork", a.authtorized(a.MatToWork))
	r.POST("/works/matfromwork", a.authtorized(a.MatFromWork))
	r.POST("/works/createtask", a.authtorized(a.CreateTask))
	r.POST("/works/createtasklist", a.authtorized(a.CreateTaskListPage))
	r.POST("/works/changetask", a.authtorized(a.ChangeTask))
	r.POST("/works/ordertotask", a.authtorized(a.OrderToTask))
	r.POST("/works/hidetask", a.authtorized(a.HideTask))
	r.POST("/works/tmcdemo", a.authtorized(a.TMCDemoPage))
	r.POST("/works/createreserv", a.authtorized(a.CreateReserv))

	r.GET("/works/tmcexcell", a.authtorized(a.TMCExcell))
	r.POST("/works/tmcexcell", a.authtorized(a.TMCExcell))
	r.GET("/works/ordersexcell", a.authtorized(a.OrdersExcell))
	r.POST("/works/ordersexcell", a.authtorized(a.OrdersExcell))
	r.GET("/works/shortordersexcell", a.authtorized(a.OrdersShortExcell))
	r.POST("/works/shortordersexcell", a.authtorized(a.OrdersShortExcell))

	r.GET("/works/file", a.authtorized(a.TestFile))
}

// Проверка авторизациия
func (a App) authtorized(nestedFunction HandleUser) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		authToken, err := Auth.ReadCookie("Lolijoyu", r)
		if err != nil { // нет токена авторизации
			log.Println("нет токена авторизации " + err.Error())

			http.Redirect(w, r, "/works/login", http.StatusSeeOther)
			return
		}

		user, err := Auth.ParseJWT(authToken, a.JwtKey)
		if err != nil {
			log.Println("Ошибка авторизации 11 " + err.Error())
			gentoken, err := Auth.ReadCookie("Korikasa", r)
			if err != nil { //нет токена генерации
				http.Redirect(w, r, "/works/login", http.StatusSeeOther)
				return
			}
			_, err = Auth.ParseJWT(gentoken, []byte(authToken))

			if err != nil {

				http.Redirect(w, r, "/works/login", http.StatusSeeOther)
				return
			}

			Auth.MakeTokens(w, r, user, a.JwtKey, *a.Db) //генерировать токен
			http.Redirect(w, r, r.RequestURI, http.StatusSeeOther)
			return
		}

		// функция с логикой
		nestedFunction(w, r, ps, user)

	}
}

// Добавление начальных устройств
func (a App) NewSns(w http.ResponseWriter, r *http.Request, pr httprouter.Params, user mytypes.User) {
	var devices []mytypes.DeviceRaw
	for i := 1; i <= 100; i++ {
		device := mytypes.DeviceRaw{
			Sn:          strconv.Itoa(i + 1000),
			Mac:         "m" + strconv.Itoa(i+1000),
			DModel:      2,
			TModel:      2,
			Rev:         "a1",
			Condition:   1,
			Name:        "Test2",
			CondDate:    time.Now(),
			Order:       0,
			Place:       1,
			Shiped:      false,
			ShipedDate:  time.Now(),
			ShippedDest: "Hjr",
			TakenDate:   time.Now(),
			TakenDoc:    "qawe",
			TakenOrder:  "asd",
		}
		devices = append(devices, device)
	}

	a.Db.InsertDiviceToSns(a.Ctx, devices...)
}

// Получение строки серийных номеров из устройств
func GetSnfromDevices(devices ...mytypes.DeviceRaw) string {
	var SnString string

	for _, a := range devices {
		SnString += a.Sn + "\n"
	}
	return SnString
}

// Получение строки серийных номеров из устройств (чистые данные)
func GetSnfromCleanDevices(devices ...mytypes.DeviceClean) string {
	var SnString string

	for _, a := range devices {
		SnString += a.Sn + " \n"
	}
	return SnString
}

// Отправка файла и его удаление
func sendTMPFile(w http.ResponseWriter, r *http.Request, path, name string) error {
	err := sendFile(w, r, path, name)
	os.Remove(path)
	return err
}

// Отправка файла
func sendFile(w http.ResponseWriter, r *http.Request, path, name string) error {
	f, err := os.Open(path)
	if err != nil {
		return err
	}

	fi, err := f.Stat()
	if err != nil {
		return err
	}
	w.Header().Set("Content-Disposition", "attachment; filename="+name)
	http.ServeContent(w, r, "test", fi.ModTime(), f)

	f.Close()
	return nil
}

// Загрузка файла
func takeFile(src multipart.File, hdr *multipart.FileHeader, user mytypes.User) (*os.File, string, error) {
	f, err := os.OpenFile(filepath.Join("Files/Uploaded", user.Login+"_"+time.Now().Format("02-01-06_15-04-05_")+hdr.Filename), os.O_CREATE, 0666)
	if err != nil {
		return nil, "", err
	}
	defer f.Close()
	io.Copy(f, src)

	return f, hdr.Filename, nil
}

// Отправка service-worker
func SendSW(w http.ResponseWriter, r *http.Request) {
	data, err := os.ReadFile("Face/service-worker.js")
	if err != nil {
		http.Error(w, "Couldn't read file", http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/javascript; charset=utf-8")
	w.Write(data)
}

// Отправка manifest
func SendManifest(w http.ResponseWriter, r *http.Request) {
	data, err := os.ReadFile("Face/manifest.json")
	if err != nil {
		http.Error(w, "Couldn't read file", http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Write(data)
}
