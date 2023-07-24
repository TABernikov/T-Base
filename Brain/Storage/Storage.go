package Storage

import (
	"T-Base/Brain/mytypes"
	"context"
	"fmt"
	"strconv"
	"time"

	"github.com/jackc/pgx/v5"
)

// Объект базы данных
type Base struct {
	db *pgx.Conn
}

// инициализация базы
func NewBase(user, pass, ip, baseName string) (*Base, error) {
	BasePointer, err := pgx.Connect(context.Background(), "postgres://"+user+":"+pass+"@localhost:5432/"+baseName+"")
	if err != nil {
		return &Base{}, err
	}
	return &Base{db: BasePointer}, nil
}

// Получение пользователя по логину
func (base Base) TakeUserByLogin(ctx context.Context, inlogin string) (mytypes.User, error) {
	u := mytypes.User{}

	row := base.db.QueryRow(ctx, "SELECT UserId, login, pass, access, name, email FROM users WHERE users.login = $1", inlogin)
	err := row.Scan(&u.UserId, &u.Login, &u.Pass, &u.Acces, &u.Name, &u.Email)

	return u, err
}

// Получение слайса пользователей по Id
func (base Base) TakeUserById(ctx context.Context, inId ...int) ([]mytypes.User, error) {
	users := []mytypes.User{}

	if len(inId) == 0 {
		u := mytypes.User{}
		rows, err := base.db.Query(ctx, "SELECT UserId, login, pass, access, name, email FROM users")
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
			row := base.db.QueryRow(ctx, "SELECT UserId, login, pass, access, name, email FROM users where id = $1", id)
			err := row.Scan(&u.UserId, &u.Login, &u.Pass, &u.Acces, &u.Name, &u.Email)
			if err != nil {
				return users, err
			}
			users = append(users, u)
		}
	}

	return users, nil
}

// запись токена генерации
func (base Base) NewRegenToken(user string, token string, ctx context.Context) {
	res, err := base.db.Exec(ctx, "UPDATE users set token = $1 where login = $2", token, user)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(res.RowsAffected())
}

// Получение слайса девайсов по Id
func (base Base) TakeDeviceById(ctx context.Context, inId ...int) ([]mytypes.DeviceRaw, error) {
	devices := []mytypes.DeviceRaw{}
	device := mytypes.DeviceRaw{}

	if len(inId) == 0 {
		rows, err := base.db.Query(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns`)
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
			row := base.db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns Where "snsId" = $1`, id)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				return devices, err
			}
			devices = append(devices, device)
		}
	}
	return devices, nil
}

// добавление устройств в базу
func (base Base) InsertDiviceToSns(ctx context.Context, devices ...mytypes.DeviceRaw) error {
	for _, device := range devices {
		qq := `INSERT INTO sns(
			sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder")
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)`
		_, err := base.db.Exec(ctx, qq, device.Sn, device.Mac, device.DModel, device.Rev, device.TModel, device.Name, device.Condition, device.CondDate, device.Order, device.Place, device.Shiped, device.ShipedDate, device.ShippedDest, device.TakenDate, device.TakenDoc, device.TakenOrder)
		if err != nil {
			return err
		}
	}
	return nil
}

// Получение стлайса устройств по условию SQL
func (base Base) TakeDeviceByRequest(ctx context.Context, request string) ([]mytypes.DeviceRaw, error) {
	devices := []mytypes.DeviceRaw{}
	device := mytypes.DeviceRaw{}

	qq := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns `

	rows, err := base.db.Query(ctx, qq+request)
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

// Получение слайса читабельных девайсов по Id
func (base Base) TakeCleanDeviceById(ctx context.Context, inId ...int) ([]mytypes.DeviceClean, error) {
	devices := []mytypes.DeviceClean{}
	device := mytypes.DeviceClean{}
	var CondDate, ShipedDate, TakenDate time.Time
	var Shiped bool

	if len(inId) == 0 {
		rows, err := base.db.Query(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM "cleanSns" order by "snsId"`)
		if err != nil {
			return devices, err
		}

		for rows.Next() {
			err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				return devices, err
			}
			device.CondDate = CondDate.Format("02.01.2006")
			device.ShipedDate = ShipedDate.Format("02.01.2006")
			device.TakenDate = TakenDate.Format("02.01.2006")
			device.Shiped = strconv.FormatBool(Shiped)
			devices = append(devices, device)
		}

	} else {
		for _, id := range inId {
			row := base.db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM "cleanSns" Where "snsId" = $1 order by "snsId"`, id)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				return devices, err
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

	qq := `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM "cleanSns" order by "snsId" `

	rows, err := base.db.Query(ctx, qq+request)
	if err != nil {
		return devices, err
	}

	for rows.Next() {
		err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder)
		if err != nil {
			return devices, err
		}
		device.CondDate = CondDate.Format("02.01.2006")
		device.ShipedDate = ShipedDate.Format("02.01.2006")
		device.TakenDate = TakenDate.Format("02.01.2006")
		device.Shiped = strconv.FormatBool(Shiped)
		devices = append(devices, device)
	}

	return devices, nil
}

// Получение стлайса устройств по условию серийным номерам
func (base Base) TakeDeviceBySn(ctx context.Context, inSn ...string) ([]mytypes.DeviceRaw, error) {
	devices := []mytypes.DeviceRaw{}
	device := mytypes.DeviceRaw{}

	if len(inSn) == 0 {
		rows, err := base.db.Query(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns`)
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
			row := base.db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns Where sn = $1`, sn)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &device.CondDate, &device.Order, &device.Place, &device.Shiped, &device.ShipedDate, &device.ShippedDest, &device.TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				continue
			}
			devices = append(devices, device)
		}
	}
	return devices, nil
}

// Получение стлайса читабельных устройств по условию серийным номерам
func (base Base) TakeCleanDeviceBySn(ctx context.Context, inSn ...string) ([]mytypes.DeviceClean, error) {
	devices := []mytypes.DeviceClean{}
	device := mytypes.DeviceClean{}
	var CondDate, ShipedDate, TakenDate time.Time
	var Shiped bool

	if len(inSn) == 0 {
		rows, err := base.db.Query(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM "cleanSns"`)
		if err != nil {
			return devices, err
		}

		for rows.Next() {
			err := rows.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				return devices, err
			}
			device.CondDate = CondDate.Format("02.01.2006")
			device.ShipedDate = ShipedDate.Format("02.01.2006")
			device.TakenDate = TakenDate.Format("02.01.2006")
			device.Shiped = strconv.FormatBool(Shiped)
			devices = append(devices, device)

		}

	} else {
		for _, sn := range inSn {
			row := base.db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM "cleanSns" Where sn = $1`, sn)
			err := row.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &CondDate, &device.Order, &device.Place, &Shiped, &ShipedDate, &device.ShippedDest, &TakenDate, &device.TakenDoc, &device.TakenOrder)
			if err != nil {
				continue
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

// Получение кол-ва устройств на складе по заказам
func (base Base) TakeStorageCount(ctx context.Context) ([]mytypes.StorageCount, error) {
	storage := []mytypes.StorageCount{}
	deviceCount := mytypes.StorageCount{}

	qq := `SELECT "order", name, count FROM wear`

	rows, err := base.db.Query(ctx, qq)
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
func (base Base) TakeStorageCountByPlace(ctx context.Context) ([]mytypes.StorageByPlaceCount, error) {
	storage := []mytypes.StorageByPlaceCount{}
	deviceCount := mytypes.StorageByPlaceCount{}

	qq := `SELECT "place", name, count FROM "wearByPlace"`

	rows, err := base.db.Query(ctx, qq)
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
