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
	Comment     string
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
	Order     int
	OrderName string
	Name      string
	Amout     int
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
	Shipped   bool
}

type StorageByTModelClean struct {
	Model     string
	Name      string
	Amout     int
	Condition string
	Shipped   bool
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
	Id          int
	Order       int
	Model       int
	Amout       int
	ServType    int
	ServActDate time.Time
	LastRed     time.Time
}

type OrderListClean struct {
	Id          int
	Order       int
	Model       string
	Amout       int
	ServType    int
	ServActDate string
	LastRed     string
}

type OrderStatusClean struct {
	Model    string
	Amout    int
	Reserved int
	InWork   int
	Done     int
	Shipped  int
}

type Mat struct {
	Id     int
	Name   string
	Name1C string
	Amout  int
	InWork int
	Price  int
	Type   string
	Places []int
}

type MatEvent struct {
	LogId     int
	MatId     int
	EventType int
	EventText string
	EventTime time.Time
	User      int
	Amout     int
}

type MatEventClean struct {
	LogId     int
	MatId     int
	EventType string
	EventText string
	EventTime string
	User      string
	Amout     int
}

type BuildListElement struct {
	MatId int
	Amout int
}

type Build struct {
	Id        int
	DModel    int
	TModel    int
	BuildList []BuildListElement
}

type BuildListElementClean struct {
	Mat   string
	Amout int
}

type BuildClean struct {
	Id        int
	DModel    string
	TModel    string
	BuildList []BuildListElementClean
}

type TModel struct {
	Id   int
	Name string
}

type DModel struct {
	Id    int
	Name  string
	Build int
}

type Task struct {
	Id          int
	Name        string
	Autor       int
	Description string
	Color       string
	Priority    int
	DateStart   time.Time
	DateEnd     time.Time
	Complete    bool
	WorkList    []TaskWorkList
}

type CleanTask struct {
	Id          int
	Name        string
	Autor       string
	Description string
	Color       string
	Priority    int
	DateStart   string
	DateEnd     string
	Complete    bool
	WorkList    []CleanTaskWorkList
}

type TaskJs struct {
	Id          int
	Name        string
	Autor       string
	Description string
	Color       string
	Priority    int
	DateStart   string
	DateEnd     string
	Complete    bool
}

type TaskWorkList struct {
	Id     int
	TModel int
	Amout  int
	Done   int
	Date   time.Time
}
type CleanTaskWorkList struct {
	Id     int
	TModel string
	Amout  int
	Done   int
	Date   time.Time
}

type ReservTask struct {
	Id        int
	SnsId     int
	DateStart time.Time
	DateEnd   time.Time
	Autor     int
	Dest      string
}

type ReservTaskJS struct {
	Id        int
	SnsId     int
	DateStart string
	DateEnd   string
	Autor     string
	Dest      string
}

func CountByDModel(devices ...DeviceRaw) (counter map[int]int) {
	counter = make(map[int]int)
	for _, device := range devices {
		if _, ok := counter[device.DModel]; !ok {
			counter[device.DModel] = 1
		} else {
			counter[device.DModel]++
		}
	}
	return
}

func CountbyTModel(devices ...DeviceRaw) (counter map[int]int) {
	counter = make(map[int]int)
	for _, device := range devices {
		if _, ok := counter[device.TModel]; !ok {
			counter[device.TModel] = 1
		} else {
			counter[device.TModel]++
		}
	}
	return
}

func ChekInWork(devices ...DeviceRaw) bool {
	for _, device := range devices {
		if device.Condition != 3 {
			return true
		}
	}
	return false
}
