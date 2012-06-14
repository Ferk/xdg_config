;;
;; Emacs Configuration File
;;
;; Author: Fernando Carmona Varo <ferkiwi@gmail.com>
;; URL: https://github.com/Ferk/xdg_config/raw/master/HOME/.emacs.d/init.el

;; Replace the annoying "yes or no" questions to a single keystroke "y or n"
(defalias 'yes-or-no-p 'y-or-n-p)

;; Disable over-write mode! Never good! Pain in the posterior!
(put 'overwrite-mode 'disabled t)

;;;;; Hooks!
;; Visual lines
(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'visual-line-mode)
;; But truncated for dired
(add-hook 'dired-mode-hook 
	  (lambda () (setq truncate-lines t)))
;; auto update the pdf when regenerated
(add-hook 'doc-view-mode-hook 'auto-revert-mode)
;; Add all org files from desired dir as agendas
(add-hook 'org-load-hook 
	  (lambda () (setq org-agenda-files (file-expand-wildcards "~/org/*.org"))))
;; When no makefile, just compile it with "make -k $file"
(add-hook 'c-mode-hook
          (lambda ()
	    (unless (or (file-exists-p "makefile")
			(file-exists-p "Makefile"))
	      (set (make-local-variable 'compile-command)
		   (concat "make -k "
			   (file-name-sans-extension buffer-file-name))))))
;; highlighting for preprocessor
(add-hook 'c-mode-hook
	  (lambda () (cpp-highlight-buffer t)))
;; outline mode for folding code, will be used for every font-locked mode
(add-hook 'c-mode-hook 'outline-minor-mode)
(add-hook 'shell-script-mode-hook 'outline-minor-mode)
;; electric indent mode
(add-hook 'c-mode-hook 'electric-indent-mode)
(add-hook 'shell-script-mode-hook 'electric-indent-mode)

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
         ("\\.jl$"            . sawfish-mode)
         ("\\.po$\\|\\.po\\." . po-mode)
         ("/[Mm]akefile\\." . makefile-mode)
         ("/crontab" . crontab-mode)
         ) auto-mode-alist))
