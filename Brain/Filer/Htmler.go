package Filer

import (
	"html/template"
	"os"
)

func ProductionMessageHtmler() (string, string, error) {

	t := template.Must(template.ParseFiles("Files/Templ/productionMessage.html"))
	name := rndName("Постановка на ГП") + ".html"
	path := "./Files/" + name

	file, err := os.Create(path)
	if err != nil {
		return "", "", err
	}

	t.Execute(file, nil)
	return path, name, nil
}
