(initsplit-this-file bos "dired-")

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
             (setq dired-subtree-line-prefix "  ┇"))

(req-package dired-narrow
  :init
  (bind-key "/" #'dired-narrow dired-mode-map))

(req-package dired :require emacs-async)

(req-package dired-ranger
  :config
  (bind-keys
   :map dired-mode-map
   ("C-w" . dired-ranger-copy)
   ("C-y" . dired-ranger-paste)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-async-mode t)
 '(dired-dwim-target t)
 '(dired-isearch-filenames (quote dwim))
 '(dired-listing-switches "-lah")
 '(dired-omit-files "^\\.[^\\.]"))
