(req-package undo-tree
  :defer nil
  :bind ("C-z" . undo-tree-undo)
  :config
  (global-undo-tree-mode)
  (diminish 'undo-tree-mode))
