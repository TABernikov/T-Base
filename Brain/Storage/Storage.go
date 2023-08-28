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

// Получение слайса читабельных устройств по Id
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

			rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM public.sns WHERE "snsId" = $1`
			cleanSelect := `SELECT tmp."snsId", tmp.sn, tmp.mac, "dModels"."dModelName" AS dmodel, tmp.rev, "tModels"."tModelsName" AS tmodel, tmp.name, "condNames"."condName" AS condition, tmp."condDate", tmp."order", tmp.place, tmp.shiped, tmp."shipedDate", tmp."shippedDest", tmp."takenDate", tmp."takenDoc", tmp."takenOrder", snscomment.comment FROM (` + rawSelect + `)tmp LEFT JOIN "dModels" ON "dModels"."dModelsId" = tmp.dmodel LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.tmodel LEFT JOIN "condNames" ON "condNames"."condNamesId" = tmp.condition LEFT JOIN snscomment ON snscomment."snsId" = tmp."snsId"`

			row := base.Db.QueryRow(ctx, cleanSelect, id)
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

// Получение стлайса читабельных устройств по условию серийным номерам
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

			rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM public.sns WHERE sn = $1`
			cleanSelect := `SELECT tmp."snsId", tmp.sn, tmp.mac, "dModels"."dModelName" AS dmodel, tmp.rev, "tModels"."tModelsName" AS tmodel, tmp.name, "condNames"."condName" AS condition, tmp."condDate", tmp."order", tmp.place, tmp.shiped, tmp."shipedDate", tmp."shippedDest", tmp."takenDate", tmp."takenDoc", tmp."takenOrder", snscomment.comment FROM (` + rawSelect + `)tmp LEFT JOIN "dModels" ON "dModels"."dModelsId" = tmp.dmodel LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.tmodel LEFT JOIN "condNames" ON "condNames"."condNamesId" = tmp.condition LEFT JOIN snscomment ON snscomment."snsId" = tmp."snsId"`

			row := base.Db.QueryRow(ctx, cleanSelect, sn)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull)
			if err != nil {
				continue
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

// Получение стлайса читабельных устройств по заказу
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

			rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM public.sns WHERE "order" = $1`
			cleanSelect := `SELECT tmp."snsId", tmp.sn, tmp.mac, "dModels"."dModelName" AS dmodel, tmp.rev, "tModels"."tModelsName" AS tmodel, tmp.name, "condNames"."condName" AS condition, tmp."condDate", tmp."order", tmp.place, tmp.shiped, tmp."shipedDate", tmp."shippedDest", tmp."takenDate", tmp."takenDoc", tmp."takenOrder", snscomment.comment FROM (` + rawSelect + `)tmp LEFT JOIN "dModels" ON "dModels"."dModelsId" = tmp.dmodel LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.tmodel LEFT JOIN "condNames" ON "condNames"."condNamesId" = tmp.condition LEFT JOIN snscomment ON snscomment."snsId" = tmp."snsId"`

			rows, err := base.Db.Query(ctx, cleanSelect, order)
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

		qq += `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment FROM "cleanSns" WHERE sn LIKE '%` + a + `%' OR mac LIKE '%` + a + `%' OR "name" LIKE '%` + a + `%' OR dmodel LIKE '%` + a + `%' OR rev LIKE '%` + a + `%' OR tmodel LIKE '%` + a + `%' OR condition LIKE '%` + a + `%' OR "shippedDest" LIKE '%` + a + `%' OR "takenDoc" LIKE '%` + a + `%' OR "takenOrder" LIKE '%` + a + `%' OR "comment" LIKE '%` + a + "%'"

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

	qq := ` SELECT
    tmp."deviceId",
    "eventTypesNames"."eventName" AS "eventType",
    tmp."eventText",
    tmp."eventTime",
    users.name AS "user"
   FROM (SELECT "logId", "deviceId", "eventType", "eventText", "eventTime", "user"
	FROM public."deviceLog" WHERE "deviceId" = $1) tmp
     LEFT JOIN "eventTypesNames" ON "eventTypesNames"."NamesId" = tmp."eventType"
     LEFT JOIN users ON users.userid = tmp."user"
	 ORDER BY "logId"`

	rows, err := base.Db.Query(ctx, qq, deviceId)
	if err != nil {
		return events, err
	}

	for rows.Next() {
		err := rows.Scan(&event.LogId, &event.EventType, &event.EventText, &eventTime, &event.User)
		if err != nil {
			return events, err
		}
		event.EventTime = eventTime.Format("02.01.2006 15:04:05")
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
		fullReqest = `SELECT "order", name, count, "orderName" FROM wear`
	}

	rows, err := base.Db.Query(ctx, fullReqest)
	if err != nil {
		return storage, err
	}

	for rows.Next() {
		err := rows.Scan(&deviceCount.Order, &deviceCount.Name, &deviceCount.Amout, &deviceCount.OrderName)
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
		fullReqest = `SELECT tmodel, name, condition, count, shiped FROM public."cleanWearByTModel";`
	}
	rows, err := base.Db.Query(ctx, fullReqest)
	if err != nil {
		return storage, err
	}

	for rows.Next() {
		err := rows.Scan(&deviceCount.Model, &deviceCount.Name, &deviceCount.Condition, &deviceCount.Amout, &deviceCount.Shipped)
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

			qq := ` SELECT tmp."orderId",
    users.name AS meneger,
    tmp."orderDate",
    tmp."reqDate",
    tmp."promDate",
    tmp."shDate",
    tmp."isAct",
    tmp.coment,
    tmp.customer,
    tmp.partner,
    tmp.disributor,
    tmp.name,
    tmp."1СName"
   FROM (SELECT "orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName"
	FROM public.orders WHERE "orderId" = $1) tmp
     LEFT JOIN users ON users.userid = tmp.meneger;`

			row := base.Db.QueryRow(ctx, qq, id)
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

func (base Base) TakeCleanOrderByReqest(ctx context.Context, reqest string) ([]mytypes.OrderClean, error) {

	var orders []mytypes.OrderClean
	var order mytypes.OrderClean
	var orderDate, reqDate, promDate, shDate time.Time
	var isAct bool

	qq := `SELECT "orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName" FROM public."cleanOrder" ` + reqest
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

	rows, err := base.Db.Query(ctx, `SELECT "orderListId", "orderId", model, amout, "servType", "srevActDate", "lastRed" FROM public."orderList" WHERE "orderId" = $1`, orderId)
	if err != nil {
		return orderList, err
	}

	for rows.Next() {
		err := rows.Scan(&pos.Id, &pos.Order, &pos.Model, &pos.Amout, &pos.ServType, &pos.ServActDate, &pos.LastRed)
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

// Получение читабельного листа заказа по его ID
func (base Base) TakeCleanOrderList(ctx context.Context, orderId int) ([]mytypes.OrderListClean, error) {
	var orderList []mytypes.OrderListClean
	var pos mytypes.OrderListClean
	var servActDate, lastRed time.Time

	qq := ` SELECT 
	tmp."orderListId",
    tmp."orderId",
    "tModels"."tModelsName" AS model,
    tmp.amout,
    tmp."servType",
    tmp."srevActDate",
    tmp."lastRed"
   FROM (SELECT "orderListId", "orderId", model, amout, "servType", "srevActDate", "lastRed"
	FROM public."orderList" WHERE "orderId" = $1) tmp
     LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.model;
`

	rows, err := base.Db.Query(ctx, qq, orderId)
	if err != nil {
		return orderList, err
	}

	for rows.Next() {
		err := rows.Scan(&pos.Id, &pos.Order, &pos.Model, &pos.Amout, &pos.ServType, &servActDate, &lastRed)
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

func (base Base) InsetDeviceByModel(ctx context.Context, DModel int, Name string, TModel int, Rev string, Place int, Doc string, Order string, InSn ...string) (int, []string, error) {
	if len(InSn) == 0 {
		return 0, nil, fmt.Errorf("не введены серийные номера")
	}

	qq := `INSERT INTO public.sns(
		sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder")
		VALUES ($1, '', $2, $3, $4, $8, 2, '2000-01-01', 2, $5, false, '2000-01-01', '', CURRENT_DATE, $6, $7);`

	var insertCount int
	var SnErr []string
	var lastErr error
	for _, sn := range InSn {
		res, err := base.Db.Exec(ctx, qq, sn, DModel, Rev, TModel, Place, Doc, Order, Name)
		if err != nil {
			SnErr = append(SnErr, sn+": "+err.Error())
			lastErr = err
			continue
		}
		insertCount += int(res.RowsAffected())
	}
	return insertCount, SnErr, lastErr
}

func (base Base) ChangeMAC(ctx context.Context, sn, mac string) (int, error) {
	qq := `UPDATE public.sns SET mac=$2 WHERE sn=$1`

	res, err := base.Db.Exec(ctx, qq, sn, mac)

	return int(res.RowsAffected()), err
}

func (base Base) ReleaseProduction(ctx context.Context, sn ...string) int {
	var counter int
	var err error

	for _, a := range sn {
		qq := `SELECT "tModelsName"
		FROM public.sns INNER JOIN public."tModels" on "tModels"."tModelsId" = sns.tmodel
		WHERE sns.sn = $1`
		var name string
		err = base.Db.QueryRow(ctx, qq, a).Scan(&name)
		if err != nil {

			continue
		}

		qq = `UPDATE public.sns
		SET  name = $2, condition = 1, "condDate" = CURRENT_DATE
		WHERE sn = $1;`
		_, err = base.Db.Exec(ctx, qq, a, name)
		if err != nil {

			continue
		}
		qq = `UPDATE public.sns
		SET  "order" = 1
		WHERE sn=$1 AND "order" = 2;`

		_, err = base.Db.Exec(ctx, qq, a)
		if err != nil {

			continue
		}
		counter++
	}

	return counter
}

func (base Base) ReturnToStorage(ctx context.Context, sn ...string) int {
	var counter int
	for _, a := range sn {
		qq := `UPDATE public.sns
		SET condition = 2
		WHERE sn = $1 AND "order" <> 3;`
		res, err := base.Db.Exec(ctx, qq, a)
		if err != nil || res.RowsAffected() == 0 {
			qq = `UPDATE public.sns
			SET condition = 1
			WHERE sn = $1 AND "order" = 3;`
			res, err := base.Db.Exec(ctx, qq, a)

			if err != nil || res.RowsAffected() == 0 {
				continue
			}
		}
		counter++
	}
	return counter
}

///////////////////////////////
// Функции изменения заказов //
///////////////////////////////

func (base Base) InsertOrder(ctx context.Context, Order mytypes.OrderRaw) (int, error) {
	qq := `INSERT INTO public.orders(
		meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName")
	   VALUES ($1, CURRENT_DATE, $2, '2000-01-01', '2000-01-01', true, '', $3, $4, $5, $6, $7);`
	_, err := base.Db.Exec(ctx, qq, Order.Meneger, Order.ReqDate, Order.Customer, Order.Partner, Order.Distributor, Order.Name, Order.Id1C)
	var Id int
	noterr := base.Db.QueryRow(ctx, `SELECT "orderId" from orders Where meneger = $1  ORDER BY "orderId" DESC`, Order.Meneger).Scan(&Id)
	if noterr != nil {
		return Id, noterr
	}
	return Id, err
}

func (base Base) DellOrder(ctx context.Context, id int) error {

	qq := `UPDATE sns
		SET "order" = (case when sns.condition = 1 then 1 else 2 END)
		WHERE "order" = $1;
		`
	_, err := base.Db.Exec(ctx, qq, id)
	if err != nil {
		return err
	}
	qq = `DELETE FROM public."orderList"
	WHERE "orderId" = $1;`
	_, err = base.Db.Exec(ctx, qq, id)
	if err != nil {
		return err
	}
	qq = `DELETE from public.orders
	WHERE "orderId" = $1;`
	_, err = base.Db.Exec(ctx, qq, id)
	if err != nil {
		return err
	}

	return nil
}

func (base Base) Change1CNumOrder(ctx context.Context, id int, new1CId int) error {
	qq := `UPDATE public.orders
	SET "1СName"=$1
	WHERE "orderId"=$2;
	`
	_, err := base.Db.Exec(ctx, qq, new1CId, id)
	if err != nil {
		return err
	}

	return nil
}

func (base Base) InsertOrderList(ctx context.Context, OrderList mytypes.OrderList) error {
	qq := `INSERT INTO public."orderList"(
	"orderId", model, amout, "servType", "srevActDate", "lastRed")
	VALUES ($1, $2, $3, $4, $5, $6);`

	_, err := base.Db.Exec(ctx, qq, OrderList.Order, OrderList.Model, OrderList.Amout, OrderList.ServType, OrderList.ServActDate, OrderList.LastRed)
	return err
}

func (base Base) ChangeOrderList(ctx context.Context, OrderList mytypes.OrderList) error {
	qq := `UPDATE public."orderList"
	SET  "orderId"=$2, model=$3, amout=$4, "servType"=$5, "srevActDate"=$6, "lastRed"=$7
	WHERE "orderListId"=$1;`

	_, err := base.Db.Exec(ctx, qq, OrderList.Id, OrderList.Order, OrderList.Model, OrderList.Amout, OrderList.ServType, OrderList.ServActDate, OrderList.LastRed)
	return err
}

func (base Base) SetPromDate(ctx context.Context, order int, date time.Time) error {
	qq := `UPDATE public.orders
	SET "promDate"=$2
	WHERE "orderId"=$1`

	res, err := base.Db.Exec(ctx, qq, order, date)
	if res.RowsAffected() == 0 {
		return fmt.Errorf("no row edits")
	}
	return err
}

////////////////////
// Другие функции //
////////////////////

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

		var CondDate time.Time
		if record[6] == "" || record[6] == " " {
			CondDate, _ = time.Parse("02.01.2006", "01.01.2000")
		} else {
			CondDate, err = time.Parse("02.01.2006", record[6])
			if err != nil {
				fmt.Println(err)
			}
		}

		Order, _ := strconv.Atoi(record[7])
		Place, _ := strconv.Atoi(record[12])
		var Shiped bool
		if record[8] == "true" {
			Shiped = true
		} else {
			Shiped = false
		}

		var ShipedDate time.Time
		if record[9] == "" || record[9] == " " {
			ShipedDate, _ = time.Parse("02.01.2006", "01.01.2000")
		} else {
			ShipedDate, err = time.Parse("02.01.2006", record[9])
			if err != nil {
				fmt.Println(err)
			}
		}

		ShippedDest := record[10]

		var TakenDate time.Time
		if record[14] == "" || record[14] == " " {
			TakenDate, _ = time.Parse("02.01.2006", "01.01.2000")
		} else {
			TakenDate, err = time.Parse("02.01.2006", record[14])
			if err != nil {
				fmt.Println(err)
			}
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

func (base Base) NewOrders() {

	file, err := os.Open("Orders.csv")
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
		Meneger, _ := strconv.Atoi(record[1])
		OrderDate, err := time.Parse("02.01.2006", record[2])
		if err != nil {
			OrderDate, _ = time.Parse("02.01.2006", "01.01.2000")
		}
		Customer := record[3]
		Partner := record[4]
		Distributor := record[5]
		ReqDate, err := time.Parse("02.01.2006", record[6])
		if err != nil {
			ReqDate, _ = time.Parse("02.01.2006", "01.01.2000")
		}
		PromDate, err := time.Parse("02.01.2006", record[7])
		if err != nil {
			PromDate, _ = time.Parse("02.01.2006", "01.01.2000")
		}
		ShDate, err := time.Parse("02.01.2006", record[8])
		if err != nil {
			ShDate, _ = time.Parse("02.01.2006", "01.01.2000")
		}
		Comment := record[9]
		var IsAct bool
		if record[8] == "true" {
			IsAct = true
		} else {
			IsAct = false
		}

		qq := `INSERT INTO public.orders(
			"orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName")
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);`

		_, err = base.Db.Exec(context.Background(), qq, Id, Meneger, OrderDate, ReqDate, PromDate, ShDate, IsAct, Comment, Customer, Partner, Distributor, "", Id)

		if err != nil {
			fmt.Println(err)
		}
	}
}

func (base Base) NewOrderList() {

	file, err := os.Open("Запрос2.csv")
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
		OrderId, _ := strconv.Atoi(record[1])
		Model, _ := strconv.Atoi(record[2])
		Amout, _ := strconv.Atoi(record[3])
		ServType, _ := strconv.Atoi(record[4])
		ServActDate, err := time.Parse("02.01.2006", record[5])
		if err != nil {
			ServActDate, _ = time.Parse("02.01.2006", "01.01.2000")
		}
		LastRed, err := time.Parse("02.01.2006 15:04:05", record[7])
		if err != nil {
			LastRed, _ = time.Parse("02.01.2006", "01.01.2000")
		}

		qq := `INSERT INTO public."orderList"(
			"orderListId", "orderId", model, amout, "servType", "srevActDate", "lastRed")
			VALUES ($1, $2, $3, $4, $5, $6, $7);`

		_, err = base.Db.Exec(context.Background(), qq, Id, OrderId, Model, Amout, ServType, ServActDate, LastRed)

		if err != nil {
			fmt.Println(err)
			fmt.Println(strconv.Itoa(OrderId) + "   " + strconv.Itoa(Model))
		}
	}
}

func (base Base) NewLog() {

	file, err := os.Open("KomLogs.csv")
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
		Sn := record[1]
		EventType, _ := strconv.Atoi(record[2])
		EventText := record[3]
		EventDate, err := time.Parse("02.01.2006 15:04:05", record[4])
		if err != nil {
			EventDate, _ = time.Parse("02.01.2006", "01.01.2000")
		}
		user, _ := strconv.Atoi(record[5])

		q := `SELECT "snsId" From sns WHERE sn = $1`
		var deviceId int
		err = base.Db.QueryRow(context.Background(), q, Sn).Scan(&deviceId)
		if err != nil {
			fmt.Println(err)
		}

		qq := `INSERT INTO public."deviceLog"(
			"logId", "deviceId", "eventType", "eventText", "eventTime", "user")
			VALUES ($1, $2, $3, $4, $5, $6);`

		if deviceId != 0 {
			_, err = base.Db.Exec(context.Background(), qq, Id, deviceId, EventType, EventText, EventDate, user)
		}
		if err != nil {
			fmt.Println(err)
		}
	}
}
