(deftheme tweaks "small adjustments to theme")
(require 'highlight-symbol)
(custom-theme-set-faces
 'tweaks

 '(dired-directory ((t (:weight bold))))

 '(mode-line ((t (:box nil :overline "gray40"))))
 '(mode-line-inactive ((t (:box nil :overline "gray40"))))

 '(outline-1 ((t (:height 1.1 :weight bold))))
 '(outline-2 ((t (:height 1.1 :weight bold))))
 '(outline-3 ((t (:height 1.1 :weight bold))))
 '(outline-4 ((t (:height 1.1 :weight bold))))
 '(outline-5 ((t (:height 1.1 :weight bold))))
 '(outline-6 ((t (:height 1.1 :weight bold))))
 '(outline-7 ((t (:height 1.1 :weight bold))))
 '(outline-8 ((t (:height 1.1 :weight bold))))
 '(outline-9 ((t (:height 1.1 :weight bold))))

 '(org-level-1 ((t (:height 1.1 :weight bold))))
 '(org-level-2 ((t (:height 1.1 :weight bold))))
 '(org-level-3 ((t (:height 1.1 :weight bold))))
 '(org-level-4 ((t (:height 1.1 :weight bold))))
 '(org-level-5 ((t (:height 1.1 :weight bold))))
 '(org-level-6 ((t (:height 1.1 :weight bold))))
 '(org-level-7 ((t (:height 1.1 :weight bold))))
 '(org-level-8 ((t (:height 1.1 :weight bold))))
 '(org-level-9 ((t (:height 1.1 :weight bold))))

 '(alect-title ((t (:foreground "orange"))))
 )

(provide-theme 'tweaks)
