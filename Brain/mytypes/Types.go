package mytypes

import "time"

// структура устройства
type DeviceRaw struct {
	Id          string
	Sn          string
	Mac         string
	DModel      int
	Rev         string
	TModel      int
	Name        string
	Condition   int
	CondDate    time.Time
	Order       int
	Place       int
	Shiped      int8
	ShipedDate  time.Time
	ShippedDest string
	TakenDate   time.Time
	TakenDoc    string
	TakenOrder  string
}

// Структура пользователя
type User struct {
	UserId int
	Login  string
	Pass   string
	Acces  int
	Name   string
	Email  string
}
