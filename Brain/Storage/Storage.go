package Storage

import (
	"T-Base/Brain/mytypes"
	"context"
	"database/sql"
	"fmt"
	"strconv"
	"time"
)

// Объект базы данных
type Base struct {
	db *sql.DB
}

// инициализация базы
func NewBase(user, pass, ip, baseName string) (*Base, error) {
	BasePointer, err := sql.Open("mysql", user+":"+pass+"@tcp("+ip+")/"+baseName)
	if err != nil {
		return &Base{}, err
	}
	return &Base{db: BasePointer}, nil
}

// Получение слайса девайсов из базы по SQL условию
func (base Base) TakeDeviceByRequest(ctx context.Context, request string) ([]mytypes.DeviceRaw, error) {
	var devices []mytypes.DeviceRaw
	qq := "SELECT `sns`.`snsId`, `sns`.`sn`,`sns`.`mac`,`sns`.`dmodel`,`sns`.`rev`,`sns`.`tmodel`,`sns`.`name`,`sns`.`condition`,`sns`.`condDate`,`sns`.`order`,`sns`.`place`,`sns`.`shiped`,`sns`.`shipedDate`,`sns`.`shippedDest`,`sns`.`takenDate`,`sns`.`takenDoc`,`sns`.`takenOrder`FROM `t-base`.`sns` "
	var res *sql.Rows
	var err error
	if request == "" {
		res, err = base.db.QueryContext(ctx, qq)
	} else {
		res, err = base.db.QueryContext(ctx, qq+request)
	}
	if err != nil {
		return devices, err
	}

	for res.Next() {
		var device mytypes.DeviceRaw
		var strCondDate, strShipedDate, strTakenDate string

		res.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &strCondDate, &device.Order, &device.Place, &device.Shiped, &strShipedDate, &device.ShippedDest, &strTakenDate, &device.TakenDoc, device.TakenOrder)

		device.CondDate, _ = time.Parse("2006-01-02", strCondDate)
		device.ShipedDate, _ = time.Parse("2006-01-02", strShipedDate)
		device.TakenDate, _ = time.Parse("2006-01-02", strTakenDate)

		devices = append(devices, device)
	}

	return devices, nil
}

// Получение слайса девайсов из базы по их ID
func (base Base) TakeDeviceById(ctx context.Context, id ...int) ([]mytypes.DeviceRaw, error) {
	qq := "SELECT `sns`.`snsId`, `sns`.`sn`,`sns`.`mac`,`sns`.`dmodel`,`sns`.`rev`,`sns`.`tmodel`,`sns`.`name`,`sns`.`condition`,`sns`.`condDate`,`sns`.`order`,`sns`.`place`,`sns`.`shiped`,`sns`.`shipedDate`,`sns`.`shippedDest`,`sns`.`takenDate`,`sns`.`takenDoc`,`sns`.`takenOrder`FROM `t-base`.`sns` "
	var devices []mytypes.DeviceRaw

	var res *sql.Rows
	var err error

	if len(id) == 0 {
		res, err = base.db.QueryContext(ctx, qq)

		if err != nil {
			return devices, err
		}

		for res.Next() {
			var device mytypes.DeviceRaw
			var strCondDate, strShipedDate, strTakenDate string

			res.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &strCondDate, &device.Order, &device.Place, &device.Shiped, &strShipedDate, &device.ShippedDest, &strTakenDate, &device.TakenDoc, device.TakenOrder)

			device.CondDate, _ = time.Parse("2006-01-02", strCondDate)
			device.ShipedDate, _ = time.Parse("2006-01-02", strShipedDate)
			device.TakenDate, _ = time.Parse("2006-01-02", strTakenDate)

			devices = append(devices, device)
		}
	} else {

		for _, a := range id {
			var device mytypes.DeviceRaw
			var strCondDate, strShipedDate, strTakenDate string

			res := base.db.QueryRowContext(ctx, qq+"where snsid = "+strconv.Itoa(a))
			res.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &strCondDate, &device.Order, &device.Place, &device.Shiped, &strShipedDate, &device.ShippedDest, &strTakenDate, &device.TakenDoc, device.TakenOrder)
			device.CondDate, _ = time.Parse("2006-01-02", strCondDate)
			device.ShipedDate, _ = time.Parse("2006-01-02", strShipedDate)
			device.TakenDate, _ = time.Parse("2006-01-02", strTakenDate)

			devices = append(devices, device)
		}
	}

	return devices, err
}

// Получение пользователя по логину
func (base Base) TakeUserByLogin(ctx context.Context, inlogin string) (mytypes.User, error) {
	u := mytypes.User{}

	res := base.db.QueryRowContext(ctx, "SELECT `users`.`UserId`,`users`.`login`,`users`.`pass`,`users`.`acces`,`users`.`name`,`users`.`email` FROM `t-base`.`users` WHERE `users`.`login` = ?", inlogin)
	err := res.Scan(&u.UserId, &u.Login, &u.Pass, &u.Acces, &u.Name, &u.Email)

	return u, err
}

// Получение слайса пользователей по Id
func (base Base) TakeUserById(ctx context.Context, inId ...int) ([]mytypes.User, error) {
	users := []mytypes.User{}
	if len(inId) == 0 { // если небыло переданы Id
		user := mytypes.User{}
		res, err := base.db.QueryContext(ctx, "SELECT `users`.`UserId`,`users`.`login`,`users`.`pass`,`users`.`acces`,`users`.`name`,`users`.`email` FROM `t-base`.`users`")
		if err != nil {
			return users, err
		}
		for res.Next() {
			err := res.Scan(&user.UserId, &user.Login, &user.Pass, &user.Acces, &user.Name, &user.Email)
			if err != nil {
				return users, err
			}
			users = append(users, user)
		}
		return users, nil
	} else { // Если Id переданы
		for _, i := range inId {
			user := mytypes.User{}
			res := base.db.QueryRowContext(ctx, "SELECT `users`.`UserId`,`users`.`login`,`users`.`pass`,`users`.`acces`,`users`.`name`,`users`.`email` FROM `t-base`.`users` WHERE `users`.`UserId` = ?", i)
			err := res.Scan(&user.UserId, &user.Login, &user.Pass, &user.Acces, &user.Name, &user.Email)
			users = append(users, user)
			if err != nil {
				return users, err
			}
		}
		return users, nil
	}
}

func (base Base) NewRegenToken(user string, token string) {
	res, err := base.db.Exec("UPDATE users set token = ? where login = ?", token, user)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(res.RowsAffected())
}
