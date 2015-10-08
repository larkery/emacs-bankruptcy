;;; quasi-monochrome-theme.el --- High contrast quasi monochrome color theme

;; Copyright (C) 2015 Lorenzo Bolla

;; Author: Lorenzo Bolla <lbolla@gmail.com>
;; URL: https://github.com/lbolla/emacs-quasi-monochrome
;; Package-Version: 20150801.1325
;; Created: 28th July 2015
;; Version: 1.0
;; Keywords: color-theme, monochrome, high contrast

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation, either version 3 of the License,
;; or (at your option) any later version.

;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A high contrast quasi-monochrome color theme.

;;; Code:

(deftheme quasi-monochrome-hinton
  "quasi-monochrome emacs theme")

;; (custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

 ;; '(compilation-error ((t (:inherit nil))))
 ;; '(cursor ((t (:background "white"))))
 ;; '(ido-match-modes-indicator-face ((t (:foreground "dark gray" :width condensed))))
 ;; '(ido-vertical-common-match-face ((t (:foreground "dark gray" :slant italic))))
 ;; '(ido-vertical-first-match-face ((t (:inherit ido-first-match :background "#3b3b30"))))
 ;; '(ido-vertical-match-face ((t (:foreground "white" :underline t))))
 ;; '(ido-vertical-only-match-face ((t (:inherit ido-only-match :background "#3b3b30"))))
 ;; '(ido-virtual ((t (:slant italic))))
 ;; '(js2-error ((t (:foreground "#D9D9D9" :underline (:color "brown" :style wave) :weight bold))))
 ;; '(js2-external-variable ((t (:strike-through t))))
 ;; '(js2-warning ((t (:underline (:color "white" :style wave)))))
 ;; '(message-cited-text ((t (:foreground "dim gray"))))
 ;; '(mode-line ((t (:height 100))))
 ;; '(notmuch-tag-face ((t (:foreground "white"))))
 ;; '(org-mode-line-clock ((t (:inherit nil))))

 ;; '(sp-show-pair-match-face ((t (:inherit highlight :underline t))))
 ;; '(w3m-anchor ((t nil))))

(let ((dark       "black")
      (dimmest    "#1a1a1a")
      (gloom      "#3a3a3a")
      (dimmer     "#595959")
      (dim        "#a9a9a9")
      (semi       "light grey")
      (bright     "#e9f6f6")
      (brightest  "white")

      (blueish    "light slate gray")
      (hint1      "#CCD")
      (hint2      "#CDC")
      (hint3      "#DCC")

      (err        "#c82829")
      (question   "#de935f")
      (warning    "brown")
      (happy      "#718c00")
      (good       "#3e999f")
      (highlight  "gold"))

  (custom-theme-set-faces
   'quasi-monochrome-hinton
   `(default ((t (:background ,dimmest :foreground ,bright))))

   `(cursor ((t (:foreground ,dimmest :background ,brightest))))

   '(sp-show-pair-match-face ((t (:inherit highlight :underline t))))

   `(variable-pitch ((t (:family "Sans Serif"))))
   `(escape-glyph ((t (:foreground ,semi))))
   `(minibuffer-prompt ((t (:weight bold :foreground ,brightest))))
   `(highlight ((t (:background ,gloom))))
   `(hl-line ((t (:background ,gloom))))
   `(region ((t (:inverse-video t :background ,dark :foreground ,highlight))))
   `(shadow ((t (:foreground ,dimmer))))
   `(secondary-selection ((t (:background ,dimmer))))
   `(trailing-whitespace ((t (:background ,warning))))
   `(font-lock-builtin-face ((t (:foreground ,semi))))
   `(font-lock-comment-delimiter-face ((default (:inherit (font-lock-comment-face)))))
   `(font-lock-comment-face ((t (:slant italic :foreground ,blueish))))
   `(font-lock-constant-face ((t (:weight bold :foreground ,semi))))
   `(font-lock-doc-face ((t (:inherit (font-lock-string-face)))))
   `(font-lock-function-name-face ((t (:foreground ,brightest))))
   `(font-lock-keyword-face ((t (:weight bold :foreground ,hint3))))
   `(font-lock-negation-char-face ((t nil)))
   `(font-lock-preprocessor-face ((t (:inherit (font-lock-builtin-face)))))
   `(font-lock-regexp-grouping-backslash ((t (:inherit (bold)))))
   `(font-lock-regexp-grouping-construct ((t (:inherit (bold)))))
   `(font-lock-string-face ((t (:foreground ,semi))))
   `(font-lock-type-face ((t (:weight bold :foreground ,brightest))))
   `(font-lock-variable-name-face ((t (:foreground ,brightest))))
   `(font-lock-warning-face ((t (:foreground ,warning))))
   `(button ((t (:inherit (link)))))
   `(link ((t (:underline (:color foreground-color :style line) :foreground ,semi))))
   `(link-visited ((t (:underline (:color foreground-color :style line) :foreground ,semi))))
   `(fringe ((t (:foreground ,semi :background ,gloom))))
   `(vertical-border ((t (:foreground ,dimmer))))
   `(header-line ((default (:inherit (mode-line)))))
   `(tooltip ((((class color)) (:inherit (variable-pitch) :foreground "black" :background "lightyellow")) (t (:inherit (variable-pitch)))))

   `(compilation-error ((t :weight bold :foreground ,brightest :background ,warning)))

   `(message-header-name ((t (:inherit font-lock-type-face))))
   `(message-header-subject ((t (:inherit font-lock-function-name-face))))
   `(message-header-to ((t (:inherit font-lock-string-face))))
   `(message-header-other ((t (:inherit font-lock-comment-face))))
   `(message-mml ((t (:weight bold :foreground ,dim))))

   `(outline-1 ((t (:foreground ,brightest :height 1.5))))
   `(outline-2 ((t (:foreground ,brightest :height 1.4))))
   `(outline-3 ((t (:foreground ,brightest :height 1.3))))
   `(outline-4 ((t (:foreground ,brightest :height 1.2))))
   `(outline-5 ((t (:foreground ,brightest :height 1.1))))
   `(outline-6 ((t (:foreground ,brightest))))
   `(outline-7 ((t (:foreground ,brightest))))
   `(outline-8 ((t (:foreground ,brightest))))

   `(ido-match-modes-indicator-face ((t (:foreground ,question))))
   `(ido-vertical-common-match-face ((t (:foreground ,semi :slant italic))))

   `(ido-first-match ((t :background ,gloom :foreground ,question)))
   `(ido-vertical-first-match ((t (:inherit ido-first-match))))

   `(ido-vertical-match-face ((t (:underline t))))

   `(ido-subdir ((t (:foreground ,hint1))))
   `(ido-only-match ((t (:background ,gloom :foreground ,highlight))))

   `(ido-vertical-only-match-face ((t (:inherit ido-only-match))))
   `(ido-virtual ((t (:slant italic))))

   `(isearch ((t (:foreground ,dimmest :background ,happy))))
   `(isearch-fail ((t (:background ,warning))))
   `(lazy-highlight ((t (:foreground ,dimmest :background ,good))))
   `(match ((t :background ,question :foreground ,dimmest)))
   `(next-error ((t (:inherit (region)))))
   `(mode-line ((t (:height 0.8 :inherit default))))
   `(mode-line-inactive ((t (:height 0.8 :inherit default))))
   `(query-replace ((t (:inherit (isearch)))))))

;;;###autoload
(when load-file-name
  (add-to-list
   'custom-theme-load-path
   (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'quasi-monochrome-hinton)

;;; quasi-monochrome-theme.el ends here
