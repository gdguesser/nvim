# Cheat Sheet

Leader is `<Space>`. tmux prefix is `C-Space`.
Neovim and tmux sections are generated from this repo and `~/.tmux.conf`.

## Neovim — find (telescope)

| Key | Action |
| --- | --- |
| `<leader>ff` | find files |
| `<leader>fg` | live grep |
| `<leader>fb` | buffers |
| `<leader>fo` | recent files |
| `<leader>fs` | document symbols |
| `<leader>fr` | LSP references |
| `<leader>fd` | diagnostics |
| `<leader>fh` | help tags |

In a picker: `C-j`/`C-k` move · `C-q` send results to quickfix.

## Neovim — files & buffers

| Key | Action |
| --- | --- |
| `<leader>e` | toggle file tree |
| `Tab` / `S-Tab` | next / previous buffer |
| `<leader>bd` | delete buffer |

In nvim-tree: `a` create (end name with `/` for a directory) · `d` delete · `r` rename · `x`/`p` cut/paste · `R` refresh.

## Neovim — run (toggleterm)

| Key | Action |
| --- | --- |
| `C-\` | toggle terminal |
| `<leader>rr` | run current file |
| `<leader>rp` | run project |
| `<leader>rt` | run tests (shell) |
| `<leader>rb` | build project |

Dispatches per filetype: Go, Java (maven/gradle), Python, JS, TS, Kotlin.
Leave terminal insert mode with `C-\ C-n`.

## Neovim — tests (neotest)

| Key | Action |
| --- | --- |
| `<leader>tn` | nearest test |
| `<leader>tf` | file tests |
| `<leader>tp` | package tests |
| `<leader>tl` | rerun last |
| `<leader>td` | debug nearest |
| `<leader>ts` | toggle summary |
| `<leader>to` | open output |

Only the `neotest-go` adapter is installed, so these are **Go-only**. For Java/TS/Python use `<leader>rt`.

## Neovim — LSP

| Key | Action |
| --- | --- |
| `gd` / `gD` | definition / declaration |
| `gi` / `gr` | implementation / references |
| `K` | hover docs |
| `<leader>ca` | code action |
| `<leader>rn` | rename symbol |
| `<leader>f` | format buffer |
| `<leader>d` | diagnostic float |
| `[d` / `]d` | previous / next diagnostic |
| `<leader>q` | diagnostics to loclist |

Go and Java format automatically on save. Servers: `gopls`, `ts_ls`, `eslint`, `jdtls`, `lua_ls`, `pyright` — check with `:Mason` / `:LspInfo`.

## Neovim — completion (insert mode)

| Key | Action |
| --- | --- |
| `C-Space` | trigger completion |
| `Tab` / `S-Tab` | next / previous item |
| `C-j` / `C-k` | next / previous item |
| `C-b` / `C-f` | scroll docs |
| `CR` | confirm |
| `C-e` | abort |

## Neovim — git (gitsigns)

No keymaps are bound; use commands:

```vim
:Gitsigns next_hunk | prev_hunk
:Gitsigns preview_hunk
:Gitsigns stage_hunk | undo_stage_hunk | reset_hunk
:Gitsigns blame_line
:Gitsigns diffthis
```

## Neovim — windows

| Key | Action |
| --- | --- |
| `C-w s` / `C-w v` | split horizontal / vertical |
| `C-w h/j/k/l` | move between splits |
| `C-w q` / `C-w o` | close this / close others |
| `C-w =` | equalize |

## tmux — panes & windows

Prefix is `C-Space`.

| Key | Action |
| --- | --- |
| `prefix "` | split vertical (keeps cwd) |
| `prefix %` | split horizontal (keeps cwd) |
| `prefix h/j/k/l` | select pane |
| `M-Left/Down/Up/Right` | select pane, no prefix |
| `prefix z` | zoom pane |
| `prefix x` | kill pane |
| `prefix c` | new window |
| `S-Left` / `S-Right` | previous / next window |
| `M-H` / `M-L` | previous / next window |
| `prefix ,` | rename window |
| `prefix d` | detach |

Mouse is on — click and drag to select panes and resize.

## tmux — copy mode (vi)

| Key | Action |
| --- | --- |
| `prefix [` | enter copy mode |
| `v` | begin selection |
| `C-v` | rectangle toggle |
| `y` | copy and exit |
| `q` | exit |

## tmux — sessions

```bash
tmux new -s name       # create named session
tmux a -t name         # attach
tmux ls                # list
prefix + $             # rename session
prefix + I             # install plugins (tpm)
prefix + r             # reload config, if bound
```

## Gotchas in the current setup

- **`C-Space` collides.** tmux eats it as the prefix, so completion-trigger inside tmux needs `C-Space C-Space`, or lean on `Tab`.
- **`<leader>f` is both a mapping and a prefix.** Format waits for the which-key timeout before firing, since `<leader>ff` etc. could still follow.
- **`vim-tmux-navigator` is only installed on the tmux side.** Seamless `C-h/j/k/l` between tmux panes and nvim splits needs the plugin in this repo too.

## Hyprland

Not verified — these are upstream defaults. Dump your real ones with `hyprctl binds`.

| Key | Action |
| --- | --- |
| `SUPER + Q` | close window |
| `SUPER + Return` | terminal |
| `SUPER + V` | toggle floating |
| `SUPER + F` | fullscreen |
| `SUPER + h/j/k/l` | focus window |
| `SUPER + SHIFT + h/j/k/l` | move window |
| `SUPER + 1..0` | switch workspace |
| `SUPER + SHIFT + 1..0` | send to workspace |
| `SUPER + mouse-left/right` | drag / resize |

```bash
hyprctl clients        # open windows with class + size
hyprctl binds          # real keybinds
hyprctl reload         # reload hyprland.conf
killall -SIGUSR2 waybar   # reload waybar
```
