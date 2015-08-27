(deftheme hinton
  "Created 2015-08-25.")

(custom-theme-set-faces
 'hinton
 '(helm-buffer-file ((t (:foreground "white"))))
 '(helm-match ((t (:background "gray16"))))
 '(helm-source-header ((t (:weight bold :underline nil :box nil :foreground "#F6F6F6" :background "dark slate gray"))))
 '(org-meta-line ((t (:foreground "#9D9D9D" :height 1.0))))
 '(org-todo ((t (:foreground "dark orange" :weight bold))))
 '(org-done ((t (:foreground "dark gray" :weight bold))))
 '(font-lock-type-face ((t (:foreground "white" :underline nil))))
 '(hl-line ((t (:background "gray20"))))
 '(org-archived ((t (:foreground "dim gray" :weight thin))))
 '(font-lock-comment-face ((t (:foreground "gray60" :slant italic :weight light))))
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face))))
 '(default ((t (:foreground "#F1EAD7" :height 120 :family "Ubuntu mono")))))

(provide-theme 'hinton)
