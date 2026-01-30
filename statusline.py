#!/usr/bin/env python3

import json
import os
import subprocess
import sys
import time
from pathlib import Path

CACHE_DIR = Path.home() / ".cache" / "claude-statusline"
SESSION_CACHE = CACHE_DIR / "session.json"
WEEKLY_CACHE = CACHE_DIR / "weekly.json"
SESSION_TTL = 60  # 1 minute
WEEKLY_TTL = 300  # 5 minutes


def hex_to_ansi(hex_color: str) -> str:
    """Convert hex color to ANSI escape sequence."""
    hex_color = hex_color.lstrip("#")
    r, g, b = int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16)
    return f"\033[38;2;{r};{g};{b}m"


# Catppuccin Mocha palette
C_RED = hex_to_ansi("#f38ba8")
C_YELLOW = hex_to_ansi("#f9e2af")
C_GREEN = hex_to_ansi("#a6e3a1")
C_CYAN = hex_to_ansi("#89dceb")
C_BLUE = hex_to_ansi("#89b4fa")
C_MAGENTA = hex_to_ansi("#cba6f7")
C_PINK = hex_to_ansi("#f5c2e7")
C_ORANGE = hex_to_ansi("#fab387")
C_GRAY = hex_to_ansi("#585b70")
C_SURFACE = hex_to_ansi("#313244")
C_TEXT = hex_to_ansi("#cdd6f4")
C_RESET = "\033[0m"


def get_model_color(model: str) -> str:
    """Get color based on model name."""
    model_lower = model.lower()
    if "opus" in model_lower:
        return C_GREEN
    elif "sonnet" in model_lower:
        return C_YELLOW
    elif "haiku" in model_lower:
        return C_RED
    return C_TEXT


def get_pct_color(pct: int) -> str:
    """Get color based on percentage."""
    if pct > 80:
        return C_RED
    elif pct > 60:
        return C_YELLOW
    return C_GREEN


def build_progress_bar(pct: int, width: int = 10) -> tuple[str, str]:
    """Build a progress bar with dynamic color."""
    color = get_pct_color(pct)
    filled = min(max(pct * width // 100, 0), width)
    empty = max(width - filled, 0)

    bar_filled = "▓" * filled
    bar_empty = "░" * empty
    return f"{color}{bar_filled}{C_GRAY}{bar_empty}{C_RESET}", color


def get_claude_token() -> str | None:
    """Get Claude access token from macOS Keychain."""
    try:
        result = subprocess.run(
            ["security", "find-generic-password", "-s", "Claude Code-credentials", "-w"],
            capture_output=True,
            text=True,
            timeout=5,
        )
        if result.returncode != 0:
            return None
        creds = json.loads(result.stdout.strip())
        # Token is nested in claudeAiOauth
        oauth = creds.get("claudeAiOauth", {})
        return oauth.get("accessToken")
    except (subprocess.TimeoutExpired, json.JSONDecodeError, FileNotFoundError):
        return None


def fetch_usage(token: str) -> dict | None:
    """Fetch usage data from Anthropic API."""
    try:
        result = subprocess.run(
            [
                "curl",
                "-s",
                "--max-time",
                "5",
                "https://api.anthropic.com/api/oauth/usage",
                "-H",
                f"Authorization: Bearer {token}",
                "-H",
                "anthropic-beta: oauth-2025-04-20",
            ],
            capture_output=True,
            text=True,
            timeout=10,
        )
        if result.returncode != 0:
            return None
        return json.loads(result.stdout)
    except (subprocess.TimeoutExpired, json.JSONDecodeError):
        return None


def get_cached_usage(cache_file: Path, ttl: int) -> dict | None:
    """Get cached usage data if still valid."""
    if not cache_file.exists():
        return None
    try:
        mtime = cache_file.stat().st_mtime
        if time.time() - mtime > ttl:
            return None
        with open(cache_file) as f:
            return json.load(f)
    except (OSError, json.JSONDecodeError):
        return None


def save_cache(cache_file: Path, data: dict) -> None:
    """Save usage data to cache."""
    try:
        CACHE_DIR.mkdir(parents=True, exist_ok=True)
        with open(cache_file, "w") as f:
            json.dump(data, f)
    except OSError:
        pass


def get_usage_data() -> tuple[int | None, int | None]:
    """Get session (5h) and weekly (7d) usage percentages."""
    # Try session cache
    session_data = get_cached_usage(SESSION_CACHE, SESSION_TTL)
    weekly_data = get_cached_usage(WEEKLY_CACHE, WEEKLY_TTL)

    # If both caches valid, return cached values
    if session_data is not None and weekly_data is not None:
        return session_data.get("pct"), weekly_data.get("pct")

    # Need to fetch fresh data
    token = get_claude_token()
    if not token:
        return None, None

    usage = fetch_usage(token)
    if not usage:
        return None, None

    # Extract percentages
    session_pct = None
    weekly_pct = None

    five_hour = usage.get("five_hour", {})
    if five_hour:
        session_pct = int(float(five_hour.get("utilization", 0)))
        save_cache(SESSION_CACHE, {"pct": session_pct})

    seven_day = usage.get("seven_day", {})
    if seven_day:
        weekly_pct = int(float(seven_day.get("utilization", 0)))
        save_cache(WEEKLY_CACHE, {"pct": weekly_pct})

    return session_pct, weekly_pct


def main():
    try:
        data = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return

    parts = []

    # Model and version
    model_data = data.get("model", {})
    if isinstance(model_data, dict):
        model_id = model_data.get("id", "unknown")
        model_display = model_data.get("display_name", "unknown")
    else:
        model_id = str(model_data)
        model_display = model_id

    version = data.get("version", "0.0.0")
    model_color = get_model_color(model_id)
    model_short = model_display.lower()

    parts.append(f"{model_color}{model_short}{C_RESET}")
    parts.append(f"{C_TEXT}v{version}{C_RESET}")

    # Context window usage (just percentage)
    usage = data.get("context_window", {}).get("current_usage")
    size = data.get("context_window", {}).get("context_window_size", 200000)

    if usage:
        current = (
            usage.get("input_tokens", 0)
            + usage.get("cache_creation_input_tokens", 0)
            + usage.get("cache_read_input_tokens", 0)
        )
    else:
        current = 0

    autocompact_threshold = size * 775 // 1000
    context_pct = (
        min(current * 100 // autocompact_threshold, 100)
        if autocompact_threshold > 0
        else 0
    )
    context_color = get_pct_color(context_pct)
    parts.append(f"{C_TEXT}context: {context_color}{context_pct}%{C_RESET}")

    # Session and weekly usage
    session_pct, weekly_pct = get_usage_data()

    if session_pct is not None:
        bar, _ = build_progress_bar(session_pct, 8)
        color = get_pct_color(session_pct)
        parts.append(f"{C_TEXT}session: {color}{session_pct}%{C_RESET} {C_GRAY}[{C_RESET}{bar}{C_GRAY}]{C_RESET}")

    if weekly_pct is not None:
        bar, _ = build_progress_bar(weekly_pct, 8)
        color = get_pct_color(weekly_pct)
        parts.append(f"{C_TEXT}weekly: {color}{weekly_pct}%{C_RESET} {C_GRAY}[{C_RESET}{bar}{C_GRAY}]{C_RESET}")

    # Join with separator
    separator = f" {C_GRAY}│{C_RESET} "
    print(separator.join(parts), end="")


if __name__ == "__main__":
    main()
