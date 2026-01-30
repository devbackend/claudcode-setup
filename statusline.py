#!/usr/bin/env python3
import json
import sys

data = json.load(sys.stdin)

version = data["version"]
model = data["model"]["display_name"]
context_perc = data["context_window"]["used_percentage"] or 0
inp_tokens = data["context_window"]["total_input_tokens"]
out_tokens = data["context_window"]["total_output_tokens"]

print(f"[{model} / v{version}] {context_perc}% {out_tokens} / {inp_tokens}")
