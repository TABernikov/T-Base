package Application

import (
	"T-Base/Brain/Auth"
	"T-Base/Brain/Storage"
	"T-Base/Brain/mytypes"
	"context"
	"net/http"
	"strconv"
	"time"

	"github.com/julienschmidt/httprouter"
)

type App struct {
	ctx    context.Context
	Db     *Storage.Base
	JwtKey []byte
}

type HandleUser func(http.ResponseWriter, *http.Request, httprouter.Params, mytypes.User)

func NewApp(ctx context.Context, jwtKey []byte, user, pass, ip, baseName string) (*App, error) {
	db, err := Storage.NewBase(user, pass, ip, baseName)
	return &App{ctx, db, jwtKey}, err
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
	r.GET("/works/tmcorder", a.authtorized(a.TMCOrderSearch))
	r.POST("/works/snsearch", a.authtorized(a.SnSearch))
	r.POST("/works/tmcsearch", a.authtorized(a.TMCSearch))
	r.POST("/works/ordersearch", a.authtorized(a.OrderSearch))
	r.POST("/works/towork", a.authtorized(a.ToWork))
	r.POST("/works/setorder", a.authtorized(a.SetOrder))
	r.POST("/works/setplace", a.authtorized(a.SetPlace))
	r.POST("/works/tmc", a.authtorized(a.AdvanceTMCSearch))
	//r.GET("/works/new", a.authtorized(a.NewSns))
}

// Проверка авторизации
func (a App) authtorized(nestedFunction HandleUser) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		authToken, err := Auth.ReadCookie("Lolijoyu", r)
		if err != nil { // нет токена авторизации
			println("нет токена авторизации " + err.Error())

			http.Redirect(w, r, "/works/login", http.StatusSeeOther)
			return

		}

		user, err := Auth.ParseJWT(authToken, a.JwtKey)
		if err != nil {
			println("Ошибка авторизации 11 " + err.Error())
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

	a.Db.InsertDiviceToSns(a.ctx, devices...)
}
