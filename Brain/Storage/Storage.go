package Storage

import (
	"T-Base/Brain/mytypes"
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
)

/* MySQL
// Объект базы данных...
type Base struct {
	db *sql.DB
}

// инициализация базы...
func NewBase(user, pass, ip, baseName string) (*Base, error) {
	BasePointer, err := sql.Open("mysql", user+":"+pass+"@tcp("+ip+")/"+baseName)
	if err != nil {
		return &Base{}, err
	}
	return &Base{db: BasePointer}, nil
}

// Получение слайса девайсов из базы по SQL условию ...
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

// Получение слайса девайсов из базы по их ID ...
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

// Получение пользователя по логину...
func (base Base) TakeUserByLogin(ctx context.Context, inlogin string) (mytypes.User, error) {
	u := mytypes.User{}

	res := base.db.QueryRowContext(ctx, "SELECT `users`.`UserId`,`users`.`login`,`users`.`pass`,`users`.`acces`,`users`.`name`,`users`.`email` FROM `t-base`.`users` WHERE `users`.`login` = ?", inlogin)
	err := res.Scan(&u.UserId, &u.Login, &u.Pass, &u.Acces, &u.Name, &u.Email)

	return u, err
}

// Получение слайса пользователей по Id ...
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

//...
func (base Base) NewRegenToken(user string, token string) {
	res, err := base.db.Exec("UPDATE users set token = ? where login = ?", token, user)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(res.RowsAffected())
}

//...
func (base Base) MakeNewToSns(devices ...mytypes.DeviceRaw) {
	for _, device := range devices {
		_, err := base.db.Exec("INSERT INTO `t-base`.`sns`(`sn`,`mac`,`dmodel`,`rev`,`tmodel`,`name`,`condition`,`condDate`,`order`,`place`,`shiped`,`shipedDate`,`shippedDest`,`takenDate`,`takenDoc`,`takenOrder`) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);", device.Sn, device.Mac, device.DModel, device.Rev, device.TModel, device.Name, device.Condition, device.CondDate, device.Order, device.Place, device.Shiped, device.ShipedDate, device.ShippedDest, device.TakenDate, device.TakenDoc, device.TakenOrder)
		if err != nil {
			fmt.Println(err)
			return
		}
	}
}

func (base Base) TakeCleanDeviceById(ctx context.Context, id ...int) ([]mytypes.DeviceClean, error) {
	qq := "SELECT `snsId`, `sn`,`mac`,`dmodel`,`rev`,`tmodel`,`name`,`condition`,`condDate`,`order`,`place`,`shiped`,`shipedDate`,`shippedDest`,`takenDate`,`takenDoc`,`takenOrder`FROM `t-base`.`clean-sns` "
	var devices []mytypes.DeviceClean

	var res *sql.Rows
	var err error

	if len(id) == 0 {
		res, err = base.db.QueryContext(ctx, qq)

		if err != nil {
			return devices, err
		}

		for res.Next() {
			var device mytypes.DeviceClean
			var strCondDate, strShipedDate, strTakenDate string

			res.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &strCondDate, &device.Order, &device.Place, &device.Shiped, &strShipedDate, &device.ShippedDest, &strTakenDate, &device.TakenDoc, device.TakenOrder)

			timeCondDate, _ := time.Parse("2006-01-02", strCondDate)
			timeShipedDate, _ := time.Parse("2006-01-02", strShipedDate)
			timeTakenDate, _ := time.Parse("2006-01-02", strTakenDate)
			device.CondDate = timeCondDate.Format("02.01.2006")
			device.ShipedDate = timeShipedDate.Format("02.01.2006")
			device.TakenDate = timeTakenDate.Format("02.01.2006")
			devices = append(devices, device)
		}
	} else {

		for _, a := range id {
			var device mytypes.DeviceClean
			var strCondDate, strShipedDate, strTakenDate string

			res := base.db.QueryRowContext(ctx, qq+"where snsid = "+strconv.Itoa(a))
			res.Scan(&device.Id, &device.Sn, &device.Mac, &device.DModel, &device.Rev, &device.TModel, &device.Name, &device.Condition, &strCondDate, &device.Order, &device.Place, &device.Shiped, &strShipedDate, &device.ShippedDest, &strTakenDate, &device.TakenDoc, device.TakenOrder)

			timeCondDate, _ := time.Parse("2006-01-02", strCondDate)
			timeShipedDate, _ := time.Parse("2006-01-02", strShipedDate)
			timeTakenDate, _ := time.Parse("2006-01-02", strTakenDate)
			device.CondDate = timeCondDate.Format("02.01.2006")
			device.ShipedDate = timeShipedDate.Format("02.01.2006")
			device.TakenDate = timeTakenDate.Format("02.01.2006")

			devices = append(devices, device)
		}
	}

	return devices, err
}

*/

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
			row := base.db.QueryRow(ctx, `SELECT "snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder" FROM sns Where snsId = $1`, id)
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
