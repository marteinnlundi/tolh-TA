# TOLH — Weeks 1 & 2 — Written Knowledge Assignment

*This is the **theory** companion to the hands-on lab. Answer in your own words.
Short answers are fine; the goal is to show you understand the **ideas**, not to
copy definitions. You may use `man`, the cheat sheet and the slides.*

---

## A. The machine and the operating system

**1.** In one sentence each, name the two things this course focuses on inside the
computer, and say what each is broadly for.

**2.** The OS kernel is responsible for managing the machine's resources. List
**three** distinct jobs the kernel does.

**3.** What is a *driver*, and why does the OS need them?

---

## B. Shells, GUI vs TUI, and connecting remotely

**4.** A shell is "just a program." In your own words, what does that program
actually do when you press Enter?

**5.** Give one practical reason you might *have* to use the command line (TUI)
even when a graphical interface (GUI) exists.

**6.** What shell does Skel use by default, and what is the most common shell on
Linux generally?

**7.** State the UNIX philosophy in one sentence.

**8.** When you run a command inside an SSH session, **where** does the command
actually execute, and **what** is sent back to your screen?

**9.** Windows and Linux disagree about how to end a line of text. Write the
newline sequence each one uses, and explain why this can cause problems when
moving text files between them.

---

## C. Anatomy of a command

**10.** Write the general shape of a command using the three labelled parts
(command, options, arguments).

**11.** Are commands case-sensitive? Give a one-word answer.

**12.** Explain the difference between an **option/flag** (e.g. `-l`) and an
**argument** (e.g. a filename), using `ls -l /etc` as your example.

**13.** What is the difference between single quotes `'...'` and the use of a
wildcard like `*` on the command line?

---

## D. The filesystem: paths and `$PATH`

**14.** Define **absolute path** and **relative path**, and give one example of each.

**15.** What do each of these refer to?
`.`  ,  `..`  ,  `../..`  ,  `~`  ,  `cd -`

**16.** Explain the `$PATH` environment variable in one sentence.

**17.** You compiled a program called `ttt`. You type `ttt` and the shell says
"command not found", even though the file is right there in your current folder.
Why? Write the command that runs it anyway.

---

## E. Files, streams, redirection and pipes

**18.** Linux says "everything is a file." Give two examples of things that are
*not* normal documents but still appear as files.

**19.** What is a **symbolic link**, and which command creates one?

**20.** Name the three standard streams and their numbers (0, 1, 2).

**21.** What does each of these do?
`> file`  ,  `2> file`  ,  `&> file`  ,  `< file`

**22.** Explain what the pipe `|` does in `cat file.txt | wc`.

**23.** `stderr` is kept separate from normal output. Give one reason a program
would deliberately send something to `stderr` instead of `stdout`.

---

## F. Permissions and scripts

**24.** Permissions have three *who* groups and three *rights*. Name all six
(letters are fine).

**25.** Decode this listing into who-can-do-what: `-rwxr-x r--` (owner / group / other).

**26.** Write the chmod **octal** number that means `rwxr-xr-x`. Show your working
(r=4, w=2, x=1).

**27.** What must be true about a `.sh` file before you can run it with
`./script.sh`, and which command sets that?

**28.** What is the **shebang**, and write the exact first line of a bash script.

**29.** In a script, what do `$1` and `$2` mean?

**30.** What does `$?` hold, and what value means "the last command succeeded"?

---

## G. Compiling C

**31.** Write the command that compiles `example.c` into a runnable program
called `example`.

**32.** Put the compilation stages in order:
*Linked executable, Assembly (.s), Source (.c), Object code (.o).*

---

## H. Data representation (binary, hex, ASCII)

**33.** How many bits are in a byte, and how many bytes does one ASCII character
take?

**34.** Why is hexadecimal convenient for showing binary data? (Hint: how many
bits does one hex digit represent?)

**35.** Convert the decimal number **78** to 8-bit binary. (Use the subtraction
or modulo-2 method and show your steps.)

**36.** Convert the binary number **0010 1010** to decimal.

**37.** The byte `0x41` is the ASCII code for which character? And `0x61`?

**38.** A text file looks empty on screen but `wc -c` says it is 14 bytes. If a
`hexdump` shows the byte `0x0a` repeated, what character is that and why would it
dominate a mostly-blank file?

---

## I. Knowing your tools (which command does what?)

For each description, name the single command that fits.

**39.** Print the path of the directory you are currently in.
**40.** Show the **first** 10 lines of a file.
**41.** Show the **last** 10 lines of a file.
**42.** Count lines, words and bytes in a file.
**43.** Search for a text pattern inside files.
**44.** Cut out a specific column/field from each line of text.
**45.** Replace one character with another across a stream of text.
**46.** Display a directory and its contents as an indented tree.
**47.** Bundle several files into one archive (and the flags to extract a gzipped one).
**48.** Read the manual page for a command, and the one-liner alternative.
