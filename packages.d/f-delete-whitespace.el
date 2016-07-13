;;(add-hook 'before-save-hook 'delete-trailing-whitespace)

(req-package ws-butler
  :config
  (ws-butler-global-mode 1))
