package Storage

import (
	"T-Base/Brain/mytypes"
	"context"
	"database/sql"
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

// Объект базы данных
type Base struct {
	Db *pgxpool.Pool
}

// инициализация базы
func NewBase(user, pass, ip, baseName string) (*Base, error) {
	BasePointer, err := pgxpool.New(context.Background(), "postgres://"+user+":"+pass+"@localhost:5432/"+baseName+"")
	if err != nil {
		return &Base{}, err
	}
	return &Base{Db: BasePointer}, nil
}

/////////////////////////////////////
// Функции получения пользователей //
/////////////////////////////////////

// Получение пользователя по логину
func (base Base) TakeUserByLogin(ctx context.Context, inlogin string) (mytypes.User, error) {
	u := mytypes.User{}

	row := base.Db.QueryRow(ctx, "SELECT UserId, login, pass, access, name, email FROM users WHERE users.login = $1", inlogin)
	err := row.Scan(&u.UserId, &u.Login, &u.Pass, &u.Acces, &u.Name, &u.Email)

	return u, err
}

// Получение слайса пользователей по Id
func (base Base) TakeUserById(ctx context.Context, inId ...int) ([]mytypes.User, error) {
	users := []mytypes.User{}

	if len(inId) == 0 {
		u := mytypes.User{}
		rows, err := base.Db.Query(ctx, "SELECT UserId, login, pass, access, name, email FROM users")
		if err != nil {
			return users, err
		}

		for rows.Next() {
			err := rows.Scan(&u.UserId, &u.Login, &u.Pass, &u.Acces, &u.Name, &u.Email)
			if err != nil {
				return users, err
			}
			users = append(users, u)
		}

	} else {
		u := mytypes.User{}

		for _, id := range inId {
			row := base.Db.QueryRow(ctx, "SELECT UserId, login, pass, access, name, email FROM users where id = $1", id)
			err := row.Scan(&u.UserId, &u.Login, &u.Pass, &u.Acces, &u.Name, &u.Email)
			if err != nil {
				return users, err
			}
			users = append(users, u)
		}
	}

	return users, nil
}

///////////////////////////////
// Функции поучения устройств//
///////////////////////////////

// Получение слайса девайсов по Id
func (base Base) TakeDeviceById(ctx context.Context, inId ...int) ([]mytypes.DeviceRaw, error) {
	devices := []mytypes.DeviceRaw{}
	device := mytypes.DeviceRaw{}

	if len(inId) == 0 {
		rows, err := base.Db.Query(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns`)
		if err != nil {
			return devices, err
		}

		for rows.Next() {
			err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				return devices, err
			}
			devices = append(devices, device)
		}

	} else {
		for _, id := range inId {
			row := base.Db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns Where "snsId" = $1`, id)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				return devices, err
			}
			devices = append(devices, device)
		}
	}
	return devices, nil
}

