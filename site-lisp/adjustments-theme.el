(deftheme adjustments "my theme adjustments")

;; theme only works properly in X, but there we go fails on server
;; start - presumably X resources not yet loaded.

(custom-theme-set-faces
 'adjustments

 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))
 '(ido-virtual ((t (:slant italic))))

 '(cursor ((t :background "dark cyan")))

 '(ido-grid-match-1 ((t (:foreground "dark cyan"))))
 '(ido-grid-match-2 ((t (:foreground "blue violet"))))
 '(ido-grid-match-3 ((t (:foreground "dark red"))))

 '(message-cited-text ((t (:inherit shadow :slant italic))))

 '(show-paren-match ((t (:underline t))))
 '(highlight-symbol-face ((t (:underline "cyan4"))))

 '(highlight ((t :foreground "black")))
 '(hl-line ((t ::background "grey20")))

 '(font-lock-comment-delimiter-face ((t (:foreground "steel blue"))))
 '(magit-section-highlight ((t :inverse-video t)))
 '(magit-section-heading ((t :inherit mode-line-emphasis)))

 '(notmuch-message-summary-face ((t (:background "white"))))

 '(org-mode-line-clock ((t ())))

 '(erc-timestamp-face ((t :inherit shadow)))

 '(eno-hint-face ((t (:inherit default :inverse-video t))))

 '(dired-directory ((t (:foreground "steel blue"))))

 '(mode-line-highlight ((t (:foreground "cyan2"))))
 '(mode-line-emphasis ((t (:foreground "orange"))))

 '(linum ((t (:foreground "grey50"))))

 '(dired-subtree-depth-1-face ((t (:background "grey80"))))
 '(dired-subtree-depth-2-face ((t (:background "grey75"))))
 '(dired-subtree-depth-3-face ((t (:background "grey70" :foreground "white"))))
 '(dired-subtree-depth-4-face ((t (:background "grey65" :foreground "white"))))
 '(dired-subtree-depth-5-face ((t (:background "grey60" :foreground "white"))))

 '(org-agenda-date ((t (:inherit outline-2))))
 '(org-agenda-date-today ((t (:inherit outline-2 :foreground "firebrick"))))
 '(org-agenda-date-weekend ((t (:inherit outline-2 :slant italic))))
 '(org-todo ((t (:foreground "firebrick" :weight bold))))
 '(org-done ((t (:foreground "dark slate gray" :weight bold))))
 '(org-meta-line ((t (:height 1.0))))
 '(org-checkbox ((t :box nil :foreground "black" :background "white")))

 '(org-document-title ((t :height 1.0)))
 '(org-level-1 ((t :height 1.0 :foreground "black" :weight bold :inherit outline-1)))
 '(org-level-2 ((t :height 1.0 :foreground "black" :weight bold :inherit outline-2)))
 '(org-level-3 ((t :height 1.0 :foreground "black" :weight bold :inherit outline-3)))
 '(org-level-4 ((t :height 1.0 :foreground "black" :weight bold :inherit outline-4)))
 '(org-level-5 ((t :height 1.0 :foreground "black" :weight bold :inherit outline-5)))
 '(org-level-6 ((t :height 1.0 :foreground "black" :weight bold :inherit outline-6)))
 '(org-level-7 ((t :height 1.0 :foreground "black" :weight bold :inherit outline-7)))
 '(org-level-8 ((t :height 1.0 :foreground "black" :weight bold :inherit outline-8)))
 '(org-level-9 ((t :height 1.0 :foreground "black" :weight bold :inherit outline-9)))

 '(outline-1 ((t (:height 1.3 :foreground "black" :weight bold))))
 '(outline-2 ((t (:height 1.2 :foreground "black" :weight bold))))
 '(outline-3 ((t (:height 1.0 :foreground "black" :weight bold))))
 '(outline-4 ((t (:height 1.0 :foreground "black" :weight bold))))
 '(outline-5 ((t (:height 1.0 :foreground "black" :weight bold))))
 '(outline-6 ((t (:height 1.0 :foreground "black" :weight bold))))
 '(outline-7 ((t (:height 1.0 :foreground "black" :weight bold))))
 '(outline-8 ((t (:height 1.0 :foreground "black" :weight bold))))
 '(outline-9 ((t (:height 1.0 :foreground "black" :weight bold))))

 '(org-date ((t (:inherit link))))

 '(rainbow-delimiters-depth-1-face ((t (:foreground "#88a3ae"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "#7c99a6"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "#70909e"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "#648093"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "#5c7687"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "#b76e5a"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "#b2634d"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "#97523c"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "#894936"))))

 '(show-paren-mismatch ((t (:background "dark red" :foreground "white"))))
 '(rainbow-delimiters-unmatched-face ((t (:inherit show-paren-mismatch))))
 '(rainbow-delimiters-mismatched-face ((t (:inherit show-paren-mismatch)))))

(provide-theme 'adjustments)
