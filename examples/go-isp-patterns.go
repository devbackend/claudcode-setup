// ❌ WRONG: Using concrete types
type Handler struct {
	bot *tgbotapi.BotAPI
	db  *sql.DB
}

// ✅ CORRECT: Using interfaces
type Handler struct {
	bot BotAPI
	db  Database
}

// contracts.go
//go:generate mockgen -source $GOFILE -destination mock_test.go -package $GOPACKAGE
package handler

import (
	"context"
	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api/v5"
)

type BotAPI interface {
	Send(c tgbotapi.Chattable) (tgbotapi.Message, error)
}

type Database interface {
	Query(ctx context.Context, query string, args ...any) (*sql.Rows, error)
	Exec(ctx context.Context, query string, args ...any) (sql.Result, error)
}
