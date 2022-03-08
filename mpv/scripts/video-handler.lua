--Pipe directory path or url into script
--example: open current video in browser to check out related music

require "mp.msg"

local function pipeToScript(command)
	path = mp.get_property("path")
	mp.commandv("run", command, path);
end

function dmusic()
  pipeToScript("dmenuhandler")
end

function handle()
  pipeToScript("linkhandler")
end

mp.add_key_binding("Ctrl+d", "dmusic", dmusic)
mp.add_key_binding("Ctrl+o", "handle", handle)
