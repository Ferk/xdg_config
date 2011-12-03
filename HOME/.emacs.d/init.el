;;
;; Emacs Configuration File
;;
;; Author: Fernando Carmona Varo <ferkiwi@gmail.com>
;; URL: https://github.com/Ferk/xdg_config/raw/master/HOME/.emacs.d/init.el

;; Replace the annoying "yes or no" questions to a single keystroke "y or n"
(defalias 'yes-or-no-p 'y-or-n-p)

;; Disable over-write mode! Never good! Pain in the posterior!
(put 'overwrite-mode 'disabled t)

;; ;;; Hooks!
;; ;; Visual lines
;; (setq text-mode-hook 'visual-lines-mode)
;; (setq text-mode-hook 'visual-lines-mode)
;; (setq org-mode-hook 'visual-lines-mode)


;;;;Completion ignores filenames ending in any string in this list.
(setq completion-ignored-extensions
      '(".o" ".elc" ".class" "java~" ".ps" ".abs" ".mx" ".~jv" ))

;;; Set up which modes to use for which file extensions
(setq auto-mode-alist
      (append
       '(
         ("\\.h$"             . c++-mode)
         ("\\.dps$"           . pascal-mode)
         ("\\.py$"            . python-mode)
         ("\\.rpy$"            . python-mode)
         ("\\.Xdefaults$"     . xrdb-mode)
         ("\\.Xenvironment$"  . xrdb-mode)
         ("\\.Xresources$"    . xrdb-mode)
         ("\\.tei$"           . xml-mode)
         ("\\.php$"           . php-mode)
         ("\\.clp$"           . clips-mode)
         ("\\.scm$"           . scheme-mode)
         ("\\.jl$"            . sawfish-mode)
         ("\\.org$"           . org-mode)
         ("\\.po$\\|\\.po\\." . po-mode)
         ("crontab" . crontab-mode)
         ) auto-mode-alist))
(modify-coding-system-alist 'file "\\.po$\\|\\.po\\."
                            'po-find-file-coding-system)


;;; indent buffer
;;;###autoload
(defun iwb ()
  "Indent Whole Buffer"
  (interactive)
  (indent-region (point-min) (point-max) nil)
  (delete-trailing-whitespace)
  (untabify (point-min) (point-max)))

(define-key global-map
  [menu-bar edit indent] '("IndentWholeBuffer" . iwb))

;; Compilation
(define-key global-map
  "\C-cc" 'compile)


(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (eshell-command
   (format "ctags -f %s/TAGS -e -R %s" dir-name (directory-file-name dir-name))))
;;(format "cd %s && ctags -eR **/*.c **/*.h" dir-name)))

  ;;;  Jonas.Jarnestrom<at>ki.ericsson.se A smarter
  ;;;  find-tag that automagically reruns etags when it cant find a
  ;;;  requested item and then makes a new try to locate it.
  ;;;  Fri Mar 15 09:52:14 2002
(defadvice find-tag (around refresh-etags activate)
  "Rerun etags and reload tags if tag not found and redo find-tag.
   If buffer is modified, ask about save before running etags."
  (let ((extension (file-name-extension (buffer-file-name))))
    (condition-case err
        ad-do-it
      (error (and (buffer-modified-p)
                  (not (ding))
                  (y-or-n-p "Buffer is modified, save it? ")
                  (save-buffer))
             (er-refresh-etags extension)
             ad-do-it))))
(defun er-refresh-etags (&optional extension)
  "Run etags on all peer files in current dir and reload them silently."
  (interactive)
  (shell-command (format "etags *.%s" (or extension "el")))
  (let ((tags-revert-without-query t))  ; don't query, revert silently
    (visit-tags-table default-directory nil)))


;;; autocompile
;;;###autoload
(add-hook 'after-save-hook 'autocompile)
(defun autocompile ()
  "Byte-compile the current file if it matchs ~/.emacs*.el
This is useful for making sure you didn't make some stupid mistake when
configuring, and also it will make emacs load faster."
  (interactive)
  (require 'bytecomp)
  (if
      (string-match (concat (getenv "HOME") "/\.emacs.*\.el")
                    (buffer-file-name))
      (byte-compile-file (buffer-file-name))))

;; -------------------
;;;;;;;;;;;;;;;;;;;;;;
;;; Customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-auto-jump-to-first-error t)
 '(compilation-scroll-output (quote first-error))
 '(compilation-window-height 6)
 '(compile-command "./compile.sh ")
 '(custom-enabled-themes (quote (darkclean org-latex)))
 '(custom-safe-themes (quote ("ffcc44b41cc03939626bab40704da970b0808457" "92c66e7bff9f22321904fa0484735700e45c70cf" "b3300a249ec04671c04e8cdef1c292c704ed75b4" default)))
 '(custom-theme-directory "~/.emacs.d/themes/")
 '(gdb-many-windows t)
 '(global-hl-line-mode t)
 '(global-semantic-idle-completions-mode t nil (semantic/idle))
 '(global-semantic-idle-scheduler-mode t)
 '(global-semantic-idle-summary-mode t)
 '(global-semanticdb-minor-mode t)
 '(gud-gdb-command-name "_/gdb.sh main.elf -i=mi")
 '(indicate-buffer-boundaries (quote left))
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(iswitchb-buffer-ignore (quote ("^ " "^*Messages" "^*Completions")))
 '(iswitchb-mode t)
 '(iswitchb-use-virtual-buffers t nil (recentf))
 '(make-backup-files nil)
 '(make-pointer-invisible t)
 '(mouse-avoidance-mode (quote animate) nil (avoid))
 '(org-mode-hook nil)
 '(package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/") ("elpa" . "http://tromey.com/elpa/")  ("marmalade" . "http://marmalade-repo.org/packages/"))))
 '(recentf-max-menu-items 32)
 '(recentf-mode t)
 '(require-final-newline t)
 '(semantic-mode t)
 '(show-paren-delay 0.125)
 '(show-paren-mode t)
 '(show-paren-ring-bell-on-mismatch t)
 '(show-paren-style (quote expression))
 '(tool-bar-mode nil)
 '(tooltip-delay 0.4)
 '(visible-bell t)
 '(x-select-enable-clipboard t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
