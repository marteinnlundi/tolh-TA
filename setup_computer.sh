#!/usr/bin/env bash
#
# setup_computer.sh
# -----------------------------------------------------------------------------
# Populates the current user's HOME so it looks like a NORMAL personal computer:
# Desktop, Documents, Downloads, Pictures, Music, Videos, Projects, logs, and a
# few hidden dotfiles -- all filled with realistic dummy files and data.
#
# The student SSHes in, sees an ordinary home directory, and works through a set
# of PRACTICAL, GOAL-BASED tasks (in ~/Desktop/tasks.txt). The tasks never name
# the command to use -- the student must figure that out, read the man pages,
# and write down what they did in their worksheet.
#
# Everything is DETERMINISTIC, so the instructor answer key (--solutions) always
# matches what the student sees.
#
# USAGE
#   ./setup_computer.sh             # populate $HOME (refuses if already populated)
#   ./setup_computer.sh --reset     # remove only what this script created, rebuild
#   ./setup_computer.sh --solutions # build if needed, then print the answer key (PRIVATE)
#   ./setup_computer.sh --check     # check optional dependencies only
#
# Reset is SAFE: it only deletes the top-level folders/files this script manages
# (listed in MANAGED below). It never touches .bashrc, .ssh, or the script itself.
# -----------------------------------------------------------------------------

set -euo pipefail

# top-level entries this script owns (the only things --reset will remove)
MANAGED=(Desktop Documents Downloads Pictures Music Videos Projects logs .local_notes)

MODE="build"
for arg in "$@"; do
  case "$arg" in
    --reset)     MODE="reset" ;;
    --solutions) MODE="solutions" ;;
    --check)     MODE="check" ;;
    -h|--help)   sed -n '2,30p' "$0"; exit 0 ;;
    *)           echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

H="$HOME"
say() { printf '%s\n' "$*"; }
hdr() { printf '\n=== %s ===\n' "$*"; }

