;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This configuration is guile based.
;;   http://www.gnu.org/software/guile/guile.html
;; any functions that work in guile will work here.
;; see EXTRA FUNCTIONS:

;; Version: 1.8.2

;; If you edit this file, do not forget to uncomment any lines
;; that you change.
;; The semicolon(;) symbol may be used anywhere for comments.

;; To specify a key, you can use 'xbindkeys --key' or
;; 'xbindkeys --multikey' and put one of the two lines in this file.

;; A list of keys is in /usr/include/X11/keysym.h and in
;; /usr/include/X11/keysymdef.h
;; The XK_ is not needed.

;; List of modifier:
;;   Release, Control, Shift, Mod1 (Alt), Mod2 (NumLock),
;;   Mod3 (CapsLock), Mod4, Mod5 (Scroll).


;; The release modifier is not a standard X modifier, but you can
;; use it if you want to catch release instead of press events

;; By defaults, xbindkeys does not pay attention to modifiers
;; NumLock, CapsLock and ScrollLock.
;; Uncomment the lines below if you want to use them.
;; To dissable them, call the functions with #f


;;;;EXTRA FUNCTIONS: Enable numlock, scrolllock or capslock usage
;;(set-numlock! #t)
;;(set-scrolllock! #t)
;;(set-capslock! #t)

;;;;; Scheme API reference
;;;;
;; Optional modifier state:
;; (set-numlock! #f or #t)
;; (set-scrolllock! #f or #t)
;; (set-capslock! #f or #t)
;; 
;; Shell command key:
;; (xbindkey key "foo-bar-command [args]")
;; (xbindkey '(modifier* key) "foo-bar-command [args]")
;; 
;; Scheme function key:
;; (xbindkey-function key function-name-or-lambda-function)
;; (xbindkey-function '(modifier* key) function-name-or-lambda-function)
;; 
;; Other functions:
;; (remove-xbindkey key)
;; (run-command "foo-bar-command [args]")
;; (grab-all-keys)
;; (ungrab-all-keys)
;; (remove-all-keys)
;; (debug)


(xbindkey '(control shift q) "xbindkeys_show")

;; set directly keycode (here control + f with my keyboard)
;;(xbindkey '("m:0x4" "c:41") "xterm")

;; specify a mouse button
;;(xbindkey '(control "b:2") "xterm")

;;(xbindkey '(shift mod2 alt s) "xterm -geom 50x20+20+20")

;; set directly keycode (control+alt+mod2 + f with my keyboard)
;;(xbindkey '(alt "m:4" mod2 "c:0x29") "xterm")

;; Control+Shift+a  release event starts rxvt
;;(xbindkey '(release control shift a) "rxvt")

;; Control + mouse button 2 release event starts rxvt
;;(xbindkey '(releace control "b:2") "rxvt")

;; (define (macroplay e)
;; 	(run-command "echo \"e\" | xmacroplay "))
 

(xbindkey '(Alt F1)   "t")
(xbindkey '(mod4 F1)   "t")
(xbindkey '(Alt Return)   "t")
(xbindkey '(Alt Help) "$XTERM")
(xbindkey '(Alt Mod4 F1) "$XTERM")

(xbindkey '(Help) "$XTERM -e dtach -A /tmp/dt-scratch -r winch dvtm")

;;; Agenda/TODO
;;(xbindkey '(Shift Help) "urxvt -e emacsclient -nw -e \"(org-agenda)\"")
(xbindkey '(mod4 o) "urxvt -e emacsclient -nw ~/org/")

;;; Run dialog
(xbindkey '(Alt F2) "drun -f")
(xbindkey '(Alt XF86MonBrightnessDown) "drun -f")
(xbindkey '(mod4 r) "drun -f")

(xbindkey '(Alt Escape) "t top")


;;; Volume control
(xbindkey '(XF86AudioLowerVolume) "vol.sh -7")
(xbindkey '(XF86AudioRaiseVolume) "vol.sh +5")
(xbindkey '(XF86AudioMute) "vol.sh mute")

(xbindkey '(mod4 minus) "vol.sh -7")
(xbindkey '(mod4 plus) "vol.sh +5")



;;; Screenshotting
(xbindkey '(Print) "scrot 'screenshot-%m%d-%H%M(%S).png'")
(xbindkey '(Shift Print) "scrot -s 'screenshot-%m%d-%H%M(%S).png'")
(xbindkey '(mod4 Print) "tmp=$(mktemp --suffix=.png) && scrot $tmp && gimp $tmp")
(xbindkey '(Shift mod4 Print) "tmp=$(mktemp --suffix=.png) && scrot -s $tmp && gimp $tmp")

;;; Music player control
;; (xbindkey '(XF86AudioPlay) "nyxmms2 toggle")
;; (xbindkey '(XF86AudioStop) "nyxmms2 stop")
;; (xbindkey '(XF86AudioPrev) "nyxmms2 prev")
;; (xbindkey '(XF86AudioNext) "nyxmms2 next")

;; (xbindkey '(Alt XF86AudioPlay) "dxmms2 coll")
;; (xbindkey '(Alt XF86AudioPrev) "dxmms2 list")

(xbindkey '(XF86AudioPlay)           "cplay"    )
(xbindkey '(XF86AudioStop)           "cplay -s" )
(xbindkey '(XF86AudioPrev)           "cplay --prev" )
(xbindkey '(XF86AudioNext)           "cplay --next" )
(xbindkey '(Alt XF86AudioPlay)       "cplay --load-pl" )
(xbindkey '(Shift Alt XF86AudioPlay) "cplay --save-pl" )


;;; Run
(xbindkey '(mod4 R) "dmenu_run")


;;; Suspend key (requires visudo permisions)
(xbindkey '(Shift mod4 XF86AudioStop) "gksudo pm-suspend")

;;; ASCII-art insertion
(xbindkey '(Shift mod4 i) "dmenu_ascii")

;; Record and execute xmacros
(xbindkey '(control mod4 r) "xmacrorec2 -k 9 > $XDG_CACHE_HOME/xmacro; notify-send 'xmacro stopped' \"exit code: $?\"")
(xbindkey '(control mod4 e) "echo 'Delay 500' | cat - \"$XDG_CACHE_HOME/xmacro\" | xmacroplay -s 0.7")
(xbindkey '(control mod4 k) 
	  "pkill turboclick.sh || turboclick.sh 10")
(xbindkey '(control mod4 l) "keylog.sh")

;;; Multi Display management
;;(xbindkey '(control XF86SplitScreen) "multihead || xrandr --output VGA1 -s 0  --primary --output LVDS1 --auto -s 0  --left-of VGA1")
(xbindkey '(control F4) "multihead || xrandr --output VGA1 -s 0  --primary --output LVDS1 --auto -s 0  --left-of VGA1")
(xbindkey '(Shift F4) "xrandr --auto")

;; Rotation
(xbindkey '(Control Mod4 Left)  "xrandr --output LVDS1 --rotate left")
(xbindkey '(Control Mod4 Right) "xrandr --output LVDS1 --rotate right")
(xbindkey '(Control Mod4 Up)    "xrandr --output LVDS1 --rotate inverted")
(xbindkey '(Control Mod4 Down)  "xrandr --output LVDS1 --rotate normal")

;; Unmount all the media devices
(xbindkey '(Control mod4 u) "xumount")

;; (xbindkey '(control a)
;;                     "decho KeyStr Home | xmacroplay ")
;; (xbindkey '(control e)
;;                     "echo KeyStr End | xmacroplay ")


(define (keypress-cmd xkeysym)
  (string-append "echo -e \"KeyStrRelease Control_L\nKeyStr " xkeysym "\nKeyStrPress Control_L\" | xmacroplay" ))

(xbindkey '(Control mod4 j)
	  (keypress-cmd "Page_Down"))
(xbindkey '(Control mod4 k)
	  (keypress-cmd "Page_Up"))

(xbindkey '(mod4 k)
	  "echo KeyStr End | xmacroplay ")
;; "echo KeyStr Begin | xmacroplay ")


				   
;; ;; ;; Double click test
;; ;; (xbindkey-function '(control w)
;; ;;                    (let ((count 0))
;; ;;                      (lambda ()
;; ;;                        (set! count (+ count 1))
;; ;;                        (if (> count 1)
;; ;;                            (begin
;; ;;                             (set! count 0)
;; ;;                             (run-command "xterm"))))))

;; ;; ;; Time double click test:
;; ;; ;;  - short double click -> run an xterm
;; ;; ;;  - long  double click -> run an rxvt
;; ;; (xbindkey-function '(shift w)
;; ;;                    (let ((time (current-time))
;; ;;                          (count 0))
;; ;;                      (lambda ()
;; ;;                        (set! count (+ count 1))
;; ;;                        (if (> count 1)
;; ;;                            (begin
;; ;;                             (if (< (- (current-time) time) 1)
;; ;;                                 (run-command "xterm")
;; ;;                                 (run-command "rxvt"))
;; ;;                             (set! count 0)))
;; ;;                        (set! time (current-time)))))


;; ;; ;; Chording keys test: Start differents program if only one key is
;; ;; ;; pressed or another if two keys are pressed.
;; ;; ;; If key1 is pressed start cmd-k1
;; ;; ;; If key2 is pressed start cmd-k2
;; ;; ;; If both are pressed start cmd-k1-k2 or cmd-k2-k1 following the
;; ;; ;;   release order
;; ;; (define (define-chord-keys key1 key2 cmd-k1 cmd-k2 cmd-k1-k2 cmd-k2-k1)
;; ;;     "Define chording keys"
;; ;;   (let ((k1 #f) (k2 #f))
;; ;;     (xbindkey-function key1 (lambda () (set! k1 #t)))
;; ;;     (xbindkey-function key2 (lambda () (set! k2 #t)))
;; ;;     (xbindkey-function (cons 'release key1)
;; ;;                        (lambda ()
;; ;;                          (if (and k1 k2)
;; ;;                              (run-command cmd-k1-k2)
;; ;;                              (if k1 (run-command cmd-k1)))
;; ;;                          (set! k1 #f) (set! k2 #f)))
;; ;;     (xbindkey-function (cons 'release key2)
;; ;;                        (lambda ()
;; ;;                          (if (and k1 k2)
;; ;;                              (run-command cmd-k2-k1)
;; ;;                              (if k2 (run-command cmd-k2)))
;; ;;                          (set! k1 #f) (set! k2 #f)))))


;; ;; ;; Example:
;; ;; ;;   Shift + b:1                   start an xterm
;; ;; ;;   Shift + b:3                   start an rxvt
;; ;; ;;   Shift + b:1 then Shift + b:3  start gv
;; ;; ;;   Shift + b:3 then Shift + b:1  start xpdf

;; ;; (define-chord-keys '(shift "b:1") '(shift "b:3")
;; ;;   "xterm" "rxvt" "gv" "xpdf")

;; ;; ;; Here the release order have no importance
;; ;; ;; (the same program is started in both case)
;; ;; (define-chord-keys '(alt "b:1") '(alt "b:3")
;; ;;   "gv" "xpdf" "xterm" "xterm")


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; End of xbindkeys guile configuration ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
