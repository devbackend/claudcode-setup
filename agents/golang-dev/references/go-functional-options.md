# Functional Options Pattern

Use for any configurable constructor:

```go
type Option func(*Config)

func WithTimeout(d time.Duration) Option {
    return func(c *Config) { c.Timeout = d }
}

func NewService(opts ...Option) *Service {
    cfg := &Config{Timeout: 30 * time.Second}
    for _, opt := range opts {
        opt(cfg)
    }
    return &Service{cfg: cfg}
}
```
