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
  (let*
      ((h1 0.55)
       (h2 (+ 0.3 h1))
       (h3 (+ 0.2 h2))

       (v-dark 0.3)
       (v-light 0.6)
       (vv-light 0.8)

       (bg (hsl 0 0 0.1))
       (lightbg (hsl 0 0 0.2))
       (mid (hsl 0 0 0.4))
       (fg (hsl 0 0 0.90))
       (dimfg (hsl 0 0 0.7))
       (w  (hsl 0 0 1))
       (b  (hsl 0 0 0))
       (c1 (hsl h1 0.6 v-dark))
       (c2 (hsl h2 0.6 v-dark))
       (c3 (hsl h3 0.6 v-dark))

       (c1l (hsl h1 0.6 v-light))
       (c2l (hsl h2 0.6 v-light))
       (c3l (hsl h3 0.6 v-light))

       (c1ll (hsl h1 0.6 vv-light))
       (c2ll (hsl h2 0.6 vv-light))
       (c3ll (hsl h3 0.6 vv-light))

       (red   (hsl 0    0.6 v-light))
       (green (hsl 0.35 0.6 v-light))
       (blue  (hsl 0.55 0.6 v-light))

       (dimred   (hsl 0    0.3 v-dark))
       (dimgreen (hsl 0.35 0.3 v-dark))
       (dimblue  (hsl 0.55 0.3 v-dark))
       )
    (message "Random!: %f %f %f" h1 h2 h3)
    (custom-theme-set-faces
     'plain
     (p `(default :background ,bg :foreground ,fg))
     (p `(cursor  :background ,w  :foreground ,b))
     (p `(region  :background ,w  :foreground ,c1 :inverse-video  t))
     (p `(shadow :foreground ,dimfg))
     (p `(error :foreground ,red))
     (p `(highlight :background ,lightbg))
     (p `(minibuffer-prompt :foreground ,w))
     (p `(ido-first-match :inverse-video t))
     (p `(ido-subdir :inherit shadow))
     (p `(ido-only-match :inherit ido-first-match :weight bold))

     (p `(vertical-border :foreground ,mid))
     (p `(fringe :background ,lightbg :foreground ,dimfg))

     (p `(font-lock-warning-face :foreground ,red))
     (p `(font-lock-function-name-face :foreground ,w))
     (p `(font-lock-variable-name-face))
     (p `(font-lock-keyword-face :weight bold :foreground ,w))
     (p `(font-lock-comment-face :slant italic :inherit shadow))

     (p `(font-lock-type-face :weight bold))
     (p `(font-lock-constant-face :weight bold))
     (p `(font-lock-builtin-face))
     (p `(font-lock-preprocessor-face))
     (p `(font-lock-string-face :foreground ,c1ll))
     (p `(font-lock-doc-face :inherit font-lock-comment-face))
     (p `(font-lock-negation-char-face))

     (p `(highlight-symbol-face :inherit highlight))

     (p `(sp-pair-overlay-face :background ,lightbg))
     (p `(sp-wrap-overlay-face :inherit sp-pair-overlay-face))
     (p `(sp-show-pair-match-face :underline t))

     (p `(mode-line :background ,c1 :box ,fg))
     (p `(mode-line-inactive :background ,lightbg :box ,mid))

     (p `(mode-line-emphasis :background ,c3))
     (p `(mode-line-highlight :background ,c2))
     (p `(header-line :inherit highlight :weight bold))
     (p `(which-func :foreground ,w))

     (p `(notmuch-tag-face :foreground ,c3l))
     (p `(notmuch-message-summary-face :inherit highlight))
     (p `(message-header-name :foreground ,w :weight bold))
     (p `(message-header-other :foreground ,w))
     (p `(message-header-cc :inherit message-header-other))
     (p `(message-header-subject :inherit message-header-other))
     (p `(message-header-to :inherit message-header-other))
     (p `(message-cited-text :inherit font-lock-comment-face))
     (p `(message-mml :foreground ,w))

     (p `(outline-1  :foreground ,w :height 1.3 :inherit default :weight bold))
     (p `(outline-2  :height 0.9 :inherit outline-1))
     (p `(outline-3  :height 0.9 :inherit outline-2))
     (p `(outline-4  :inherit outline-3))
     (p `(outline-5  :inherit outline-4))
     (p `(outline-6  :inherit outline-5))
     (p `(outline-7  :inherit outline-6))
     (p `(outline-8  :inherit outline-7))

     (p `(link :underline t))
     (p `(w3m-anchor :inherit link))

     (p `(org-mode-line-clock :inherit nil))
     (p `(org-todo :inherit error))
     (p `(org-done :foreground ,green))
     (p `(org-date :inherit link :foreground ,c3l))

     (p `(isearch :foreground ,w :background ,c1))
     (p `(match :inherit isearch))
     (p `(lazy-highlight :foreground ,w :background ,lightbg))
     (p `(anzu-mode-line :inherit mode-line-highlight))

     (p `(diff-hl-change :foreground ,blue :background ,dimblue))
     (p `(diff-hl-delete :foreground ,red :background ,dimred))
     (p `(diff-hl-insert :foreground ,green :background ,dimgreen))
     )))

(provide-theme 'plain)

;;; plain-theme.el ends here
