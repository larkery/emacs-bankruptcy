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

(dolist (binding
	 `(("C-x C-b" . ibuffer)
	   ("C-x k"   . my-kill-this-buffer)
	   ("M-/" . hippie-expand)
	   ("C-z" . undo)
       ("C-x C-a" . my-sudo-edit)       
	   ([remap just-one-space] . my-just-one-space)

           ("C-c t" . my-tabulate)
           ("C-1" . ,(kbd "C-x 1"))
           ("C-2" . ,(kbd "C-x 2"))
           ("C-3" . ,(kbd "C-x 3"))
           ("C-5" . ,(kbd "C-x 0"))
           ("C-4" . ,(kbd "C-x 5 2"))
	   ))
  (let ((key (car binding))
	(action (cdr binding)))
    (global-set-key
     (if (stringp key) (kbd key) key)
     action)))

;; use control h for backspace, we have f1 for help
(define-key key-translation-map [?\C-h] [?\C-?])