check_deps() {
  local missing=()
  for c in tree find file du gcc tar hexdump; do
    command -v "$c" >/dev/null 2>&1 || missing+=("$c")
  done
  if ((${#missing[@]})); then
    say "NOTE: optional tools missing: ${missing[*]}"
    say "      sudo apt-get update && sudo apt-get install -y tree findutils file coreutils gcc tar bsdmainutils"
  else
    say "All tools present (tree, find, file, du, gcc, tar, hexdump)."
  fi
}

already_populated() {
  local e
  for e in "${MANAGED[@]}"; do
    [[ -e "$H/$e" ]] && return 0
  done
  return 1
}

wipe_managed() {
  local e
  for e in "${MANAGED[@]}"; do
    [[ -e "$H/$e" ]] && chmod -R u+rwX "$H/$e" 2>/dev/null || true
    rm -rf "$H/$e"
  done
}

# =============================================================================
#  BUILD THE "COMPUTER"
# =============================================================================
build_home() {
  if already_populated && [[ "$MODE" != "reset" ]]; then
    say "Home already looks populated (found one of: ${MANAGED[*]})."
    say "Use '--reset' to clear just those and rebuild."
    exit 1
  fi
  wipe_managed

  # ---- standard top-level folders ------------------------------------------
  mkdir -p "$H"/{Desktop,Documents,Downloads,Pictures,Music,Videos,Projects,logs}

  # ---- Documents -----------------------------------------------------------
  mkdir -p "$H/Documents/work/reports" "$H/Documents/work/invoices" \
           "$H/Documents/work/confidential" \
           "$H/Documents/personal/recipes" "$H/Documents/personal/misc"

  cat > "$H/Documents/todo.txt" <<'EOF'
- reply to landlord about the lease
- book dentist appointment
- finish the quarterly report
- back up the laptop
- cancel the unused streaming subscription
- call mom on Sunday
- renew car insurance before the 30th
EOF

  printf 'Notes from the Monday standup.\nDiscussed the budget, the new hire, and the launch date.\nAction items assigned to the team.\n' \
    > "$H/Documents/work/meeting_notes.txt"

  for q in 1 2 3 4; do
    printf 'Quarterly report Q%s\nRevenue up, costs flat, headcount stable.\n' "$q" \
      > "$H/Documents/work/reports/report_q${q}.txt"
  done
  printf '# Year summary\nAll four quarters met target.\n' \
    > "$H/Documents/work/reports/summary.md"

  printf 'id,date,amount,client\n' > "$H/Documents/work/invoices/_header.note"
  for i in $(seq -w 1 12); do
    printf 'id,date,amount,client\n%s,2024-%02d-15,%d.00,client_%s\n' \
      "$i" "$((10#$i))" "$(( 100 + 10#$i * 37 ))" "$i" \
      > "$H/Documents/work/invoices/invoice_${i}.csv"
  done
  rm -f "$H/Documents/work/invoices/_header.note"

  # a locked folder (permission puzzle, but realistic: "confidential")
  printf 'salary review notes - do not share\n' \
    > "$H/Documents/work/confidential/salaries.txt"
  chmod 000 "$H/Documents/work/confidential"

  printf 'Grandma pasta sauce: tomatoes, garlic, basil, olive oil.\n' \
    > "$H/Documents/personal/recipes/pasta.txt"
  printf 'Pancakes: flour, milk, egg, pinch of salt.\n' \
    > "$H/Documents/personal/recipes/pancakes.txt"
  printf 'Curry: onion, ginger, garlic, spices, coconut milk.\n' \
    > "$H/Documents/personal/recipes/curry.txt"

  printf 'month,spent\nJan,1200\nFeb,1100\nMar,1350\n' \
    > "$H/Documents/personal/budget_2024.csv"

  # the "I wrote my wifi password somewhere" needle (grep -r target)
  printf 'Router setup, 2022.\nSSID: home-net-5g\nwifi password: brave-otter-42\nForgot where I put this!\n' \
    > "$H/Documents/personal/misc/old_setup_notes.txt"
  printf 'random scribbles\nnothing important here\n' \
    > "$H/Documents/personal/misc/scratch.txt"

  # ---- Downloads -----------------------------------------------------------
  mkdir -p "$H/Downloads/photo_dump"
  # 50 (empty) photos -- count target; empties so they are NOT the biggest file
  for i in $(seq -w 1 50); do : > "$H/Downloads/photo_dump/IMG_${i}.jpg"; done

  printf '#!/bin/bash\necho "pretend installer"\n' > "$H/Downloads/installer.sh"

  # misleading extension: a .bin that is really text
  printf 'I am plain readable text, despite the .bin extension.\n' \
    > "$H/Downloads/notes.bin"

  # the clearly-largest file in Downloads (~2000 lines of CSV)
  {
    printf 'row,value\n'
    for i in $(seq 1 2000); do printf '%d,%d\n' "$i" "$(( (i * 31) % 1000 ))"; done
  } > "$H/Downloads/big_dataset.csv"

  printf 'just some junk I downloaded and never opened\n' \
    > "$H/Downloads/random_notes.txt"

  # an archive to unpack
  local tmp; tmp="$(mktemp -d)"
  mkdir -p "$tmp/holiday_pics"
  printf 'beach.jpg placeholder\n'    > "$tmp/holiday_pics/beach.txt"
  printf 'mountains.jpg placeholder\n'> "$tmp/holiday_pics/mountains.txt"
  printf 'readme: photos from the trip\n' > "$tmp/holiday_pics/README.txt"
  tar czf "$H/Downloads/holiday_pics.tar.gz" -C "$tmp" holiday_pics
  rm -rf "$tmp"

  # ---- Pictures / Music / Videos (light, for realism) ----------------------
  mkdir -p "$H/Pictures/vacation_2023" "$H/Pictures/screenshots"
  : > "$H/Pictures/wallpaper.png"
  : > "$H/Pictures/vacation_2023/sunset.jpg"
  : > "$H/Pictures/vacation_2023/dinner.jpg"
  : > "$H/Pictures/screenshots/screenshot_01.png"
  : > "$H/Pictures/screenshots/screenshot_02.png"
  : > "$H/Music/playlist.m3u"
  : > "$H/Videos/clip.mp4"

  # ---- Projects ------------------------------------------------------------
  mkdir -p "$H/Projects/website/js" "$H/Projects/scripts" \
           "$H/Projects/c_demo" "$H/Projects/data_analysis/results"

  printf '<!doctype html>\n<html><head><title>My site</title></head>\n<body><h1>Hello</h1></body></html>\n' \
    > "$H/Projects/website/index.html"
  printf 'body { font-family: sans-serif; }\n' > "$H/Projects/website/style.css"
  printf 'console.log("hi");\n' > "$H/Projects/website/js/app.js"
  printf '# My website\nA tiny static site.\n' > "$H/Projects/website/README.md"

  # two scripts that are NOT executable yet (the chmod lesson)
  cat > "$H/Projects/scripts/backup.sh" <<'EOF'
#!/bin/bash
echo "Backup started..."
echo "Backup finished. Secret check-word: PANGOLIN"
EOF
  cat > "$H/Projects/scripts/cleanup.sh" <<'EOF'
#!/bin/bash
echo "Nothing to clean today."
EOF
  chmod 644 "$H/Projects/scripts/backup.sh" "$H/Projects/scripts/cleanup.sh"

  # C source to compile (writes to stdout AND stderr)
  cat > "$H/Projects/c_demo/hello.c" <<'EOF'
#include <stdio.h>
int main(void) {
    printf("Program ran: hello from C\n");
    fprintf(stderr, "(this line is a diagnostic on stderr)\n");
    return 0;
}
EOF

  printf 'name,score\nada,91\nlin,88\nalan,95\ngrace,99\n' \
    > "$H/Projects/data_analysis/data.csv"
  printf 'import csv  # placeholder analysis script\n' \
    > "$H/Projects/data_analysis/analysis.py"

  # ---- logs ----------------------------------------------------------------
  generate_server_log > "$H/logs/server.log"
  printf 'install ok\nall packages configured\n' > "$H/logs/install.log"

  # ---- a hidden file (ls -a needle) ----------------------------------------
  printf 'reminder to self: the spare key is under the third plant pot.\n' \
    > "$H/.local_notes"

  # ---- the on-machine guidance + task list ---------------------------------
  write_desktop_notes

  say "Your practice computer is ready in: $H"
  say "Tell the student to start by reading the note on the Desktop:"
  say "    cat ~/Desktop/START_HERE.txt"
}

# ---- deterministic noisy server log ----------------------------------------
generate_server_log() {
  local ips=(10.0.0.1 10.0.0.2 10.0.0.3 192.168.1.5 172.16.0.9)
  local i ip lvl t
  for i in $(seq 1 2000); do
    t=$(( i * 7 ))
    if (( i % 3 == 0 )); then ip="10.0.0.1"; else ip="${ips[$(( i % 5 ))]}"; fi
    if   (( i % 17 == 0 )); then lvl="ERROR"
    elif (( i % 5  == 0 )); then lvl="WARN"
    else                        lvl="INFO"; fi
    printf '2026-06-15 %02d:%02d:%02d %s %s request handled\n' \
      $(( (t/3600) % 24 )) $(( (t/60) % 60 )) $(( t % 60 )) "$lvl" "$ip"
  done
}

# ---- desktop note + task list (lives on the machine for SSH-only students) -
write_desktop_notes() {
  cat > "$H/Desktop/START_HERE.txt" <<'EOF'
========================================================================
 Welcome - this is your practice computer
========================================================================
You're working on a Linux machine. This home directory is set up like an
ordinary computer: Documents, Downloads, Pictures, Projects, and so on.

YOUR JOB
  Work through the tasks in:   cat ~/Desktop/tasks.txt
  The tasks describe a GOAL ("find the biggest file in Downloads"). They do
  NOT tell you which command to use. Figuring that out is the whole point.

HOW TO FIGURE OUT A COMMAND YOU DON'T KNOW
  * Search the manuals by keyword:   apropos size      (or: man -k size)
  * Read a command's manual:         man du
  * One-line description:            whatis du
  * Inside man: scroll with arrows/space, search with /word, quit with q.

DOCUMENT EVERYTHING (this is graded)
  Keep a logbook (see ~/Desktop/worksheet.txt). For every task write down:
    1. what the goal was,
    2. which command(s) you tried,
    3. the command that worked,
    4. one thing you learned (often from the man page).

Start now:   cat ~/Desktop/tasks.txt
========================================================================
EOF

  cat > "$H/Desktop/tasks.txt" <<'EOF'
PRACTICAL TASKS  -  figure out the command yourself, then write it down.
(There is almost always more than one valid way. Use man / apropos freely.)

--- Getting your bearings ---
 1. Confirm exactly where you are in the filesystem.
 2. List everything in your home directory, INCLUDING hidden items. There is a
    hidden file here - what does it say?
 3. Get a bird's-eye view of the whole Documents folder and its sub-folders at
    once (a visual tree, not one ls at a time).

--- Finding things ---
 4. How many photos are in Downloads/photo_dump? Do not count them by eye.
 5. Which single file in Downloads is the largest?
 6. Find every .csv file anywhere in your home directory. How many are there?
 7. You once saved your home wifi password in a file somewhere under Documents,
    but you can't remember which file. Find the file and the password.
 8. You have a C source file called hello.c somewhere in Projects but forgot
    which sub-folder. Find its full path.
 9. You want to know the total size on disk of your Downloads folder, but you
    don't know which command does that. Find a suitable command (search the
    manuals by keyword), then use it.

--- Looking inside files ---
10. Show only the FIRST 3 lines of your todo list, then only the LAST 3 lines.
11. How many lines and words are in Documents/work/meeting_notes.txt?
12. Downloads/notes.bin has a .bin name. What type of file is it REALLY?
13. Look at the raw bytes of Documents/personal/recipes/pasta.txt. Which byte
    value (in hex) appears most often, and what character is it?

--- Tidying up your computer ---
14. Create a new folder Documents/work/2024 and move all four quarterly report
    files into it (in as few commands as you can).
15. Make a backup copy of Documents/personal/budget_2024.csv called
    budget_2024.bak in the same folder, keeping the original.
16. Delete the junk file Downloads/random_notes.txt. Then remove the (now
    empty) Pictures/screenshots folder after deleting what's in it.
17. Leave yourself a note: create a file note.txt on your Desktop containing the
    single line "remember to submit homework" - using ONE command.

--- Text & log analysis ---
18. logs/server.log is thousands of lines long. How many ERROR entries are in it?
19. Which IP address appears the most in logs/server.log?
20. Produce a top-3 list of the IP addresses responsible for the most ERROR
    lines, with the count next to each. (You'll need to chain several commands.)
21. From Documents/work/invoices/invoice_001.csv, pull out ONLY the amount column.
22. Make an alphabetically sorted list of your recipe names (the filenames in
    Documents/personal/recipes), with no duplicates.

--- Permissions, scripts, building ---
23. The script Projects/scripts/backup.sh refuses to run. Work out why, fix it,
    run it, and report the secret check-word it prints.
24. You cannot open the folder Documents/work/confidential at all. Find out why
    from its listing, give yourself just enough access, then read what's inside.
25. Unpack the archive Downloads/holiday_pics.tar.gz and list what was inside it.
26. Turn Projects/c_demo/hello.c into a runnable program and run it. Then run it
    again so that its normal output goes into one file and its error/diagnostic
    output goes into a separate file. Confirm which line ended up where.
EOF

  cat > "$H/Desktop/worksheet.txt" <<'EOF'
LOGBOOK  -  fill one block in per task. Be honest about what you tried.

Task #: ____
Goal (in my own words): ______________________________________________
Commands I tried:        ______________________________________________
The command that worked: ______________________________________________
What I learned (man page / why it works): ____________________________
-----------------------------------------------------------------------
(repeat for each task)
EOF
}

# =============================================================================
#  INSTRUCTOR ANSWER KEY (computed live from the generated files)
# =============================================================================
print_solutions() {
  already_populated || { MODE="build"; build_home; }

  hdr "PRACTICE COMPUTER - INSTRUCTOR ANSWER KEY"
  say "Home: $H   (numbers computed live, so they match what the student sees)"

  hdr "Getting your bearings"
  say "1. pwd                                  -> their home path ($H)"
  say "2. ls -a  (or ls -la)                   -> hidden .local_notes: 'spare key under the third plant pot'"
  say "3. tree Documents  (or ls -R Documents) -> the Documents tree"

  hdr "Finding things"
  printf '4. ls Downloads/photo_dump | wc -l       -> %s photos\n' \
    "$(ls "$H/Downloads/photo_dump" | wc -l | tr -d ' ')"
  printf '5. ls -lS Downloads | head  (or du -a Downloads | sort -n) -> %s\n' \
    "$(ls -S "$H/Downloads" -p | grep -v / | head -n1)"
  printf '6. find ~ -name "*.csv"  (then | wc -l) -> %s csv files\n' \
    "$(find "$H" -name '*.csv' 2>/dev/null | wc -l | tr -d ' ')"
  printf '7. grep -r -i "password" ~/Documents     -> %s\n' \
    "$(grep -rl -i 'wifi password' "$H/Documents" 2>/dev/null | sed "s|$H/||")"
  say   "   password = brave-otter-42"
  printf '8. find ~/Projects -name hello.c          -> %s\n' \
    "$(find "$H/Projects" -name hello.c 2>/dev/null | sed "s|$H/||")"
  say   "9. apropos size / man -k 'disk usage' -> du ;  then  du -sh ~/Downloads"

  hdr "Looking inside files"
  say "10. head -n 3 Documents/todo.txt ; tail -n 3 Documents/todo.txt"
  printf '11. wc Documents/work/meeting_notes.txt   -> lines=%s words=%s\n' \
    "$(wc -l < "$H/Documents/work/meeting_notes.txt")" \
    "$(wc -w < "$H/Documents/work/meeting_notes.txt")"
  say "12. file Downloads/notes.bin             -> ASCII text (NOT binary)"
  local pb pc
  pb="$(hexdump -v -e '/1 "%02x\n"' "$H/Documents/personal/recipes/pasta.txt" | sort | uniq -c | sort -rn | head -n1 | awk '{print $2}')"
  pc="$(printf '%b' "\\x$pb")"
  printf '13. hexdump -C pasta.txt                  -> most common byte 0x%s (the character "%s")\n' "$pb" "$pc"

  hdr "Tidying up"
  say "14. mkdir Documents/work/2024 ; mv Documents/work/reports/report_q*.txt Documents/work/2024/"
  say "15. cp Documents/personal/budget_2024.csv Documents/personal/budget_2024.bak"
  say "16. rm Downloads/random_notes.txt ; rm Pictures/screenshots/* ; rmdir Pictures/screenshots"
  say "17. echo 'remember to submit homework' > ~/Desktop/note.txt"

  hdr "Text & log analysis"
  printf '18. grep -c " ERROR " logs/server.log     -> %s ERROR lines\n' \
    "$(grep -c ' ERROR ' "$H/logs/server.log")"
  printf '19. cut -d" " -f4 logs/server.log | sort | uniq -c | sort -rn | head -1 -> %s\n' \
    "$(cut -d' ' -f4 "$H/logs/server.log" | sort | uniq -c | sort -rn | head -n1 | awk '{print $2" ("$1")"}')"
  say "20. grep ' ERROR ' logs/server.log | cut -d' ' -f4 | sort | uniq -c | sort -rn | head -3 :"
  grep ' ERROR ' "$H/logs/server.log" | cut -d' ' -f4 | sort | uniq -c | sort -rn | head -n3 | sed 's/^/      /'
  printf '21. cut -d, -f3 invoice_001.csv          -> header "amount" then %s\n' \
    "$(cut -d, -f3 "$H/Documents/work/invoices/invoice_01.csv" | tail -n1)"
  say "22. ls Documents/personal/recipes | sort | uniq  -> curry.txt, pancakes.txt, pasta.txt"

  hdr "Permissions, scripts, building"
  say "23. chmod u+x Projects/scripts/backup.sh ; ./backup.sh  -> check-word PANGOLIN"
  say "24. ls -l Documents/work (confidential has no rwx) ; chmod u+rx Documents/work/confidential ; cat .../salaries.txt"
  say "25. tar xzf Downloads/holiday_pics.tar.gz ; ls holiday_pics  -> beach.txt, mountains.txt, README.txt"
  say "26. gcc -o hello Projects/c_demo/hello.c ; ./hello ; ./hello > out.txt 2> err.txt"
  say "    out.txt = 'Program ran: hello from C' ; err.txt = '(this line is a diagnostic on stderr)'"
  say ""
}

# =============================================================================
#  MAIN
# =============================================================================
case "$MODE" in
  check)     check_deps ;;
  solutions) check_deps; print_solutions ;;
  reset)     check_deps; build_home ;;
  build)     check_deps; build_home ;;
esac
