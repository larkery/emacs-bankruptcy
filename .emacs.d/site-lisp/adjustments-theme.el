
(deftheme adjustments "my theme adjustments")

(custom-theme-set-faces
 'adjustments
 '(default ((t :height 100 :foreground "#c7c7c7")))
 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))
 '(cursor ((t (:background "#ffffff"))))
 '(outline-1 ((t (:height 1.5 :foreground "#ffffff"))))
 '(outline-2 ((t (:height 1.4 :foreground "#ffffff"))))
 '(outline-3 ((t (:height 1.3 :foreground "#ffffff"))))
 '(outline-4 ((t (:height 1.2 :foreground "#ffffff"))))
 '(outline-5 ((t (:height 1.1 :foreground "#ffffff"))))
 )

(provide-theme 'adjustments)
