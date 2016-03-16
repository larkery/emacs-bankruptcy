(deftheme adjustments "my theme adjustments")

(custom-theme-set-faces
 'adjustments
 '(default ((t :height 105 :background "#E8E8E5" :foreground "#4D4D4C")))
 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))
 '(ido-virtual ((t (:slant italic))))

 '(ido-grid-match-1 ((t (:background "#d0a195"))))
 '(ido-grid-match-2 ((t (:background "#94a7b6"))))
 '(ido-grid-match-3 ((t (:background "#d0bc95"))))

 '(cursor ((t (:background "black"))))
 '(message-cited-text ((t (:inherit shadow :slant italic))))

 '(show-paren-match ((t (:underline t))))
 '(highlight-symbol-face ((t (:background "#ddd"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "black"))))

 '(eno-hint-face ((t (:inherit default :inverse-video t))))

 '(outline-1 ((t (:height 140 :foreground "#444" :background "#eee" :slant normal))))
 '(outline-2 ((t (:height 130 :foreground "#444" :background "#eee" :slant normal))))
 '(outline-3 ((t (:height 120 :foreground "#444" :background "#eee" :slant normal))))
 '(outline-4 ((t (:height 110 :foreground "#444" :background "#eee" :slant normal))))
 '(outline-5 ((t (:height 105 :foreground "#444" :background "#eee" :slant normal))))
 '(outline-6 ((t (:height 105 :foreground "#444" :background "#eee" :slant normal))))
 '(outline-7 ((t (:height 105 :foreground "#444" :background "#eee" :slant normal))))
 '(outline-8 ((t (:height 105 :foreground "#444" :background "#eee" :slant normal))))
 '(outline-9 ((t (:height 105 :foreground "#444" :background "#eee" :slant normal))))

 '(org-date ((t (:inherit link))))
 '(org-verbatim ((t :foreground "black")))
 '(fringe ((t (:foreground "white"))))

 '(rainbow-delimiters-depth-1-face ((t (:foreground "#8ca5b0"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "#809ba8"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "#7492a0"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "#668497"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "#5e7a8b"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "#b9725e"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "#b46751"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "#9b543e"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "#8d4b38"))))
 )

(provide-theme 'adjustments)
