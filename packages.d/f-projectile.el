;; -*- lexical-binding: t -*-
(initsplit-this-file "projectile")

(req-package projectile
  :require counsel-projectile
  :diminish (projectile-mode . "")
  :config

  (projectile-global-mode t)
  (counsel-projectile-mode)
  (bind-key "C-x M-b" #'projectile-switch-to-buffer)
  (bind-key "C-c d" #'projectile-dired)
  )

(req-package ibuffer-projectile
  :commands ibuffer-projectile-set-filter-groups ibuffer-filter-by-projectile-root
  :init
  (with-eval-after-load 'ibuffer
    (bind-key "/ j g" 'ibuffer-projectile-set-filter-groups ibuffer-mode-map)
    (bind-key "/ j f" 'ibuffer-filter-by-projectile-root ibuffer-mode-map))
  :config

  (define-ibuffer-filter projectile-root
    "Toggle current view to buffers with projectile root dir QUALIFIER."
    (:description "projectile root dir"
                  :reader (expand-file-name
                           (completing-read "Filter by projectile root dir (regexp): "
                                            projectile-known-projects)))
    (if-let ((project-root
              (with-current-buffer buf (let (projectile-require-project-root)
                                         (projectile-project-root)))))
        (equal qualifier project-root))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(projectile-completion-system (quote ivy)))
