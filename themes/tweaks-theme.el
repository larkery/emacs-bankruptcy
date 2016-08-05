(deftheme tweaks "small adjustments to theme")

(custom-theme-set-faces
 'tweaks

 '(ivy-remote ((t (:inherit error))))

 '(show-paren-match ((t (:background nil :foreground nil :weight bold
;;                                     :box (:line-width -1)

                                     :underline t
                                     ))))
 '(show-paren-mismatch ((t (:background "black" :foreground "red" :weight bold))))

 '(org-todo ((t (:foreground "white" :background "red3"))))
 '(org-done ((t (:foreground "white" :background "green3"))))

 '(dired-subtree-depth-1-face ((t ())))
 '(dired-subtree-depth-5-face ((t ())))
 '(dired-subtree-depth-3-face ((t ())))
 '(dired-subtree-depth-2-face ((t ())))
 '(dired-subtree-depth-4-face ((t ())))
 '(dired-subtree-depth-6-face ((t ())))

 '(w3m-lnum ((t (:background "#F0F0F0" :foreground "dark orange"))))

 '(outline-1 ((t (:height 1.3 :box "grey50"))))
 '(outline-2 ((t (:height 1.2 :box "grey50"))))
 '(outline-3 ((t (:height 1.1 :box "grey50"))))
 '(outline-4 ((t (:height 1.1 :box "grey50"))))
 '(outline-5 ((t (:height 1.1 :box "grey50"))))
 '(outline-6 ((t (:height 1.1 :box "grey50"))))
 '(outline-7 ((t (:height 1.1 :box "grey50"))))
 '(outline-8 ((t (:height 1.1 :box "grey50"))))
 '(outline-9 ((t (:height 1.1 :box "grey50"))))

 '(org-level-1 ((t (:height 1.3 :box "grey50"))))
 '(org-level-2 ((t (:height 1.2 :box "grey50"))))
 '(org-level-3 ((t (:height 1.1 :box "grey50"))))
 '(org-level-4 ((t (:height 1.1 :box "grey50"))))
 '(org-level-5 ((t (:height 1.1 :box "grey50"))))
 '(org-level-6 ((t (:height 1.1 :box "grey50"))))
 '(org-level-7 ((t (:height 1.1 :box "grey50"))))
 '(org-level-8 ((t (:height 1.1 :box "grey50"))))
 '(org-level-9 ((t (:height 1.1 :box "grey50"))))

 '(message-cited-text ((t (:weight bold))))

 )

(provide-theme 'tweaks)
