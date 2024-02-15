package DocBase

import (
	"T-Base/Brain/mytypes"
	"context"
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
