# TOLH — Command-Line Practice Computer

This repository spins up a free, browser-based Linux machine (via **GitHub
Codespaces**) whose home directory is set up like an ordinary computer —
`Documents`, `Downloads`, `Pictures`, `Projects`, `logs` — full of realistic
files. You practise real command-line skills by working through a set of
goal-based tasks.

No installation, no payment, nothing on your own machine.

## How to start (student)

1. Click the green **`< > Code`** button on this repo → **Codespaces** tab →
   **Create codespace on main**.
2. Wait ~1 minute while it builds your computer (the first time only).
3. When the terminal appears, type:

   ```bash
   cd ~
   cat Desktop/START_HERE.txt
   ```

4. Then open the task list and begin:

   ```bash
   cat Desktop/tasks.txt
   ```

> The files you see in the editor sidebar (this README, the script, etc.) are
> just the repo. **Your "computer" lives in the terminal** — everything you need
> is under your home directory (`cd ~`).

## What's here (for the instructor)

| File | Purpose |
|------|---------|
| `setup_computer.sh` | Builds the realistic home directory (deterministic; `--reset` to rebuild, `--solutions` for the answer key). |
| `.devcontainer/devcontainer.json` | Tells Codespaces to install the tools and run the setup script automatically. |
| `TASKS.md` | The 26 goal-based tasks (same text the student gets in `~/Desktop/tasks.txt`). |
| `WORKSHEET.md` | Logbook template for documenting each task. |
| `KNOWLEDGE_QUESTIONS.md` / `KNOWLEDGE_ANSWERS.md` | The written theory assignment (includes a light, conceptual SSH section). |
| `INSTRUCTOR_GUIDE.md` | How to deploy, run a session, and the full practical answer key. |

Free tier: every personal GitHub account gets 120 core-hours/month (60 hours on
a 2-core machine) and 15 GB storage — no credit card. Each student uses their
own free quota.
