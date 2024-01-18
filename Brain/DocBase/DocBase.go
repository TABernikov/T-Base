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

func (base DocBase) NewDoc(ctx context.Context, DocType string, name string, user mytypes.User, content string, access []string, files ...string) error {
	collection := base.Db.Collection(DocType)

	type DocToIn struct {
		Tatle        string    `bson:"tatle"`
		Authtor      string    `bson:"authtor"`
		CreationTime time.Time `bson:"creationTime"`
		Content      string    `bson:"content"`
		Access       []string  `bson:"access"`
		Files        []string  `bson:"files"`
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
	}

	_, err := collection.InsertOne(ctx, doc)
	if err != nil {
		return err
	}

	return nil
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

	return res, nil

}

func (base DocBase) TakeDoc(ctx context.Context, DocType string, id primitive.ObjectID) (mytypes.Document, error) {

	collection := base.Db.Collection(DocType)
	var doc mytypes.Document
	err := collection.FindOne(ctx, bson.D{{"_id", id}}).Decode(&doc)
	if err != nil {
		return doc, err
	}
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
