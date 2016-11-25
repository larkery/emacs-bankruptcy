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
         (if (eq last-command 'endless/fill-or-unfill)
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

(dolist (binding
	 `(("C-x C-b" . ibuffer)
	   ("C-x k"   . my-kill-this-buffer)
	   ("M-/" . hippie-expand)
	   ("C-z" . undo)
       ("C-x C-a" . my-sudo-edit)
	   ([remap just-one-space] . my-just-one-space)

       ("C-c t" . my-tabulate)
       ("C-c d" . dired-ffap)

       ("<f8> <f6>" . delete-other-windows)
       ("<f8> <f7>" . delete-window)
       ("<f8> <f8>" . my-split-window)
       ("<f8> <f9>" . make-frame-command)
       ("C-c C-/" . my-insert-file-name)

  ;;     ("C-v f" . delete-other-windows)
    ;;   ("C-v d" . delete-window)
;;       ("C-v c" . ctl-x-5-prefix)
;;       ("C-v s" . my-split-window)
;;       ("C-v b" . ctl-x-4-prefix)
;;       ("C-M-v" . scroll-up-command)
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
