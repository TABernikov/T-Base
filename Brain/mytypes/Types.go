package mytypes

import "time"

// структура устройства
type DeviceRaw struct {
	Id          int
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
	Shiped      bool
	ShipedDate  time.Time
	ShippedDest string
	TakenDate   time.Time
	TakenDoc    string
	TakenOrder  string
}

// структура устройства для вывода пользователю
type DeviceClean struct {
	Id          int
	Sn          string
	Mac         string
	DModel      string
	Rev         string
	TModel      string
	Name        string
	Condition   string
	CondDate    string
	Order       string
	Place       int
	Shiped      int8
	ShipedDate  string
	ShippedDest string
	TakenDate   string
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
