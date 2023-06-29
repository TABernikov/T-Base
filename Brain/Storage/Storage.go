package Storage

import (
	"T-Base/Brain/mytypes"
	"database/sql"
	"time"
)

// Объект базы данных
type Base struct {
	db *sql.DB
}

// инициализация базы через ссылку на ее объект (созданный в main)
func NewBase(pool *sql.DB) *Base {
	return &Base{db: pool}
}

func (base Base) TakeDeviceByRequest(request string) ([]mytypes.DeviceRaw, error) {
	var devices []mytypes.DeviceRaw
	qq := "SELECT `sns`.`snsId`, `sns`.`sn`,`sns`.`mac`,`sns`.`dmodel`,`sns`.`rev`,`sns`.`tmodel`,`sns`.`name`,`sns`.`condition`,`sns`.`condDate`,`sns`.`order`,`sns`.`place`,`sns`.`shiped`,`sns`.`shipedDate`,`sns`.`shippedDest`,`sns`.`takenDate`,`sns`.`takenDoc`,`sns`.`takenOrder`FROM `t-base`.`sns` "

	var res *sql.Rows
	var err error
	if request == "" {
		res, err = base.db.Query(qq)
	} else {
		res, err = base.db.Query(qq + request)
	}
	if err != nil {
		return devices, err
	}

	for res.Next() {
		var d mytypes.DeviceRaw
		var strCondDate, strShipedDate, strTakenDate string
		res.Scan(&d.Id, &d.Sn, &d.Mac, &d.DModel, &d.Rev, &d.TModel, &d.Name, &d.Condition, &strCondDate, &d.Order, &d.Place, &d.Shiped, &strShipedDate, &d.ShippedDest, &strTakenDate, &d.TakenDoc, d.TakenOrder)
		d.CondDate, _ = time.Parse("2006-01-02", strCondDate)
		d.ShipedDate, _ = time.Parse("2006-01-02", strShipedDate)
		d.TakenDate, _ = time.Parse("2006-01-02", strTakenDate)
		devices = append(devices, d)
	}

	return devices, nil

}
