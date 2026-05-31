# Interface Segregation Principle (ISP) Patterns

## Rule

**MANDATORY: Apply ISP to ALL external dependencies without exception.**

- **NEVER use concrete types as struct fields for external dependencies**
- **ALWAYS create minimal interfaces in `contracts.go` for ANY external dependency**

Applies to:
- ✅ External libraries (DB repositories, Redis client, HTTP client, etc.)
- ✅ Structs from other internal packages
- ✅ Any dependency that will be mocked in tests
- ❌ Domain entities (User, Product, etc.) — pass directly
- ❌ Simple data structures without behavior (configs, DTOs)

## Required Steps for Every Struct with Dependencies

1. Create `contracts.go` in the same package
2. Define minimal interfaces with ONLY the methods actually used
3. Add `//go:generate mockgen -source $GOFILE -destination mock_test.go -package $GOPACKAGE` at the top
4. Use interface types in struct fields, NOT concrete types
5. Run `go generate ./...` to generate mocks

## Example

```go
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
```

## Common Violations to Avoid

| Wrong | Correct |
|---|---|
| `repo *postgres.UserRepository` | `repo UserRepository` |
| `client *redis.Client` | `client RedisClient` |
| `bot *tgbotapi.BotAPI` | `bot BotAPI` |
| `fsm *fsm.FSM` | `fsm FSM` |
| `parser *parsing.HaloParser` | `parser ListingParser` |
