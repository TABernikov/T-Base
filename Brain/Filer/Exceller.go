package Filer

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"strconv"
	"time"

	"github.com/xuri/excelize/v2"
)

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

func rndName(BasicName string) string {
	rnum, err := rand.Int(rand.Reader, big.NewInt(1000))
	if err != nil {
		return BasicName
	}
	num := rnum.Int64()
	return BasicName + " " + time.Now().Format("02.01.2006") + " " + strconv.Itoa(int(num))
}
