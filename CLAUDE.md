# Project O

## Structure
- `CONTENT/` — All project content lives here. This is the payload folder.
- `sync.sh` — Single sync script. Run `bash sync.sh` for full sync, or `push`/`pull`/`status`.
- `.gitignore` — Blocks `desktop.ini` and OS junk from ever entering the repo.

## Sync Commands (for Claude)
When the user says "sync", "push", or "pull":
```bash
cd "P:/My Drive/!@!/$//Projects/O" && bash sync.sh        # full sync
cd "P:/My Drive/!@!/$//Projects/O" && bash sync.sh push    # local → GitHub
cd "P:/My Drive/!@!/$//Projects/O" && bash sync.sh pull    # GitHub → local
cd "P:/My Drive/!@!/$//Projects/O" && bash sync.sh status  # check state
```

## Rules
- **Never** commit `desktop.ini` — Google Drive creates these constantly. The .gitignore and sync.sh both strip them.
- Keep commits atomic and auto-messaged via sync.sh.
- The GitHub remote is `https://github.com/wvvtcofounder/O.git` (private, shared).
