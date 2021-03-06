;; -*- lexical-binding: t -*-
(initsplit-this-file bos "dired-")

(with-eval-after-load 'dired
  (require 'dired-x)

  (bind-keys
   :map dired-mode-map
   ("V" . magit-status)
   ("C-x C-f" .  dired-C-x-C-f)
   ("e" .  dired-xdg-open)
   ("K" .  (lambda (arg) (interactive "P")
             (message "%s" arg)
             (if arg
                 (save-excursion
                   (goto-char (point-min))
                   (while (dired-next-subdir (point))
                     (dired-kill-subdir)
                     (goto-char (point-min))))
               (let ((here (dired-current-directory)))
                 (and (dired-goto-subdir here)
                      (progn (dired-do-kill-lines 1)
                             (dired-goto-file here)))))
             ))
   ("I" .  dired-insert-patricidally)
   ("r" .  dired-from-recentf)
   ("^" .  dired-up-directory-here)
   ("C-M-p" . dired-up-directory-here)
   ("J" .  bookmark-jump)
   ("C-c RET" .  run-terminal-here)

   ;; so this is related to mouse-1-click-follows-link
   ;; which makes mouse-1 raise a mouse-2 event on a link.
   ("<mouse-2>" . dired-mouse-insert-or-find-file-other-window)

   ("[" . dired-prev-subdir)
   ("]" . dired-next-subdir)
   ("M-n" . dired-next-subdir)
   ("M-p" . dired-prev-subdir)
   (")" . dired-omit-mode)
   )

  (defvar dired-remembered-state nil)
  (defvar dired-loaded-yet nil)
  (make-variable-buffer-local 'dired-loaded-yet)

  (defun dired-persist (&rest _blah)
    (when (eq dired-loaded-yet t)
      (setq dired-remembered-state
            (cons
             (cons default-directory (dired-get-state))
             (delq (assoc default-directory dired-remembered-state) dired-remembered-state)))))

  (defun dired-restore (&rest _blah)
    (unless dired-loaded-yet
      (setq dired-loaded-yet 'loading)
      (if-let ((state (assoc default-directory dired-remembered-state)))
          (dired-set-state (cdr state)))
      (setq dired-loaded-yet t)))

  (defun dired-get-state ()
    (list :subdirs (mapcar #'car dired-subdir-alist)
          :omit dired-omit-mode
          :details dired-hide-details-mode))

  (defun dired-set-state (state)
    (dolist (subdir (reverse (plist-get state :subdirs)))
      (condition-case nil
          (dired-insert-subdir subdir)
        (error nil)))
    (dired-omit-mode (or (plist-get state :omit) -1))
    (dired-hide-details-mode (or (plist-get state :details) -1)))

  (add-hook 'dired-after-readin-hook #'dired-restore)
  (add-hook 'dired-omit-mode-hook #'dired-persist)
  (add-hook 'dired-hide-details-mode-hook #'dired-persist)

  (advice-add 'dired-do-kill-lines :after #'dired-persist)
  (advice-add 'dired-insert-subdir :after #'dired-persist)

  (defun save-window-start (o &rest args)
    (let* ((inhibit-redisplay t)
           (wins (get-buffer-window-list (current-buffer)))
           (--old-window-starts (mapcar #'window-start wins))
           (result (apply o args)))
      (dolist (w wins)
        (let ((old-start (pop --old-window-starts)))
          (set-window-start w old-start)
          (unless (pos-visible-in-window-p nil w)
            (recenter))))
      result))


  (advice-add 'dired-insert-subdir :around #'save-window-start)

  (defun dired-mouse-insert-or-find-file-other-window (event)
    "In Dired, visit the file or directory name you click on."
    (interactive "e")
    (let (window pos file)
      (save-excursion
        (setq window (posn-window (event-end event))
              pos (posn-point (event-end event)))
        (if (not (windowp window))
            (error "No file chosen"))
        (set-buffer (window-buffer window))
        (goto-char pos)
        (setq file (dired-get-file-for-visit)))
      (if (file-directory-p file)
          (progn (condition-case nil
                     (or (and (cdr dired-subdir-alist)
                              (dired-goto-subdir file))
                         (progn
                           (select-window window)
                           (dired-insert-subdir file)))
                   (error
                    (message "an error")
                    (select-window window)
                    (dired-find-alternate-file)))
                 (call-interactively #'recenter-top-bottom))
        (select-window window)
        (find-file-other-window (file-name-sans-versions file t)))))

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
(add-hook 'dired-mode-hook 'dired-omit-mode)

;;;; use key ')' to toggle omitted files in dired


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
 '(dired-auto-revert-buffer t)
 '(dired-bind-info nil)
 '(dired-bind-jump nil)
 '(dired-bind-man nil)
 '(dired-dwim-target t)
 '(dired-isearch-filenames (quote dwim))
 '(dired-listing-switches "-lah")
 '(dired-omit-files "^\\.[^\\.]")
 '(dired-omit-verbose nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-directory ((t (:inherit font-lock-function-name-face :weight bold)))))
