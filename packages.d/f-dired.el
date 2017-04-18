(initsplit-this-file bos "dired-")

(bind-key "V" #'magit-status dired-mode-map)
(bind-key "C-c RET" #'run-terminal-here dired-mode-map)
(bind-key "C-c o" #'dired-xdg-open dired-mode-map)
(bind-key "J" #'bookmark-jump dired-mode-map)
(bind-key "^" #'dired-up-directory-here dired-mode-map)
(bind-key "r" #'dired-from-recentf dired-mode-map)

(defun dired-up-directory-here (arg)
  (interactive "P")
  (if arg
      (call-interactively #'dired-up-directory)
    (let* ((current-dir (dired-current-directory)))
      (find-alternate-file "..")
      (dired-goto-file current-dir))))

(defun dired-from-recentf (arg)
  (interactive "P")

  (funcall (if arg #'dired-other-window #'dired)
   (completing-read
    "Directory: "

    (delete-dups
     (mapcar (lambda (f)
               (if (and (not (file-remote-p f))
                        (file-directory-p f))
                   f
                 (file-name-directory f)))
             recentf-list)))))

(defun dired-xdg-open ()
  (interactive)

  (dolist (file (dired-get-marked-files t current-prefix-arg))
    (start-process "xdg-open" nil "xdg-open" file)))

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
