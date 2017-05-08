(defun align-whitespace (start end)
  "Align region so that non-whitespace bits line up"
  (interactive "r")
  (align-regexp start end
                "\\S-+\\(\\s-+\\)"
                1 1 t))

(defun kill-this-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

(defun align-paragraph ()
  (interactive)
  (save-excursion
    (forward-paragraph)
    (let ((here (point)))
      (backward-paragraph)
      (align (point) here))))

(defun cycle-just-one-space ()
  (interactive)
  (cycle-spacing -1 t))

(defun insert-date (p)
  "Insert date (and time, with C-u)"
  (interactive "P")
  (insert (format-time-string
           (cond
            (p "%c")
            (t "%x")))))

(defun xman (args)
  (with-current-buffer (man args)
    (local-set-key
     (kbd "q")
     #'delete-window-or-frame)))

(defun edit-as-root (prefix)
  (interactive "P")

  (let ((target-user (if prefix
                         (completing-read "edit as: " '("root" "nixops"))
                         "root"))
        (the-place (or buffer-file-name default-directory))
        (position (point)))
    (if (file-remote-p the-place)
        (let* ((dat (tramp-dissect-file-name the-place))
               (u (tramp-file-name-user dat))
               (m1 (tramp-file-name-method dat))
               (m (if (string= m1 "scp") "ssh" m1))
               (h (tramp-file-name-host dat))
               (l (tramp-file-name-localname dat))

               (sudo-path (concat
                           tramp-prefix-format

                           (unless (zerop (length m))
                             (concat m tramp-postfix-method-format))

                           (unless (zerop (length u))
                             (concat u tramp-postfix-user-format))

                           (when h
                             (if (string-match tramp-ipv6-regexp h)
                                 (concat tramp-prefix-ipv6-format h tramp-postfix-ipv6-format)
                               h))

                           tramp-postfix-hop-format

                           "sudo:" target-user "@" h

                           tramp-postfix-host-format

                           l)))

          (find-alternate-file sudo-path))
      ;; non-remote files are easier
      (find-alternate-file (concat "/sudo:root@" (system-name) ":" the-place)))
    (goto-char position)))

(defun fill-or-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'my-fill-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))

(defun dired-ffap ()
  (interactive)
  (condition-case x
      (dired-find-file-other-window)
    (error (dired-jump-other-window))))

(defun narrow-dwim (p)
  (interactive "P")
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing
         ;; command. Remove this first conditional if
         ;; you don't want it.
         (cond ((ignore-errors (org-edit-src-code) t)
                (delete-other-windows))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((derived-mode-p 'latex-mode)
         (LaTeX-narrow-to-environment))
        (t (narrow-to-defun))))
