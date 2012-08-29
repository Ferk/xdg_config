


----------------------------------------------------------------------
-- hooks
----------------------------------------------------------------------

pre_format_html_hooks = {n=0}
function pre_format_html_hook (url, html)
    local changed = nil

    table.foreachi(pre_format_html_hooks,
                   function (i, fn)
                       local new,stop = fn(url,html)

                       if new then html=new changed=1 end
                       return stop
                   end)

   return changed and html
end

goto_url_hooks = {n=0}
function goto_url_hook (url, current_url)
    table.foreachi(goto_url_hooks,
                   function (i, fn)
                       local new,stop = fn(url, current_url)

                       url = new

                       return stop
                   end)

   return url
end

follow_url_hooks = {n=0}
function follow_url_hook (url)
    table.foreachi(follow_url_hooks,
                   function (i, fn)
                       local new,stop = fn(url)

                       url = new

                       return stop
                   end)

   return url
end

quit_hooks = {n=0}
function quit_hook (url, html)
    table.foreachi(quit_hooks, function (i, fn) return fn() end)
end


----------------------------------------------------------------------
--  case-insensitive string.gsub
----------------------------------------------------------------------

-- Please note that this is not completely correct yet.
-- It will not handle pattern classes like %a properly.
-- FIXME: Handle pattern classes.

function gisub (s, pat, repl, n)
    pat = string.gsub (pat, '(%a)',
                function (v) return '['..string.upper(v)..string.lower(v)..']' end)
    if n then
        return string.gsub (s, pat, repl, n)
    else
        return string.gsub (s, pat, repl)
    end
end


----------------------------------------------------------------------
--  goto_url_hook
----------------------------------------------------------------------

function match (prefix, url)
    return string.sub (url, 1, string.len (prefix)) == prefix
end

function hx (c)
    return string.char((c >= 10 and (c - 10) + string.byte ('A')) or c + string.byte ('0'))
end

function char2hex (c)
    return '%'..hx (string.byte (c) / 16)..hx (math.mod(string.byte (c), 16))
end

function escape (str)
    return string.gsub (str, "(%W)", char2hex)
end

-- Expand ~ to home directories.
function expand_tilde (url, current_url)
    if not match ("~", url) then return url,nil end

    if string.sub(url, 2, 2) == "/" or string.len(url) == 1 then    -- ~/foo
        return home_dir..string.sub(url, 2),true
    else                                -- ~foo/bar
        return "/home/"..string.sub(url, 2),true
    end
end
table.insert(goto_url_hooks, expand_tilde)


-- Don't take localhost as directory name
function expand_localhost (url)
    if not match("localhost", url) then return url,nil end

    return "http://"..url,nil
end
table.insert(goto_url_hooks, expand_localhost)


----------------------------------------------------------------------
--  follow_url_hook
----------------------------------------------------------------------

-- Plain string.find (no metacharacters).
function sstrfind (s, pattern)
    return string.find (s, pattern, 1, 1)
end

-- open youtube videos in mplayer (using youtube-dl) instead
function open_youtube_dl (url)
    if not sstrfind(url, "youtube.com/watch") then return url end
    
    --execute( string.gsub( get_option("document.uri_passing.youtube-dl"), '%c', "'"..url.."'" ) )
    execute(' mplayer -cache 512 $(youtube-dl --max-quality 5 -g "'..url..'") >/dev/null 2>&1 ')
    return nil
end
table.insert(follow_url_hooks, open_youtube_dl)


----------------------------------------------------------------------
--  pre_format_html_hook
----------------------------------------------------------------------

-- Mangle ALT="" in IMG tags.
function mangle_blank_alt (url, html)
    local n

    if not mangle_blank_alt then return nil,nil end

    html, n = gisub (html, '(<img[^>]-) alt=""', '%1 alt="&nbsp;"')

    return ((n > 0) and html), nil
end
table.insert(pre_format_html_hooks, mangle_blank_alt)


-- Fix unclosed INPUT tags.
function mangle_unclosed_input_tags (url, html)
    local n

    html, n = gisub (html, '(<input[^>]-[^=]")<', '%1><')

    return ((n > 0) and html), nil
end
table.insert(pre_format_html_hooks, mangle_unclosed_input_tags)


-- Fix unclosed A tags.
function mangle_unclosed_a_tags (url, html)
    local n

    html, n = gisub (html, '(<a[^>]-[^=]")<', '%1><')

    return ((n > 0) and html), nil
end
table.insert(pre_format_html_hooks, mangle_unclosed_a_tags)

-- http://lua-users.org/wiki/PatternsTutorial
function mangle_reddit (url, html)
   if not sstrfind (url, "reddit.com") then return nil,nil end

   -- we will use display: none
   set_option ("document.css.ignore_display_none", false)

   -- html = string.gsub (html, '</head>', '<link rel="stylesheet" type="text/css" href="file://'..elinks_home..'/reddit.css" /></head>',1)
   -- html = string.gsub (html, '</head>','<style type="text/css">#head, .side, .sharelink {display:none !important;}</style></head>',1)

   -- remove everything before the content
   html = string.gsub (html, '<body.-<div class="content', '<body><div class="content',1)

   if sstrfind (url, "comments") then
   else
      -- remove sharelink form
      html = string.gsub (html, '<form.-sharelink.-</form>', '',1)
   end

   -- remove the first spacer
   html = string.gsub (html, '<div class="spacer".-<div class="spacer"', '<div class="spacer"',1)

   return html,true
