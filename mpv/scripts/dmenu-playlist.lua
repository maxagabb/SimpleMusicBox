-- Bound to F8 by default.

local mp = require 'mp'

local opts = {
  music_osc = ""
}

(require 'mp.options').read_options(opts, "dmenu-playlist")

local function exec(args, stdin)
  local command = {
    name = "subprocess",
    playback_only = false,
    capture_stdout = true,
    detach = false,
    args = args,
  }
  if stdin then command.stdin_data = stdin end
  local ret = mp.command_native(command)
  return ret.stdout
end

local function choose_prefix(i)
  if i == mp.get_property_number('playlist-pos', 0) then
    return "● "
  else
    return "○ "
  end
end

local function show_menu()
  local playlist = mp.get_property_native('playlist')
  local choiceTable = {}

  for i = 1, #playlist do
    local title = playlist[i].title
    if (title == nil) then
      title = playlist[i].filename:match("^.+/(.+)$")
    end
    choiceTable[i] = choose_prefix(i - 1) .. title .. "\n"
  end

  local choices = table.concat(choiceTable)
  local command = {
    "dmenu-dwm",
    "-b",
    "-i",
    "-l",
    "40",
    "-p",
    "___   Search in playlist: "
  }
  local choice = exec(command, choices)
  mp.osd_message(choice:sub(4))

  local selected = -3
  for k, v in pairs(choiceTable) do
    if v == choice then
      selected = k - 1
      break
    end
  end

  if (selected == -3) then
    return
  end

  mp.commandv("playlist-play-index", selected)
end

mp.commandv("script-message", "osc-visibility", "never", "no-osd")
if opts.music_osc ~= "" then
  local ov = mp.create_osd_overlay('ass-events')
  ov.data = [[{\an5\p1\alpha&FF\1c&H0000&\3a&Hff}]] ..
      [[m30 15 b37 8 112 8 117 15 b125 22 125 75 118 82 b112 89 38 89 30 82 b23 75 23 22 30 15 m76 108]] ..
      [[{\alpha&H79\1c&Hffffff&\3a&Hff} m-45 -25 l 2 2 l -45 28{\p0}]]
  mp.observe_property("pause", "bool", function(_, paused)
    if paused then ov:update()
    else ov:remove() end
  end)
end


-- keybind to launch menu
mp.add_key_binding("F8", "dmenu-playlist", show_menu)
