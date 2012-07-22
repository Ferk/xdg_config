

set confirm off
#set prompt \033[37m(gdb) \033[0m
#set simprompt \033[37m<< \033[0m

set history filename ~/.cache/gdb.history
set history save on

set output-radix 0x10
set input-radix 0x10

# don't pause on long output
set height 0
# prevents line wrapping
set width 0


# ---- tools

define stack
    if $argc == 0
        info stack
    end
    if $argc == 1
        info stack $arg0
    end
    if $argc > 1
        help stack
    end
end
document stack
Print backtrace of the call stack, or innermost COUNT frames.
Usage: stack <COUNT>
end


define rr
  kill
  run
end
document rr
Reruns
end


define locals
  info locals
end
document locals
Show local variables
end


define ascii_char
    if $argc != 1
        help ascii_char
    else
        # thanks elaine :)
        set $_c = *(unsigned char *)($arg0)
        if ($_c < 0x20 || $_c > 0x7E)
            printf "."
        else
            printf "%c", $_c
        end
    end
end
document ascii_char
Print ASCII value of byte at address ADDR.
Print "." if the value is unprintable.
Usage: ascii_char ADDR
end