end
table.insert(pre_format_html_hooks, mangle_reddit)


function mangle_linuxtoday (url, html)
    if not sstrfind (url, "linuxtoday.com") then return nil,nil end

    if sstrfind (url, "news_story") then
        html = string.gsub (html, '<TABLE CELLSPACING="0".-</TABLE>', '', 1)
        html = string.gsub (html, '<TR BGCOLOR="#FFF.-</TR></TABLE>', '', 1)
    else
        html = string.gsub (html, 'WIDTH="120">\n<TR.+</TABLE></TD>', '>', 1)
    end
    html = string.gsub (html, '<A HREF="http://www.internet.com.-</A>', '')
    html = string.gsub (html, "<IFRAME.-</IFRAME>", "")
    -- emphasis in text is lost
    html = string.gsub (html, 'text="#002244"', 'text="#001133"', 1)

    return html,true
end
table.insert(pre_format_html_hooks, mangle_linuxtoday)


function mangle_dictionary_dot_com (url, html)
    local t = { t = "" }
    local n

    if not sstrfind (url, "dictionary.com/cgi-bin/dict.pl") then return nil,nil end

    _,n = string.gsub (html, "resultItemStart %-%-%>(.-)%<%!%-%- resultItemEnd",
                       function (x) t.t = t.t.."<tr><td>"..x.."</td></tr>" end)
    if n == 0 then
        -- we've already mangled this page before
        return nil,true
    end

    html = "<html><head><title>Dictionary.com lookup</title></head>"..
           "<body><table border=0 cellpadding=5>"..t.t.."</table>"..
           "</body></html>"

    return html,true
end
table.insert(pre_format_html_hooks, mangle_dictionary_dot_com)


function mangle_allmusic_dot_com (url, html)
    if not sstrfind (url, "allmusic.com") then return nil,nil end

    html = string.gsub(html, "javascript:z%('(.-)'%)", "/cg/amg.dll?p=amg&sql=%1")

    return html,true
end
table.insert(pre_format_html_hooks, mangle_allmusic_dot_com)


-- Handle gzip'd files within reasonable size.
-- Note that this is not needed anymore since we have a support for this
-- in core ELinks. I still keep it here for a reference (as an example),
-- though. If you will add something similiar using pipe_read(), feel free
-- to remove this. --pasky
function decompress_html (url, html)
    local tmp

    if not string.find (url, "%.gz$") or string.len (html) >= 65536 then
        return nil,nil
    end

    tmp = tmpname ()
    writeto (tmp) write (html) writeto ()
    html = pipe_read ("(gzip -dc "..tmp.." || cat "..tmp..") 2>/dev/null")
    os.remove (tmp)

    return html,nil
end
--table.insert(pre_format_html_hooks, decompress_html)

----------------------------------------------------------------------
--  Miscellaneous functions, accessed with the Lua Console.
----------------------------------------------------------------------

-- Reload this file (hooks.lua) from within Links.
function reload ()
    dofile (hooks_file)
end

-- Helper function.
function catto (output)
    local doc = current_document_formatted (79)
    if doc then writeto (output) write (doc) writeto () end
end

-- Email the current document, using Mutt (http://www.mutt.org).
-- This only works when called from lua_console_hook, below.
function mutt ()
    local tmp = tmpname ()
    writeto (tmp) write (current_document ()) writeto ()
    table.insert (tmp_files, tmp)
    return "run", "mutt -a "..tmp
end

-- Table of expressions which are recognised by our lua_console_hook.
console_hook_functions = {
    reload      = "reload ()",
    mutt        = mutt,
}

function lua_console_hook (expr)
    local x = console_hook_functions[expr]
    if type (x) == "function" then
        return x ()
    else
        return "eval", x or expr
    end
end


----------------------------------------------------------------------
--  quit_hook
----------------------------------------------------------------------

-- We need to delete the temporary files that we create.
if not tmp_files then
    tmp_files = {}
end

function delete_tmp_files ()
    if tmp_files and os.remove then
        tmp_files.n = nil
        for i,v in tmp_files do os.remove (v) end
    end
end
table.insert(quit_hooks, delete_tmp_files)


----------------------------------------------------------------------
--  Examples of keybinding
----------------------------------------------------------------------

-- Bind Ctrl-H to a "Home" page.

--    bind_key ("main", "Ctrl-H",
--            function () return "goto_url", "http://www.google.com/" end)

-- Bind Alt-p to print.

--    bind_key ("main", "Alt-p", lpr)

-- Bind Alt-m to toggle ALT="" mangling.

    bind_key ("main", "Alt-m",
              function () mangle_blank_alt = not mangle_blank_alt end)


-- vim: shiftwidth=4 softtabstop=4
