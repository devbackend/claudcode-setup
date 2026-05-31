# Rust Crate Preferences

| Category | Crate(s) |
|---|---|
| Serialisation | `serde` + `serde_json` / `serde_yaml` / `bincode` |
| Error handling | `thiserror` (libraries), `anyhow` (applications) |
| Async runtime | `tokio` |
| Async utilities | `futures` |
| HTTP client | `reqwest` |
| HTTP server | `axum` (preferred) or `actix-web` |
| CLI | `clap` v4 |
| Logging / tracing | `tracing` + `tracing-subscriber` |
| Testing | `rstest`, `proptest`, `mockall` |
| CPU parallelism | `rayon` |
| Collections | `indexmap`, `ahash`, `smallvec` |
| Date / Time | `chrono` or `time` |

Always use the latest stable version. Prefer crates with strong maintenance records and wide adoption.
