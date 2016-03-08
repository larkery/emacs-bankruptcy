
(deftheme adjustments "my theme adjustments")

(custom-theme-set-faces
 'adjustments
 '(default ((t :height 105)))
 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))
 '(ido-virtual ((t (:slant italic))))
 '(cursor ((t (:background "#ffffff"))))
 '(message-cited-text ((t (:inherit shadow :slant italic))))
 '(show-paren-match ((t (:underline t))))
 '(diff-hl-change ((t (:background "dim gray" :foreground "dark gray"))))
 '(highlight-symbol-face ((t (:underline t))))
 '(font-lock-function-name-face ((t (:foreground "#4493a1"))))
 '(outline-1 ((t (:height 1.2 :inherit font-lock-function-name-face))))
 '(outline-2 ((t (:height 1.2 :inherit font-lock-type-face))))
 '(org-date ((t (:inherit link)))))

(provide-theme 'adjustments)
