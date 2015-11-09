(put 'dired-find-alternate-file 'disabled nil)
(add-hook 'dired-load-hook (lambda () (require 'dired-x)))

(bind-key "RET" #'dired-find-alternate-file dired-mode-map)

(req-package dired-k
  :commands dired-k dired-k-no-revert
  :init
  (add-hook 'dired-after-readin-hook #'dired-k-no-revert)
  (setq dired-k-style 'git
        dired-k-human-readable t))

(req-package dired-imenu
  :config
  (require 'dired-imenu))

(req-package dired-x
  :commands dired-omit-mode
  :init
  (bind-key ")" #'dired-omit-mode dired-mode-map))

(req-package dired-subtree
  :commands dired-subtree-toggle
  :init
  (bind-key "i" #'dired-subtree-toggle dired-mode-map))

(req-package dired-filter :defer t)
