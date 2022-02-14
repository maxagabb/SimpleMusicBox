--Pipe directory path or url into script
--example: open current video in browser to check out related music

require "mp.msg"

local function pipeToMenu(path)
    mp.commandv("run", "dmenuhandler", path);
end

function dmusic()
  path = mp.get_property("path")
  pipeToMenu(path)
end

mp.add_key_binding("Ctrl+Shift+d", "dmusic", dmusic)
