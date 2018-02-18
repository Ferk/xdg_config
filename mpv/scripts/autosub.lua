-- requires subliminal, version 1.0 or newer
-- default keybinding: b
-- add the following to your input.conf to change the default keybinding:
-- keyname script_binding auto_load_subs
local utils = require 'mp.utils'
function load_sub_fn()
    subl = "subliminal" -- the program must be in PATH
    mp.msg.info("Searching subtitle")
    mp.osd_message("Searching subtitle")
    t = {}
    t.args = {subl, "download", "-l", "en", mp.get_property("path")}
    res = utils.subprocess(t)
    if res.status == 0 then
	local last_line = res.stdout
        mp.msg.info("autosub suceeded: " .. res.stdout)
        mp.commandv("rescan_external_files", "reselect")
        mp.osd_message("Subtitle available" )
    else
        mp.msg.warn("Subtitle download failed")
        mp.osd_message("Subtitle download failed")
    end
end

mp.add_key_binding("b", "auto_load_subs", load_sub_fn)