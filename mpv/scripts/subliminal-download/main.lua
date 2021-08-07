-- requires subliminal, version 1.0 or newer
-- default keybinding: b
-- add the following to your input.conf to change the default keybinding:
-- keyname script_binding sub-autodownload
local utils = require 'mp.utils'
function sub_autodownload_fn()
	local videodir, videoname = utils.split_path(mp.get_property("path"))
    mp.msg.info("Searching subtitle")
    mp.osd_message("Searching subtitle")
    t = {}
	t.args = {"python", mp.get_script_directory(), videoname, videodir, "eng"}
    res = utils.subprocess(t)
    if res.status == 0 then
	local last_line = res.stdout
        mp.msg.info("suceeded: " .. res.stdout)
        mp.osd_message("Subtitle Refresh")
        mp.commandv("rescan_external_files", "reselect")
    else
        mp.msg.warn("Subtitle download failed")
        mp.osd_message("Subtitle download failed")
    end
end

mp.add_key_binding("b", "sub-autodownload", sub_autodownload_fn)