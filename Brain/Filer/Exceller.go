package Filer

import (
	"T-Base/Brain/mytypes"
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
