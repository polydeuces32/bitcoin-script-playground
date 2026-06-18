#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="Bitcoin-Script-33"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_ROOT"

if [[ -t 1 ]]; then
  RESET=$'\033[0m'
  BOLD=$'\033[1m'
  DIM=$'\033[2m'
  CYAN=$'\033[36m'
  BLUE=$'\033[94m'
  GREEN=$'\033[32m'
  ORANGE=$'\033[38;5;208m'
  PURPLE=$'\033[35m'
  YELLOW=$'\033[33m'
  WHITE=$'\033[97m'
  RED=$'\033[31m'
else
  RESET=""
  BOLD=""
  DIM=""
  CYAN=""
  BLUE=""
  GREEN=""
  ORANGE=""
  PURPLE=""
  YELLOW=""
  WHITE=""
  RED=""
fi

line() {
  printf '%s%s%s\n' "$DIM" '────────────────────────────────────────────────────────────────────────────' "$RESET"
}

print_window_header() {
  printf '\n%s●%s %s●%s %s●%s  %sdev-status.sh — %s%s\n' \
    "$RED" "$RESET" "$YELLOW" "$RESET" "$GREEN" "$RESET" "$DIM" "$PROJECT_NAME" "$RESET"
  line
}

print_prompt() {
  printf '\n%s%s@Mac%s %s~%s ./scripts/dev-status.sh\n\n' "$GREEN" "giancarlovizhnay" "$RESET" "$DIM" "$RESET"
}

print_ghost_frame_1() {
  cat <<EOF
${CYAN}${DIM}             .........
${CYAN}${DIM}        .:+#############+:.
${CYAN}      .+#####################+.
${CYAN}     +#########${WHITE}  oo  ${CYAN}#########+
${CYAN}    ##########${WHITE}  oo  ${CYAN}##########
${BLUE}   .###########################.
${BLUE}   #############################
${BLUE}   #############################
${BLUE}   #######${DIM}::::${BLUE}#########${DIM}::::${BLUE}#######
${BLUE}   #####:${DIM}    ${BLUE}:#####:${DIM}    ${BLUE}:#####
${BLUE}${DIM}   .###:      :###:      :###.
${BLUE}${DIM}     :+.      .:+.      .+:
${CYAN}${DIM}          ghost process waking${RESET}
EOF
}

print_ghost_frame_2() {
  cat <<EOF
${CYAN}${DIM}              .........
${CYAN}${DIM}         .:+#############+:.
${CYAN}       .+#####################+.
${CYAN}      +#########${WHITE}  --  ${CYAN}#########+
${CYAN}     ##########${WHITE}  --  ${CYAN}##########
${BLUE}    .###########################.
${BLUE}    #############################
${BLUE}    #############################
${BLUE}    #######${DIM}::::${BLUE}#########${DIM}::::${BLUE}#######
${BLUE}    #####:${DIM}    ${BLUE}:#####:${DIM}    ${BLUE}:#####
${BLUE}${DIM}    .###:      :###:      :###.
${BLUE}${DIM}      :+.      .:+.      .+:
${CYAN}${DIM}           ghost process blinking${RESET}
EOF
}

print_ghost_frame_3() {
  cat <<EOF
${CYAN}${DIM}             .........
${CYAN}${DIM}        .:+#############+:.
${CYAN}      .+#####################+.
${CYAN}     +#########${WHITE}  OO  ${CYAN}#########+
${CYAN}    ##########${WHITE}  OO  ${CYAN}##########
${BLUE}   .###########################.
${BLUE}   #############################
${BLUE}   #############################
${BLUE}   #######${DIM}::::${BLUE}#########${DIM}::::${BLUE}#######
${BLUE}   #####:${DIM}    ${BLUE}:#####:${DIM}    ${BLUE}:#####
${BLUE}${DIM}   .###:      :###:      :###.
${BLUE}${DIM}     :+.      .:+.      .+:
${CYAN}${DIM}          ghost process online${RESET}
EOF
}

print_ghost() {
  print_ghost_frame_3
}

animate_ghost() {
  [[ -t 1 ]] || return 0
  [[ "${NO_GHOST_ANIMATION:-0}" == "1" ]] && return 0

  local start_line
  start_line="$(tput sc 2>/dev/null || true)"
  tput civis 2>/dev/null || true

  for _ in 1 2; do
    tput rc 2>/dev/null || true
    print_ghost_frame_1
    sleep 0.16
    tput rc 2>/dev/null || true
    print_ghost_frame_2
    sleep 0.12
    tput rc 2>/dev/null || true
    print_ghost_frame_3
    sleep 0.18
  done

  tput cnorm 2>/dev/null || true
  printf '\n'
}

