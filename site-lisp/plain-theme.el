;;; plain-theme.el --- simple theme

;; Copyright tom hinton 2015; wtfpl

;;; Commentary:

;; a plain theme

;;; Code:

(require 'cl)
(require 'color)

(deftheme plain "a very plain theme")

(cl-flet ((hsl (h s l)
               (concat "#"
                       (mapconcat
                        (lambda (x) (format "%X" (truncate (* x 255))))
                        (color-hsl-to-rgb h s l) "")))
          (p (x)
             `(,(car x) ((t ,(cdr x))))))
  (message (hsl 0 0 1))
  (let*
      ((h1 0)
       (h2 (+ h1 0.33))
       (h3 (+ h2 0.33))

       (bg (hsl 0 0 0.1))
       (lightbg (hsl 0 0 0.15))
       (fg (hsl 0 0 0.9))
       (dimfg (hsl 0 0 0.7))
       (w  (hsl 0 0 1))
       (b  (hsl 0 0 0))
       (c1 (hsl h1 0.5 0.2))
       (c2 (hsl h2 0.5 0.2))
       (c3 (hsl h3 0.5 0.2))

       (c1l (hsl h1 0.5 0.6))
       (c2l (hsl h2 0.5 0.6))
       (c3l (hsl h3 0.5 0.6))

     )
    (custom-theme-set-faces
     'plain
     (p `(default :background ,bg :foreground ,fg))
     (p `(cursor  :background ,w  :foreground ,b))
     (p `(region  :background ,w  :foreground ,c1 :inverse-video  t))
     (p `(shadow :foreground ,dimfg))
     (p `(highlight :background ,lightbg))
     (p `(minibuffer-prompt :foreground ,w))
     (p `(ido-first-match :inverse-video t))
     (p `(ido-subdir :inherit shadow))
     (p `(ido-only-match :inherit ido-first-match :weight bold))

     (p `(vertical-border :foreground ,bg))
     (p `(fringe :background ,lightbg :foreground ,fg))

     (p `(font-lock-warning-face :foreground ,c2))
     (p `(font-lock-function-name-face))
     (p `(font-lock-variable-name-face))
     (p `(font-lock-keyword-face :weight bold :foreground ,w))
     (p `(font-lock-comment-face :slant italic :inherit shadow))

     (p `(font-lock-type-face :weight bold))
     (p `(font-lock-constant-face))
     (p `(font-lock-builtin-face))
     (p `(font-lock-preprocessor-face))
     (p `(font-lock-string-face :foreground ,w))
     (p `(font-lock-doc-face :weight bold))
     (p `(font-lock-negation-char-face))

     (p `(highlight-symbol-face :underline t))

     (p `(sp-pair-overlay-face :background ,lightbg))
     (p `(sp-wrap-overlay-face :inherit sp-pair-overlay-face))
     (p `(sp-show-pair-match-face :underline t))

     (p `(mode-line :background ,c1))
     (p `(mode-line-inactive :background ,b))
     (p `(mode-line-emphasis :background ,c2))
     (p `(mode-line-highlight :background ,c3))
     (p `(header-line :inherit highlight :weight bold))

     (p `(notmuch-tag-face :foreground ,c3l))
     (p `(notmuch-message-summary-face :inherit default))
     (p `(message-header-name :foreground ,w :weight bold))
     (p `(message-header-other :foreground ,w))
     (p `(message-header-cc :inherit message-header-other))
     (p `(message-header-subject :inherit message-header-other))
     (p `(message-header-to :inherit message-header-other))

     )))
