#!/usr/bin/env python3

import json
import sys


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


def format_tokens(tokens: int) -> str:
    """Format token count (e.g., 110k)."""
    if tokens >= 1000:
        return f"{tokens // 1000}k"
    return str(tokens)


def build_progress_bar(pct: int, width: int = 10) -> tuple[str, str]:
    """Build a progress bar with dynamic color."""
    if pct > 80:
        color = C_RED
    elif pct > 60:
        color = C_YELLOW
    else:
        color = C_GREEN

    filled = min(max(pct * width // 100, 0), width)
    empty = max(width - filled, 0)

    bar_filled = "▓" * filled
    bar_empty = "░" * empty
    return f"{color}{bar_filled}{C_GRAY}{bar_empty}{C_RESET}", color


def main():
    try:
        data = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return

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

    model_part = f"{C_GRAY}{model_color}{model_short}{C_GRAY} │ {C_TEXT}v{version}{C_GRAY}{C_RESET}"

    # Context window usage
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

    # Autocompact triggers at 77.5% (100% - 22.5% buffer)
    autocompact_threshold = size * 775 // 1000
    pct = (
        min(current * 100 // autocompact_threshold, 100)
        if autocompact_threshold > 0
        else 0
    )
    remaining = max(autocompact_threshold - current, 0)

    remaining_fmt = format_tokens(remaining)
    current_fmt = format_tokens(current)

    progress_bar, pct_color = build_progress_bar(pct)

    context_part = (
        f" {C_GRAY}│{C_RESET} {pct_color}{pct}%{C_RESET}: "
        f"{current_fmt}{C_GRAY}[{C_RESET}{progress_bar}{C_GRAY}]{C_RESET}{remaining_fmt}"
    )

    print(f"{model_part}{context_part}", end="")


if __name__ == "__main__":
    main()
