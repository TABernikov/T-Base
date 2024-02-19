package Storage

import (
	"T-Base/Brain/mytypes"
	"context"
	"database/sql"
	"fmt"
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
			row := base.Db.QueryRow(ctx, "SELECT userid, login, pass, access, name, email FROM users where userid = $1", id)
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
		rows, err := base.Db.Query(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", "assembler" FROM sns`)
		if err != nil {
			return devices, err
		}

		for rows.Next() {
			err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder, &device.Assembler)
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

	qq := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", "assembler" FROM sns `

	rows, err := base.Db.Query(ctx, qq+request)
	if err != nil {
		return devices, err
	}

	for rows.Next() {
		err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder, &device.Assembler)
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
		rows, err := base.Db.Query(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", "assembler" FROM sns`)
		if err != nil {
			return devices, err
		}

		for rows.Next() {
			err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder, &device.Assembler)
			if err != nil {
				return devices, err
			}
			devices = append(devices, device)
		}

	} else {
		for _, sn := range inSn {
			row := base.Db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", "assembler" FROM sns Where sn = $1`, sn)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder, &device.Assembler)
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

// Получение слайса читабельных устройств по полному sql запросу
func (base Base) TakeCleanDevice(ctx context.Context, fullReqest string) ([]mytypes.DeviceClean, error) {
	devices := []mytypes.DeviceClean{}
	device := mytypes.DeviceClean{}
	var CondDate, ShipedDate, TakenDate time.Time
	var Shiped bool
	var commentnull sql.NullString

	if fullReqest == "" {
		fullReqest = `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment, "assembler" FROM "cleanSns" `
	}

	rows, err := base.Db.Query(ctx, fullReqest)
	if err != nil {
		return devices, err
	}

	for rows.Next() {
		err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull, &device.Assembler)
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

			rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", "assembler" FROM public.sns WHERE "snsId" = $1`
			cleanSelect := `SELECT tmp."snsId", tmp.sn, tmp.mac, "dModels"."dModelName" AS dmodel, tmp.rev, "tModels"."tModelsName" AS tmodel, tmp.name, "condNames"."condName" AS condition, tmp."condDate", tmp."order", tmp.place, tmp.shiped, tmp."shipedDate", tmp."shippedDest", tmp."takenDate", tmp."takenDoc", tmp."takenOrder", snscomment.comment, users.name AS assembler  FROM (` + rawSelect + `)tmp LEFT JOIN "dModels" ON "dModels"."dModelsId" = tmp.dmodel LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.tmodel LEFT JOIN "condNames" ON "condNames"."condNamesId" = tmp.condition LEFT JOIN snscomment ON snscomment."snsId" = tmp."snsId" LEFT JOIN users ON tmp.assembler = users.userid`

			row := base.Db.QueryRow(ctx, cleanSelect, id)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull, &device.Assembler)
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

	qq := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment, assembler FROM "cleanSns" `

	rows, err := base.Db.Query(ctx, qq+request)
	if err != nil {
		return devices, err
	}

	for rows.Next() {
		err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull, &device.Assembler)
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

			rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", assembler FROM public.sns WHERE sn = $1`
			cleanSelect := `SELECT tmp."snsId", tmp.sn, tmp.mac, "dModels"."dModelName" AS dmodel, tmp.rev, "tModels"."tModelsName" AS tmodel, tmp.name, "condNames"."condName" AS condition, tmp."condDate", tmp."order", tmp.place, tmp.shiped, tmp."shipedDate", tmp."shippedDest", tmp."takenDate", tmp."takenDoc", tmp."takenOrder", snscomment.comment, users.name AS assembler FROM (` + rawSelect + `)tmp LEFT JOIN "dModels" ON "dModels"."dModelsId" = tmp.dmodel LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.tmodel LEFT JOIN "condNames" ON "condNames"."condNamesId" = tmp.condition LEFT JOIN snscomment ON snscomment."snsId" = tmp."snsId" LEFT JOIN users ON tmp.assembler = users.userid`

			row := base.Db.QueryRow(ctx, cleanSelect, sn)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull, &device.Assembler)
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

			rawSelect := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", assembler FROM public.sns WHERE "order" = $1`
			cleanSelect := `SELECT tmp."snsId", tmp.sn, tmp.mac, "dModels"."dModelName" AS dmodel, tmp.rev, "tModels"."tModelsName" AS tmodel, tmp.name, "condNames"."condName" AS condition, tmp."condDate", tmp."order", tmp.place, tmp.shiped, tmp."shipedDate", tmp."shippedDest", tmp."takenDate", tmp."takenDoc", tmp."takenOrder", snscomment.comment, users.name AS assembler FROM (` + rawSelect + `)tmp LEFT JOIN "dModels" ON "dModels"."dModelsId" = tmp.dmodel LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.tmodel LEFT JOIN "condNames" ON "condNames"."condNamesId" = tmp.condition LEFT JOIN snscomment ON snscomment."snsId" = tmp."snsId" LEFT JOIN users ON sns.assembler = users.userid`

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

		qq += `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder", comment, assembler FROM "cleanSns" WHERE sn LIKE '%` + a + `%' OR mac LIKE '%` + a + `%' OR "name" LIKE '%` + a + `%' OR dmodel LIKE '%` + a + `%' OR rev LIKE '%` + a + `%' OR tmodel LIKE '%` + a + `%' OR condition LIKE '%` + a + `%' OR "shippedDest" LIKE '%` + a + `%' OR "takenDoc" LIKE '%` + a + `%' OR "takenOrder" LIKE '%` + a + `%' OR "comment" LIKE '%` + a + `%' OR "assembler" LIKE '%` + a + "%'"

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
	if err != nil {
		return devices, err
	}

	for rows.Next() {
		err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder, &commentnull, &device.Assembler)
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

// Получение слайса чистых событий коммутатора по его ID
func (base Base) TakeCleanDeviceEvent(ctx context.Context, deviceId int) ([]mytypes.DeviceEventClean, error) {
	var events []mytypes.DeviceEventClean
	var event mytypes.DeviceEventClean
	var eventTime time.Time

	qq := ` SELECT
    tmp."logId",
    "eventTypesNames"."eventName" AS "eventType",
    tmp."eventText",
    tmp."eventTime",
    users.name AS "user"
   FROM (SELECT "logId", "deviceId", "eventType", "eventText", "eventTime", "user"
	FROM public."deviceLog" WHERE "deviceId" = $1) tmp
     LEFT JOIN "eventTypesNames" ON "eventTypesNames"."NamesId" = tmp."eventType"
     LEFT JOIN users ON users.userid = tmp."user"
	 ORDER BY "eventTime" DESC;`

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

// Получение кол-ва устройств на складе по моделям и статусу
func (base Base) TakeStorageByTModel(ctx context.Context, fullReqest string) ([]mytypes.StorageByTModel, error) {
	storage := []mytypes.StorageByTModel{}
	deviceCount := mytypes.StorageByTModel{}

	if fullReqest == "" {
		fullReqest = `SELECT tmodel, name, condition, count, shiped FROM public."WearByTModel";`
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

// Получение кол-ва устройств на складе по чистым моделям и статусу
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

// Отчет о выходе с производства по моделям
// Выходная мапа [модель][дата]кол-во
func (base Base) TakeProdOutByModel(ctx context.Context, dateStart time.Time, dateEnd time.Time) (prodOut map[string]map[string]int, models []string, dates []string, err error) {

	qq := `SELECT name FROM public.sns WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2 GROUP BY name ORDER BY name;`

	rows, err := base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	for rows.Next() {
		var name string
		err = rows.Scan(&name)
		if err != nil {
			return
		}
		models = append(models, name)
	}
	models = append(models, "Все")

	qq = `SELECT "condDate" FROM public.sns WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2 GROUP BY "condDate" ORDER BY "condDate";`

	rows, err = base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	for rows.Next() {
		var date time.Time
		err = rows.Scan(&date)
		if err != nil {
			return
		}
		dateStr := date.Format("02.01.2006")
		dates = append(dates, dateStr)
	}
	dates = append(dates, "Все")

	qq = `SELECT name, "condDate", COUNT(sn) FROM public.sns
	WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2
	GROUP BY name, "condDate" ORDER BY name, "condDate";`

	prodOut = make(map[string]map[string]int)

	rows, err = base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	for rows.Next() {
		var date time.Time
		var name string
		var count int
		err = rows.Scan(&name, &date, &count)
		if err != nil {
			return
		}
		dateStr := date.Format("02.01.2006")
		if prodOut[name] == nil {
			prodOut[name] = make(map[string]int)
		}
		prodOut[name][dateStr] = count
	}

	//сумма по дням
	qq = `SELECT "condDate", COUNT(sn) FROM public.sns
	WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2
	GROUP BY "condDate" ORDER BY "condDate";`

	rows, err = base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	prodOut["Все"] = make(map[string]int)
	for rows.Next() {
		var date time.Time
		var count int
		err = rows.Scan(&date, &count)
		if err != nil {
			return
		}
		dateStr := date.Format("02.01.2006")
		prodOut["Все"][dateStr] = count
	}

	//сумма по моделям
	qq = `SELECT name, COUNT(sn) FROM public.sns
	WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2
	GROUP BY name ORDER BY name;`

	rows, err = base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	for rows.Next() {
		var name string
		var count int
		err = rows.Scan(&name, &count)
		if err != nil {
			return
		}
		prodOut[name]["Все"] = count
	}

	qq = `SELECT COALESCE(COUNT(sn), 0::int) FROM public.sns WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2;`

	var count int
	err = base.Db.QueryRow(ctx, qq, dateStart, dateEnd).Scan(&count)
	if err != nil {
		return
	}

	prodOut["Все"]["Все"] = count

	return

}

// Отчет о выходе с производства по датам
// Выходная мапа [дата][модель]кол-во
func (base Base) TakeProdOutByDate(ctx context.Context, dateStart time.Time, dateEnd time.Time) (prodOut map[string]map[string]int, models []string, dates []string, err error) {

	qq := `SELECT name FROM public.sns WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2 GROUP BY name ORDER BY name;`

	rows, err := base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	for rows.Next() {
		var name string
		err = rows.Scan(&name)
		if err != nil {
			return
		}
		models = append(models, name)
	}
	models = append(models, "Все")

	qq = `SELECT "condDate" FROM public.sns WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2 GROUP BY "condDate" ORDER BY "condDate";`

	rows, err = base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	for rows.Next() {
		var date time.Time
		err = rows.Scan(&date)
		if err != nil {
			return
		}
		dateStr := date.Format("02.01.2006")
		dates = append(dates, dateStr)
	}
	dates = append(dates, "Все")

	qq = `SELECT "condDate", name, COUNT(sn) FROM public.sns
	WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2
	GROUP BY "condDate", name ORDER BY "condDate", name;`

	prodOut = make(map[string]map[string]int)

	rows, err = base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	for rows.Next() {
		var date time.Time
		var name string
		var count int
		err = rows.Scan(&date, &name, &count)
		if err != nil {
			return
		}
		dateStr := date.Format("02.01.2006")
		if prodOut[dateStr] == nil {
			prodOut[dateStr] = make(map[string]int)
		}
		prodOut[dateStr][name] = count
	}

	//сумма по дням
	qq = `SELECT "condDate", COUNT(sn) FROM public.sns
	WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2
	GROUP BY "condDate" ORDER BY "condDate";`

	rows, err = base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	for rows.Next() {
		var date time.Time
		var count int
		err = rows.Scan(&date, &count)
		if err != nil {
			return
		}
		dateStr := date.Format("02.01.2006")
		prodOut[dateStr]["Все"] = count
	}

	//сумма по моделям
	qq = `SELECT name, COUNT(sn) FROM public.sns
	WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2
	GROUP BY name ORDER BY name;`

	rows, err = base.Db.Query(ctx, qq, dateStart, dateEnd)
	if err != nil {
		return
	}

	prodOut["Все"] = make(map[string]int)
	for rows.Next() {
		var name string
		var count int
		err = rows.Scan(&name, &count)
		if err != nil {
			return
		}
		prodOut["Все"][name] = count
	}

	qq = `SELECT COALESCE(COUNT(sn), 0::int) FROM public.sns WHERE condition = 1 AND "condDate" BETWEEN $1 AND $2;`

	var count int
	err = base.Db.QueryRow(ctx, qq, dateStart, dateEnd).Scan(&count)
	if err != nil {
		return
	}

	prodOut["Все"]["Все"] = count

	return

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

// Получение чистого заказа по его ID
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

// Получение чистого заказа по sql условию
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

// Получение чистого заказа с вхождениями указаных строк
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

		qq += `SELECT "orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName" FROM public."cleanOrder" WHERE meneger LIKE '%` + a + `%' OR coment LIKE '%` + a + `%' OR customer LIKE '%` + a + `%' OR partner LIKE '%` + a + `%' OR disributor LIKE '%` + a + `%' OR name LIKE '%` + a + `%'`

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
     LEFT JOIN "tModels" ON "tModels"."tModelsId" = tmp.model
	 ORDER BY model;`

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

// Получения чистого статуса заказа по его ID
func (base Base) TakeCleanOrderStatus(ctx context.Context, orderId int) ([]mytypes.OrderStatusClean, error) {
	var statusList []mytypes.OrderStatusClean
	var status mytypes.OrderStatusClean
	qq := `SELECT "tModels"."tModelsName", "orderList".amout,  count(*)FILTER(WHERE sns.condition IS NOT NULL), count(*)FILTER(WHERE sns.condition = 3), count(*)FILTER(WHERE sns.condition = 1), count(*)FILTER(WHERE sns.shiped = true)
	FROM "orderList"
	LEFT JOIN "sns" ON "orderList"."orderId" = "sns".order AND "orderList".model = "sns".tmodel
	LEFT JOIN "tModels" ON "orderList".model = "tModels"."tModelsId"
	WHERE "orderList"."orderId" = $1
	GROUP BY "tModels"."tModelsName","orderList".amout
	ORDER BY "tModels"."tModelsName"`

	rows, err := base.Db.Query(ctx, qq, orderId)
	if err != nil {
		return statusList, err
	}

	for rows.Next() {
		err := rows.Scan(&status.Model, &status.Amout, &status.Reserved, &status.InWork, &status.Done, &status.Shipped)
		if err != nil {
			return statusList, err
		}
		statusList = append(statusList, status)
	}
	return statusList, nil
}

/////////////////////////////////

// Функции изменения устройств //

/////////////////////////////////

// Передачу устройства в работу (состояние = 3, место = 0) по его серийному номеру
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

// Изменение заказа устройства по его серийному нореру
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

// Изменение места устройства по его серийному номеру
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

// Возврат устройства (отгружен = false, место = 10) по его серийному номеру
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

// Отправка устройства (отгружен = true, место = -1) по его серийному номеру
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

// Изменение номера места
func (base Base) ChangeNumPlace(ctx context.Context, old, new int) error {

	_, err := base.Db.Exec(ctx, `UPDATE public.sns SET place = $1 WHERE place = $2`, new, old)

	return err
}

// Добавление комментария к устройству по его ID
func (base Base) AddCommentToSns(ctx context.Context, id int, text string, user mytypes.User) error {

	time := time.Now().Format("02.01.2006 15:04")
	text = "[" + user.Name + " " + time + ": " + text + "]     "

	qq := `UPDATE public.snscomment
			SET comment= $2 || comment
			WHERE "snsId" = $1;`

	res, err := base.Db.Exec(ctx, qq, id, text)

	if err != nil {
		return err
	}
	if res.RowsAffected() == 0 {
		qq = `INSERT INTO public.snscomment(
			"snsId", comment)
			VALUES ( $1, $2);`
		_, err = base.Db.Exec(ctx, qq, id, text)
		if err != nil {
			return err
		}
	}

	return nil
}

// Добавление устройства по пораметрам
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

// Добовление устройств из структуры
func (base Base) InsertDivice(ctx context.Context, devices ...mytypes.DeviceRaw) (int, error) {
	if len(devices) == 0 {
		return 0, fmt.Errorf("не введены серийные номера")
	}
	insertCount := 0

	qq := `INSERT INTO public.sns(
		sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder")
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16);`

	for _, a := range devices {
		res, err := base.Db.Exec(ctx, qq, a.Sn, a.Mac, a.DModel, a.Rev, a.TModel, a.Name, a.Condition, a.CondDate, a.Order, a.Place, a.Shiped, a.ShipedDate, a.ShippedDest, a.TakenDate, a.TakenDoc, a.TakenOrder)
		if err != nil {
			continue
		}
		insertCount += int(res.RowsAffected())
	}
	return insertCount, nil
}

// Изменение MAC адреса устройства
func (base Base) ChangeMAC(ctx context.Context, sn, mac string) (int, error) {
	qq := `UPDATE public.sns SET mac=$2 WHERE sn=$1`

	res, err := base.Db.Exec(ctx, qq, sn, mac)

	return int(res.RowsAffected()), err
}

// Преобразование устройства по серийному номеру
// (состояние = 1)
// (по сборке привязанной к модели постовщика списываются материалы находящиеся в производстве)
func (base Base) ReleaseProduction(ctx context.Context, sn string) (int, int, map[int]int, error) {
	devices, err := base.TakeDeviceBySn(ctx, sn)
	if err != nil {
		return -1, -1, nil, err
	}
	if len(devices) == 0 {
		return -1, -1, nil, fmt.Errorf("не девайс")
	}
	device := devices[0]
	if device.Condition == 1 {
		return -1, -1, nil, fmt.Errorf("девайс уже собран")
	}

	var buildId int
	err = base.Db.QueryRow(ctx, `Select build FROM public."dModels" WHERE "dModelsId" = $1`, device.DModel).Scan(&buildId)
	if err != nil {
		return -1, -1, nil, err
	}
	build, err := base.TakeBuildById(ctx, buildId)
	if err != nil {
		return -1, -1, nil, err
	}

	matList := make(map[int]int)
	for _, buildElement := range build.BuildList {
		var matId int
		err = base.Db.QueryRow(ctx, `SELECT "matId" FROM public.mats WHERE name = $1 AND "inWork" > 0`, buildElement.MatId).Scan(&matId)
		if err != nil {
			return -1, -1, nil, err
		}
		_, err = base.Db.Exec(ctx, `UPDATE public.mats SET amout= amout - $2, "inWork"= "inWork" - $2 WHERE "matId" = $1`, matId, buildElement.Amout)
		if err != nil {
			return -1, -1, nil, err
		}
		matList[matId] += buildElement.Amout

	}

	var order int
	if device.Order == 2 {
		order = 1
	} else {
		order = device.Order
	}
	var newName string

	err = base.Db.QueryRow(ctx, `SELECT "tModelsName" FROM public."tModels" WHERE "tModelsId" = $1`, build.TModel).Scan(&newName)
	if err != nil {
		return -1, -1, nil, err
	}

	_, err = base.Db.Exec(ctx, `UPDATE public.sns SET condition = 1, "condDate" = $1, "order" = $2, name = $3, tmodel = $5 Where sn = $4`, time.Now(), order, newName, sn, build.TModel)
	if err != nil {
		return -1, -1, nil, err
	}

	return build.Id, build.TModel, matList, nil
}

// Возврат устройства из работы на склад
// Демо устройства после этого считаются собраными, все осталльные нет
func (base Base) ReturnToStorage(ctx context.Context, sn ...string) int {
	var counter int
	for _, a := range sn {
		qq := `UPDATE public.sns
		SET condition = 2
		WHERE sn = $1 AND "order" <> 3 AND condition = 3;`
		res, err := base.Db.Exec(ctx, qq, a)
		if err != nil || res.RowsAffected() == 0 {
			qq = `UPDATE public.sns
			SET condition = 1
			WHERE sn = $1 AND "order" = 3 AND condition = 3;`
			res, err := base.Db.Exec(ctx, qq, a)

			if err != nil || res.RowsAffected() == 0 {
				continue
			}
		}
		counter++
	}
	return counter
}

// Добавление события устройству по его ID
func (base Base) AddDeviceEventById(ctx context.Context, evntType int, eventText string, userId int, InId ...int) int {
	if len(InId) == 0 {
		return 0
	}

	qq := `INSERT INTO public."deviceLog"(
	"deviceId", "eventType", "eventText", "user")
	VALUES ($1, $2, $3, $4);`

	var count int
	for _, id := range InId {
		_, err := base.Db.Exec(ctx, qq, id, evntType, eventText, userId)
		if err == nil {
			count++
		}
	}

	return count
}

// Добавление события устройству по его серийному номеру
func (base Base) AddDeviceEventBySn(ctx context.Context, evntType int, eventText string, userId int, InSn ...string) int {
	if len(InSn) == 0 {
		return 0
	}

	qq := `SELECT "snsId"
	FROM public.sns
	WHERE `

	for i, sn := range InSn {
		if i == 0 {
			qq += `sn = '` + sn + `'`
		} else {
			qq += ` OR sn = '` + sn + `'`
		}
	}

	rows, err := base.Db.Query(ctx, qq)
	if err != nil {
		return 0
	}

	var ids []int
	var id int
	for rows.Next() {
		err := rows.Scan(&id)
		if err != nil {
			return 0
		}
		ids = append(ids, id)
	}

	return base.AddDeviceEventById(ctx, evntType, eventText, userId, ids...)
}

// Изменение сборщика устройства
func (base Base) ChangeDeviceAssembler(ctx context.Context, sn string, assembler int) error {
	qq := `UPDATE public.sns
	SET assembler = $1
	WHERE "sn" = $2;`
	_, err := base.Db.Exec(ctx, qq, assembler, sn)
	return err
}

///////////////////////////////

// Функции изменения заказов //

///////////////////////////////

// Добавление нового заказа из структуры
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

// Удаление заказа по его ID
// Зарезервированные устройства стоновятся свободными
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

// Изменение имени 1С заказа по его ID
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

// Добавление состава заказа
func (base Base) InsertOrderList(ctx context.Context, OrderList mytypes.OrderList) error {
	qq := `INSERT INTO public."orderList"(
	"orderId", model, amout, "servType", "srevActDate", "lastRed")
	VALUES ($1, $2, $3, $4, $5, $6);`

	_, err := base.Db.Exec(ctx, qq, OrderList.Order, OrderList.Model, OrderList.Amout, OrderList.ServType, OrderList.ServActDate, OrderList.LastRed)
	return err
}

// Изменение состава заказа
func (base Base) ChangeOrderList(ctx context.Context, OrderList mytypes.OrderList) error {
	qq := `UPDATE public."orderList"
	SET  "orderId"=$2, model=$3, amout=$4, "servType"=$5, "srevActDate"=$6, "lastRed"=$7
	WHERE "orderListId"=$1;`

	_, err := base.Db.Exec(ctx, qq, OrderList.Id, OrderList.Order, OrderList.Model, OrderList.Amout, OrderList.ServType, OrderList.ServActDate, OrderList.LastRed)
	return err
}

// Изменение даты сдачи заказа с производства
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

func (base Base) SetShDate(ctx context.Context, order int) error {
	qq := `UPDATE public.orders
	SET "shDate"=CURRENT_DATE, "isAct" = false
	WHERE "orderId"=$1`

	res, err := base.Db.Exec(ctx, qq, order)
	if res.RowsAffected() == 0 {
		return fmt.Errorf("ни один заказ не изменен")
	}
	return err

}

///////////////

// Материалы //

///////////////

// Получение списка материалов по списку их ID
func (base Base) TakeMatsById(ctx context.Context, Ids ...int) ([]mytypes.Mat, error) {

	var mat mytypes.Mat
	var mats []mytypes.Mat
	if len(Ids) == 0 {
		qq := `SELECT "matId", name, "1CName", amout, "inWork", type, price FROM public."cleanMats" ORDER BY "name", "matId";`
		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return mats, err
		}

		for rows.Next() {
			err := rows.Scan(&mat.Id, &mat.Name, &mat.Name1C, &mat.Amout, &mat.InWork, &mat.Type, &mat.Price)
			if err != nil {
				return mats, err
			}
			mat.Places = nil
			rows, err := base.Db.Query(ctx, `SELECT place FROM public.matplaces WHERE mat = $1`, mat.Id)
			if err != nil {
				return mats, err
			}
			for rows.Next() {
				var place int
				err := rows.Scan(&place)
				if err != nil {
					return mats, err
				}
				mat.Places = append(mat.Places, place)
			}
			mats = append(mats, mat)
		}
	} else {
		qq := `SELECT "matId", name, "1CName", amout, "inWork", type, price FROM public."cleanMats" WHERE "matId" = $1 ORDER BY "name"`

		for _, a := range Ids {
			err := base.Db.QueryRow(ctx, qq, a).Scan(&mat.Id, &mat.Name, &mat.Name1C, &mat.Amout, &mat.InWork, &mat.Type, &mat.Price)
			if err != nil {
				return mats, err
			}
			mats = append(mats, mat)
		}
	}
	return mats, nil
}

// Получение списка материалов которые есть в работе по списку их ID
func (base Base) TakeMatsInWorkById(ctx context.Context, Ids ...int) ([]mytypes.Mat, error) {

	var mat mytypes.Mat
	var mats []mytypes.Mat
	if len(Ids) == 0 {
		qq := `SELECT "matId", name, "1CName", amout, "inWork", type, price FROM public."cleanMats" WHERE "inWork" > 0 ORDER BY "name", "matId";`
		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return mats, err
		}

		for rows.Next() {
			err := rows.Scan(&mat.Id, &mat.Name, &mat.Name1C, &mat.Amout, &mat.InWork, &mat.Type, &mat.Price)
			if err != nil {
				return mats, err
			}
			mat.Places = nil
			rows, err := base.Db.Query(ctx, `SELECT place FROM public.matplaces WHERE mat = $1`, mat.Id)
			if err != nil {
				return mats, err
			}
			for rows.Next() {
				var place int
				err := rows.Scan(&place)
				if err != nil {
					return mats, err
				}
				mat.Places = append(mat.Places, place)
			}
			mats = append(mats, mat)
		}
	} else {
		qq := `SELECT "matId", name, "1CName", amout, "inWork", type, price FROM public."cleanMats" WHERE "matId" = $1 AND WHERE "inWork" > 0 ORDER BY "name"`

		for _, a := range Ids {
			err := base.Db.QueryRow(ctx, qq, a).Scan(&mat.Id, &mat.Name, &mat.Name1C, &mat.Amout, &mat.InWork, &mat.Type, &mat.Price)
			if err != nil {
				return mats, err
			}
			mats = append(mats, mat)
		}
	}
	return mats, nil
}

// Получение списка материалов по списку их фактических имен
// Возврощаемая структура имеет только фактическое имя и кол-во
func (base Base) TakeAmoutMatsByName(ctx context.Context, names ...string) ([]mytypes.Mat, error) {
	var mat mytypes.Mat
	var mats []mytypes.Mat
	if len(names) == 0 {
		qq := `SELECT name, sum FROM "matsByName" ORDER BY name`
		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return mats, err
		}

		for rows.Next() {
			err := rows.Scan(&mat.Name, &mat.Amout)
			if err != nil {
				return mats, err
			}
			mats = append(mats, mat)
		}
	} else {
		qq := `SELECT name, sum FROM "matsByName" WHERE "name" = $1 ORDER BY "name"`

		for _, a := range names {
			err := base.Db.QueryRow(ctx, qq, a).Scan(&mat.Name, &mat.Amout)
			if err != nil {
				return mats, err
			}
			mats = append(mats, mat)
		}
	}
	return mats, nil
}

// Получение списка материалов по списку их имен в 1С
// Возврощаемая структура имеет только имя в 1с и кол-во
func (base Base) TakeAmoutMatsBy1C(ctx context.Context, names1c ...string) ([]mytypes.Mat, error) {
	var mat mytypes.Mat
	var mats []mytypes.Mat
	if len(names1c) == 0 {
		qq := `SELECT "1CName", sum FROM "matsBy1C" ORDER BY "1CName"`
		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return mats, err
		}

		for rows.Next() {
			err := rows.Scan(&mat.Name1C, &mat.Amout)
			if err != nil {
				return mats, err
			}
			mats = append(mats, mat)
		}
	} else {
		qq := `SELECT "1CName", sum FROM "matsBy1C" WHERE "1CName" = $1 ORDER BY "1CName"`

		for _, a := range names1c {
			err := base.Db.QueryRow(ctx, qq, a).Scan(&mat.Name1C, &mat.Amout)
			if err != nil {
				return mats, err
			}
			mats = append(mats, mat)
		}
	}
	return mats, nil
}

// Добавить новую модель материала
func (base Base) InsertMat(ctx context.Context, name string, matType int) error {
	qq := `INSERT INTO public."matsName" (name, type) VALUES ($1, $2)`

	_, err := base.Db.Exec(ctx, qq, name, matType)
	return err
}

// Добавить новый материал (приемка)
func (base Base) AddMat(ctx context.Context, name string, name1c string, price int, amout int, place int) (int, error) {
	var nameId int
	qq := `SELECT "matNameId" FROM public."matsName" WHERE "name" = $1;`
	err := base.Db.QueryRow(ctx, qq, name).Scan(&nameId)
	if err != nil {
		return -1, err
	}

	qq = `UPDATE public.mats SET amout=amout + $4 WHERE name = $1 AND "1CName" = $2 AND price = $3;`
	res, err := base.Db.Exec(ctx, qq, nameId, name1c, price, amout)
	done := int(res.RowsAffected())
	if err != nil {
		return -1, err
	}
	if done != 1 {
		if done == 0 {
			qq := `INSERT INTO public.mats( "1CName", amout, name, price) VALUES ($1, $2, $3, $4);`
			res, err = base.Db.Exec(ctx, qq, name1c, amout, nameId, price)
			if err != nil {
				return -1, err
			}
			done = int(res.RowsAffected())
			if done != 1 {
				return -1, fmt.Errorf("критическая ошибка")
			}
		} else {
			return -1, fmt.Errorf("критическая ошибка")
		}

	}

	var matId int
	qq = `SELECT "matId" FROM public.mats WHERE name = $1 AND "1CName" = $2 AND price = $3;`
	err = base.Db.QueryRow(ctx, qq, nameId, name1c, price).Scan(&matId)
	if err != nil {
		return -1, err
	}

	err = base.SetMatPlace(ctx, matId, place)
	if err != nil {
		return -1, err
	}

	return matId, nil
}

// Добавление нового места хранения материалу
func (base Base) SetMatPlace(ctx context.Context, matId int, place int) error {
	qq := `INSERT INTO public.matplaces(mat, place) VALUES ($1, $2);`
	_, err := base.Db.Exec(ctx, qq, matId, place)
	if err != nil && err.Error() != `ОШИБКА: повторяющееся значение ключа нарушает ограничение уникальности "matplaces_mat_place_key" (SQLSTATE 23505)` {
		return err
	}
	return nil
}

// Передать материал в работу
func (base Base) AddMatToWork(ctx context.Context, matId int, toWork int) error {
	var amount, inWork int
	err := base.Db.QueryRow(ctx, `SELECT amout, "inWork" FROM public.mats WHERE "matId" = $1`, matId).Scan(&amount, &inWork)
	if err != nil {
		return err
	}
	if amount < toWork+inWork {
		return fmt.Errorf("нельзя взять в работу больше материалов чем есть на складе")

	}
	qq := `UPDATE public.mats SET "inWork" = "inWork" + $1 WHERE "matId" = $2;`
	_, err = base.Db.Exec(ctx, qq, toWork, matId)
	if err != nil {
		return err
	}
	return nil
}

// Вернуть материал с работы
func (base Base) RemuveMatFromWork(ctx context.Context, matId int, toWork int) error {
	var inWork int
	err := base.Db.QueryRow(ctx, `SELECT "inWork" FROM public.mats WHERE "matId" = $1`, matId).Scan(&inWork)
	if err != nil {
		return err
	}
	if inWork < toWork {
		return fmt.Errorf("нельзя снять из работы больше чем есть на производстве")
	}
	qq := `UPDATE public.mats SET "inWork" = "inWork" - $1 WHERE "matId" = $2;`
	_, err = base.Db.Exec(ctx, qq, toWork, matId)
	if err != nil {
		return err
	}
	return nil
}

// Добавть событие материалу
func (base Base) AddMatLog(ctx context.Context, matId int, amout int, eventType int, eventText string, userId int) error {
	qq := `INSERT INTO public."matLog" ("matId", "eventType", "eventText", "eventTime", "user", amout) VALUES ($1, $2, $3, $4, $5, $6);`
	_, err := base.Db.Exec(ctx, qq, matId, eventType, eventText, time.Now(), userId, amout)
	return err
}

// Получить события материала по его ID
func (base Base) TakeMatLog(ctx context.Context, matId int) ([]mytypes.MatEvent, error) {
	var matEvent mytypes.MatEvent
	var matEvents []mytypes.MatEvent
	qq := `SELECT id, "matId", "eventType", "eventText", "eventTime", user, amout FROM public."matLog" WHERE "matId" = $1 ORDER BY "eventTime";`
	rows, err := base.Db.Query(ctx, qq, matId)
	if err != nil {
		return matEvents, err
	}
	for rows.Next() {
		err := rows.Scan(&matEvent.LogId, &matEvent.MatId, &matEvent.EventType, &matEvent.EventText, &matEvent.EventTime, &matEvent.User, &matEvent.Amout)
		if err != nil {
			return matEvents, err
		}
		matEvents = append(matEvents, matEvent)
	}
	return matEvents, nil
}

// Получить чистых событий материала по его ID
func (base Base) TakeCleanMatLog(ctx context.Context, matId ...int) ([]mytypes.MatEventClean, error) {
	var matEvent mytypes.MatEventClean
	var matEvents []mytypes.MatEventClean
	if len(matId) == 0 {
		qq := `SELECT id, "matId", "eventType", "eventText", "eventTime", "user", amout FROM public."CleanMatLog" ORDER BY "eventTime";`
		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return matEvents, err
		}
		for rows.Next() {
			var evtime time.Time
			err := rows.Scan(&matEvent.LogId, &matEvent.MatId, &matEvent.EventType, &matEvent.EventText, &evtime, &matEvent.User, &matEvent.Amout)
			if err != nil {
				return matEvents, err
			}
			matEvent.EventTime = evtime.Format("02.01.2006 15:04:05")
			matEvents = append(matEvents, matEvent)
		}
	} else {
		qq := `SELECT id, "matId", "eventType", "eventText", "eventTime", "user", amout FROM public."CleanMatLog" WHERE "matId" = $1 ORDER BY "eventTime";`
		for _, id := range matId {
			rows, err := base.Db.Query(ctx, qq, id)
			if err != nil {
				return matEvents, err
			}
			for rows.Next() {
				var evtime time.Time
				err := rows.Scan(&matEvent.LogId, &matEvent.MatId, &matEvent.EventType, &matEvent.EventText, &evtime, &matEvent.User, &matEvent.Amout)
				if err != nil {
					return matEvents, err
				}
				matEvent.EventTime = evtime.Format("02.01.2006 15:04:05")
				matEvents = append(matEvents, matEvent)
			}
		}
	}
	return matEvents, nil
}

////////////

// Сборки //

////////////

// InsertBuild вставляет несколько записей о сборках в базу данных.
//
// Функция принимает переменное количество объектов типа `mytypes.Build` в качестве входных данных и вставляет их в таблицу `builds` в базе данных.
// Она возвращает количество успешно вставленных записей и ошибку, если она возникла.
func (base Base) InsertBuild(ctx context.Context, builds ...mytypes.Build) (int, error) {
	qq := `INSERT INTO public.builds("buildId", "dModel", "tModel") VALUES ($1, $2, $3);`
	counter := 0
	for _, build := range builds {

		var id int
		err := base.Db.QueryRow(ctx, `SELECT "buildId" FROM builds ORDER BY "buildId" DESC`).Scan(&id)
		if err != nil {
			if err.Error() != "no rows in result set" {
				return counter, err
			}
			id = 0
		}
		id++

		_, err = base.Db.Exec(ctx, qq, id, build.DModel, build.TModel)
		if err != nil {
			return counter, err
		}

		for _, a := range build.BuildList {
			_, err := base.Db.Exec(ctx, `INSERT INTO public."buildMatList"("billdId", "mat", amout) VALUES ($1, $2, $3);`, id, a.MatId, a.Amout)
			if err != nil {
				return counter, err
			}
		}
		counter++
	}

	return counter, nil
}

// TakeBuildById извлекает сборку из базы данных по ее идентификатору.
//
// Принимает параметры context.Context и id типа int.
// Возвращает структуру mytypes.Build и ошибку.
func (base Base) TakeBuildById(ctx context.Context, id int) (mytypes.Build, error) {
	var Build mytypes.Build
	qq := `SELECT "buildId", "dModel", "tModel" FROM public.builds WHERE "buildId" = $1;`
	err := base.Db.QueryRow(ctx, qq, id).Scan(&Build.Id, &Build.DModel, &Build.TModel)
	if err != nil {
		return Build, err
	}

	qq = `SELECT "mat", amout FROM public."buildMatList" WHERE "billdId" = $1;`
	rows, err := base.Db.Query(ctx, qq, Build.Id)
	if err != nil {
		return Build, err
	}

	var buildlist []mytypes.BuildListElement
	var buildElement mytypes.BuildListElement
	for rows.Next() {
		err := rows.Scan(&buildElement.MatId, &buildElement.Amout)
		if err != nil {
			return Build, err
		}
		buildlist = append(buildlist, buildElement)
	}
	Build.BuildList = buildlist

	return Build, nil
}

// Получить чистую сборку по ее ID
func (base Base) TakeCleanBuildById(ctx context.Context, id int) (mytypes.BuildClean, error) {
	qq := ` SELECT builds."buildId",
		"tModels"."tModelsName" AS "tModel",
		"dModels"."dModelName" AS "dModel"
	FROM builds
		LEFT JOIN "tModels" ON builds."tModel" = "tModels"."tModelsId"
		LEFT JOIN "dModels" ON builds."dModel" = "dModels"."dModelsId"
	WHERE builds."buildId" = $1;`
	var build mytypes.BuildClean

	rows, err := base.Db.Query(ctx, qq, id)
	if err != nil {
		return build, err
	}

	for rows.Next() {

		err := rows.Scan(&build.Id, &build.TModel, &build.DModel)
		if err != nil {
			return build, err
		}

		qq = `SELECT "mat", amout FROM public."cleanBuildMatList" WHERE "billdId" = $1;`
		rows, err := base.Db.Query(ctx, qq, build.Id)
		if err != nil {
			if err.Error() == "no rows in result set" {
				continue
			}
			return build, err
		}

		var buildlist []mytypes.BuildListElementClean
		var buildElement mytypes.BuildListElementClean
		for rows.Next() {
			err := rows.Scan(&buildElement.Mat, &buildElement.Amout)
			if err != nil {
				return build, err
			}
			buildlist = append(buildlist, buildElement)
		}
		build.BuildList = buildlist
	}
	return build, nil
}

// Получить лист сборок относящихся к модели T-KOM
func (base Base) TakeBuildByTModel(ctx context.Context, TModels ...int) ([]mytypes.Build, error) {
	var Builds []mytypes.Build
	if len(TModels) > 0 {
		qq := `SELECT "buildId", "dModel", "tModel" FROM public.builds WHERE "tModel" = $1;`
		for _, a := range TModels {

			var build mytypes.Build

			err := base.Db.QueryRow(ctx, qq, a).Scan(&build.Id, &build.DModel, &build.TModel)
			if err != nil {
				return Builds, err
			}

			qq = `SELECT "mat", amout FROM public."buildMatList" WHERE "billdId" = $1;`
			rows, err := base.Db.Query(ctx, qq, build.Id)
			if err != nil {
				return Builds, err
			}

			var buildlist []mytypes.BuildListElement
			var buildElement mytypes.BuildListElement
			for rows.Next() {
				err := rows.Scan(&buildElement.MatId, &buildElement.Amout)
				if err != nil {
					return Builds, err
				}
				buildlist = append(buildlist, buildElement)
			}
			build.BuildList = buildlist
			Builds = append(Builds, build)
		}

	} else {

		qq := `SELECT "buildId", "dModel", "tModel" FROM public.builds;`

		var build mytypes.Build
		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return Builds, err
		}

		for rows.Next() {
			err := rows.Scan(&build.Id, &build.DModel, &build.TModel)
			if err != nil {
				return Builds, err
			}

			qq = `SELECT amout, mat FROM public."buildMatList" WHERE "billdId" = $1;`

			rows, err := base.Db.Query(ctx, qq, build.Id)
			if err != nil {
				return Builds, err
			}

			var buildlist []mytypes.BuildListElement
			var buildElement mytypes.BuildListElement
			for rows.Next() {
				err := rows.Scan(&buildElement.Amout, &buildElement.MatId)
				if err != nil {
					return Builds, err
				}
				buildlist = append(buildlist, buildElement)
			}
			build.BuildList = buildlist
			Builds = append(Builds, build)
		}
	}
	return Builds, nil
}

// Получить лист сборок относящихся к модели поставщика
func (base Base) TakeBuildByDModel(ctx context.Context, DModels ...int) ([]mytypes.Build, error) {
	var Builds []mytypes.Build
	if len(DModels) > 0 {
		qq := `SELECT "buildId", "dModel", "tModel" FROM public.builds WHERE "dModel" = $1;`
		for _, a := range DModels {

			var build mytypes.Build

			err := base.Db.QueryRow(ctx, qq, a).Scan(&build.Id, &build.DModel, &build.TModel)
			if err != nil {
				return Builds, err
			}

			qq = `SELECT "mat", amout FROM public."buildMatList" WHERE "billdId" = $1;`
			rows, err := base.Db.Query(ctx, qq, build.Id)
			if err != nil {
				return Builds, err
			}

			var buildlist []mytypes.BuildListElement
			var buildElement mytypes.BuildListElement
			for rows.Next() {
				err := rows.Scan(&buildElement.MatId, &buildElement.Amout)
				if err != nil {
					return Builds, err
				}
				buildlist = append(buildlist, buildElement)
			}
			build.BuildList = buildlist
			Builds = append(Builds, build)
		}

	} else {

		qq := `SELECT "buildId", "dModel", "tModel" FROM public.builds;`

		var build mytypes.Build
		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return Builds, err
		}

		for rows.Next() {
			err := rows.Scan(&build.Id, &build.DModel, &build.TModel)
			if err != nil {
				return Builds, err
			}

			qq = `SELECT amout, mat FROM public."buildMatList" WHERE "billdId" = $1;`

			rows, err := base.Db.Query(ctx, qq, build.Id)
			if err != nil {
				return Builds, err
			}

			var buildlist []mytypes.BuildListElement
			var buildElement mytypes.BuildListElement
			for rows.Next() {
				err := rows.Scan(&buildElement.Amout, &buildElement.MatId)
				if err != nil {
					return Builds, err
				}
				buildlist = append(buildlist, buildElement)
			}
			build.BuildList = buildlist
			Builds = append(Builds, build)
		}
	}
	return Builds, nil
}

// Получить лист чистых сборок относящихся к модели T-KOM
func (base Base) TakeCleanBuildByTModel(ctx context.Context, TModels ...int) ([]mytypes.BuildClean, error) {
	var Builds []mytypes.BuildClean
	if len(TModels) > 0 {
		qq := ` SELECT builds."buildId",
					"tModels"."tModelsName" AS "tModel",
					"dModels"."dModelName" AS "dModel"
	  			FROM builds
		 			LEFT JOIN "tModels" ON builds."tModel" = "tModels"."tModelsId"
		 			LEFT JOIN "dModels" ON builds."dModel" = "dModels"."dModelsId"
				WHERE builds."tModel" = $1;`
		for _, a := range TModels {

			var build mytypes.BuildClean

			rows, err := base.Db.Query(ctx, qq, a)
			if err != nil {
				if err.Error() == "no rows in result set" {
					continue
				}
				return Builds, err
			}

			for rows.Next() {

				err := rows.Scan(&build.Id, &build.TModel, &build.DModel)
				if err != nil {
					return Builds, err
				}

				qq = `SELECT "mat", amout FROM public."cleanBuildMatList" WHERE "billdId" = $1;`
				rows, err := base.Db.Query(ctx, qq, build.Id)
				if err != nil {
					if err.Error() == "no rows in result set" {
						continue
					}
					return Builds, err
				}

				var buildlist []mytypes.BuildListElementClean
				var buildElement mytypes.BuildListElementClean
				for rows.Next() {
					err := rows.Scan(&buildElement.Mat, &buildElement.Amout)
					if err != nil {
						return Builds, err
					}
					buildlist = append(buildlist, buildElement)
				}
				build.BuildList = buildlist
				Builds = append(Builds, build)
			}

		}

	} else if len(TModels) == 0 {

		qq := `SELECT "buildId", "dModel", "tModel" FROM public."cleanBuilds";`

		var build mytypes.BuildClean
		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return Builds, err
		}

		for rows.Next() {
			err := rows.Scan(&build.Id, &build.DModel, &build.TModel)
			if err != nil {
				return Builds, err
			}

			qq = `SELECT amout, mat FROM public."cleanBuildMatList" WHERE "billdId" = $1;`

			rows, err := base.Db.Query(ctx, qq, build.Id)
			if err != nil {
				return Builds, err
			}

			var buildlist []mytypes.BuildListElementClean
			var buildElement mytypes.BuildListElementClean
			for rows.Next() {
				err := rows.Scan(&buildElement.Amout, &buildElement.Mat)
				if err != nil {
					return Builds, err
				}
				buildlist = append(buildlist, buildElement)
			}
			build.BuildList = buildlist
			Builds = append(Builds, build)
		}
	}
	return Builds, nil
}

// Получить лист чистых сборок относящихся к модели поставщика
func (base Base) TakeCleanBuildByDModel(ctx context.Context, DModels ...int) ([]mytypes.BuildClean, error) {
	var Builds []mytypes.BuildClean
	if len(DModels) > 0 {
		qq := ` SELECT builds."buildId",
					"tModels"."tModelsName" AS "tModel",
					"dModels"."dModelName" AS "dModel"
	  			FROM builds
		 			LEFT JOIN "tModels" ON builds."tModel" = "tModels"."tModelsId"
		 			LEFT JOIN "dModels" ON builds."dModel" = "dModels"."dModelsId"
				WHERE builds."dModel" = $1;`
		for _, a := range DModels {

			var build mytypes.BuildClean

			rows, err := base.Db.Query(ctx, qq, a)
			if err != nil {
				if err.Error() == "no rows in result set" {
					continue
				}
				return Builds, err
			}

			for rows.Next() {

				err := rows.Scan(&build.Id, &build.TModel, &build.DModel)
				if err != nil {
					return Builds, err
				}

				qq = `SELECT "mat", amout FROM public."cleanBuildMatList" WHERE "billdId" = $1;`
				rows, err := base.Db.Query(ctx, qq, build.Id)
				if err != nil {
					if err.Error() == "no rows in result set" {
						continue
					}
					return Builds, err
				}

				var buildlist []mytypes.BuildListElementClean
				var buildElement mytypes.BuildListElementClean
				for rows.Next() {
					err := rows.Scan(&buildElement.Mat, &buildElement.Amout)
					if err != nil {
						return Builds, err
					}
					buildlist = append(buildlist, buildElement)
				}
				build.BuildList = buildlist
				Builds = append(Builds, build)
			}

		}

	} else {

		qq := `SELECT "buildId", "dModel", "tModel" FROM public."cleanBuilds";`

		var build mytypes.BuildClean
		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return Builds, err
		}

		for rows.Next() {
			err := rows.Scan(&build.Id, &build.DModel, &build.TModel)
			if err != nil {
				return Builds, err
			}

			qq = `SELECT amout, mat FROM public."cleanBuildMatList" WHERE "billdId" = $1;`

			rows, err := base.Db.Query(ctx, qq, build.Id)
			if err != nil {
				return Builds, err
			}

			var buildlist []mytypes.BuildListElementClean
			var buildElement mytypes.BuildListElementClean
			for rows.Next() {
				err := rows.Scan(&buildElement.Amout, &buildElement.Mat)
				if err != nil {
					return Builds, err
				}
				buildlist = append(buildlist, buildElement)
			}
			build.BuildList = buildlist
			Builds = append(Builds, build)
		}
	}
	return Builds, nil
}

// [buildId]amout
func (base Base) TakeCanBuildMap(ctx context.Context) (map[int]int, error) {
	canbuld := make(map[int]int)
	canbuld[-1] = -1

	qq := `SELECT "buildId", "amout" FROM public.canbebuilded`
	rows, err := base.Db.Query(ctx, qq)
	if err != nil {

		return canbuld, err
	}

	var id, amout int
	for rows.Next() {
		err := rows.Scan(&id, &amout)
		if err != nil {

			return canbuld, err
		}
		canbuld[id] = amout
	}
	return canbuld, nil
}

func (base Base) TakeCanBuildByDmodel(ctx context.Context, dmodel int) int {
	qq := ` SELECT 
		LEAST(COALESCE(modelcount.count, 0::bigint), COALESCE(matcount.minmat, 0::bigint)) AS amout
	FROM "dModels"
		LEFT JOIN ( SELECT sns.dmodel,
				count(sns."snsId") AS count
			FROM sns
			WHERE sns.condition = 2 AND sns.shiped = false
			GROUP BY sns.dmodel) modelcount ON "dModels"."dModelsId" = modelcount.dmodel
		LEFT JOIN ( SELECT "buildMatList"."billdId" AS build,
				min(matsamout.sum / "buildMatList".amout) AS minmat
			FROM "buildMatList"
				LEFT JOIN ( SELECT mats.name,
						sum(mats.amout) AS sum
					FROM mats
					GROUP BY mats.name) matsamout ON "buildMatList".mat = matsamout.name
			GROUP BY "buildMatList"."billdId") matcount ON matcount.build = "dModels"."build"
	WHERE "dModels"."dModelsId" = $1`

	var amout int
	err := base.Db.QueryRow(ctx, qq, dmodel).Scan(&amout)
	if err != nil {
		return 0
	}
	return amout
}

func (base Base) TakeCanBuildByOrder(ctx context.Context, order int, current bool) ([]mytypes.CanBuild, error) {
	var canbuild []mytypes.CanBuild
	var element mytypes.CanBuild
	var qq string
	if current {
		qq = `SELECT builds."buildId",
			builds."dModel",
			builds."tModel",
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
				INNER JOIN (SELECT model FROM "orderList"
						WHERE "orderId" = $1)ordermodel ON ordermodel.model = builds."tModel"
				INNER JOIN "dModels" ON "dModels".build = builds."buildId"
		WHERE builds."buildId" <> '-1'::integer AND LEAST(COALESCE(modelcount.count, 0::bigint), COALESCE(matcount.minmat, 0::bigint)) > 0`
	} else {
		qq = `SELECT builds."buildId",
			builds."dModel",
			builds."tModel",
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
				INNER JOIN (SELECT model FROM "orderList"
						WHERE "orderId" = $1)ordermodel ON ordermodel.model = builds."tModel"
		WHERE builds."buildId" <> '-1'::integer AND LEAST(COALESCE(modelcount.count, 0::bigint), COALESCE(matcount.minmat, 0::bigint)) > 0`
	}

	rows, err := base.Db.Query(ctx, qq, order)
	if err != nil {
		return canbuild, err
	}

	for rows.Next() {
		err := rows.Scan(&element.BuildID, &element.DModel, &element.TModel, &element.Amout)
		if err != nil {
			return canbuild, err
		}
		canbuild = append(canbuild, element)
	}

	return canbuild, nil
}

func (base Base) TakeCanBuildByOrderTmodel(ctx context.Context, order int, tmodel int, current bool) ([]mytypes.CanBuild, error) {
	var canbuild []mytypes.CanBuild
	var element mytypes.CanBuild
	var qq string
	if current {
		qq = `SELECT builds."buildId",
		builds."dModel",
		builds."tModel",
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
			INNER JOIN "dModels" ON "dModels".build = builds."buildId"
	WHERE builds."buildId" <> '-1'::integer AND LEAST(COALESCE(modelcount.count, 0::bigint), COALESCE(matcount.minmat, 0::bigint)) > 0 AND builds."tModel" = $2`
	} else {
		qq = `SELECT builds."buildId",
			builds."dModel",
			builds."tModel",
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
		WHERE builds."buildId" <> '-1'::integer AND LEAST(COALESCE(modelcount.count, 0::bigint), COALESCE(matcount.minmat, 0::bigint)) > 0 AND builds."tModel" = $2`
	}

	rows, err := base.Db.Query(ctx, qq, order, tmodel)
	if err != nil {
		return canbuild, err
	}

	for rows.Next() {
		err := rows.Scan(&element.BuildID, &element.DModel, &element.TModel, &element.Amout)
		if err != nil {
			return canbuild, err
		}
		canbuild = append(canbuild, element)
	}

	return canbuild, nil
}

////////////

// Модели //

////////////

func (base Base) TakeTModelsById(ctx context.Context, Ids ...int) ([]mytypes.TModel, error) {
	var TModels []mytypes.TModel
	var TModel mytypes.TModel

	if len(Ids) == 0 {
		qq := `SELECT "tModelsId", "tModelsName", kigid, ds FROM public."tModels" ORDER BY "tModelsName";`

		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return nil, err
		}
		for rows.Next() {
			err := rows.Scan(&TModel.Id, &TModel.Name, &TModel.KigId, &TModel.DsId)
			if err != nil {
				return TModels, err
			}
			TModels = append(TModels, TModel)
		}

	} else {
		qq := `SELECT "tModelsId", "tModelsName", kigid, ds FROM public."tModels" WHERE "tModelsId" = $1 ORDER BY "tModelsName";`

		for _, a := range Ids {
			err := base.Db.QueryRow(ctx, qq, a).Scan(&TModel.Id, &TModel.Name, &TModel.KigId, &TModel.DsId)
			if err != nil {
				return TModels, err
			}
			TModels = append(TModels, TModel)
		}
	}
	return TModels, nil
}

func (base Base) TakeDModelsById(ctx context.Context, Ids ...int) ([]mytypes.DModel, error) {
	var DModels []mytypes.DModel
	var DModel mytypes.DModel

	if len(Ids) == 0 {
		qq := `SELECT "dModelsId", "dModelName", build FROM public."dModels" ORDER BY "dModelName";`

		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return nil, err
		}
		for rows.Next() {
			err := rows.Scan(&DModel.Id, &DModel.Name, &DModel.Build)
			if err != nil {
				return DModels, err
			}
			DModels = append(DModels, DModel)
		}

	} else {
		qq := `SELECT "dModelsId", "dModelName", build FROM public."dModels" WHERE "dModelsId" = $1 ORDER BY "dModelName";`

		for _, a := range Ids {
			err := base.Db.QueryRow(ctx, qq, a).Scan(&DModel.Id, &DModel.Name, &DModel.Build)
			if err != nil {
				return DModels, err
			}
			DModels = append(DModels, DModel)
		}
	}
	return DModels, nil
}

func (base Base) ChangeDefBuild(ctx context.Context, dModelId int, newBuild int) error {
	qq := `UPDATE public."dModels" SET "build" = $1 WHERE "dModelsId" = $2;`

	_, err := base.Db.Exec(ctx, qq, newBuild, dModelId)
	if err != nil {
		return err
	}
	return nil
}

func (base Base) ChangeTModelKig(ctx context.Context, tModelId int, newKigId string) error {
	qq := `UPDATE public."tModels" SET kigid = $1 WHERE "tModelsId" = $2;`

	_, err := base.Db.Exec(ctx, qq, newKigId, tModelId)
	if err != nil {
		return err
	}
	return nil
}

func (base Base) ChangeTModelDs(ctx context.Context, tModelId int, newDsId string) error {
	qq := `UPDATE public."tModels" SET ds = $1 WHERE "tModelsId" = $2;`

	_, err := base.Db.Exec(ctx, qq, newDsId, tModelId)
	if err != nil {
		return err
	}
	return nil
}

////////////

// Задачи //

////////////

func (base Base) TakeTasksById(ctx context.Context, Ids ...int) ([]mytypes.Task, error) {
	var Tasks []mytypes.Task
	var Task mytypes.Task

	if len(Ids) == 0 {
		qq := `SELECT id, name, description, cololor, priority, datestart, dateend, complete, autor FROM public.tasks WHERE complete = false ORDER BY dateend;`

		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return nil, err
		}

		for rows.Next() {
			err := rows.Scan(&Task.Id, &Task.Name, &Task.Description, &Task.Color, &Task.Priority, &Task.DateStart, &Task.DateEnd, &Task.Complete, &Task.Autor)
			if err != nil {
				return Tasks, err
			}
			var TaskWorkList []mytypes.TaskWorkList
			var TaskWork mytypes.TaskWorkList
			qqq := `SELECT  id, tmodel, amout, done, datechange FROM public."taskWorkList" WHERE "taskId" = $1;`
			taskrows, err := base.Db.Query(ctx, qqq, Task.Id)
			if err != nil {
				return Tasks, err
			}

			for taskrows.Next() {
				err := taskrows.Scan(&TaskWork.Id, &TaskWork.TModel, &TaskWork.Amout, &TaskWork.Done, &TaskWork.Date)
				if err != nil {
					return Tasks, err
				}
				TaskWorkList = append(TaskWorkList, TaskWork)
			}

			Task.WorkList = TaskWorkList

			Tasks = append(Tasks, Task)
		}

	} else {
		qq := `SELECT id, name, description, cololor, priority, datestart, dateend, complete, autor FROM public.tasks WHERE id = $1 ORDER BY dateend;`

		for _, id := range Ids {
			err := base.Db.QueryRow(ctx, qq, id).Scan(&Task.Id, &Task.Name, &Task.Description, &Task.Color, &Task.Priority, &Task.DateStart, &Task.DateEnd, &Task.Complete, &Task.Autor)
			if err != nil {
				return Tasks, err
			}

			var TaskWorkList []mytypes.TaskWorkList
			var TaskWork mytypes.TaskWorkList
			qqq := `SELECT  id, tmodel, amout, done, datechange FROM public."taskWorkList" WHERE "taskId" = $1;`
			taskrows, err := base.Db.Query(ctx, qqq, Task.Id)
			if err != nil {
				return Tasks, err
			}

			for taskrows.Next() {
				err := taskrows.Scan(&TaskWork.Id, &TaskWork.TModel, &TaskWork.Amout, &TaskWork.Done, &TaskWork.Date)
				if err != nil {
					return Tasks, err
				}
				TaskWorkList = append(TaskWorkList, TaskWork)
			}

			Task.WorkList = TaskWorkList
			Tasks = append(Tasks, Task)
		}
	}

	return Tasks, nil
}

func (base Base) TakeCleanTasksById(ctx context.Context, Ids ...int) ([]mytypes.CleanTask, error) {
	var Tasks []mytypes.CleanTask
	var Task mytypes.CleanTask

	if len(Ids) == 0 {
		qq := `SELECT id, "CleanTasks".name, description, cololor, priority, datestart, dateend, complete, autor FROM public."CleanTasks" WHERE complete = false ORDER BY dateend;`

		rows, err := base.Db.Query(ctx, qq)
		if err != nil {
			return nil, err
		}

		for rows.Next() {
			var timeStart, timeEnd time.Time
			err := rows.Scan(&Task.Id, &Task.Name, &Task.Description, &Task.Color, &Task.Priority, &timeStart, &timeEnd, &Task.Complete, &Task.Autor)
			if err != nil {
				return Tasks, err
			}
			Task.DateStart = timeStart.Format("02.01.2006")
			Task.DateEnd = timeEnd.Format("02.01.2006")
			var TaskWorkList []mytypes.CleanTaskWorkList
			var TaskWork mytypes.CleanTaskWorkList
			qqq := `SELECT  id, tmodel, amout, done, datechange FROM public."CleanTaskWorkList" WHERE "taskId" = $1;`
			taskrows, err := base.Db.Query(ctx, qqq, Task.Id)
			if err != nil {
				return Tasks, err
			}

			for taskrows.Next() {
				err := taskrows.Scan(&TaskWork.Id, &TaskWork.TModel, &TaskWork.Amout, &TaskWork.Done, &TaskWork.Date)
				if err != nil {
					return Tasks, err
				}
				TaskWorkList = append(TaskWorkList, TaskWork)
			}

			Task.WorkList = TaskWorkList

			Tasks = append(Tasks, Task)
		}

	} else {
		qq := `SELECT id, "CleanTasks".name, description, cololor, priority, datestart, dateend, complete, autor FROM public."CleanTasks" WHERE id = $1 ORDER BY dateend;`

		for _, id := range Ids {
			var timeStart, timeEnd time.Time
			err := base.Db.QueryRow(ctx, qq, id).Scan(&Task.Id, &Task.Name, &Task.Description, &Task.Color, &Task.Priority, &timeStart, &timeEnd, &Task.Complete, &Task.Autor)
			if err != nil {
				return Tasks, err
			}
			Task.DateStart = timeStart.Format("02.01.2006")
			Task.DateEnd = timeEnd.Format("02.01.2006")
			var TaskWorkList []mytypes.CleanTaskWorkList
			var TaskWork mytypes.CleanTaskWorkList
			qqq := `SELECT  id, tmodel, amout, done, datechange FROM public."CleanTaskWorkList" WHERE "taskId" = $1;`
			taskrows, err := base.Db.Query(ctx, qqq, Task.Id)
			if err != nil {
				return Tasks, err
			}

			for taskrows.Next() {
				err := taskrows.Scan(&TaskWork.Id, &TaskWork.TModel, &TaskWork.Amout, &TaskWork.Done, &TaskWork.Date)
				if err != nil {
					return Tasks, err
				}
				TaskWorkList = append(TaskWorkList, TaskWork)
			}

			Task.WorkList = TaskWorkList
			Tasks = append(Tasks, Task)
		}
	}

	return Tasks, nil
}

func (base Base) TakeJsTaskByReqest(ctx context.Context, reqest string) ([]mytypes.TaskJs, error) {
	var Tasks []mytypes.TaskJs
	var Task mytypes.TaskJs

	qq := `SELECT id, "CleanTasks".name, description, cololor, priority, datestart, dateend, complete, autor FROM public."CleanTasks" ` + reqest

	rows, err := base.Db.Query(ctx, qq)
	if err != nil {
		return nil, err
	}

	for rows.Next() {
		var timeStart, timeEnd time.Time
		err := rows.Scan(&Task.Id, &Task.Name, &Task.Description, &Task.Color, &Task.Priority, &timeStart, &timeEnd, &Task.Complete, &Task.Autor)
		if err != nil {
			return Tasks, err
		}
		Task.DateStart = timeStart.Format("2006-01-02")
		Task.DateEnd = timeEnd.Format("2006-01-02")

		Tasks = append(Tasks, Task)
	}
	return Tasks, nil
}

func (base Base) InsertTask(ctx context.Context, task mytypes.Task) error {
	qq := `INSERT INTO public.tasks(
	name, description, cololor, priority, datestart, dateend, complete, autor)
	VALUES ( $1, $2, $3, $4, $5, $6, $7, $8);`
	_, err := base.Db.Exec(ctx, qq, task.Name, task.Description, task.Color, task.Priority, task.DateStart, task.DateEnd, task.Complete, task.Autor)
	if err != nil {
		return err
	}

	return nil
}

func (base Base) InsertTaskWorkList(ctx context.Context, taskId int, taskWorkList mytypes.TaskWorkList) error {
	qq := `INSERT INTO public."taskWorkList" ("taskId", tmodel, amout, done) VALUES ($1, $2, $3, $4);`
	_, err := base.Db.Exec(ctx, qq, taskId, taskWorkList.TModel, taskWorkList.Amout, taskWorkList.Done)
	if err != nil {
		return err
	}
	return nil
}

func (base Base) ChangeTask(ctx context.Context, task mytypes.Task) error {
	qq := `UPDATE public.tasks
	SET cololor=$2, priority=$3, datestart=$4, dateend=$5
	WHERE id=$1;`
	_, err := base.Db.Exec(ctx, qq, task.Id, task.Color, task.Priority, task.DateStart, task.DateEnd)
	return err
}

func (base Base) ChangeTaskList(ctx context.Context, taskWorkList mytypes.TaskWorkList) error {
	qq := `UPDATE public."taskWorkList"
	SET tmodel=$2, amout=$3, done=$4, datechange=$5
	WHERE id = $1;`
	_, err := base.Db.Exec(ctx, qq, taskWorkList.Id, taskWorkList.TModel, taskWorkList.Amout, taskWorkList.Done, taskWorkList.Date)
	return err
}

func (base Base) TakeRelevantTaskByTModel(ctx context.Context, model int) (taskId int, taskElementId int, err error) {
	qq := `SELECT
	"taskWorkList".id, "taskWorkList"."taskId"
	FROM public."taskWorkList"
	LEFT JOIN tasks on "taskWorkList"."taskId" = tasks.id
	WHERE complete = false And amout > done AND complete = false AND datestart <= CURRENT_DATE AND dateend >= CURRENT_DATE AND tmodel = $1
	ORDER BY priority`
	err = base.Db.QueryRow(ctx, qq, model).Scan(&taskElementId, &taskId)
	return
}

func (base Base) ProdToTask(ctx context.Context, taskId int, taskElementId int) (err error) {
	qq := `UPDATE public."taskWorkList"SET done = done + 1 WHERE "taskId" = $1 AND id = $2;`
	_, err = base.Db.Exec(ctx, qq, taskId, taskElementId)
	return
}

func (base Base) CompleatTask(ctx context.Context, taskId int) (err error) {
	qq := `UPDATE public.tasks
	SET complete = $2
	WHERE id=$1;`
	_, err = base.Db.Exec(ctx, qq, taskId, true)
	return
}

// Нужно переделать (скрипт должен сробатывать сам на сервере раз в сутки) !!!!
func (base Base) ChekTaks(ctx context.Context) (err error) {
	qq := `SELECT id FROM public.tasks
	WHERE dateend < CURRENT_DATE AND complete = false
	ORDER BY datestart DESC `

	rows, err := base.Db.Query(ctx, qq)
	if err != nil {
		return err
	}

	var id int
	for rows.Next() {
		err = rows.Scan(&id)
		if err != nil {
			return err
		}
		qqq := `UPDATE public.tasks
		SET cololor='#bb0a1e',  dateend=CURRENT_DATE
		WHERE id=$1 AND name like '%!!Просрочено!!';`
		_, err = base.Db.Exec(ctx, qqq, id)
		if err != nil {
			return err
		}

		qqq = `UPDATE public.tasks
		SET cololor='#bb0a1e',  dateend=CURRENT_DATE, name = name || ' !!Просрочено!!'
		WHERE id=$1 AND NOT name like '%!!Просрочено!!';`
		_, err = base.Db.Exec(ctx, qqq, id)
		if err != nil {
			return err
		}
	}
	return nil
}

// Материалы и их кол-ва необходимые для завершения этой задачи
func (base Base) TakeCleanMatForTask(ctx context.Context, taskId int) ([]mytypes.BuildListElementClean, error) {
	var result []mytypes.BuildListElementClean

	qq := `SELECT "buildMatList".AMOUT * SUM(BUILDEQ.AMOUT) AS AMOUT,
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
					WHERE TASKS.ID = $1
					GROUP BY TMODEL)MONTHONE
			LEFT JOIN
				(SELECT "dModels"."build",
						BUILDS."tModel"
					FROM "dModels"
					LEFT JOIN BUILDS ON BUILDS."buildId" = "dModels"."build")EQ ON MONTHONE.TMODEL = EQ."tModel"
			GROUP BY BUILD)BUILDEQ ON BUILDEQ.BUILD = "buildMatList"."billdId"
	LEFT JOIN PUBLIC."matsName" ON "matsName"."matNameId" = "buildMatList".MAT
	GROUP BY MAT,"buildMatList".AMOUT, NAME`

	rows, err := base.Db.Query(ctx, qq, taskId)
	if err != nil {
		return result, err
	}

	for rows.Next() {
		var element mytypes.BuildListElementClean
		err = rows.Scan(&element.Amout, &element.Mat)
		if err != nil {
			return result, err
		}
		result = append(result, element)
	}
	return result, nil
}

/////////////////////////

// Резервирование ДЕМО //

/////////////////////////

func (base Base) InsertReservation(ctx context.Context, reservTask mytypes.ReservTask) error {
	qq := `INSERT INTO public.demoreservation(
		"snsId", datestart, dateend, autor, dest)
		VALUES ($1, $2, $3, $4, $5);`

	_, err := base.Db.Exec(ctx, qq, reservTask.SnsId, reservTask.DateStart, reservTask.DateEnd, reservTask.Autor, reservTask.Dest)
	if err != nil {
		return err
	}
	return nil
}

func (base Base) DeleteReservation(ctx context.Context, id int) error {
	qq := `DELETE FROM public.demoreservation WHERE id = $1;`

	_, err := base.Db.Exec(ctx, qq, id)
	if err != nil {
		return err
	}
	return nil
}

func (base Base) TakeReservation(ctx context.Context, snsId int) ([]mytypes.ReservTask, error) {
	var result []mytypes.ReservTask
	qq := `SELECT id, "snsId", datestart, dateend, autor, dest FROM public.demoreservation WHERE "snsId" = $1;`

	rows, err := base.Db.Query(ctx, qq, snsId)
	if err != nil {
		return result, err
	}

	for rows.Next() {
		var element mytypes.ReservTask
		err = rows.Scan(&element.Id, &element.SnsId, &element.DateStart, &element.DateEnd, &element.Autor, &element.Dest)
		if err != nil {
			return result, err
		}
		result = append(result, element)
	}
	return result, nil
}

func (base Base) TakeJSReservatios(ctx context.Context, snsId int) ([]mytypes.ReservTaskJS, error) {
	var result []mytypes.ReservTaskJS
	qq := `SELECT id, "snsId", datestart, dateend, users.name, dest AS autor FROM public.demoreservation LEFT JOIN users ON users.userid = demoreservation.autor WHERE "snsId" = $1;`

	rows, err := base.Db.Query(ctx, qq, snsId)
	if err != nil {
		return result, err
	}

	for rows.Next() {
		var timeStart, timeEnd time.Time
		var element mytypes.ReservTaskJS
		err = rows.Scan(&element.Id, &element.SnsId, &timeStart, &timeEnd, &element.Autor, &element.Dest)
		if err != nil {
			return result, err
		}

		element.DateStart = timeStart.Format("2006-01-02")
		element.DateEnd = timeEnd.Format("2006-01-02")
		result = append(result, element)
	}
	return result, nil
}

////////////////////

// Драфты заказов //

////////////////////

func (base Base) TakeDrafts(ctx context.Context, DraftId int) ([]mytypes.Draft, error) {
	var result []mytypes.Draft

	qq := `SELECT id, draft, model, amout FROM public.drafts WHERE draft = $1;`

	rows, err := base.Db.Query(ctx, qq, DraftId)
	if err != nil {
		return result, err
	}

	for rows.Next() {
		var element mytypes.Draft
		err = rows.Scan(&element.Id, &element.DraftId, &element.Model, &element.Amout)
		if err != nil {
			return result, err
		}
		result = append(result, element)
	}
	return result, nil
}

func (base Base) TakeClenDrafts(ctx context.Context, DraftId int) ([]mytypes.DraftClean, error) {
	var result []mytypes.DraftClean
	qq := `SELECT id, draft, model, "tModels"."tModelsName" AS modelname, amout FROM public.drafts 
	LEFT JOIN public."tModels" ON drafts.model = "tModels"."tModelsId"
	WHERE draft = $1 ORDER BY "tModels"."tModelsName"`

	rows, err := base.Db.Query(ctx, qq, DraftId)
	if err != nil {
		return result, err
	}

	for rows.Next() {
		var element mytypes.DraftClean
		err = rows.Scan(&element.Id, &element.DraftId, &element.Model, &element.ModelName, &element.Amout)
		if err != nil {
			return result, err
		}
		result = append(result, element)
	}
	return result, nil
}

func (base Base) TakeDraft(ctx context.Context, id int) (mytypes.Draft, error) {
	var result mytypes.Draft
	qq := `SELECT id, draft, model, amout FROM public.drafts WHERE id = $1;`

	err := base.Db.QueryRow(ctx, qq, id).Scan(&result.Id, &result.DraftId, &result.Model, &result.Amout)
	return result, err
}

func (base Base) DeleteDraft(ctx context.Context, id int) error {
	qq := `DELETE FROM public.drafts WHERE id = $1;`
	_, err := base.Db.Exec(ctx, qq, id)
	return err
}

func (base Base) InsertDraft(ctx context.Context, draft mytypes.Draft) error {
	qq := `INSERT INTO public.drafts(
		draft, model, amout)
		VALUES ($1, $2, $3);`

	_, err := base.Db.Exec(ctx, qq, draft.DraftId, draft.Model, draft.Amout)
	return err
}

func (base Base) UpdateDraft(ctx context.Context, id, amout, model int) error {
	qq := `UPDATE public.drafts SET model = $1, amout = $2 WHERE id = $3;`

	_, err := base.Db.Exec(ctx, qq, model, amout, id)
	return err
}

////////////////////

// Другие функции //

////////////////////

// запись токена генерации
func (base Base) NewRegenToken(user string, token string, ctx context.Context) {
	_, err := base.Db.Exec(ctx, "UPDATE users set token = $1 where login = $2", token, user)
	if err != nil {
		return
	}
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
