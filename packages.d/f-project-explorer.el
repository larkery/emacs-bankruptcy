(req-package project-explorer
  :bind ("<f5>" . project-explorer-toggle)
  :config
  (bind-keys
   :map project-explorer-mode-map
   ("o" . pe/find-file)
   ("%" . projectile-ag)))
