package Filer

import (
	"T-Base/Brain/Storage"
	"T-Base/Brain/mytypes"
	"context"
	"crypto/rand"
	"fmt"
	"math/big"
	"strconv"
	"time"

	"github.com/xuri/excelize/v2"
)

////////////////////////
// Генераторы отчетов //
////////////////////////

func TMCExceller(link string, devices ...mytypes.DeviceClean) (string, string, error) {
	f := excelize.NewFile()
	f.SetSheetName("Sheet1", "ТМЦ")

	makeTMCSheet(f, "ТМЦ", link, devices...)

	name := rndName("ТМЦ") + ".xlsx"
	path := "./Files/" + name
	if err := f.SaveAs(path); err != nil {
		fmt.Println(err)
		return "", "", err
	}

	if err := f.Close(); err != nil {
		fmt.Println(err)
		return "", "", err
	}
	return path, name, nil
}

func OrderExceller(base Storage.Base, link string, orders ...mytypes.OrderClean) (string, string, error) {
	f := excelize.NewFile()

	if len(orders) > 1 {
		f.SetSheetName("Sheet1", "Общий_список")
		makeOrdersListSheet(f, "Общий_список", link, orders...)

	} else if len(orders) == 1 {
		f.DeleteSheet("Sheet1")
	}

	for _, order := range orders {
		f.NewSheet("Заказ" + strconv.Itoa(order.Id1C) + "(" + strconv.Itoa(order.OrderId) + ")")
		makeOrderSheet(f, "Заказ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "http://127.0.0.1:8080/works/order/mini?Id="+strconv.Itoa(order.OrderId), order, base)

		// ТМЦ Заказа
		devices, err := base.TakeCleanDeviceByOrder(context.Background(), order.OrderId)
		if err != nil {
			return "", "", err
		}

		f.NewSheet("ТМЦ" + strconv.Itoa(order.Id1C) + "_" + strconv.Itoa(order.OrderId))
		makeTMCSheet(f, "ТМЦ"+strconv.Itoa(order.Id1C)+"_"+strconv.Itoa(order.OrderId), "http://127.0.0.1:8080/works/tmc?Search=Raw&Order="+strconv.Itoa(order.OrderId), devices...)

	}
	// сохранение
	name := rndName("Заказ") + ".xlsx"
	path := "./Files/" + name
	if err := f.SaveAs(path); err != nil {
		fmt.Println(err)
		return "", "", err
	}

	if err := f.Close(); err != nil {
		fmt.Println(err)
		return "", "", err
	}
	return path, name, nil
}

func ShortOrdersExceller(link string, orders ...mytypes.OrderClean) (string, string, error) {
	f := excelize.NewFile()

	f.SetSheetName("Sheet1", "Общий_список")
	makeOrdersListSheet(f, "Общий_список", link, orders...)

	name := rndName("Список заказов") + ".xlsx"
	path := "./Files/" + name
	if err := f.SaveAs(path); err != nil {
		fmt.Println(err)
		return "", "", err
	}

	if err := f.Close(); err != nil {
		fmt.Println(err)
		return "", "", err
	}
	return path, name, nil
}

func makeTMCSheet(f *excelize.File, name, link string, devices ...mytypes.DeviceClean) {
	f.SetCellValue(name, "A1", "ТМЦ УСТРОЙСТВ:")
	f.SetCellValue(name, "B1", len(devices))
	f.SetCellValue(name, "C1", "Открыть в браузере")
	f.SetCellHyperLink(name, "C1", link, "External")

	f.SetCellValue(name, "A3", "Id")
	f.SetColWidth(name, "A", "A", 18)
	f.SetCellValue(name, "B3", "Имя")
	f.SetColWidth(name, "B", "B", 18)
	f.SetCellValue(name, "C3", "SN")
	f.SetColWidth(name, "C", "C", 19)
	f.SetCellValue(name, "D3", "MAC")
	f.SetColWidth(name, "D", "D", 18)
	f.SetCellValue(name, "E3", "Состояние")
	f.SetColWidth(name, "E", "E", 14)
	f.SetCellValue(name, "F3", "Дата сборки")
	f.SetColWidth(name, "F", "F", 16)
	f.SetCellValue(name, "G3", "Модель Т-КОМ")
	f.SetColWidth(name, "G", "G", 18)
	f.SetCellValue(name, "H3", "Исходная модель")
	f.SetColWidth(name, "H", "H", 20)
	f.SetCellValue(name, "I3", "Ревизия")
	f.SetColWidth(name, "I", "I", 13)
	f.SetCellValue(name, "J3", "Заказ")
	f.SetColWidth(name, "J", "J", 10)
	f.SetCellValue(name, "K3", "Место")
	f.SetColWidth(name, "K", "K", 10)
	f.SetCellValue(name, "L3", "Отгрузка")
	f.SetColWidth(name, "L", "L", 12)
	f.SetCellValue(name, "M3", "Дата отгрузки")
	f.SetColWidth(name, "M", "M", 17)
	f.SetCellValue(name, "N3", "Место отгрузки")
	f.SetColWidth(name, "N", "N", 18)
	f.SetCellValue(name, "O3", "Дата приемки")
	f.SetColWidth(name, "O", "O", 17)
	f.SetCellValue(name, "P3", "Документ приемки")
	f.SetColWidth(name, "P", "P", 22)
	f.SetCellValue(name, "Q3", "Заказ приемки")
	f.SetColWidth(name, "Q", "Q", 17)

	f.SetCellValue(name, "R3", "Комментарии")
	f.SetColWidth(name, "R", "R", 17)

	for i, a := range devices {
		f.SetCellValue(name, "A"+strconv.Itoa(i+4), a.Id)
		f.SetCellValue(name, "B"+strconv.Itoa(i+4), a.Name)
		f.SetCellValue(name, "C"+strconv.Itoa(i+4), a.Sn)
		f.SetCellValue(name, "D"+strconv.Itoa(i+4), a.Mac)
		f.SetCellValue(name, "E"+strconv.Itoa(i+4), a.Condition)
		f.SetCellValue(name, "F"+strconv.Itoa(i+4), a.CondDate)
		f.SetCellValue(name, "G"+strconv.Itoa(i+4), a.TModel)
		f.SetCellValue(name, "H"+strconv.Itoa(i+4), a.DModel)
		f.SetCellValue(name, "I"+strconv.Itoa(i+4), a.Rev)
		f.SetCellValue(name, "J"+strconv.Itoa(i+4), a.Order)
		f.SetCellValue(name, "K"+strconv.Itoa(i+4), a.Place)
		f.SetCellValue(name, "L"+strconv.Itoa(i+4), a.Shiped)
		f.SetCellValue(name, "M"+strconv.Itoa(i+4), a.ShipedDate)
		f.SetCellValue(name, "N"+strconv.Itoa(i+4), a.ShippedDest)
		f.SetCellValue(name, "O"+strconv.Itoa(i+4), a.TakenDate)
		f.SetCellValue(name, "P"+strconv.Itoa(i+4), a.TakenDoc)
		f.SetCellValue(name, "Q"+strconv.Itoa(i+4), a.TakenOrder)
		f.SetCellValue(name, "R"+strconv.Itoa(i+4), a.Comment)
	}

	disable := false
	f.AddTable(name, &excelize.Table{
		Range:             "A3:R" + strconv.Itoa(len(devices)+3),
		Name:              name,
		StyleName:         "TableStyleMedium4",
		ShowFirstColumn:   true,
		ShowLastColumn:    true,
		ShowRowStripes:    &disable,
		ShowColumnStripes: true,
	})
	f.SetCellValue(name, "A"+strconv.Itoa(len(devices)+4), "Устройств:")
	f.SetCellFormula(name, "B"+strconv.Itoa(len(devices)+4), "=SUBTOTAL(102, A3:A"+strconv.Itoa(len(devices)+3)+")")
}

func makeOrderSheet(f *excelize.File, name, link string, order mytypes.OrderClean, base Storage.Base) error {
	f.SetCellValue(name, "A1", "Заказ")
	f.SetCellValue(name, "B1", "ID")
	f.SetCellValue(name, "B2", "№1c")
	f.SetCellValue(name, "C1", order.OrderId)
	f.SetCellValue(name, "C2", order.Id1C)

	f.SetCellValue(name, "F1", "Открыть в браузере")
	f.SetCellHyperLink(name, "F1", link, "External")

	// Информация о заказе
	for i := 4; i < 17; i++ {
		f.MergeCell(name, "B"+strconv.Itoa(i), "D"+strconv.Itoa(i))
	}

	f.SetColWidth(name, "A", "A", 15.5)
	f.SetCellValue(name, "A4", "ID заказа")
	f.SetCellValue(name, "B4", order.OrderId)
	f.SetCellValue(name, "A5", "№ в 1С")
	f.SetCellValue(name, "B5", order.Id1C)
	f.SetCellValue(name, "A6", "Имя заказа")
	f.SetCellValue(name, "B6", order.Name)
	f.SetCellValue(name, "A7", "Менеджер")
	f.SetCellValue(name, "B7", order.Meneger)
	f.SetCellValue(name, "A8", "Дата создания")
	f.SetCellValue(name, "B8", order.OrderDate)
	f.SetCellValue(name, "A9", "Требуемая дата")
	f.SetCellValue(name, "B9", order.ReqDate)
	f.SetCellValue(name, "A10", "Обещаная дата")
	f.SetCellValue(name, "B10", order.PromDate)
	f.SetCellValue(name, "A11", "Заказчик")
	f.SetCellValue(name, "B11", order.Customer)
	f.SetCellValue(name, "A12", "Партнер")
	f.SetCellValue(name, "B12", order.Partner)
	f.SetCellValue(name, "A13", "Дистрибьютер")
	f.SetCellValue(name, "B13", order.Distributor)
	f.SetCellValue(name, "A14", "Дата отгрузки")
	f.SetCellValue(name, "B14", order.ShDate)
	f.SetCellValue(name, "A15", "Активный")
	f.SetCellValue(name, "B15", order.IsAct)
	f.SetCellValue(name, "A16", "Комментарий")
	f.SetCellValue(name, "B16", order.Comment)

	style, err := f.NewStyle(&excelize.Style{
		Border: []excelize.Border{
			{Type: "left", Color: "000000", Style: 1},
			{Type: "top", Color: "000000", Style: 1},
			{Type: "bottom", Color: "000000", Style: 1},
			{Type: "right", Color: "000000", Style: 1},
		},
	})
	if err != nil {
		fmt.Println(err)
	}
	f.SetCellStyle(name, "A4", "D16", style)

	// Лист заказа
	list, err := base.TakeCleanOrderList(context.Background(), order.OrderId)
	if err != nil {
		fmt.Println(err)
		return err
	}

	f.SetColWidth(name, "F", "F", 18)
	f.SetCellValue(name, "F4", "Модель")
	f.SetColWidth(name, "G", "G", 10)
	f.SetCellValue(name, "G4", "Кол-во")
	f.SetColWidth(name, "H", "H", 10)
	f.SetCellValue(name, "H4", "Сервис")
	f.SetColWidth(name, "I", "I", 25)
	f.SetCellValue(name, "I4", "Дата активации сервиса")
	f.SetColWidth(name, "J", "J", 30)
	f.SetCellValue(name, "J4", "Последнее редактирование")
	for i, a := range list {
		f.SetCellValue(name, "F"+strconv.Itoa(i+5), a.Model)
		f.SetCellValue(name, "G"+strconv.Itoa(i+5), a.Amout)
		f.SetCellValue(name, "H"+strconv.Itoa(i+5), a.ServType)
		f.SetCellValue(name, "I"+strconv.Itoa(i+5), a.ServActDate)
		f.SetCellValue(name, "J"+strconv.Itoa(i+5), a.LastRed)
	}
	disable := false
	if err := f.AddTable(name, &excelize.Table{
		Range:             "F4:J" + strconv.Itoa(len(list)+4),
		Name:              "Состав" + strconv.Itoa(order.OrderId),
		StyleName:         "TableStyleMedium4",
		ShowFirstColumn:   true,
		ShowLastColumn:    true,
		ShowRowStripes:    &disable,
		ShowColumnStripes: true,
	}); err != nil {
		return err
	}

	// Статус заказа
	stasus, err := base.TakeCleanOrderStatus(context.Background(), order.OrderId)
	if err != nil {
		fmt.Println(err)
		return err
	}

	f.SetColWidth(name, "L", "L", 18)
	f.SetCellValue(name, "L4", "Модель")
	f.SetColWidth(name, "M", "M", 10.5)
	f.SetCellValue(name, "M4", "В заказе")
	f.SetColWidth(name, "N", "N", 9.5)
	f.SetCellValue(name, "N4", "Резерв")
	f.SetColWidth(name, "O", "O", 11)
	f.SetCellValue(name, "O4", "В работе")
	f.SetColWidth(name, "P", "P", 11)
	f.SetCellValue(name, "P4", "Собрано")
	f.SetColWidth(name, "Q", "Q", 14)
	f.SetCellValue(name, "Q4", "Отправлено")
	for i, a := range stasus {
		f.SetCellValue(name, "L"+strconv.Itoa(i+5), a.Model)
		f.SetCellValue(name, "M"+strconv.Itoa(i+5), a.Amout)
		f.SetCellValue(name, "N"+strconv.Itoa(i+5), a.Reserved)
		f.SetCellValue(name, "O"+strconv.Itoa(i+5), a.InWork)
		f.SetCellValue(name, "P"+strconv.Itoa(i+5), a.Done)
		f.SetCellValue(name, "Q"+strconv.Itoa(i+5), a.Shipped)
	}
	if err := f.AddTable(name, &excelize.Table{
		Range:             "L4:Q" + strconv.Itoa(len(list)+4),
		Name:              "Статус" + strconv.Itoa(order.OrderId),
		StyleName:         "TableStyleMedium4",
		ShowFirstColumn:   true,
		ShowLastColumn:    true,
		ShowRowStripes:    &disable,
		ShowColumnStripes: true,
	}); err != nil {
		return err
	}
	return nil
}

func makeOrdersListSheet(f *excelize.File, name, link string, orders ...mytypes.OrderClean) {
	f.SetCellValue(name, "A1", "Заказов:")
	f.SetCellValue(name, "B1", len(orders))
	f.SetCellValue(name, "C1", "Открыть в браузере")
	f.SetCellHyperLink(name, "C1", link, "External")

	f.SetCellValue(name, "A3", "Id")
	f.SetColWidth(name, "A", "A", 18)
	f.SetCellValue(name, "B3", "№ в 1С")
	f.SetColWidth(name, "B", "B", 18)
	f.SetCellValue(name, "C3", "Имя заказа")
	f.SetColWidth(name, "C", "C", 19)
	f.SetCellValue(name, "D3", "Менеджер")
	f.SetColWidth(name, "D", "D", 18)
	f.SetCellValue(name, "E3", "Дата заказа")
	f.SetColWidth(name, "E", "E", 14)
	f.SetCellValue(name, "F3", "Покупатель")
	f.SetColWidth(name, "F", "F", 16)
	f.SetCellValue(name, "G3", "Партнер")
	f.SetColWidth(name, "G", "G", 18)
	f.SetCellValue(name, "H3", "Дистрибьютер")
	f.SetColWidth(name, "H", "H", 20)
	f.SetCellValue(name, "I3", "Требуемая дата")
	f.SetColWidth(name, "I", "I", 13)
	f.SetCellValue(name, "J3", "Обещаная дата")
	f.SetColWidth(name, "J", "J", 10)
	f.SetCellValue(name, "K3", "Дата отгрузки")
	f.SetColWidth(name, "K", "K", 10)
	f.SetCellValue(name, "L3", "Активный")
	f.SetColWidth(name, "L", "L", 12)
	f.SetCellValue(name, "M3", "Комментарий")
	f.SetColWidth(name, "M", "M", 17)

	for i, order := range orders {
		f.SetCellValue(name, "A"+strconv.Itoa(i+4), order.OrderId)
		f.SetCellValue(name, "B"+strconv.Itoa(i+4), order.Id1C)
		f.SetCellValue(name, "C"+strconv.Itoa(i+4), order.Name)
		f.SetCellValue(name, "D"+strconv.Itoa(i+4), order.Meneger)
		f.SetCellValue(name, "E"+strconv.Itoa(i+4), order.OrderDate)
		f.SetCellValue(name, "F"+strconv.Itoa(i+4), order.Customer)
		f.SetCellValue(name, "G"+strconv.Itoa(i+4), order.Partner)
		f.SetCellValue(name, "H"+strconv.Itoa(i+4), order.Distributor)
		f.SetCellValue(name, "I"+strconv.Itoa(i+4), order.ReqDate)
		f.SetCellValue(name, "J"+strconv.Itoa(i+4), order.PromDate)
		f.SetCellValue(name, "K"+strconv.Itoa(i+4), order.ShDate)
		f.SetCellValue(name, "L"+strconv.Itoa(i+4), order.IsAct)
		f.SetCellValue(name, "M"+strconv.Itoa(i+4), order.Comment)
		f.SetCellHyperLink(name, "A"+strconv.Itoa(i+4), "Состав"+strconv.Itoa(order.OrderId), "Location")
	}

	disable := false
	err := f.AddTable(name, &excelize.Table{
		Range:             "A3:M" + strconv.Itoa(len(orders)+3),
		Name:              name + "",
		StyleName:         "TableStyleMedium4",
		ShowFirstColumn:   true,
		ShowLastColumn:    true,
		ShowRowStripes:    &disable,
		ShowColumnStripes: true,
	})
	fmt.Println(err)
}

////////////
// Другое //
////////////

// тестовый отчет
func TextExcell() (string, string, error) {
	f := excelize.NewFile()
	f.SetSheetName("Sheet1", "Коммутаторы")
	// Create a new sheet.
	_, err := f.NewSheet("Данные")
	if err != nil {
		fmt.Println(err)
		return "", "", err
	}
	// Set value of a cell.
	f.SetCellValue("Данные", "A3", "Hello world.")
	f.SetCellValue("Коммутаторы", "B2", time.Now())

	name := rndName("Тест") + ".xlsx"
	path := "./Files/" + name
	if err := f.SaveAs(path); err != nil {
		fmt.Println(err)
	}

	if err := f.Close(); err != nil {
		fmt.Println(err)
		return "", "", err
	}
	return path, name, nil
}

// Генерация случайного имени
func rndName(BasicName string) string {
	rnum, err := rand.Int(rand.Reader, big.NewInt(1000))
	if err != nil {
		return BasicName
	}
	num := rnum.Int64()
	return BasicName + " " + time.Now().Format("02.01.2006") + " " + strconv.Itoa(int(num))
}
