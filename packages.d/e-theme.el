;; (req-package hydandata-light
;;   :config
;;   (load-theme 'hydandata-light t))

;; (req-package paper-theme
;; :config
;; (load-theme 'paper t))

;; (req-package greymatters-theme
;;   (load-theme 'greymatters t))

(req-package minimal-theme
  :config
  (load-theme 'minimal-light t)
  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
  (load-theme 'tweaks t)
  (setq-default cursor-type 'box))


(defun my-unload-themes ()
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))
