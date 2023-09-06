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

	f.SetCellValue("ТМЦ", "A1", "ТМЦ УСТРОЙСТВ:")
	f.SetCellValue("ТМЦ", "B1", len(devices))
	f.SetCellValue("ТМЦ", "C1", "Открыть в браузере")
	f.SetCellHyperLink("ТМЦ", "C1", link, "External")

	f.SetCellValue("ТМЦ", "A3", "Id")
	if f.SetColWidth("ТМЦ", "A", "A", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "B3", "Имя")
	if f.SetColWidth("ТМЦ", "B", "B", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "C3", "SN")
	if f.SetColWidth("ТМЦ", "C", "C", 19) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "D3", "MAC")
	if f.SetColWidth("ТМЦ", "D", "D", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "E3", "Состояние")
	if f.SetColWidth("ТМЦ", "E", "E", 14) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "F3", "Дата сборки")
	if f.SetColWidth("ТМЦ", "F", "F", 16) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "G3", "Модель Т-КОМ")
	if f.SetColWidth("ТМЦ", "G", "G", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "H3", "Исходная модель")
	if f.SetColWidth("ТМЦ", "H", "H", 20) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "I3", "Ревизия")
	if f.SetColWidth("ТМЦ", "I", "I", 13) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "J3", "Заказ")
	if f.SetColWidth("ТМЦ", "J", "J", 10) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "K3", "Место")
	if f.SetColWidth("ТМЦ", "K", "K", 10) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "L3", "Отгрузка")
	if f.SetColWidth("ТМЦ", "L", "L", 12) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "M3", "Дата отгрузки")
	if f.SetColWidth("ТМЦ", "M", "M", 17) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "N3", "Место отгрузки")
	if f.SetColWidth("ТМЦ", "N", "N", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "O3", "Дата приемки")
	if f.SetColWidth("ТМЦ", "O", "O", 17) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "P3", "Документ приемки")
	if f.SetColWidth("ТМЦ", "P", "P", 22) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "Q3", "Заказ приемки")
	if f.SetColWidth("ТМЦ", "Q", "Q", 17) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ", "R3", "Комментарии")
	if f.SetColWidth("ТМЦ", "R", "R", 17) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}

	for i, a := range devices {
		f.SetCellValue("ТМЦ", "A"+strconv.Itoa(i+4), a.Id)
		f.SetCellValue("ТМЦ", "B"+strconv.Itoa(i+4), a.Name)
		f.SetCellValue("ТМЦ", "C"+strconv.Itoa(i+4), a.Sn)
		f.SetCellValue("ТМЦ", "D"+strconv.Itoa(i+4), a.Mac)
		f.SetCellValue("ТМЦ", "E"+strconv.Itoa(i+4), a.Condition)
		f.SetCellValue("ТМЦ", "F"+strconv.Itoa(i+4), a.CondDate)
		f.SetCellValue("ТМЦ", "G"+strconv.Itoa(i+4), a.TModel)
		f.SetCellValue("ТМЦ", "H"+strconv.Itoa(i+4), a.DModel)
		f.SetCellValue("ТМЦ", "I"+strconv.Itoa(i+4), a.Rev)
		f.SetCellValue("ТМЦ", "J"+strconv.Itoa(i+4), a.Order)
		f.SetCellValue("ТМЦ", "K"+strconv.Itoa(i+4), a.Place)
		f.SetCellValue("ТМЦ", "L"+strconv.Itoa(i+4), a.Shiped)
		f.SetCellValue("ТМЦ", "M"+strconv.Itoa(i+4), a.ShipedDate)
		f.SetCellValue("ТМЦ", "N"+strconv.Itoa(i+4), a.ShippedDest)
		f.SetCellValue("ТМЦ", "O"+strconv.Itoa(i+4), a.TakenDate)
		f.SetCellValue("ТМЦ", "P"+strconv.Itoa(i+4), a.TakenDoc)
		f.SetCellValue("ТМЦ", "Q"+strconv.Itoa(i+4), a.TakenOrder)
		f.SetCellValue("ТМЦ", "R"+strconv.Itoa(i+4), a.Comment)
	}

	disable := false
	if err := f.AddTable("ТМЦ", &excelize.Table{
		Range:             "A3:R" + strconv.Itoa(len(devices)+3),
		Name:              "ТМЦ",
		StyleName:         "TableStyleMedium4",
		ShowFirstColumn:   true,
		ShowLastColumn:    true,
		ShowRowStripes:    &disable,
		ShowColumnStripes: true,
	}); err != nil {
		return "", "", err
	}
	f.SetCellValue("ТМЦ", "A"+strconv.Itoa(len(devices)+4), "Устройств:")
	f.SetCellFormula("ТМЦ", "B"+strconv.Itoa(len(devices)+4), "=SUBTOTAL(102, A3:A"+strconv.Itoa(len(devices)+3)+")")

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