// Получение стлайса устройств по условию SQL
func (base Base) TakeDeviceByRequest(ctx context.Context, request string) ([]mytypes.DeviceRaw, error) {
	devices := []mytypes.DeviceRaw{}
	device := mytypes.DeviceRaw{}

	qq := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns `

	rows, err := base.Db.Query(ctx, qq+request)
	if err != nil {
		return devices, err
	}

	for rows.Next() {
		err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder)
		if err != nil {
			return devices, err
		}
		devices = append(devices, device)
	}

	return devices, nil
}

// Получение стлайса устройств по условию серийным номерам
func (base Base) TakeDeviceBySn(ctx context.Context, inSn ...string) ([]mytypes.DeviceRaw, error) {
	devices := []mytypes.DeviceRaw{}
	device := mytypes.DeviceRaw{}

	if len(inSn) == 0 {
		rows, err := base.Db.Query(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns`)
		if err != nil {
			return devices, err
		}

		for rows.Next() {
			err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				return devices, err
			}
			devices = append(devices, device)
		}

	} else {
		for _, sn := range inSn {
			row := base.Db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns Where sn = $1`, sn)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				continue
			}
			devices = append(devices, device)
		}
	}
	return devices, nil
}

///////////////////////////////////////////
// Функции поучения читабельных устройств//
///////////////////////////////////////////

func (base Base) TakeCleanDevice(ctx context.Context, fullReqest string) ([]mytypes.DeviceClean, error) {
	devices := []mytypes.DeviceClean{}
	device := mytypes.DeviceClean{}
	var CondDate, ShipedDate, TakenDate time.Time
	var Shiped bool
	var commentnull sql.NullString

	if fullReqest == "" {
		fullReqest = `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment FROM "cleanSns" `
	}

	rows, err := base.Db.Query(ctx, fullReqest)
	fmt.Println(fullReqest)
	if err != nil {
		return devices, err
	}

	for rows.Next() {
		err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull)
		if err != nil {
			return devices, err
		}
		if commentnull.Valid {
			device.Comment = commentnull.String
		} else {
			device.Comment = ""
		}
		device.CondDate = CondDate.Format("02.01.2006")
		device.ShipedDate = ShipedDate.Format("02.01.2006")
		device.TakenDate = TakenDate.Format("02.01.2006")
		device.Shiped = strconv.FormatBool(Shiped)
		devices = append(devices, device)
	}

	return devices, nil
}

// Получение слайса читабельных устройств по Id ОПТИМИЗИРОВАТЬ
func (base Base) TakeCleanDeviceById(ctx context.Context, inId ...int) ([]mytypes.DeviceClean, error) {
	devices := []mytypes.DeviceClean{}
	device := mytypes.DeviceClean{}
	var CondDate, ShipedDate, TakenDate time.Time
	var Shiped bool
	var commentnull sql.NullString
	var err error

	if len(inId) == 0 {
		devices, err = base.TakeCleanDevice(ctx, "")
		if err != nil {
			return devices, err
		}

	} else {
		for _, id := range inId {
			row := base.Db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment FROM "cleanSns" Where "snsId" = $1 order by "snsId"`, id)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull)
			if err != nil {
				return devices, err
			}
			if commentnull.Valid {
				device.Comment = commentnull.String
			} else {
				device.Comment = ""
			}
			device.CondDate = CondDate.Format("02.01.2006")
			device.ShipedDate = ShipedDate.Format("02.01.2006")
			device.TakenDate = TakenDate.Format("02.01.2006")
			device.Shiped = strconv.FormatBool(Shiped)
			devices = append(devices, device)
		}
	}
	return devices, nil
}

// Получение стлайса читабельных устройств по условию SQL
func (base Base) TakeCleanDeviceByRequest(ctx context.Context, request string) ([]mytypes.DeviceClean, error) {
	devices := []mytypes.DeviceClean{}
	device := mytypes.DeviceClean{}
	var CondDate, ShipedDate, TakenDate time.Time
	var Shiped bool
	var commentnull sql.NullString

	qq := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment FROM "cleanSns" `

	rows, err := base.Db.Query(ctx, qq+request)
	fmt.Println(qq + request)
	if err != nil {
		return devices, err
	}

	for rows.Next() {
		err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull)
		if err != nil {
			return devices, err
		}
		if commentnull.Valid {
			device.Comment = commentnull.String
		} else {
			device.Comment = ""
		}
		device.CondDate = CondDate.Format("02.01.2006")
		device.ShipedDate = ShipedDate.Format("02.01.2006")
		device.TakenDate = TakenDate.Format("02.01.2006")
		device.Shiped = strconv.FormatBool(Shiped)
		devices = append(devices, device)
	}

	return devices, nil
}

// Получение стлайса читабельных устройств по условию серийным номерам ОПТИМИЗИРОВАТЬ
func (base Base) TakeCleanDeviceBySn(ctx context.Context, inSn ...string) ([]mytypes.DeviceClean, error) {
	devices := []mytypes.DeviceClean{}
	device := mytypes.DeviceClean{}
	var CondDate, ShipedDate, TakenDate time.Time
	var Shiped bool
	var commentnull sql.NullString

	if len(inSn) == 0 {
		devices, err := base.TakeCleanDevice(ctx, "")
		if err != nil {
			return devices, err
		}

	} else {
		for _, sn := range inSn {
			row := base.Db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment FROM "cleanSns" Where sn = $1`, sn)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull)
			if err != nil {
				return devices, err
			}
			if commentnull.Valid {
				device.Comment = commentnull.String
			} else {
				device.Comment = ""
			}
			device.CondDate = CondDate.Format("02.01.2006")
			device.ShipedDate = ShipedDate.Format("02.01.2006")
			device.TakenDate = TakenDate.Format("02.01.2006")
			device.Shiped = strconv.FormatBool(Shiped)
			devices = append(devices, device)
		}
	}
	return devices, nil
}