(modify-coding-system-alist 'file "\\.po$\\|\\.po\\."
                            'po-find-file-coding-system)


(defun show-sublevel ()
  "Progressivelly unfolds the current level. First showing the childs and then the whole subtree if the command is issued a second time."
  (interactive)
  (if (eq last-command this-command)
      (show-subtree)
    (or (show-entry) (show-children))))

(add-hook 'outline-minor-mode-hook
	  (lambda ()
	    (local-set-key [S-M-left] 'hide-subtree)
	    (local-set-key [S-M-right] 'show-sublevel)
	    (local-set-key [S-M-up] 'outline-previous-visible-heading)
	    (local-set-key [S-M-down] 'outline-next-visible-heading)
	    ))


(defun shell-command-general (command arg)
  "Run a shell command passing the text of the region (if
selected) to it. Ant then replace the region with the output of the command (if no argument was passed to this function)."
  (interactive (list (read-from-minibuffer "Shell command: " nil nil nil 'shell-command-history)
                     current-prefix-arg))
  (let ((begin (if mark-active (region-beginning) 0))
        (end (if mark-active (region-end) 0)))
    (if (= begin end)
        ;; No active region
	(shell-command command arg)
      ;; Active region
      (if (eq arg nil)
          (shell-command-on-region begin end command t t)
        (shell-command-on-region begin end command)))))
(global-set-key [f3] 'shell-command-general)

(defun uniq-lines ()
  "Searches for duplicated lines in region (or whole buffer if no
mark active) and deletes them."
  (interactive)
  (let ((begin (if mark-active (region-beginning) (point-min)))
        (end (if mark-active (region-end) (point-max)))
	(count 0)
	)
    (save-excursion
      (save-restriction
	(narrow-to-region begin end)
	(goto-char (point-min))
	(while (not (eobp))
	  (kill-line 1)
	  (yank)
	  (let ((next-line (point)))
	    (while
		(re-search-forward
		 (format "^%s" (regexp-quote (car kill-ring))) nil t)
	      (replace-match "" nil nil)
	      (setq count (+ count 1)))
	    (goto-char next-line)))))
    (princ (format "%d duplicated lines found" count))))

;;; indent buffer
;;;###autoload
(defun indent-whole-buffer ()
  "Indent the whole buffer"
  (interactive)
  (indent-region (point-min) (point-max) nil)
  (delete-trailing-whitespace)
  (untabify (point-min) (point-max)))

(defalias 'iwb 'indent-whole-buffer)
(define-key global-map
  [menu-bar edit indent] '("Indent the whole buffer" . indent-whole-buffer))

;; Compilation
(define-key global-map
  "\C-cc" 'compile)

;;; eTAGS
(defun create-tags (dir-name langs)
  "Create/update tags file and load it silently."
  (interactive "DDirectory: \nsLanguages to tag from (none for default): ")
  (or langs (setq langs "Make,Java,Lua,Lisp,C,C++,PHP"))
  (setq langmap "c:.c.h")
  (and
   (shell-command
    ;;(format "ctags -f %s/TAGS -e -R %s" dir-name (directory-file-name dir-name))
    (concat "cd " dir-name " && ctags -eR --langmap=" langmap
	    (and langs (concat " --languages=" langs))))
   ;;(format "cd %s && ctags -eR --languages=\"%s\"" dir-name langs))
   (let ((tags-revert-without-query t))  ; don't query, revert silently
     (visit-tags-table dir-name nil))))

(defadvice find-tag (around refresh-tags activate)
  "Rerun etags and reload tags if tag not found and redo find-tag.
   If buffer is modified, ask about save before running etags."
  (let ((extension (file-name-extension (buffer-file-name))))
    (condition-case err
        ad-do-it
      (error (and (buffer-modified-p)
                  (not (ding))
                  (y-or-n-p "Buffer is modified, save it? ")
                  (save-buffer))
             ;;(create-tags "." (concat "*." extension))
             ad-do-it))))

;;; Use the C-w Unix tty behaviour of deleting word backward
(defadvice kill-region (before unix-werase activate compile)
  "When called interactively with no active region, delete a single word
    backwards instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (save-excursion (backward-word 1) (point)) (point)))))

;;; autocompile
(add-hook 'after-save-hook 'autocompile)
;;;###autoload
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


;;;;
;; (defadvice barf-if-buffer-read-only (before ask-rooting-if-non-writable activate)
;;   (and buffer-read-only
;;        (not (file-writable-p (buffer-file-name)))
;;        (y-or-n-p "No permissions, switch to root?")
;;        (open-as-root)))
;;;; (barf-if-buffer-read-only)
;;;;;
;;(add-hook 'before-save-hook 'switch-to-root)
(defun open-as-root ()
  "Using tramp, switches to editting the current file as root."
  (interactive)
   (set-visited-file-name
    (concat "/sudo::" (buffer-file-name)))
   ;;(and (file-writable-p (buffer-file-name))
	 (setq buffer-read-only nil));)


(defun smart-comint-up ()
   "Implement the behaviour of the up arrow key in comint mode.  At
the end of buffer, do comint-previous-input, otherwise just move in
the buffer."
   (interactive)
   (if (= (point) (point-max))
       (comint-previous-input 1)
     (previous-line 1)))

(defun smart-comint-down ()
   "Implement the behaviour of the down arrow key in comint mode.  At
the end of buffer, do comint-next-input, otherwise just move in the
buffer."
   (interactive)
     (if (= (point) (point-max))
	(comint-next-input 1)
       (forward-line 1)))

(eval-after-load "gud"
  '(progn 
     (define-key gud-mode-map (kbd "<up>") 'smart-comint-up)
     (define-key gud-mode-map (kbd "<down>") 'smart-comint-down)))

;;;;;;;;;;;
(global-set-key (kbd "<M-gr>") (quote rgrep))
;;(global-set-key "\347r" (quote rgrep))


;; (add-to-list 'load-path "~/.emacs.d/evil")
;; (require 'evil)
;; (evil-mode 1)

;; -------------------
;;;;;;;;;;;;;;;;;;;;;;
;;; Customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("." . "/home/ferk/.emacs.d/backups/"))))
 '(clean-buffer-list-delay-special 900)
 '(column-number-mode t)
 '(comint-input-ignoredups t)
 '(comint-prompt-read-only t)
 '(comint-scroll-to-bottom-on-input (quote this))
 '(compilation-auto-jump-to-first-error t)
 '(compilation-scroll-output (quote first-error))
 '(compilation-skip-threshold 2)
 '(compilation-window-height 6)
 '(completion-ignored-extensions (quote (".o" ".elc" ".class" "java~" ".ps" ".abs" ".mx" ".~jv" ".elf" ".bin")))
 '(cpp-edit-list (quote (("1" default font-lock-comment-face t) ("0" font-lock-comment-face default both))))
 '(cpp-known-face (quote default))
 '(cpp-unknown-face (quote default))
 '(custom-enabled-themes (quote (darkclean)))
 '(custom-safe-themes (quote ("1346451da65eb33475f56746e55feefd8f1bd29b5375e93ba869153140ec9ec5" "7dccd51c91b656df5726f71c2c04531546a48453cd9a349762acba993d6db83f" "f2bdbc41e575d67b0714de86f6b7105393bcd0198a941f719084171af6d9d67f" "5d3d4c3438b34957498b590cbacade51506c05d4f49aba6c0a79d202c9d06da9" "83656b96bbb718461906b39ba7c11e2beb9d268b" "d49ce0533a835b784afbda9d0c27445537dec93d" default)))
 '(custom-theme-directory "~/.emacs.d/themes/")
 '(dired-auto-revert-buffer (quote dired-directory-changed-p))
 '(dired-guess-shell-alist-user (quote (("\\.\\(gz\\|bz2\\|lzma\\|\\tar\\|zip\\|rar\\)" "unp -U" "xdg-open") ("." "xdg-open"))))
 '(dired-isearch-filenames (quote dwim))
 '(dired-listing-switches "-alhG --time-style=iso")
 '(eshell-visual-commands (quote ("vi" "screen" "top" "less" "more" "lynx" "ncftp" "pine" "tin" "trn" "elm" "alsamixer" "wicd-curses")))
 '(gdb-show-main t)
 '(global-hl-line-mode t)
 '(global-semantic-idle-completions-mode t nil (semantic/idle))
 '(global-semantic-idle-scheduler-mode t nil (semantic/idle))
 '(global-semantic-idle-summary-mode t)
 '(global-semanticdb-minor-mode t)
 '(grep-command "grep . -nHIr -e ")
 '(grep-scroll-output t)
 '(ido-enable-flex-matching t)
 '(ido-everywhere t)
 '(ido-max-work-directory-list 64)
 '(ido-max-work-file-list 64)
 '(ido-mode (quote both) nil (ido))
 '(ido-use-virtual-buffers t)
 '(indicate-buffer-boundaries (quote left))
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(iswitchb-buffer-ignore (quote ("^ " "^*Messages" "^*Completions")))
 '(iswitchb-use-virtual-buffers t nil (recentf))
 '(kill-do-not-save-duplicates t)
 '(make-backup-files nil)
 '(mark-even-if-inactive t)
 '(menu-bar-mode nil)
 '(midnight-delay 1800)
 '(midnight-mode t nil (midnight))
 '(mouse-avoidance-mode (quote animate) nil (avoid))
 '(org-agenda-files (quote ("~/org/home.org" "~/org/work.org")))
 '(org-mode-hook nil t)
 '(org-src-fontify-natively t)
 '(org-startup-with-inline-images t)
 '(outline-regexp "\\([*^L]+\\|.*{{{\\|.*#{\\)")
 '(package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/") ("elpa" . "http://tromey.com/elpa/") ("marmalade" . "http://marmalade-repo.org/packages/"))))
 '(recentf-auto-cleanup (quote never))
 '(recentf-max-saved-items 128)
 '(recentf-mode t)
 '(recentf-save-file "~/.cache/emacs/recentf")
 '(require-final-newline t)
 '(savehist-mode t nil (savehist))
 '(scroll-bar-mode (quote right))
 '(semantic-mode t)
 '(show-paren-delay 0.125)
 '(show-paren-mode t)
 '(show-paren-ring-bell-on-mismatch nil)
 '(show-paren-style (quote expression))
 '(size-indication-mode t)
 '(speedbar-directory-button-trim-method (quote trim))
 '(tags-case-fold-search nil)
 '(tags-revert-without-query t)
 '(tool-bar-mode nil)
 '(tooltip-delay 0.4)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify) "distinguish duplicate filenames renaming the buffers to contain part of the path")
 '(vc-follow-symlinks t)
 '(visible-bell t)
 '(x-select-enable-clipboard t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#080808" :foreground "#FFF" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 105 :width normal :foundry "unknown" :family "Droid Sans Mono")))))
