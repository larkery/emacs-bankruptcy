
;;   :config (load-theme 'anti-zenburn t))

;; (req-package anti-zenburn-theme)


;; (req-package leuven-theme)


;; (req-package zenburn-theme

;;   ;; (load-theme 'zenburn t)
;;   )


(req-package seoul256-theme
  :demand
  :bind ("C-c b" . seoul256-switch-background)
  :config
  (load-theme 'seoul256 t))






;; (defun my-rotate-theme ()
;;   (interactive)
;;   (let ((theme (car custom-enabled-themes)))
;;     (when theme (disable-theme theme))
;;     (load-theme (case theme
;;                   ('zenburn 'anti-zenburn)
;;                   ('anti-zenburn 'leuven)
;;                   (t 'zenburn)
;;                   ) t)))
