(defun align-whitespace (start end)
  "Align region so that non-whitespace bits line up"
  (interactive "r")
  (align-regexp start end
                "\\S-+\\(\\s-+\\)"
                1 1 t))

(defun swap-last-windows ()
  (interactive)

  (let* ((this-window (selected-window))
         (other-window (previous-window this-window))
         (this-buffer (window-buffer this-window))
         (other-buffer (window-buffer other-window)))
    (set-window-buffer this-window other-buffer)
    (set-window-buffer other-window this-buffer)
    (select-window other-window)))

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

(defun minimally-indent (p m)
  (interactive "r")
  (save-excursion
    (save-restriction
      (goto-char p)
      (while (looking-at "^$") (forward-line))
      (let ((mindent (progn (back-to-indentation)
                            (current-column))))
        (while (< (point) m)
          (forward-line)
          (back-to-indentation)
          (unless (looking-at "^$")
            (setq mindent (min mindent (current-column))))
          (end-of-line))
        (forward-line -1)
        (move-to-column mindent)
        (delete-rectangle p (point))
        mindent))))

(defvar remote-editing-position nil)
(make-variable-buffer-local 'remote-editing-position)

(defun remotely-edit-string ()
  "Remotely edit the string at point as in org-mode"
  (interactive)
  (if (not remote-editing-position)
      ;; start editing
      (let* ((string-start (or (nth 8 (syntax-ppss))
                               (error "Not in a string")))
             (string-end (save-excursion (goto-char string-start)
                                         (forward-sexp 1)
                                         (point))))

        ;; remove paired delimiters from the start and end of the string
        (while (string= (buffer-substring string-start (+ 1 string-start))
                        (buffer-substring (- string-end 1) string-end))
          (cl-incf string-start)
          (cl-decf string-end))

        ;; strip out blank start and end lines
        (save-excursion
          (goto-char string-start)
          (when (looking-at (rx (* blank) eol))
            (forward-line 1)
            (beginning-of-line)
            (setq string-start (point)))
          (goto-char string-end)
          (beginning-of-line)
          (when (string-match-p (rx bos (* blank) eos)
                                (buffer-substring (point) string-end))
            (forward-line -1)
            (end-of-line)
            (setq string-end (point))))

        (setq string-start (set-marker (make-marker) string-start)
              string-end (set-marker (make-marker) string-end))

        (let ((text (buffer-substring-no-properties string-start string-end))
              indent)
          (with-current-buffer
              (get-buffer-create "*remote-edit*")

            (switch-to-buffer-other-window (current-buffer))
            (insert text "\n")
            (setq orig-indent (minimally-indent (point-min) (point-max)))
            (normal-mode)
            (goto-char (point-min))
            (setq remote-editing-position (list string-start string-end orig-indent))
            (local-set-key (kbd "C-c C-c") #'remotely-edit-string)
            (local-set-key (kbd "C-c C-k")
                           (lambda ()
                             (interactive)
                             (let ((return-to (car remote-editing-position)))
                               (kill-this-buffer)
                               (condition-case nil
                                   (delete-window)
                                 (error t))
                               (switch-to-buffer (marker-buffer return-to))
                               (goto-char return-to))))

            (local-set-key (kbd "C-c m")
                           (lambda (mode)
                             (interactive (list (read-file-local-variable-value 'mode)))
                             (let ((rep remote-editing-position))
                               (add-file-local-variable-prop-line 'mode mode)
                               (normal-mode)
                               (setq remote-editing-position rep)
                               )
                             )
                           )

            (setq header-line-format (format "Remote editing %s - press C-c C-c to save, C-c C-k to cancel, C-c m to set mode" (buffer-name (marker-buffer string-start))))
            )))

    ;; restore edit
    (let ((position remote-editing-position)
            new-text)
        (goto-char (point-max))
        (when (looking-at (rx bol (* blank) eol))
          (delete-region (save-excursion (forward-line -1)
                                         (end-of-line)
                                         (point))
                         (point)))
        (string-rectangle
         (point-min)
         (save-excursion (goto-char (point-max))
                         (beginning-of-line)
                         (point))
         (make-string (caddr position) ? ))

        (setq new-text (buffer-string))
        (kill-this-buffer)
        (condition-case nil
            (delete-window)
          (error t))

        (with-current-buffer
            (marker-buffer (car position))
          (switch-to-buffer (current-buffer))
          (delete-region (car position) (cadr position))
          (goto-char (car position))
          (insert new-text)
          (goto-char (car position))))))
