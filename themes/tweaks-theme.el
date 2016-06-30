(deftheme tweaks "small adjustments to theme")

(custom-theme-set-faces
 'tweaks

 '(show-paren-mismatch ((t (:background "black" :foreground "red" :weight bold))))

 '(org-todo ((t (:foreground "white" :background "red3"))))
 '(org-done ((t (:foreground "white" :background "green3"))))

 '(dired-subtree-depth-1-face ((t (:background "gray10"))))
 '(dired-subtree-depth-2-face ((t (:background "gray15"))))
 '(dired-subtree-depth-3-face ((t (:background "gray20"))))
 '(dired-subtree-depth-4-face ((t (:background "gray25"))))
 '(dired-subtree-depth-5-face ((t (:background "gray30"))))
 '(dired-subtree-depth-6-face ((t (:background "gray35"))))

;; '(font-lock-comment-face ((t (:foreground "white"))))

 '(w3m-lnum ((t (:background "#F0F0F0" :foreground "dark orange"))))

 '(outline-1 ((t (:height 1.5))))
 '(outline-2 ((t (:height 1.5))))
 '(outline-3 ((t (:height 1.5))))
 '(outline-4 ((t (:height 1.5))))
 '(outline-5 ((t (:height 1.5))))
 '(outline-6 ((t (:height 1.5))))
 '(outline-7 ((t (:height 1.5))))
 '(outline-8 ((t (:height 1.5))))
 '(outline-9 ((t (:height 1.5))))

 '(org-level-1 ((t (:height 1.5))))
 '(org-level-2 ((t (:height 1.5))))
 '(org-level-3 ((t (:height 1.5))))
 '(org-level-4 ((t (:height 1.5))))
 '(org-level-5 ((t (:height 1.5))))
 '(org-level-6 ((t (:height 1.5))))
 '(org-level-7 ((t (:height 1.5))))
 '(org-level-8 ((t (:height 1.5))))
 '(org-level-9 ((t (:height 1.5))))

 )

(provide-theme 'tweaks)
