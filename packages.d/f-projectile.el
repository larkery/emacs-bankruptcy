(message "projectileing")

(req-package projectile
  :diminish (projectile-mode . "")
  :config
  (setq projectile-completion-system 'ivy)
  (projectile-global-mode t)
  (bind-keys
   :map projectile-mode-map
   ("C-c p s s" . counsel-ag)
   ("C-c p s g" . counsel-grep)))

