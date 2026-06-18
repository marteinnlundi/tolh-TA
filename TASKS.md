# TOLH — Practical Command-Line Tasks (Student Handout)

You are working on a **practice computer** you reach over SSH. Its home directory
is set up like an ordinary machine — `Documents`, `Downloads`, `Pictures`,
`Projects`, `logs`, and so on, all full of real-looking files.

These tasks describe a **goal**. They do **not** tell you which command to use —
working that out is the point. There is almost always more than one valid way.

## How to find a command you don't know
- Search the manuals by keyword: `apropos size` or `man -k "disk usage"`
- Read a command's manual: `man du`
- One-line description: `whatis du`
- Inside `man`: scroll with arrows/space, search with `/word`, quit with `q`,
  press `h` for help on the reader itself.

## Document everything (this is the graded part)
For **every** task, write in your worksheet:
1. the goal in your own words,
2. the command(s) you tried,
3. the command that finally worked,
4. one thing you learned (usually from the man page).

---

## Getting your bearings
1. Confirm exactly where you are in the filesystem.
2. List everything in your home directory, **including hidden items**. There is a
   hidden file here — what does it say?
3. Get a bird's-eye view of the whole `Documents` folder and its sub-folders at
   once (a visual tree, not one `ls` at a time).

## Finding things
4. How many photos are in `Downloads/photo_dump`? Do not count them by eye.
5. Which single file in `Downloads` is the **largest**?
6. Find every `.csv` file anywhere in your home directory. How many are there?
7. You once saved your home wifi password in a file somewhere under `Documents`
   but can't remember which file. Find the file and the password.
8. You have a C source file `hello.c` somewhere in `Projects` but forgot which
   sub-folder. Find its full path.
9. You want the total size on disk of your `Downloads` folder but don't know
   which command does that. Find a suitable command (search the manuals by
   keyword), then use it.

## Looking inside files
10. Show only the **first 3** lines of your todo list, then only the **last 3**.
11. How many lines and words are in `Documents/work/meeting_notes.txt`?
12. `Downloads/notes.bin` has a `.bin` name. What type of file is it **really**?
13. Look at the raw bytes of `Documents/personal/recipes/pasta.txt`. Which byte
    value (in hex) appears most often, and what character is it?

## Tidying up your computer
14. Create `Documents/work/2024` and move all four quarterly report files into
    it, in as few commands as you can.
15. Make a backup copy of `Documents/personal/budget_2024.csv` called
    `budget_2024.bak` in the same folder, keeping the original.
16. Delete the junk file `Downloads/random_notes.txt`. Then delete the contents
    of `Pictures/screenshots` and remove the now-empty folder.
17. Leave yourself a note: create `note.txt` on your Desktop containing the
    single line `remember to submit homework`, using **one** command.

## Text & log analysis
18. `logs/server.log` is thousands of lines long. How many `ERROR` entries are
    in it?
19. Which IP address appears the most in `logs/server.log`?
20. Produce a **top-3** list of the IP addresses responsible for the most
    `ERROR` lines, with the count next to each. (Chain several commands.)
21. From `Documents/work/invoices/invoice_001.csv`, pull out **only** the amount
    column.
22. Make an alphabetically sorted, duplicate-free list of your recipe names (the
    filenames in `Documents/personal/recipes`).

## Permissions, scripts, building
23. `Projects/scripts/backup.sh` refuses to run. Work out why, fix it, run it,
    and report the secret check-word it prints.
24. You cannot open the folder `Documents/work/confidential` at all. Find out
    why from its listing, give yourself just enough access, then read what's
    inside.
25. Unpack the archive `Downloads/holiday_pics.tar.gz` and list what was inside.
26. Turn `Projects/c_demo/hello.c` into a runnable program and run it. Then run
    it again so that its normal output goes into one file and its
    error/diagnostic output goes into a **separate** file. Confirm which line
    ended up where.
