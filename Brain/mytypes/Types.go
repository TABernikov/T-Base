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
	Shiped      string
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

type StorageCount struct {
	Order int
	Name  string
	Amout int
}

type StorageByPlaceCount struct {
	Place int
	Name  string
	Amout int
}

type StorageByTModel struct {
	Model     int
	Name      string
	Amout     int
	Condition int
}

type StorageByTModelClean struct {
	Model     string
	Name      string
	Amout     int
	Condition string
}

type DeviceEvent struct {
	LogId     int
	EventType int
	EventText string
	EventTime time.Time
	User      int
}

type DeviceEventClean struct {
	LogId     int
	EventType string
	EventText string
	EventTime string
	User      string
}

type OrderRaw struct {
	OrderId     int
	Id1C        int
	Meneger     int
	OrderDate   time.Time
	Customer    string
	Partner     string
	Distributor string
	ReqDate     time.Time
	PromDate    time.Time
	ShDate      time.Time
	IsAct       bool
	Comment     string
	Name        string
}

type OrderClean struct {
	OrderId     int
	Id1C        int
	Meneger     string
	OrderDate   string
	Customer    string
	Partner     string
	Distributor string
	ReqDate     string
	PromDate    string
	ShDate      string
	IsAct       string
	Comment     string
	Name        string
}

type OrderList struct {
	Order       int
	Model       int
	Amout       int
	ServType    int
	ServActDate time.Time
	LastRed     time.Time
}

type OrderListClean struct {
	Order       int
	Model       string
	Amout       int
	ServType    int
	ServActDate string
	LastRed     string
}