func OrderExceller(order mytypes.OrderClean, base Storage.Base) (string, string, error) {
	f := excelize.NewFile() // Доработать для мн-ва заказов
	f.SetSheetName("Sheet1", "Заказ")

	f.SetCellValue("Заказ", "A1", "Заказ")
	f.SetCellValue("Заказ", "B1", "ID")
	f.SetCellValue("Заказ", "B2", "№1c")
	f.SetCellValue("Заказ", "C1", order.OrderId)
	f.SetCellValue("Заказ", "C2", order.Id1C)

	// Информация о заказе
	for i := 4; i < 17; i++ {
		f.MergeCell("Заказ", "B"+strconv.Itoa(i), "D"+strconv.Itoa(i))
	}

	f.SetColWidth("Заказ", "A", "A", 15.5)
	f.SetCellValue("Заказ", "A4", "ID заказа")
	f.SetCellValue("Заказ", "B4", order.OrderId)
	f.SetCellValue("Заказ", "A5", "№ в 1С")
	f.SetCellValue("Заказ", "B5", order.Id1C)
	f.SetCellValue("Заказ", "A6", "Имя заказа")
	f.SetCellValue("Заказ", "B6", order.Name)
	f.SetCellValue("Заказ", "A7", "Менеджер")
	f.SetCellValue("Заказ", "B7", order.Meneger)
	f.SetCellValue("Заказ", "A8", "Дата создания")
	f.SetCellValue("Заказ", "B8", order.OrderDate)
	f.SetCellValue("Заказ", "A9", "Требуемая дата")
	f.SetCellValue("Заказ", "B9", order.ReqDate)
	f.SetCellValue("Заказ", "A10", "Обещаная дата")
	f.SetCellValue("Заказ", "B10", order.PromDate)
	f.SetCellValue("Заказ", "A11", "Заказчик")
	f.SetCellValue("Заказ", "B11", order.Customer)
	f.SetCellValue("Заказ", "A12", "Партнер")
	f.SetCellValue("Заказ", "B12", order.Partner)
	f.SetCellValue("Заказ", "A13", "Дистрибьютер")
	f.SetCellValue("Заказ", "B13", order.Distributor)
	f.SetCellValue("Заказ", "A14", "Дата отгрузки")
	f.SetCellValue("Заказ", "B14", order.ShDate)
	f.SetCellValue("Заказ", "A15", "Активный")
	f.SetCellValue("Заказ", "B15", order.IsAct)
	f.SetCellValue("Заказ", "A16", "Комментарий")
	f.SetCellValue("Заказ", "B16", order.Comment)

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
	f.SetCellStyle("Заказ", "A4", "D16", style)

	// Лист заказа
	list, err := base.TakeCleanOrderList(context.Background(), order.OrderId)
	if err != nil {
		fmt.Println(err)
		return "", "", err
	}

	f.SetColWidth("Заказ", "F", "F", 18)
	f.SetCellValue("Заказ", "F4", "Модель")
	f.SetColWidth("Заказ", "G", "G", 10)
	f.SetCellValue("Заказ", "G4", "Кол-во")
	f.SetColWidth("Заказ", "H", "H", 10)
	f.SetCellValue("Заказ", "H4", "Сервис")
	f.SetColWidth("Заказ", "I", "I", 25)
	f.SetCellValue("Заказ", "I4", "Дата активации сервиса")
	f.SetColWidth("Заказ", "J", "J", 30)
	f.SetCellValue("Заказ", "J4", "Последнее редактирование")
	for i, a := range list {
		f.SetCellValue("Заказ", "F"+strconv.Itoa(i+5), a.Model)
		f.SetCellValue("Заказ", "G"+strconv.Itoa(i+5), a.Amout)
		f.SetCellValue("Заказ", "H"+strconv.Itoa(i+5), a.ServType)
		f.SetCellValue("Заказ", "I"+strconv.Itoa(i+5), a.ServActDate)
		f.SetCellValue("Заказ", "J"+strconv.Itoa(i+5), a.LastRed)
	}
	disable := false
	if err := f.AddTable("Заказ", &excelize.Table{
		Range:             "F4:J" + strconv.Itoa(len(list)+4),
		Name:              "Состав",
		StyleName:         "TableStyleMedium4",
		ShowFirstColumn:   true,
		ShowLastColumn:    true,
		ShowRowStripes:    &disable,
		ShowColumnStripes: true,
	}); err != nil {
		return "", "", err
	}

	// Статус заказа
	stasus, err := base.TakeCleanOrderStatus(context.Background(), order.OrderId)
	if err != nil {
		fmt.Println(err)
		return "", "", err
	}

	f.SetColWidth("Заказ", "L", "L", 18)
	f.SetCellValue("Заказ", "L4", "Модель")
	f.SetColWidth("Заказ", "M", "M", 10.5)
	f.SetCellValue("Заказ", "M4", "В заказе")
	f.SetColWidth("Заказ", "N", "N", 9.5)
	f.SetCellValue("Заказ", "N4", "Резерв")
	f.SetColWidth("Заказ", "O", "O", 11)
	f.SetCellValue("Заказ", "O4", "В работе")
	f.SetColWidth("Заказ", "P", "P", 11)
	f.SetCellValue("Заказ", "P4", "Собрано")
	f.SetColWidth("Заказ", "Q", "Q", 14)
	f.SetCellValue("Заказ", "Q4", "Отправлено")
	for i, a := range stasus {
		f.SetCellValue("Заказ", "L"+strconv.Itoa(i+5), a.Model)
		f.SetCellValue("Заказ", "M"+strconv.Itoa(i+5), a.Amout)
		f.SetCellValue("Заказ", "N"+strconv.Itoa(i+5), a.Reserved)
		f.SetCellValue("Заказ", "O"+strconv.Itoa(i+5), a.InWork)
		f.SetCellValue("Заказ", "P"+strconv.Itoa(i+5), a.Done)
		f.SetCellValue("Заказ", "Q"+strconv.Itoa(i+5), a.Shipped)
	}
	if err := f.AddTable("Заказ", &excelize.Table{
		Range:             "L4:Q" + strconv.Itoa(len(list)+4),
		Name:              "Статус",
		StyleName:         "TableStyleMedium4",
		ShowFirstColumn:   true,
		ShowLastColumn:    true,
		ShowRowStripes:    &disable,
		ShowColumnStripes: true,
	}); err != nil {
		return "", "", err
	}

	// ТМЦ Заказа
	devices, err := base.TakeCleanDeviceByOrder(context.Background(), order.OrderId)
	if err != nil {
		return "", "", err
	}

	f.NewSheet("ТМЦ" + strconv.Itoa(order.Id1C) + "(" + strconv.Itoa(order.OrderId) + ")")

	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "A1", "ТМЦ УСТРОЙСТВ:")
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "B1", len(devices))
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "C1", "Открыть в браузере")
	f.SetCellHyperLink("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "C1", "http://127.0.0.1:8080/works/tmc?Search=Raw&Order="+strconv.Itoa(order.OrderId), "External")

	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "A3", "Id")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "A", "A", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "B3", "Имя")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "B", "B", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "C3", "SN")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "C", "C", 19) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "D3", "MAC")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "D", "D", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "E3", "Состояние")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "E", "E", 14) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "F3", "Дата сборки")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "F", "F", 16) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "G3", "Модель Т-КОМ")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "G", "G", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "H3", "Исходная модель")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "H", "H", 20) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "I3", "Ревизия")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "I", "I", 13) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "J3", "Заказ")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "J", "J", 10) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "K3", "Место")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "K", "K", 10) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "L3", "Отгрузка")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "L", "L", 12) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "M3", "Дата отгрузки")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "M", "M", 17) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "N3", "Место отгрузки")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "N", "N", 18) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "O3", "Дата приемки")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "O", "O", 17) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "P3", "Документ приемки")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "P", "P", 22) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "Q3", "Заказ приемки")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "Q", "Q", 17) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "R3", "Комментарии")
	if f.SetColWidth("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "R", "R", 17) != nil {
		return "", "", fmt.Errorf("ошибка изменения ширины столбца")
	}

	for i, a := range devices {
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "A"+strconv.Itoa(i+4), a.Id)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "B"+strconv.Itoa(i+4), a.Name)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "C"+strconv.Itoa(i+4), a.Sn)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "D"+strconv.Itoa(i+4), a.Mac)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "E"+strconv.Itoa(i+4), a.Condition)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "F"+strconv.Itoa(i+4), a.CondDate)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "G"+strconv.Itoa(i+4), a.TModel)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "H"+strconv.Itoa(i+4), a.DModel)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "I"+strconv.Itoa(i+4), a.Rev)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "J"+strconv.Itoa(i+4), a.Order)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "K"+strconv.Itoa(i+4), a.Place)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "L"+strconv.Itoa(i+4), a.Shiped)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "M"+strconv.Itoa(i+4), a.ShipedDate)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "N"+strconv.Itoa(i+4), a.ShippedDest)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "O"+strconv.Itoa(i+4), a.TakenDate)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "P"+strconv.Itoa(i+4), a.TakenDoc)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "Q"+strconv.Itoa(i+4), a.TakenOrder)
		f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "R"+strconv.Itoa(i+4), a.Comment)
	}

	if err := f.AddTable("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", &excelize.Table{
		Range:             "A3:R" + strconv.Itoa(len(devices)+3),
		Name:              "ТМЦ" + strconv.Itoa(order.Id1C),
		StyleName:         "TableStyleMedium4",
		ShowFirstColumn:   true,
		ShowLastColumn:    true,
		ShowRowStripes:    &disable,
		ShowColumnStripes: true,
	}); err != nil {
		return "", "", err
	}
	f.SetCellValue("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "A"+strconv.Itoa(len(devices)+4), "Устройств:")
	f.SetCellFormula("ТМЦ"+strconv.Itoa(order.Id1C)+"("+strconv.Itoa(order.OrderId)+")", "B"+strconv.Itoa(len(devices)+4), "=SUBTOTAL(102, A3:A"+strconv.Itoa(len(devices)+3)+")")

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
