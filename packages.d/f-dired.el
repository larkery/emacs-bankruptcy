(initsplit-this-file bos "dired-")

(bind-key "V" #'magit-status dired-mode-map)
(bind-key "C-c RET" #'run-terminal-here dired-mode-map)
(bind-key "C-c o" #'dired-xdg-open dired-mode-map)

(defun dired-xdg-open (&optional arg file-list)
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg)))
     (list
      ;; Want to give feedback whether this file or marked files are used:
      current-prefix-arg
      files)))
  (dired-do-async-shell-command "xdg-open" arg file-list))

(add-hook 'dired-mode-hook 'auto-revert-mode)

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
  :commands dired-narrow
  :init
  (bind-key "/" #'dired-narrow dired-mode-map))

(req-package dired-ranger
  :commands dired-ranger-copy dired-ranger-paste
  :defer t
  :init
  (bind-keys
   :map dired-mode-map
   ("C-w" . dired-ranger-copy)
   ("C-y" . dired-ranger-paste)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-async-mode nil)
 '(dired-auto-revert-buffer t)
 '(dired-dwim-target t)
 '(dired-isearch-filenames (quote dwim))
 '(dired-listing-switches "-lah")
 '(dired-omit-files "^\\.[^\\.]"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-directory ((t (:inherit font-lock-function-name-face :weight bold)))))
