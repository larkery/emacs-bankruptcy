;; (req-package hydandata-light
;;   :config
;;   (load-theme 'hydandata-light t))

;; (req-package paper-theme
;; :config
;; (load-theme 'paper t))

;; (req-package greymatters-theme
;;   (load-theme 'greymatters t))

;; (req-package spacemacs-theme
;;   :config
;;   (load-theme 'spacemacs-light t)
;;   ;;  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
;;   (load-theme 'tweaks t)
;;   ;;(setq-default cursor-type 'box)
;;   )

;; sanityinc-tomorrow-day

(req-package darktooth
  :config
  (load-theme 'darktooth t)
  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
  (load-theme 'tweaks t))

(defun my-unload-themes ()
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))
