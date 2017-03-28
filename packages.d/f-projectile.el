(initsplit-this-file "projectile")

(req-package projectile
  :diminish (projectile-mode . "")
  :config

  (projectile-global-mode t)
  (bind-key "C-x M-b" #'projectile-switch-to-buffer)
  )


(req-package ibuffer-projectile
  :commands ibuffer-projectile-set-filter-groups
  :init
  (bind-key "/ j g" 'ibuffer-projectile-set-filter-groups ibuffer-mode-map)
  (bind-key "/ j f" 'ibuffer-filter-by-projectile-root ibuffer-mode-map)
  :config

  (define-ibuffer-filter projectile-root
    "Toggle current view to buffers with projectile root dir QUALIFIER."
    (:description "projectile root dir"
                  :reader (expand-file-name
                           (completing-read "Filter by projectile root dir (regexp): "
                                            projectile-known-projects)))
    (ibuffer-awhen (ibuffer-projectile-root buf)
      (equal qualifier it)))

  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(projectile-completion-system (quote ivy)))
