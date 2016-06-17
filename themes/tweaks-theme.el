(deftheme tweaks "small adjustments to theme")

(custom-theme-set-faces
 'tweaks

 '(region ((t (:inverse-video t))))
;; '(cursor ((t (:background "red2"))))
 
 '(show-paren-match    ((t (:foreground "dark cyan" :weight bold))))
 '(show-paren-mismatch ((t (:background "black" :foreground "red" :weight bold)))))
 
 '(dired-subtree-depth-1-face ((t (:background "gray90"))))
 '(dired-subtree-depth-2-face ((t (:background "gray85"))))
 '(dired-subtree-depth-3-face ((t (:background "gray80"))))
 '(dired-subtree-depth-4-face ((t (:background "gray75"))))
 '(dired-subtree-depth-5-face ((t (:background "gray70"))))
 '(dired-subtree-depth-6-face ((t (:background "gray65"))))
 '(w3m-lnum ((t (:background "#F0F0F0" :foreground "dark orange")))))

(provide-theme 'tweaks)
