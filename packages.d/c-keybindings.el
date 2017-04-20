;; basic keybindings which aren't package-specific
(defun my-kill-this-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

(defun my-just-one-space ()
  (interactive)
  (cycle-spacing -1 t))

(defun my-tabulate ()
  (interactive)
  (let ((a (region-beginning))
        (b (region-end)))
    (align-regexp
     a b
     "\\(\\s-*\\) "
     0
     1
     t)
    (indent-region a b)))

(defun insert-date (p)
  "Insert date (and time, with C-u)"
  (interactive "P")
  (insert (format-time-string
           (cond
            (p "%c")
            (t "%x")))))

(defun my-split-window ()
  (interactive)
  (let ((fwidth (frame-pixel-width))
        (width (window-pixel-width)))
    (if (or (< width (* 0.6 fwidth))
            (< (window-text-width) 120))
        (split-window-below)
      (split-window-right)))
  (balance-windows))

(defun delete-window-or-frame (&optional window)
  (interactive)
  (let* ((window (or window (get-buffer-window)))
         (frame (window-frame window))
         (siblings (window-list frame)))
    (if (= 1 (length siblings))
        (delete-frame frame)
      (delete-window window))))

(defun xman (args)
  (with-current-buffer (man args)
    (local-set-key
     (kbd "q")
     #'delete-window-or-frame)))

(defun my-sudo-edit (prefix)
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

(defun my-insert-file-name (filename &optional args)
  "Insert name of file FILENAME into buffer after point.

  Prefixed with \\[universal-argument], expand the file name to
  its fully canocalized path.  See `expand-file-name'.

  Prefixed with \\[negative-argument], use relative path to file
  name from current directory, `default-directory'.  See
  `file-relative-name'.

  The default with no prefix is to insert the file name exactly as
  it appears in the minibuffer prompt."
  ;; Based on insert-file in Emacs -- ashawley 20080926
  (interactive "*fInsert file name: \nP")
  (cond ((eq '- args)
         (insert (expand-file-name filename)))
        ((not (null args))
         (insert filename))
        (t
         (insert (file-relative-name filename)))))

;;(unbind-key "C-v")

(defun my-fill-or-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'my-fill-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))

(global-set-key [remap fill-paragraph] #'my-fill-or-unfill)

(defun my-adv-multi-pop-to-mark (orig-fun &rest args)
  "Call ORIG-FUN until the cursor moves.
Try the repeated popping up to 10 times."
  (let ((p (point)))
    (dotimes (i 10)
      (when (= p (point))
        (apply orig-fun args)))))

(advice-add 'pop-to-mark-command :around #'my-adv-multi-pop-to-mark)

(defun dired-ffap ()
  (interactive)
  (condition-case x
      (dired-find-file-other-window)
    (error (dired-jump-other-window))))

(defun run-terminal-here ()
  (interactive)
  (call-process "urxvt" nil 0 nil))

(defun my-cycle-case (p m)
  (interactive "r")
  ;; wor_d -> woR_d -> WOR_D -> wor_d
  (let* ((bounds (if (region-active-p)
                     (cons p m)
                   (bounds-of-thing-at-point 'symbol)))

         (thing (buffer-substring (car bounds) (cdr bounds)))
         (uthing (upcase thing)))
    ;; (delete-region)
    (cond
     ;; all uppercase, downcase whole thing
     ((string= thing uthing)
      (downcase-region (car bounds) (cdr bounds)))
     ;; char at point is uppercase word char, uppercase whole thing
     ((string= (substring thing 0 1)
               (substring uthing 0 1))
      (upcase-region (car bounds) (cdr bounds)))
     ;; char at point is lowercase word char, uppercase char at point
     (t (upcase-region (car bounds) (1+ (car bounds)))))))

(defun ibuffer-recent-buffer (o &rest args) ()
       "Open ibuffer with cursor pointed to most recent buffer name"
       (let ((last-buffer (if (minibufferp) (buffer-name (minibuffer-selected-window))
                            (buffer-name))))
         (apply o args)
         (ibuffer-jump-to-buffer last-buffer)
         (let ((ln (save-excursion
                     (goto-char (point-max))
                     (line-number-at-pos))))
           (set-window-text-height (get-buffer-window)
                                   (min 15 ln)))))

(advice-add #'ibuffer :around #'ibuffer-recent-buffer)
(with-eval-after-load
    'ibuffer
  (define-ibuffer-column display-time
    (:inline t :name "Seen")
    (let* ((delta (time-subtract (current-time) buffer-display-time))
           (lsec (nth 1 delta)))
      (cond
       ((< lsec 60) "now")
       ((< lsec 1800)
        (format "%dm" (/ lsec 60)))
       ((< lsec (* 3600 7))
        (format "%dh" (/ lsec 3600)))
       (t ".")
       ))))

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

(dolist (binding
	 `(("C-x C-b" . ibuffer)
	   ("C-x k"   . my-kill-this-buffer)
	   ("M-/" . hippie-expand)
	   ("C-z" . undo)
           ("C-x C-a" . my-sudo-edit)
	   ([remap just-one-space] . my-just-one-space)
           ([remap narrow-to-region] . narrow-dwim)

           ("C-c t t" . my-tabulate)
           ("C-c t a" . align-regexp)
           ("C-c t A" . align)
           ("C-x d" . dired-ffap)

           ("<XF86Launch9>" . switch-to-next-buffer)
           ("<XF86Launch8>" . switch-to-prev-buffer)
           ("C-c C-/" . my-insert-file-name)
           ("M-o" . other-window)
	   ))
  (let ((key (car binding))
	(action (cdr binding)))
    (global-set-key
     (if (stringp key) (kbd key) key)
     action)))

(defun my-insert-date ()
    (interactive)
  (insert (shell-command-to-string "date -I"))
  (call-interactively 'backward-delete-char))