collect_system_info() {
  local os host kernel uptime shell_name terminal_name cpu memory disk local_ip
  os="$(sw_vers -productName 2>/dev/null || uname -s) $(sw_vers -productVersion 2>/dev/null || true)"
  host="$(sysctl -n hw.model 2>/dev/null || hostname)"
  kernel="$(uname -sr 2>/dev/null || printf 'unknown')"
  uptime="$(uptime | sed 's/^.*up //' | sed 's/, [0-9]* user.*$//' | sed 's/, load averages.*$//' 2>/dev/null || printf 'unknown')"
  shell_name="${SHELL:-unknown}"
  shell_name="${shell_name##*/}"
  terminal_name="${TERM_PROGRAM:-Terminal}"
  cpu="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || printf 'Apple Silicon')"
  memory="$(( $(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1024 / 1024 / 1024 )) GiB"
  disk="$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}' 2>/dev/null || printf 'unknown')"
  local_ip="$(ipconfig getifaddr en0 2>/dev/null || printf 'offline')"

  printf '%s%s%s%s\n' "$BOLD" "$CYAN" "giancarlovizhnay@Mac" "$RESET"
  printf '%s\n' "────────────────────────"
  printf '%sOS%s        : %s\n' "$ORANGE" "$RESET" "$os"
  printf '%sHost%s      : %s\n' "$ORANGE" "$RESET" "$host"
  printf '%sKernel%s    : %s\n' "$ORANGE" "$RESET" "$kernel"
  printf '%sUptime%s    : %s\n' "$ORANGE" "$RESET" "$uptime"
  printf '%sShell%s     : %s\n' "$ORANGE" "$RESET" "$shell_name"
  printf '%sTerminal%s  : %s\n' "$ORANGE" "$RESET" "$terminal_name"
  printf '%sCPU%s       : %s\n' "$ORANGE" "$RESET" "$cpu"
  printf '%sMemory%s    : %s\n' "$ORANGE" "$RESET" "$memory"
  printf '%sDisk (/)%s  : %s\n' "$ORANGE" "$RESET" "$disk"
  printf '%sLocal IP%s  : %s\n' "$ORANGE" "$RESET" "$local_ip"
}

print_status_grid() {
  printf '%s%s=== %s Dev Status ===%s\n\n' "$BOLD" "$CYAN" "$PROJECT_NAME" "$RESET"
  paste <(print_ghost) <(collect_system_info) | sed 's/^/  /'
}

print_repo_status() {
  printf '\n%s=== Repository ===%s\n' "$PURPLE" "$RESET"
  line
  printf '%sPath%s         : %s%s%s\n' "$DIM" "$RESET" "$CYAN" "$PROJECT_ROOT" "$RESET"

  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local branch commit
    branch="$(git branch --show-current 2>/dev/null || printf 'unknown')"
    commit="$(git rev-parse --short HEAD 2>/dev/null || printf 'unknown')"

    printf '%sBranch%s       : %s%s%s\n' "$DIM" "$RESET" "$GREEN" "$branch" "$RESET"
    printf '%sCommit%s       : %s%s%s\n' "$DIM" "$RESET" "$YELLOW" "$commit" "$RESET"

    if git diff --quiet --ignore-submodules -- 2>/dev/null; then
      printf '%sWorking tree%s : %s✓ clean%s\n' "$DIM" "$RESET" "$GREEN" "$RESET"
    else
      printf '%sWorking tree%s : %shas local changes%s\n' "$DIM" "$RESET" "$ORANGE" "$RESET"
    fi
  else
    printf 'Git: unavailable or not inside a repository\n'
  fi
}

print_project_files() {
  printf '\n%s=== Project Files ===%s\n' "$CYAN" "$RESET"
  line
  find . \
    -path './.git' -prune -o \
    -path './node_modules' -prune -o \
    -path './dist' -prune -o \
    -path './build' -prune -o \
    -maxdepth 2 \
    -type f \
    -print | sort | sed 's#^./#├── #'
}

print_window_header
print_prompt
animate_ghost
print_status_grid
print_repo_status
print_project_files

printf '\n%s✓ Done.%s\n' "$GREEN" "$RESET"
