package Application

import (
	"T-Base/Brain/Auth"
	"T-Base/Brain/DocBase"
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
	"strings"
	"time"

	"github.com/julienschmidt/httprouter"
)

// Объект приложения
type App struct {
	Ctx     context.Context
	Db      *Storage.Base
	DocBase *DocBase.DocBase
	Templ   *PageTempl.Templ
	JwtKey  []byte
	AppIp   string
}

type HandleUser func(http.ResponseWriter, *http.Request, httprouter.Params, mytypes.User)

// Инициализация приложения
func NewApp(ctx context.Context, jwtKey []byte, user, pass, ip, baseName, appIp string) (*App, error) {
	db, err := Storage.NewBase(user, pass, ip, baseName)
	if err != nil {
		return &App{}, err
	}
	docbase, err := DocBase.NewDocBase()
	if err != nil {
		return &App{}, err
	}
	templ := PageTempl.NewTempl(ctx, db)

	return &App{ctx, db, docbase, templ, jwtKey, appIp}, nil
}

// Роутер
func (a App) Routs(r *httprouter.Router) {
	// открытые пути
	r.ServeFiles("/works/Face/*filepath", http.Dir("Face"))
	r.ServeFiles("/works/device/Face/*filepath", http.Dir("Face"))
	r.ServeFiles("/works/order/Face/*filepath", http.Dir("Face"))
	r.ServeFiles("/works/storage/Face/*filepath", http.Dir("Face"))
	r.ServeFiles("/works/docs/Face/*filepath", http.Dir("Face"))

	r.GET("/", a.startPage)
	r.GET("/works/login", func(w http.ResponseWriter, r *http.Request, pr httprouter.Params) { a.LoginPage(w, "") })
	r.GET("/works/home", a.homePage)

	r.POST("/works/login", a.Login)
	r.GET("/works/Logout", Auth.Logout)
	r.POST("/works/Logout", Auth.Logout)

	// пути требующие авторизацию
	r.GET("/works/prof", a.authtorized(a.UserPage))
	r.GET("/works/changepass", a.authtorized(a.ChangePassPage))
	r.GET("/works/reservcal", a.authtorized(a.ReservCalendarPage))
	r.GET("/works/createreserv", a.authtorized(a.CreateReservPage))

	r.POST("/works/changepass", a.authtorized(a.ChangePass))
	r.POST("/works/createreserv", a.authtorized(a.CreateReserv))

	TMCRouts(a, r)
	DeviceChangeRouts(a, r)
	OrderRouts(a, r)
	TaskPlanRouts(a, r)
	MaterialsRouts(a, r)
	ReportsRouts(a, r)
	ModelsRouts(a, r)
	DocumentsBaseRouts(a, r)
	BuildsRouts(a, r)
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

func takeDocFile(src multipart.File, hdr *multipart.FileHeader, docType string) (*os.File, string, error) {
	docType = strings.ReplaceAll(docType, ".", "/")
	f, err := os.OpenFile(filepath.Join("Files/DocStor", docType, hdr.Filename), os.O_CREATE, 0666)
	if err != nil {
		return nil, "", err
	}
	defer f.Close()
	io.Copy(f, src)
	return f, hdr.Filename, nil
}

func dellDocFile(docType string, docPath string) error {
	docType = strings.ReplaceAll(docType, ".", "/")
	return os.Remove(filepath.Join("Files/DocStor", docType, docPath))
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
