(deftheme hinton
  "Created 2015-08-07.")

(custom-theme-set-faces
 'hinton
 '(helm-buffer-file ((t (:foreground "white"))))
 '(helm-match ((t (:background "gray16"))))
 '(helm-source-header ((t (:weight bold :underline nil :box nil :foreground "#F6F6F6" :background "dark slate gray"))))
 '(mode-line ((t (:background "black" :foreground "gray60" :inverse-video nil :box (:line-width 1 :style released-button) :height 86 :family "Sans"))))
 '(mode-line-inactive ((t (:background "#404045" :foreground "gray60" :inverse-video nil :box (:line-width 1 :style released-button) :height 86 :family "Sans"))))
 '(sml/filename ((t (:inherit sml/global :foreground "deep sky blue" :weight bold))))
 '(org-meta-line ((t (:foreground "#9D9D9D" :height 1.0))))
 '(org-todo ((t (:foreground "dark orange" :weight bold))))
 '(org-done ((t (:foreground "dark gray" :weight bold))))
 '(font-lock-type-face ((t (:foreground "white" :underline nil))))
 '(hl-line ((t (:background "gray20"))))
 '(org-archived ((t (:foreground "dim gray" :weight thin))))
 '(default ((t (:foreground "#F1EAD7" :height 120 :family "Monospace")))))

(provide-theme 'hinton)
