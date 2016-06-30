(req-package projectile
  :diminish (projectile-mode . "")
  :config
  (setq projectile-completion-system 'ivy)
  (projectile-global-mode t)
  (bind-keys
   :map projectile-mode-map
   ("C-c p s S" . projectile-ag)
   ("C-c p s G" . projectile-grep)
   ("C-c p s s" . counsel-ag)
   ("C-c p s g" . counsel-grep)))

(req-package ibuffer-projectile
  :commands ibuffer-projectile-set-filter-groups
  :config
  (bind-key "/ p" 'ibuffer-projectile-set-filter-groups ibuffer-mode-map)
  )
