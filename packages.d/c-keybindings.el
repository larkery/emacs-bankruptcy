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
  (let ((width (window-pixel-width))
        (height (window-pixel-height)))
    (select-window
     (cond
      ((and (> width 450)
            (> width height))
       (split-window-right))
      (t
       (split-window-below))
      ))))

(defun my-sudo-edit ()
  (interactive)

  (let ((the-place (or buffer-file-name default-directory)))
    (if (file-remote-p the-place)
        (let* ((dat (tramp-dissect-file-name the-place))
               (u (tramp-file-name-user dat))
               (m (tramp-file-name-method dat))
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

                           "sudo:root@" h

                           tramp-postfix-host-format

                           l)))

          (find-alternate-file sudo-path))
      ;; non-remote files are easier

      (find-alternate-file (concat "/sudo:root@" (system-name) ":" the-place)))))


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

(dolist (binding
	 `(("C-x C-b" . ibuffer)
	   ("C-x k"   . my-kill-this-buffer)
	   ("M-/" . hippie-expand)
	   ("C-z" . undo)
       ("C-x C-a" . my-sudo-edit)
	   ([remap just-one-space] . my-just-one-space)

       ("C-c t" . my-tabulate)
       ("<f1>" . delete-other-windows)
       ("<f2>" . my-split-window)
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
