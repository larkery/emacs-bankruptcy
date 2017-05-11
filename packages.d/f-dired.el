(initsplit-this-file bos "dired-")

(with-eval-after-load 'dired
  (bind-keys
   :map dired-mode-map
   ("V" . magit-status)
   ("C-x C-f" .  dired-C-x-C-f)
   ("e" .  dired-xdg-open)
   ("K" .  (lambda () (interactive)
                  (let ((here (dired-current-directory)))
                    (and (dired-goto-subdir here)
                         (progn (dired-do-kill-lines 1)
                                (dired-goto-file here))))))
   ("I" .  dired-insert-patricidally)
   ("r" .  dired-from-recentf)
   ("^" .  dired-up-directory-here)
   ("J" .  bookmark-jump)
   ("C-c RET" .  run-terminal-here))

  (defun dired-C-x-C-f ()
    (interactive)

    (let ((default-directory (dired-current-directory)))
      (call-interactively (global-key-binding (kbd "C-x C-f")))))

  (defun dired-up-directory-here (arg)
    (interactive "P")
    (let* ((here (dired-current-directory))
           (up (file-name-directory (directory-file-name here))))
      (or (dired-goto-file (directory-file-name here))
          (and (cdr dired-subdir-alist)
               (or (dired-goto-subdir up)
                   (condition-case nil
                       (progn
                         (dired-goto-subdir here)
                         (dired-do-kill-lines 1)
                         (dired-maybe-insert-subdir up) t)
                     (error nil))))
          (progn (find-alternate-file up)
                 (dired-goto-file here)))))

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

  (defun dired-insert-patricidally ()
    (interactive)
    (if (cdr dired-subdir-alist)
        (let ((here (dired-current-directory)))

          (call-interactively #'dired-maybe-insert-subdir)
          (save-excursion
            (and (dired-goto-subdir here)
                 (dired-do-kill-lines 1))))
      (dired-find-alternate-file)))

  (defun dired-xdg-open ()
    (interactive)

    (dolist (file (dired-get-marked-files t current-prefix-arg))
      (start-process "xdg-open" nil "xdg-open" file))))

(add-hook 'dired-mode-hook 'auto-revert-mode)

;;;; use key ')' to toggle omitted files in dired
(req-package dired-x
	     :commands dired-omit-mode
	     :init
	     (add-hook 'dired-load-hook (lambda () (require 'dired-x)))
             (bind-key ")" #'dired-omit-mode dired-mode-map))

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
 '(dired-bind-info nil)
 '(dired-bind-jump nil)
 '(dired-bind-man nil)
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
