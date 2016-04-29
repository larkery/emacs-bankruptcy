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

 '(font-lock-comment-delimiter-face ((t (:foreground "steel blue"))))

 '(notmuch-message-summary-face ((t (:inherit highlight))))

 '(org-mode-line-clock ((t ())))

 '(erc-timestamp-face ((t :inherit shadow)))

 '(eno-hint-face ((t (:inherit default :inverse-video t))))

 '(dired-directory ((t (:foreground "steel blue"))))

 '(mode-line-highlight ((t (:foreground "cyan2"))))
 '(mode-line-emphasis ((t (:foreground "orange"))))

 '(dired-subtree-depth-1-face ((t (:background "cornsilk2"))))
 '(dired-subtree-depth-2-face ((t (:background "cornsilk3"))))
 '(dired-subtree-depth-3-face ((t (:background "cornsilk4" :foreground "white"))))
 '(dired-subtree-depth-4-face ((t (:background "cornsilk4" :foreground "white"))))
 '(dired-subtree-depth-5-face ((t (:background "cornsilk4" :foreground "white"))))

 '(org-agenda-date ((t (:inherit outline-2))))
 '(org-agenda-date-today ((t (:inherit outline-2 :foreground "firebrick"))))
 '(org-agenda-date-weekend ((t (:inherit outline-2 :slant italic))))

 '(outline-1 ((t (:height 130 :foreground "cadetblue4" :slant normal))))
 '(outline-2 ((t (:height 125 :foreground "cadetblue4" :slant normal))))
 '(outline-3 ((t (:height 120 :foreground "cadetblue4" :slant normal))))
 '(outline-4 ((t (:height 115 :foreground "cadetblue4" :slant normal))))
 '(outline-5 ((t (:height 110 :foreground "cadetblue4" :slant normal))))
 '(outline-6 ((t (:height 110 :foreground "cadetblue4" :slant normal))))
 '(outline-7 ((t (:height 110 :foreground "cadetblue4" :slant normal))))
 '(outline-8 ((t (:height 110 :foreground "cadetblue4" :slant normal))))
 '(outline-9 ((t (:height 110 :foreground "cadetblue4" :slant normal))))

 '(org-date ((t (:inherit link))))

 '(rainbow-delimiters-depth-1-face ((t (:foreground "#8ca5b0"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "#809ba8"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "#7492a0"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "#668497"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "#5e7a8b"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "#b9725e"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "#b46751"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "#9b543e"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "#8d4b38"))))

 '(show-paren-mismatch ((t (:background "dark red" :foreground "white"))))
 '(rainbow-delimiters-unmatched-face ((t (:inherit show-paren-mismatch))))
 '(rainbow-delimiters-mismatched-face ((t (:inherit show-paren-mismatch)))))

(provide-theme 'adjustments)
