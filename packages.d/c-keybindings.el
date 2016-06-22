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
    (message "%f %f" width height)
    (cond
     ((> width height)
      (split-window-right))
     (t
      (split-window-below))
    ))
  )

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

(unbind-key "C-v")

(dolist (binding
	 `(("C-x C-b" . ibuffer)
	   ("C-x k"   . my-kill-this-buffer)
	   ("M-/" . hippie-expand)
	   ("C-z" . undo)
       ("C-x C-a" . my-sudo-edit)       
	   ([remap just-one-space] . my-just-one-space)

       ("C-c t" . my-tabulate)
       ("<f2>" . my-split-window)
       ("C-v f" . delete-other-windows)
       ("C-v d" . delete-window)
       ("C-v c" . ctl-x-5-prefix)
       ("C-v s" . my-split-window)
       ("C-v b" . ctl-x-4-prefix)
       ("C-M-v" . scroll-up-command)
	   ))
  (let ((key (car binding))
	(action (cdr binding)))
    (global-set-key
     (if (stringp key) (kbd key) key)
     action)))

;; use control h for backspace, we have f1 for help
(define-key key-translation-map [?\C-h] [?\C-?])

;;(lookup-key global-map (kbd "C-x 4"))



