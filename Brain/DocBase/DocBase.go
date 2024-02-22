package DocBase

import (
	"T-Base/Brain/mytypes"
	"bytes"
	"context"
	"text/template"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type DocBase struct {
	Db *mongo.Database
}

func NewDocBase() (*DocBase, error) {
	opts := options.Client().ApplyURI("mongodb://localhost:27017")
	client, err := mongo.Connect(context.Background(), opts)
	database := client.Database("TBaseDoc")

	return &DocBase{Db: database}, err
}

func (base DocBase) NewDoc(ctx context.Context, DocType string, name string, user mytypes.User, content string, access []string, files ...string) (primitive.ObjectID, error) {
	collection := base.Db.Collection(DocType)
	var id primitive.ObjectID

	type DocToIn struct {
		Tatle        string    `bson:"tatle"`
		Authtor      string    `bson:"authtor"`
		CreationTime time.Time `bson:"creationTime"`
		Content      string    `bson:"content"`
		Access       []string  `bson:"access"`
		Files        []string  `bson:"files"`
		Type         string    `bson:"docType"`
	}

	if files == nil {
		files = []string{}
	}

	doc := DocToIn{
		Tatle:        name,
		Authtor:      user.Name,
		CreationTime: time.Now(),
		Content:      content,
		Access:       access,
		Files:        files,
		Type:         DocType,
	}

	res, err := collection.InsertOne(ctx, doc)
	if err != nil {
		return id, err
	}

	id = res.InsertedID.(primitive.ObjectID)

	return id, nil
}

func (base DocBase) TakeDocs(ctx context.Context, DocType string) ([]mytypes.Document, error) {
	var docs []mytypes.Document
	collection := base.Db.Collection(DocType)

	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		return docs, err
	}

	var res []mytypes.Document
	err = cursor.All(ctx, &res)
	if err != nil {
		return docs, err
	}

	for i := 0; i < len(res); i++ {
		res[i].DocType = DocType
	}

	return res, nil

}

func (base DocBase) TakeDoc(ctx context.Context, DocType string, id primitive.ObjectID) (mytypes.Document, error) {

	collection := base.Db.Collection(DocType)
	var doc mytypes.Document
	err := collection.FindOne(ctx, bson.D{{"_id", id}}).Decode(&doc)
	if err != nil {
		return doc, err
	}
	doc.DocType = DocType
	return doc, nil
}

func (base DocBase) TakeDocsByUser(ctx context.Context, DocType string, user mytypes.User) ([]mytypes.Document, error) {
	var docs []mytypes.Document
	collection := base.Db.Collection(DocType)

	cursor, err := collection.Find(ctx, bson.D{{"authtor", user.Name}})
	if err != nil {
		return docs, err
	}

	var res []mytypes.Document
	err = cursor.All(ctx, &res)
	if err != nil {
		return docs, err
	}

	for i := 0; i < len(res); i++ {
		res[i].DocType = DocType
	}

	return res, nil
}

func (base DocBase) DeleteDoc(ctx context.Context, DocType string, id primitive.ObjectID) error {
	collection := base.Db.Collection(DocType)

	_, err := collection.DeleteOne(ctx, bson.D{{"_id", id}})
	return err
}

func (base DocBase) UpdateDoc(ctx context.Context, DocType string, doc mytypes.Document) error {
	collection := base.Db.Collection(DocType)
	_, err := collection.UpdateByID(context.Background(), doc.Id, bson.M{"$set": doc})
	return err
}

func (base DocBase) CreateProductionDoc(ctx context.Context, buildMap mytypes.Map5int, tModelSn map[int][]string, dModelCount map[int]int, user mytypes.User, tModelMap map[int]string, dModelMap map[int]string, mModelMap map[int]string) (docId string, err error) {
	docType := "production.out"
	docName := `Постановка на ГП ` + time.Now().Format("02.01.2006 15:04")

	docContent := ``
	acces := []string{}

	templ := `# {{.Title}}

**{{.Authtor}}**

#### Произведено:

|Наименование | Кол-во |
|--|--|
{{range .TDone}}|{{.Name}}|{{.Amount}}|
{{end}}

----

#### Затрачено:

**Коммутаторы:**
|Наименование | Кол-во |
|--|--|
{{range .DDone}}|{{.Name}}|{{.Amount}}|
{{end}}

----

**Материалы**
|Наименование | Кол-во |
|--|--|
{{range .MDone}}|{{.Name}}|{{.Amount}}|
{{end}}

----

### Подробно
{{range .BDone}}
Сборка № **{{.BN}}**
|Т-КОМ|Кол-во|D-LINK|Кол-во|
|--|--|--|--|
|{{.TN}}|{{.TD}}|{{.DN}}|{{.DD}}|

|Наименование|Кол-во|
|--|--|
{{range .MDone}}|{{.Name}}|{{.Amount}}|
{{end}}


----

{{end}}

`
	type Done struct {
		Name   string
		Amount int
	}
	type BuildDone struct {
		TN    string
		TD    int
		DN    string
		DD    int
		BN    int
		MDone []Done
	}
	type outData struct {
		Title   string
		Authtor string
		TDone   []Done
		DDone   []Done
		MDone   []Done
		BDone   []BuildDone
	}

	var tDone []Done
	for t, sn := range tModelSn {
		tDone = append(tDone, Done{Name: tModelMap[t], Amount: len(sn)})
	}

	var dDone []Done
	for d, count := range dModelCount {
		dDone = append(dDone, Done{Name: dModelMap[d], Amount: count})
	}

	var mDone []Done
	mDoneMap := make(map[string]int)
	for _, dmods := range buildMap {
		for _, bilds := range dmods {
			for _, matIds := range bilds {
				for matId, amout := range matIds {
					mDoneMap[mModelMap[matId]] += amout
				}
			}
		}
	}

	for matName, amout := range mDoneMap {
		mDone = append(mDone, Done{Name: matName, Amount: amout})
	}

	var bDone []BuildDone
	for t, dmods := range buildMap {
		for d, bilds := range dmods {
			var MDone []Done
			for b, matIds := range bilds {
				for matId, amout := range matIds {
					MDone = append(MDone, Done{Name: mModelMap[matId], Amount: amout})
				}
				bDone = append(bDone, BuildDone{TN: tModelMap[t], DN: dModelMap[d], TD: len(bilds), DD: len(MDone), MDone: MDone, BN: b})
			}
		}
	}

	data := outData{
		Title:   docName,
		Authtor: user.Name,
		TDone:   tDone,
		DDone:   dDone,
		MDone:   mDone,
		BDone:   bDone,
	}

	t := template.New("test")
	t, err = t.Parse(templ)
	if err != nil {
		return
	}

	var tpl bytes.Buffer
	err = t.Execute(&tpl, data)
	if err != nil {
		return
	}

	docContent = tpl.String()

	user.Name = "Система"
	id, err := base.NewDoc(ctx, docType, docName, user, docContent, acces)
	if err != nil {
		return
	}

	docId = id.Hex()
	return
}
