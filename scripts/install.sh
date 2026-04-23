#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
安装当前 skill 到常见 AI agent skill 目录。
Install the current skill folder into common AI-agent skill directories.

用法 / Usage:
  scripts/install.sh [--all] [--codex] [--claude] [--gemini] [--agents] [--target DIR] [--name NAME]

示例 / Examples:
  scripts/install.sh --all
  scripts/install.sh --codex --claude
  scripts/install.sh --target "$HOME/.my-agent/skills"

默认行为 / Defaults:
  不传目标参数时等同于 --all。
  With no target flags, installs to --all.
  已存在同名 skill 时会先备份为 .backup.TIMESTAMP.PID。
  Existing same-name skills are moved aside as .backup.TIMESTAMP.PID.
EOF
}

skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_name="$(basename "$skill_root")"

targets=()
selected=0

add_target() {
  targets+=("$1")
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      selected=1
      add_target "$HOME/.codex/skills"
      add_target "$HOME/.agents/skills"
      add_target "$HOME/.claude/skills"
      add_target "$HOME/.gemini/skills"
      shift
      ;;
    --codex)
      selected=1
      add_target "$HOME/.codex/skills"
      add_target "$HOME/.agents/skills"
      shift
      ;;
    --claude)
      selected=1
      add_target "$HOME/.claude/skills"
      shift
      ;;
    --gemini)
      selected=1
      add_target "$HOME/.gemini/skills"
      shift
      ;;
    --agents)
      selected=1
      add_target "$HOME/.agents/skills"
      shift
      ;;
    --target)
      selected=1
      [[ $# -ge 2 ]] || { echo "Missing value for --target" >&2; exit 2; }
      add_target "$2"
      shift 2
      ;;
    --name)
      [[ $# -ge 2 ]] || { echo "Missing value for --name" >&2; exit 2; }
      skill_name="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$selected" -eq 0 ]]; then
  add_target "$HOME/.codex/skills"
  add_target "$HOME/.agents/skills"
  add_target "$HOME/.claude/skills"
  add_target "$HOME/.gemini/skills"
fi

if [[ ! -f "$skill_root/SKILL.md" ]]; then
  echo "未找到 SKILL.md / SKILL.md not found in $skill_root" >&2
  exit 1
fi

for target in "${targets[@]}"; do
  mkdir -p "$target"
  dest="$target/$skill_name"
  if [[ -e "$dest" ]]; then
    backup="$dest.backup.$(date +%Y%m%d%H%M%S).$$"
    mv "$dest" "$backup"
    echo "已备份旧版本 / Backed up existing $dest -> $backup"
  fi
  mkdir -p "$dest"
  tar \
    --exclude '.git' \
    --exclude '.DS_Store' \
    --exclude '__pycache__' \
    -C "$skill_root" -cf - . | tar -C "$dest" -xf -
  echo "已安装 / Installed $skill_name -> $dest"
done
