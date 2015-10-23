(add-hook 'dired-load-hook (lambda () (require 'dired-x)))
(req-package dired-k)

(req-package dired-imenu
  :config
  (require 'dired-imenu))

(req-package dired+
  :commands dired
  :config
  (diredp-toggle-find-file-reuse-dir 1))

(req-package dired-subtree
  :commands dired-subtree-toggle
  :init
  (bind-key "i" #'dired-subtree-toggle dired-mode-map))
