package Auth

import (
	"T-Base/Brain/Storage"
	"T-Base/Brain/mytypes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/dgrijalva/jwt-go/v4"
	"github.com/julienschmidt/httprouter"
)

type сlaims struct {
	jwt.StandardClaims
	Uid   int
	Login string
	UName string
	Acces int
}

// Парсинг JWT токена
func ParseJWT(tokenStr string, key []byte) (mytypes.User, error) {
	token, err := jwt.ParseWithClaims(tokenStr, &сlaims{}, func(token *jwt.Token) (interface{}, error) {

		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("неверный метод шифрования токена %v", token.Header)
		}
		return key, nil
	})

	if token != nil {
		user := mytypes.User{}
		if claims, ok := token.Claims.(*сlaims); ok {
			user = mytypes.User{
				UserId: claims.Uid,
				Login:  claims.Login,
				Name:   claims.UName,
				Acces:  claims.Acces,
			}
			if token.Valid {
				fmt.Println("Тут тоже", user, "имя ", user.Name)
				return user, nil
			} else {
				return user, fmt.Errorf("токен недействителен", err)
			}

		}
	}

	return mytypes.User{
		Login: "err",
		Email: "err",
		Name:  "claims.UName",
		Acces: 33,
	}, err
}

// Запись 2х токенов
func MakeTokens(w http.ResponseWriter, r *http.Request, user mytypes.User, JwtKey []byte, db Storage.Base) {
	fmt.Println("Делаю токен для ", user)
	cleanCookies(w, r)
	// генерируем токен авторизации
	authToken := jwt.NewWithClaims(jwt.SigningMethodHS256, сlaims{
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: jwt.At(time.Now().Add(1 * time.Minute)),
			IssuedAt:  jwt.At(time.Now()),
		},
		Uid:   user.UserId,
		Login: user.Login,
		UName: user.Name,
		Acces: user.Acces,
	})
	println(user.Name)

	t, err := authToken.SignedString(JwtKey)
	if err != nil { // Ошибка генерации токена
		println(err)
	}

	// Создаем куки авторизации
	livingTime := 60 * time.Minute           // время жизни 60 минут
	expiration := time.Now().Add(livingTime) // задание даты смерти куки
	jsonToken, _ := json.Marshal(t)
	stringJsonToken := strings.Trim(string(jsonToken), "\"")

	cookie := http.Cookie{Name: "Lolijoyu", Value: stringJsonToken, Expires: expiration, HttpOnly: true, SameSite: http.SameSiteStrictMode, Path: "/works"} // создание куки с покеном по именем LoKiujhuyg
	http.SetCookie(w, &cookie)
	r.AddCookie(&cookie)
	println(user.Login + " авт: " + stringJsonToken)

	// генерируем токен генерации
	generToken := jwt.NewWithClaims(jwt.SigningMethodHS256, сlaims{
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: jwt.At(time.Now().Add(60 * time.Minute)),
			IssuedAt:  jwt.At(time.Now()),
		},
	})

	gt, err := generToken.SignedString([]byte(stringJsonToken))
	if err != nil { // Ошибка генерации токена
		println(err)
	}

	// Создаем куки генерации
	livingTime = 60 * time.Minute           // время жизни 60 минут
	expiration = time.Now().Add(livingTime) // задание даты смерти куки
	jsonToken, _ = json.Marshal(gt)
	stringJsonToken = strings.Trim(string(jsonToken), "\"")

	cookie = http.Cookie{Name: "Korikasa", Value: stringJsonToken, Expires: expiration, HttpOnly: true, SameSite: http.SameSiteStrictMode, Path: "/works"} // создание куки с покеном по именем Koisd2hsd
	http.SetCookie(w, &cookie)
	r.AddCookie(&cookie)
	db.NewRegenToken(user.Login, stringJsonToken, context.Background())

	println(user.Login + " ген: " + stringJsonToken)
}

// обработчик деавторизации удаление всех кук
func Logout(w http.ResponseWriter, r *http.Request, pr httprouter.Params) {
	cleanCookies(w, r)
	http.Redirect(w, r, "/works/login", http.StatusSeeOther)
}

// чтение куки по имени
func ReadCookie(name string, r *http.Request) (string, error) {
	if name == "" {
		return "", errors.New("you are tryin to read unreal cookie")
	}
	cookie, err := r.Cookie(name)
	if err != nil {
		return "", err
	}
	return url.QueryEscape(cookie.Value), err
}

// чистим куки
func cleanCookies(w http.ResponseWriter, r *http.Request) {
	for _, v := range r.Cookies() {
		c := http.Cookie{
			Name:   v.Name,
			MaxAge: -1,
			Path:   "/works",
		}
		http.SetCookie(w, &c)

	}
}
