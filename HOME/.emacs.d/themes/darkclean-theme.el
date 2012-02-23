;;; darkclean-theme.el --- Dark and clean theme

;; Copyright (C) 2009, 2010 Free Software Foundation, Inc.

;; Author: Fernando Carmona Varo <ferkiwi@gmail.com>
;; Created: 2009-08-12

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Simple theme with dark background colors. It has faces for hl-line,
;; whitespace and some other modes. Best seen at 16bit color depth or
;; higher (some background color transitions are tenuous and might be
;; too strong on low color depths). Created by Fernando Carmona Varo
;;
;;; Installation:
;;
;;   Drop the theme in the `custom-theme-load-path' (typically ~/.emacs.d/themes)
;;
;;; Code
(deftheme darkclean
  "Simple theme that makes use of dark background colors for some special modes (hl-line, whitespace, flymake). Best seen at 16-bit color depth or higher.")

(custom-theme-set-faces
 'darkclean
 '(default ((t (:foreground "#FFF" :background "#080808"))))
 '(bold ((t (:weight bold :bold t))))
 '(bold-italic ((t (:weight bold :slant italic :bold t :italic t))))
 '(mode-line ((t (:box (:line-width -1 :style released-button)
                                           :foreground "#000" :background "#AAA"))))
 '(mode-line-inactive ((t (:box (:line-width -1 :style pressed-button)
                                                  :foreground "#EEE" :background "#444"))))
 '(region ((t (:background "#004"))))
 '(show-paren-match ((t (:background "#330"))))
 '(show-paren-mismatch ((t (:background "#F00"))))
 '(font-lock-builtin-face ((t (:foreground "#ABE"))))
 '(font-lock-preprocessor-face ((t (:weight extra-bold :inherit (font-lock-builtin-face)))))
 '(font-lock-comment-face ((t (:foreground "#B9B"))))
 '(font-lock-comment-delimiter-face ((nil (:weight bold :foreground "#999"))))
 '(font-lock-constant-face ((t (:slant italic :foreground "#8EB"))))
 '(font-lock-doc-face ((t (:height 1.1 :slant italic :foreground "#BCD"))))
 '(font-lock-keyword-face ((t (:weight bold :foreground "#0FF"))))
 '(font-lock-string-face ((t (:slant italic :foreground "#FA8"))))
 '(font-lock-type-face ((t (:weight bold :foreground "#9B3"))))
 '(font-lock-variable-name-face ((t (:foreground "#FD7"))))
 '(font-lock-warning-face ((t (:weight bold :foreground "orange"))))
 '(font-lock-function-name-face ((t (:slant italic :foreground "#6CF"))))
 '(fringe ((t (:background "grey10"))))
 '(button ((t (:underline t :foreground "#7AD"))))
 '(link ((t (:underline t :foreground "#7CF"))))
 '(link-visited ((t (:underline t :foreground "#36A"))))
 '(isearch ((t (:foreground "#FFF" :background "#950"))))
 '(lazy-highlight ((t (:background "#640"))))
 '(hl-line ((t (:background "#000"))))
 '(trailing-whitespace ((t (:background "#100"))))
 '(whitespace-tab ((((class color) (background dark)) (:background "#111" :foreground "#222"))))
 '(whitespace-indentation ((t (:background "#111"))))
 '(whitespace-newline ((t (:foreground "#012" :weight normal))))
 '(whitespace-space-before-tab ((t (:background "#210"))))
 '(whitespace-space-after-tab ((t (:background "#210"))))
 '(whitespace-trailing ((t (:background "#100"))))
 '(flymake-warnline ((((class color) (background dark)) (:underline "#00F" :background "#004"))))
 '(flymake-errline ((((class color) (background dark)) (:underline "#F00" :background "#400"))))
 '(makefile-makepp-perl ((t (:background "#005"))))
 '(makefile-space ((t (:background "#301"))))
 )


;; (custom-theme-set-variables
;;  'darkclean
;;  ;; this theme is intended to be used with show-paren-match applied to the whole expresion
;;  '(show-paren-style 'expression)
;; )


(provide-theme 'darkclean)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; darkclean-theme.el ends here.
