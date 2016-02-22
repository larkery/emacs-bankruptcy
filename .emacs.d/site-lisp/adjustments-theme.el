
(deftheme adjustments "my theme adjustments")

(custom-theme-set-faces
 'adjustments
 '(default ((t :height 100)))
 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))
 '(cursor ((t (:background "#ffffff"))))
 '(outline-1 ((t (:height 1.4 :underline "#555555" :foreground "#ffffff"))))
 '(outline-2 ((t (:height 1.3 :underline "#555555" :foreground "#ffffff"))))
 '(outline-3 ((t (:height 1.2 :underline "#555555" :foreground "#ffffff"))))
 '(outline-4 ((t (:height 1.1 :underline "#555555" :foreground "#ffffff"))))
 '(outline-5 ((t (:height 1.0 :underline "#555555" :foreground "#ffffff"))))
 '(message-cited-text ((t (:inherit shadow :slant italic))))
 )

(provide-theme 'adjustments)
