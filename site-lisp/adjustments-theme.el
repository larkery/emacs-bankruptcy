
(deftheme adjustments "my theme adjustments")

(custom-theme-set-faces
 'adjustments
 '(default ((t :height 105)))
 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))
 '(cursor ((t (:background "#ffffff"))))
 '(outline-1 ((t (:height 1.3 :underline "#555555" :foreground "#ffffff"))))
 '(outline-2 ((t (:height 1.2 :underline "#555555" :foreground "#ffffff"))))
 '(outline-3 ((t (:height 1.1 :underline "#555555" :foreground "#ffffff"))))
 '(outline-4 ((t (:height 1.05 :underline "#555555" :foreground "#ffffff"))))
 '(outline-5 ((t (:height 1.0 :underline "#555555" :foreground "#ffffff"))))
 '(font-lock-comment-face ((t (:foreground "#777777"))))
 '(font-lock-function-name-face ((t (:foreground "#3898a8"))))
 '(message-cited-text ((t (:inherit shadow :slant italic))))

 '(diff-hl-change ((t (:background "dim gray" :foreground "dark gray"))))
 '(highlight-symbol-face ((t (:underline t))))
 '(magit-blame-heading ((t (:inherit (highlight shadow) :slant italic))))
 '(org-date ((t (:inherit link)))))

(provide-theme 'adjustments)
