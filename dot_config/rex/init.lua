-- Ghostty config `keybind = cmd+shift+p=text:\x10` (\x10 is ctrl+p)
rex.bind("shift+cmd+p", "pane.send_key", { key = "ctrl+p" })

-- ── Project layouts (replaces tmuxinator) ──
-- Layouts live in projects.lua next to this file, kept out of the public repo.
-- Each project becomes an action: `rex do <name>` or pick it in the command palette.
-- If the session already exists it is reused, like `tmuxinator start`.
local HOME = os.getenv("HOME")
local SHELL = "com.superlogical.terminal.shell"

local function open_project(p)
  local root = (p.root:gsub("^~", HOME))
  for _, s in ipairs(rex.call("session.list", {}).sessions or {}) do
    if s.label == p.name then
      pcall(rex.client.queue, "session.select", { session_id = s.session_id })  -- switch the app that ran it (no-op from the CLI)
      return { session_id = s.session_id, reused = true }
    end
  end
  local windows = {}
  for _, tab in ipairs(p.tabs) do
    windows[#windows + 1] = { window_label = tab, layout = { block = { flavor = SHELL, options = { cwd = root } } } }
  end
  local r = rex.call("session.create", { label = p.name, initial_windows = windows })
  rex.call("session.attach", { session_id = r.session_id })
  for i, tab in ipairs(p.tabs) do
    local cmd = p.run and p.run[tab]
    if cmd then
      -- typed into the shell (not run as the pane's program) so the shell survives when it exits
      rex.call("block.method", { session_id = r.session_id, block_id = r.initial_windows[i].block_ids[1], method = "write", args = { data = cmd .. "\r" } })
    end
  end
  rex.call("session.focus_window", { session_id = r.session_id, window_id = r.initial_windows[1].window_id })
  pcall(rex.client.queue, "session.select", { session_id = r.session_id })  -- switch the app that ran it (no-op from the CLI)
  return { session_id = r.session_id }
end

local ok, projects = pcall(dofile, HOME .. "/.config/rex/projects.lua")
if ok and type(projects) == "table" then
  for _, p in ipairs(projects) do
    rex.action{ name = (p.name:gsub("-", "_")), title = "Open " .. p.name, run = function() return open_project(p) end }
  end
end
