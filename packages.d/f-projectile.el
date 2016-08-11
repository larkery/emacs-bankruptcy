(req-package projectile
  :diminish (projectile-mode . "")
  :config
  (setq projectile-completion-system 'ido)
  (projectile-global-mode t)
  ;; (bind-keys
  ;;  :map projectile-mode-map
  ;;  ("C-c p s S" . projectile-ag)
  ;;  ("C-c p s G" . counsel-git-grep)

  ;;  ;; ("C-c p s s" . counsel-projectile-ag)

  ;;  ;; ("C-c p s g" . counsel-projectile-grep)
  ;;  )


  ;; (defun counsel-projectile-ag ()
  ;;   (interactive)
  ;;   (counsel-ag nil (projectile-project-root)))


  ;; (defun counsel-projectile-grep ()
  ;;   (interactive)
  ;;   (counsel-grep nil (projectile-project-root)))


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
