# LSP Keybindings Reference

This document explains every LSP-related keybinding configured in `init.lua`, grouped by category.

## Navigation

| Key | Function | Description |
|-----|----------|-------------|
| `gd` | `vim.lsp.buf.definition` | Jumps straight to where a function, variable, or class is **defined**. Place the cursor on `my_function()` and press `gd` to jump to `def my_function():`. |
| `gD` | `vim.lsp.buf.declaration` | Similar to `gd`, but goes to the **declaration** instead of the definition. In Python there's usually no difference, but in C/C++ this is key: it takes you to the `.h` file (declaration) instead of the `.c` file (implementation). |
| `gri` | `vim.lsp.buf.implementation` | Useful with interfaces/abstract classes. If you have an `Animal` interface with a `make_sound()` method, this shows **all classes that implement it** (`Dog`, `Cat`, etc.), not the interface itself. |
| `grt` | `vim.lsp.buf.type_definition` | Jumps to the definition of a variable's **type**, not the variable itself. Example: with `let x: User = ...`, placing the cursor on `x` takes you to where the `User` class/type is defined. |

## Symbols

| Key | Function | Description |
|-----|----------|-------------|
| `grr` | `vim.lsp.buf.references` | Shows **every place in the project** where the symbol under the cursor is used/referenced. On a variable `total`, it lists every line where `total` is used (not just where it's defined). |
| `gO` | `vim.lsp.buf.document_symbol` | Shows an index of **all symbols in the current file** (functions, classes, top-level variables) in a quickfix-style window. Like a file "table of contents" for quick jumping between functions. |
| `<leader>ws` | `vim.lsp.buf.workspace_symbol` | Same as above, but searches **the whole project**, not just the open file. Prompts you for a name and shows where it's defined across any file in the workspace. |

## Call Hierarchy

| Key | Function | Description |
|-----|----------|-------------|
| `grc` | `vim.lsp.buf.incoming_calls` | "Who calls me?" — On a function, shows **every function that calls it** across the project. Useful for understanding the impact of modifying that function. |
| `gro` | `vim.lsp.buf.outgoing_calls` | The opposite: "Who do I call?" — On a function, shows **every function it calls internally**. Useful for quickly understanding what something does without reading the whole body. |

## Actions

| Key | Function | Description |
|-----|----------|-------------|
| `grn` | `vim.lsp.buf.rename` | Renames a symbol **across the entire project**, not just the current file. Rename `total` to `total_sum` once and the LSP updates every usage in every file automatically. |
| `gra` (normal/visual) | `vim.lsp.buf.code_action` | Opens a menu of **automatic fixes/suggestions** the LSP detects on that line: importing a missing module, extracting a variable, converting to an arrow function, wrapping in try/catch, etc. Content varies by language and detected error/warning. Also mapped in visual mode, since sometimes you select multiple lines to request a refactor on that block. |
| `grx` | `vim.lsp.codelens.run` | Runs a "code lens" — those small annotations that sometimes appear above a function (e.g. "▶ Run test" or "3 references"). This executes the action tied to that annotation if the cursor is on that line. |
| `<leader>f` | `vim.lsp.buf.format` | Formats the whole file using the formatting rules configured in the LSP (e.g. `black` for Python via pyright, `prettier`-style for TS). Note: not every LSP server supports formatting; some need a separate external formatter. |

## Docs / Hints

| Key | Function | Description |
|-----|----------|-------------|
| `K` | `vim.lsp.buf.hover` | Shows **documentation** for whatever is under the cursor in a floating window: function signature, docstring, variable type, etc. This is Vim's traditional "help" key, repurposed by the LSP. |
| `<C-s>` (insert mode) | `vim.lsp.buf.signature_help` | While typing inside a function's parentheses, shows a tooltip with the **expected parameters** and which one you're currently filling in. Similar to VS Code's IntelliSense when opening a parenthesis. |

## Inlay Hints

| Key | Function | Description |
|-----|----------|-------------|
| `<leader>th` | toggle `vim.lsp.inlay_hint` | Inlay hints are gray annotations that appear *inside* the code without you writing them — e.g. next to a parameter it shows its name (`foo(name: "John")`) or next to a variable it shows its inferred type. This toggles them on/off, since they can sometimes clutter the code visually. |

## Diagnostics

| Key | Function | Description |
|-----|----------|-------------|
| `]d` / `[d` | `vim.diagnostic.goto_next` / `goto_prev` | Jumps to the **next / previous error or warning** in the current file, without scrolling to hunt for them manually. |
| `<leader>e` | `vim.diagnostic.open_float()` | Opens a floating window with the **full text of the error/warning** on the current line. Useful because the sign column only shows an icon or underline, not the full error message. |
| `<leader>D` | `open_float` with `scope = 'cursor'` | Like the above, but more precise: if there are **multiple diagnostics on the same line**, this shows specifically the one right under the cursor, instead of all of them mixed together. |
| `<leader>q` | `vim.diagnostic.setloclist()` | Sends **all diagnostics in the file** to Vim's location list (`:lopen` to view it) — a navigable list of all errors/warnings, useful for reviewing an entire file at once. |
| `<leader>td` | toggle `vim.diagnostic.enable` | Turns diagnostic display **completely** on or off (red/yellow underlines, sign column icons). Useful when writing half-finished code and the constant red underline is distracting. |
