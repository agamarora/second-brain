#!/bin/sh
# doctor.sh — preflight checks for second-brain setup
# Run before the CLAUDE.md wizard to catch missing tools / config early.

set -e

FAIL=0
WARN=0

check() {
  # $1 = label, $2 = command, $3 = fix hint
  if eval "$2" >/dev/null 2>&1; then
    printf "  [OK]   %s\n" "$1"
  else
    printf "  [FAIL] %s\n         fix: %s\n" "$1" "$3"
    FAIL=$((FAIL + 1))
  fi
}

warn_check() {
  # $1 = label, $2 = command, $3 = hint
  if eval "$2" >/dev/null 2>&1; then
    printf "  [OK]   %s\n" "$1"
  else
    printf "  [WARN] %s\n         hint: %s\n" "$1" "$3"
    WARN=$((WARN + 1))
  fi
}

echo "doctor: running preflight checks for second-brain"
echo ""

# 1. gh CLI present
check "gh CLI installed" \
      "gh --version" \
      "install from https://cli.github.com, then: gh auth login"

# 1b. gh authenticated — required for `gh repo create --template`
check "gh authenticated" \
      "gh auth status" \
      "run: gh auth login"

# 2. git configured
check "git user.name set" \
      "test -n \"\$(git config --get user.name)\"" \
      "git config --global user.name 'Your Name'"

check "git user.email set" \
      "test -n \"\$(git config --get user.email)\"" \
      "git config --global user.email 'you@example.com'"

# 3. Claude Code detection — best-effort warn only
warn_check "Claude Code detected (optional)" \
           "command -v claude || test -d \"\$HOME/.claude\"" \
           "not required; non-Claude-Code agents work via SETUP-GUIDE.md"

# 4. Current directory is writable
check "cwd writable" \
      "touch .doctor-write-test && rm -f .doctor-write-test" \
      "chmod +w . or run from a writable directory"

# 5. inbox/ exists and is empty (ready for user drops)
if [ -d "inbox" ]; then
  # count non-hidden, non-.gitkeep files
  DROPPED=$(find inbox -maxdepth 1 -type f ! -name '.gitkeep' ! -name '.*' | wc -l | tr -d ' ')
  if [ "$DROPPED" -eq 0 ]; then
    printf "  [OK]   inbox/ exists and is empty (ready for artifacts)\n"
  else
    printf "  [INFO] inbox/ already contains %s file(s) — wizard will ingest them\n" "$DROPPED"
  fi
else
  printf "  [FAIL] inbox/ missing\n         fix: mkdir -p inbox && touch inbox/.gitkeep\n"
  FAIL=$((FAIL + 1))
fi

echo ""
if [ "$FAIL" -gt 0 ]; then
  printf "doctor: %s failure(s), %s warning(s) — fix failures before running the wizard.\n" "$FAIL" "$WARN"
  exit 1
else
  printf "doctor: OK (%s warning(s))\n" "$WARN"
  exit 0
fi