// Получение стлайса читабельных устройств по заказу ОПТИМИЗИРОВАТЬ
func (base Base) TakeCleanDeviceByOrder(ctx context.Context, inOrders ...int) ([]mytypes.DeviceClean, error) {
	devices := []mytypes.DeviceClean{}
	device := mytypes.DeviceClean{}
	var CondDate, ShipedDate, TakenDate time.Time
	var Shiped bool
	var commentnull sql.NullString

	if len(inOrders) == 0 {
		devices, err := base.TakeCleanDevice(ctx, "")
		if err != nil {
			return devices, err
		}

	} else {
		for _, order := range inOrders {
			rows, err := base.Db.Query(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment  FROM "cleanSns" Where "order" = $1`, order)
			if err != nil {
				continue
			}

			for rows.Next() {
				err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull)
				if err != nil {
					return devices, err
				}
				if commentnull.Valid {
					device.Comment = commentnull.String
				} else {
					device.Comment = ""
				}
				device.CondDate = CondDate.Format("02.01.2006")
				device.ShipedDate = ShipedDate.Format("02.01.2006")
				device.TakenDate = TakenDate.Format("02.01.2006")
				device.Shiped = strconv.FormatBool(Shiped)
				devices = append(devices, device)

			}

		}
	}
	return devices, nil
}

// Получение слайса читабельных устройств в которых любой параметр совпадает со значением строки
func (base Base) TakeCleanDeviceByAnything(ctx context.Context, request ...string) ([]mytypes.DeviceClean, error) {

	var qq string
	for i, a := range request {
		a = strings.TrimSpace(a)
		if i != 0 {
			qq += " UNION "
		} else if a == "" {
			device, err := base.TakeCleanDeviceById(ctx)
			return device, err
		}

		qq += `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment FROM "cleanSns" WHERE sn = '` + a + `' OR mac = '` + a + `' OR "name" = '` + a + `' OR dmodel = '` + a + `' OR rev = '` + a + `' OR tmodel = '` + a + `' OR condition = '` + a + `' OR "shippedDest" = '` + a + `' OR "takenDoc" = '` + a + `' OR "takenOrder" = '` + a + `' OR "comment" = '` + a + "'"

		_, err := strconv.Atoi(a)
		if err == nil {
			qq += ` OR "order" = ` + a + ` OR place = ` + a + ` OR "snsId" = ` + a
		}

		date, err := time.Parse("02.01.2006", a)
		if err == nil {
			a = date.Format("2006-01-02")
			qq += ` OR "condDate" = '` + a + `' OR "shipedDate" = '` + a + `' OR "takenDate" = '` + a + `'`
		}
	}

	devices := []mytypes.DeviceClean{}
	device := mytypes.DeviceClean{}
	var CondDate, ShipedDate, TakenDate time.Time
	var Shiped bool
	var commentnull sql.NullString

	rows, err := base.Db.Query(ctx, qq)
	fmt.Println(request)
	fmt.Println(qq)
	if err != nil {
		return devices, err
	}

	for rows.Next() {
		err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull)
		if err != nil {
			return devices, err
		}
		if commentnull.Valid {
			device.Comment = commentnull.String
		} else {
			device.Comment = ""
		}
		device.CondDate = CondDate.Format("02.01.2006")
		device.ShipedDate = ShipedDate.Format("02.01.2006")
		device.TakenDate = TakenDate.Format("02.01.2006")
		device.Shiped = strconv.FormatBool(Shiped)
		devices = append(devices, device)
	}

	return devices, nil
}

////////////////////////////////////////
// Функции получения событий устройств//
////////////////////////////////////////

// Получение слайса событий коммутатора по его ID
func (base Base) TakeDeviceEvent(ctx context.Context, deviceId int) ([]mytypes.DeviceEvent, error) {
	var events []mytypes.DeviceEvent
	var event mytypes.DeviceEvent

	rows, err := base.Db.Query(ctx, `SELECT "logId", "eventType", "eventText", "eventTime", "user" FROM public."deviceLog" WHERE "deviceId" = $1`, deviceId)
	if err != nil {
		return events, err
	}

	for rows.Next() {
		err := rows.Scan(&event.LogId, &event.EventType, &event.EventText, &event.EventTime, &event.User)
		if err != nil {
			return events, err
		}
		events = append(events, event)
	}

	return events, nil
}

func (base Base) TakeCleanDeviceEvent(ctx context.Context, deviceId int) ([]mytypes.DeviceEventClean, error) {
	var events []mytypes.DeviceEventClean
	var event mytypes.DeviceEventClean
	var eventTime time.Time

	rows, err := base.Db.Query(ctx, `SELECT "logId", "eventType", "eventText", "eventTime", "user" FROM public."cleanDeviceLog" WHERE "deviceId" = $1 ORDER BY "logId"`, deviceId)
	if err != nil {
		return events, err
	}

	for rows.Next() {
		err := rows.Scan(&event.LogId, &event.EventType, &event.EventText, &eventTime, &event.User)
		if err != nil {
			return events, err
		}
		event.EventTime = eventTime.Format("02.01.2006")
		events = append(events, event)
	}

	return events, nil
}

///////////////////////////////////////
// Функции получения кол-ва устройств//
///////////////////////////////////////

// Получение кол-ва устройств на складе по заказам
func (base Base) TakeStorageCount(ctx context.Context, fullReqest string) ([]mytypes.StorageCount, error) {
	storage := []mytypes.StorageCount{}
	deviceCount := mytypes.StorageCount{}

	if fullReqest == "" {
		fullReqest = `SELECT "order", name, count FROM wear`
	}

	rows, err := base.Db.Query(ctx, fullReqest)
	if err != nil {
		return storage, err
	}

	for rows.Next() {
		err := rows.Scan(&deviceCount.Order, &deviceCount.Name, &deviceCount.Amout)
		if err != nil {
			return storage, err
		}

		storage = append(storage, deviceCount)
	}
	return storage, nil
}

// Получение кол-ва устройств на складе по местам
func (base Base) TakeStorageCountByPlace(ctx context.Context, fullReqest string) ([]mytypes.StorageByPlaceCount, error) {
	storage := []mytypes.StorageByPlaceCount{}
	deviceCount := mytypes.StorageByPlaceCount{}

	if fullReqest == "" {
		fullReqest = `SELECT "place", name, count FROM "wearByPlace"`
	}

	rows, err := base.Db.Query(ctx, fullReqest)
	if err != nil {
		return storage, err
	}

	for rows.Next() {
		err := rows.Scan(&deviceCount.Place, &deviceCount.Name, &deviceCount.Amout)
		if err != nil {
			return storage, err
		}

		storage = append(storage, deviceCount)
	}
	return storage, nil
}

func (base Base) TakeStorageByTModelClean(ctx context.Context, fullReqest string) ([]mytypes.StorageByTModelClean, error) {
	storage := []mytypes.StorageByTModelClean{}
	deviceCount := mytypes.StorageByTModelClean{}

	if fullReqest == "" {
		fullReqest = `SELECT tmodel, name, condition, count FROM public."cleanWearByTModel";`
	}
	rows, err := base.Db.Query(ctx, fullReqest)
	if err != nil {
		return storage, err
	}

	for rows.Next() {
		err := rows.Scan(&deviceCount.Model, &deviceCount.Name, &deviceCount.Condition, &deviceCount.Amout)
		if err != nil {
			return storage, err
		}

		storage = append(storage, deviceCount)
	}
	return storage, nil
}

//////////////////////////////
// Функции получения заказов//
//////////////////////////////

// Получение слайса заказов по ID
func (base Base) TakeOrderById(ctx context.Context, inId ...int) ([]mytypes.OrderRaw, error) {
	var orders []mytypes.OrderRaw
	var order mytypes.OrderRaw

	if len(inId) == 0 {
		rows, err := base.Db.Query(ctx, `SELECT "orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName" FROM public.orders`)
		if err != nil {
			return orders, err
		}

		for rows.Next() {
			err := rows.Scan(&order.OrderId, &order.Meneger, &order.OrderDate, &order.ReqDate, &order.PromDate, &order.ShDate, &order.IsAct, &order.Comment, &order.Customer, &order.Partner, &order.Distributor, &order.Name, &order.Id1C)
			if err != nil {
				return orders, err
			}
			orders = append(orders, order)
		}
	} else {

		for _, Id := range inId {

			row := base.Db.QueryRow(ctx, `SELECT "orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName" FROM public.orders Where "orderId" = $1`, Id)
			err := row.Scan(&order.OrderId, &order.Meneger, &order.OrderDate, &order.ReqDate, &order.PromDate, &order.ShDate, &order.IsAct, &order.Comment, &order.Customer, &order.Partner, &order.Distributor, &order.Name, &order.Id1C)
			if err != nil {
				return orders, err
			}
			orders = append(orders, order)
		}
	}

	return orders, nil
}

//////////////////////////////////////////
// Функции получения читабельных заказов//
//////////////////////////////////////////

// ОПТИМИЗИРОВАТЬ
func (base Base) TakeCleanOrderById(ctx context.Context, inId ...int) ([]mytypes.OrderClean, error) {
	var orders []mytypes.OrderClean
	var order mytypes.OrderClean
	var orderDate, reqDate, promDate, shDate time.Time
	var isAct bool

	if len(inId) == 0 {
		rows, err := base.Db.Query(ctx, `SELECT "orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName" FROM public."cleanOrder"`)
		if err != nil {
			return orders, err
		}

		for rows.Next() {
			err := rows.Scan(&order.OrderId, &order.Meneger, &orderDate, &reqDate, &promDate, &shDate, &isAct, &order.Comment, &order.Customer, &order.Partner, &order.Distributor, &order.Name, &order.Id1C)
			if err != nil {
				return orders, err
			}
			order.OrderDate = orderDate.Format("02.01.2006")
			order.ReqDate = reqDate.Format("02.01.2006")
			order.PromDate = promDate.Format("02.01.2006")
			order.ShDate = shDate.Format("02.01.2006")
			order.IsAct = strconv.FormatBool(isAct)
			orders = append(orders, order)
		}
	} else {

		for _, id := range inId {

			row := base.Db.QueryRow(ctx, `SELECT "orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName" FROM public."cleanOrder" WHERE "orderId" = $1`, id)
			err := row.Scan(&order.OrderId, &order.Meneger, &orderDate, &reqDate, &promDate, &shDate, &isAct, &order.Comment, &order.Customer, &order.Partner, &order.Distributor, &order.Name, &order.Id1C)
			if err != nil {
				return orders, err
			}

			order.OrderDate = orderDate.Format("02.01.2006")
			order.ReqDate = reqDate.Format("02.01.2006")
			order.PromDate = promDate.Format("02.01.2006")
			order.ShDate = shDate.Format("02.01.2006")
			order.IsAct = strconv.FormatBool(isAct)
			orders = append(orders, order)

		}
	}

	return orders, nil
}

func (base Base) TakeCleanOrderByAnything(ctx context.Context, reqest ...string) ([]mytypes.OrderClean, error) {
	var qq string

	for i, a := range reqest {
		a = strings.TrimSpace(a)
		if i != 0 {
			qq += " UNION "
		} else if a == "" {
			device, err := base.TakeCleanOrderById(ctx)
			return device, err
		}

		qq += `SELECT "orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName" FROM public."cleanOrder" WHERE meneger = '` + a + `' OR coment = '` + a + `' OR customer = '` + a + `' OR partner = '` + a + `' OR disributor = '` + a + `' OR name = '` + a + `'`

		_, err := strconv.Atoi(a)
		if err == nil {
			qq += ` OR "orderId" = ` + a + ` OR "1СName" = ` + a
		}

		date, err := time.Parse("02.01.2006", a)
		if err == nil {
			a = date.Format("2006-01-02")
			qq += ` OR "orderDate" = '` + a + `' OR "reqDate" = '` + a + `' OR "promDate" = '` + a + `' OR "shDate" = '` + a + `'`
		}

	}

	var orders []mytypes.OrderClean
	var order mytypes.OrderClean
	var orderDate, reqDate, promDate, shDate time.Time
	var isAct bool

	rows, err := base.Db.Query(ctx, qq)

	if err != nil {
		return orders, err
	}

	for rows.Next() {
		err := rows.Scan(&order.OrderId, &order.Meneger, &orderDate, &reqDate, &promDate, &shDate, &isAct, &order.Comment, &order.Customer, &order.Partner, &order.Distributor, &order.Name, &order.Id1C)
		if err != nil {
			return orders, err
		}
		order.OrderDate = orderDate.Format("02.01.2006")
		order.ReqDate = reqDate.Format("02.01.2006")
		order.PromDate = promDate.Format("02.01.2006")
		order.ShDate = shDate.Format("02.01.2006")
		order.IsAct = strconv.FormatBool(isAct)
		orders = append(orders, order)
	}

	return orders, nil
}

////////////////////////////////////
// функции получения листа заказов//
////////////////////////////////////

// Получение листа заказа по его ID
func (base Base) TakeOrderList(ctx context.Context, orderId int) ([]mytypes.OrderList, error) {
	var orderList []mytypes.OrderList
	var pos mytypes.OrderList

	rows, err := base.Db.Query(ctx, `SELECT "orderId", model, amout, "servType", "srevActDate", "lastRed" FROM public."orderList" WHERE "orderId" = $1`, orderId)
	if err != nil {
		return orderList, err
	}

	for rows.Next() {
		err := rows.Scan(&pos.Order, &pos.Model, &pos.Amout, &pos.ServType, &pos.ServActDate, &pos.LastRed)
		if err != nil {
			return orderList, err
		}

		orderList = append(orderList, pos)
	}

	return orderList, nil
}

/////////////////////////////////////////////////
// функции получения читабельного листа заказов//
/////////////////////////////////////////////////

// Получение читабельного листа заказа по его ID ОПТИМИЗИРОВАТЬ
func (base Base) TakeCleanOrderList(ctx context.Context, orderId int) ([]mytypes.OrderListClean, error) {
	var orderList []mytypes.OrderListClean
	var pos mytypes.OrderListClean
	var servActDate, lastRed time.Time

	rows, err := base.Db.Query(ctx, `SELECT "orderId", model, amout, "servType", "srevActDate", "lastRed" FROM public."cleanOrderList" WHERE "orderId" = $1`, orderId)
	if err != nil {
		return orderList, err
	}

	for rows.Next() {
		err := rows.Scan(&pos.Order, &pos.Model, &pos.Amout, &pos.ServType, &servActDate, &lastRed)
		if err != nil {
			return orderList, err
		}

		pos.ServActDate = servActDate.Format("02.01.2006")
		pos.LastRed = lastRed.Format("02.01.2006 15:04:05")
		orderList = append(orderList, pos)
	}

	return orderList, nil
}

/////////////////////////////////
// Функции изменения устройств //
/////////////////////////////////

func (base Base) SnToWork(ctx context.Context, InSn ...string) (int, error) {
	if len(InSn) == 0 {
		return 0, fmt.Errorf("не введены серийные номера")
	}

	qq := `UPDATE public.sns SET condition = 3, place= 0 WHERE`
	for i, sn := range InSn {
		if i == 0 {
			qq += (`( sn = '` + sn + `') `)
		} else {
			qq += (`OR ( sn = '` + sn + `') `)
		}
	}

	res, err := base.Db.Exec(ctx, qq)

	return int(res.RowsAffected()), err
}

func (base Base) SnSetOrder(ctx context.Context, inOrder int, InSn ...string) (int, error) {
	if len(InSn) == 0 {
		return 0, fmt.Errorf("не введены серийные номера")
	}

	qq := `UPDATE public.sns SET "order" = $1 WHERE`
	for i, sn := range InSn {
		if i == 0 {
			qq += (`( sn = '` + sn + `') `)
		} else {
			qq += (`OR ( sn = '` + sn + `') `)
		}
	}

	res, err := base.Db.Exec(ctx, qq, inOrder)

	return int(res.RowsAffected()), err
}

func (base Base) SnSetPlace(ctx context.Context, inPlace int, InSn ...string) (int, error) {
	if len(InSn) == 0 {
		return 0, fmt.Errorf("не введены серийные номера")
	}

	qq := `UPDATE public.sns SET "place" = $1 WHERE`
	for i, sn := range InSn {
		if i == 0 {
			qq += (`( sn = '` + sn + `') `)
		} else {
			qq += (`OR ( sn = '` + sn + `') `)
		}
	}

	res, err := base.Db.Exec(ctx, qq, inPlace)

	return int(res.RowsAffected()), err
}

func (base Base) SnTakeDemo(ctx context.Context, InSn ...string) (int, error) {
	if len(InSn) == 0 {
		return 0, fmt.Errorf("не введены серийные номера")
	}

	qq := `UPDATE public.sns SET shiped = 'false', place= 10 WHERE`
	for i, sn := range InSn {
		if i == 0 {
			qq += (`( sn = '` + sn + `') `)
		} else {
			qq += (`OR ( sn = '` + sn + `') `)
		}
	}

	res, err := base.Db.Exec(ctx, qq)

	return int(res.RowsAffected()), err
}

func (base Base) SnToShip(ctx context.Context, dest string, InSn ...string) (int, error) {
	if len(InSn) == 0 {
		return 0, fmt.Errorf("не введены серийные номера")
	}

	qq := `UPDATE public.sns SET shiped = 'true', place= -1, "shippedDest" = '` + dest + `', "shipedDate" = CURRENT_DATE WHERE`
	for i, sn := range InSn {
		if i == 0 {
			qq += (`( sn = '` + sn + `') `)
		} else {
			qq += (`OR ( sn = '` + sn + `') `)
		}
	}

	res, err := base.Db.Exec(ctx, qq)

	return int(res.RowsAffected()), err
}

func (base Base) ChangeNumPlace(ctx context.Context, old, new int) error {

	_, err := base.Db.Exec(ctx, `UPDATE public.sns SET place = $1 WHERE place = $2`, new, old)

	return err
}

func (base Base) AddCommentToSns(ctx context.Context, id int, text string, user mytypes.User) error {

	qq := `UPDATE public.snscomment
			SET comment= comment || $2
			WHERE "snsId" = $1;`

	res, err := base.Db.Exec(ctx, qq, id, text)

	if err != nil {
		fmt.Println(err)
		return err
	}
	if res.RowsAffected() == 0 {
		qq = `INSERT INTO public.snscomment(
			"snsId", comment)
			VALUES ( $1, $2);`
		_, err = base.Db.Exec(ctx, qq, id, text)
		if err != nil {
			fmt.Println(err)
			return err
		}
	}

	return nil
}

///////////////////
// Другие функции//
///////////////////

// запись токена генерации
func (base Base) NewRegenToken(user string, token string, ctx context.Context) {
	res, err := base.Db.Exec(ctx, "UPDATE users set token = $1 where login = $2", token, user)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(res.RowsAffected())
}

// добавление устройств в базу
func (base Base) InsertDiviceToSns(ctx context.Context, devices ...mytypes.DeviceRaw) error {
	for _, device := range devices {
		qq := `INSERT INTO sns(
			sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder")
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);`
		_, err := base.Db.Exec(ctx, qq, device.Sn, device.Mac, device.DModel, device.Rev, device.TModel, device.Name, device.Condition, device.CondDate, device.Order, device.Place, device.Shiped, device.ShipedDate, device.ShippedDest, device.TakenDate, device.TakenDoc, device.TakenOrder)
		if err != nil {
			return err
		}
	}
	return nil
}

func (base Base) NewDModels() {

	file, err := os.Open("Запрос1.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	reader.Comma = ';'

	for {
		record, e := reader.Read()
		if e != nil {
			fmt.Println(e)
			break
		}

		Id, _ := strconv.Atoi(record[0])
		Sn := record[3]
		Mac := record[4]
		DModel, _ := strconv.Atoi(record[1])
		Rev := record[16]
		TModel, _ := strconv.Atoi(record[2])
		Name := record[13]
		Condition, _ := strconv.Atoi(record[5])
		CondDate, err := time.Parse("02.01.2006", record[6])
		if err != nil {
			CondDate, _ = time.Parse("02.01.2006", "01.01.2000")
		}
		Order, _ := strconv.Atoi(record[7])
		Place, _ := strconv.Atoi(record[12])
		var Shiped bool
		if record[8] == "true" {
			Shiped = true
		} else {
			Shiped = false
		}
		ShipedDate, err := time.Parse("02.01.2006", record[9])
		if err != nil {
			CondDate, _ = time.Parse("02.01.2006", "01.01.2000")
		}
		ShippedDest := record[10]
		TakenDate, err := time.Parse("02.01.2006", record[14])
		if err != nil {
			CondDate, _ = time.Parse("02.01.2006", "01.01.2000")
		}
		TakenDoc := record[15]
		TakenOrder := record[17]

		qq := `INSERT INTO public.sns(
				"snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder")
				VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);`

		_, err = base.Db.Exec(context.Background(), qq, Id, Sn, Mac, DModel, Rev, TModel, Name, Condition, CondDate, Order, Place, Shiped, ShipedDate, ShippedDest, TakenDate, TakenDoc, TakenOrder)

		if err != nil {
			fmt.Println(err)
		}
	}

}
