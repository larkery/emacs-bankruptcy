(add-hook
 'dired-mode-hook
 (lambda () (interactive) (local-set-key (kbd "V") #'magit-status)))

;;;; use key ')' to toggle omitted files in dired
(req-package dired-x
	     :commands dired-omit-mode
	     :init
	     (add-hook 'dired-load-hook (lambda () (require 'dired-x)))
	     (bind-key ")" #'dired-omit-mode dired-mode-map))

;;;; insert dired subtree indented rather than at bottom
(req-package dired-subtree
	     :commands dired-subtree-toggle dired-subtree-cycle
	     :init
	     (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
         )
