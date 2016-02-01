(defun sudo-edit ()
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

(bind-key "H-s" #'sudo-edit)
(bind-key "C-x C-z" #'sudo-edit)

(defun crontab-e ()
    (interactive)
    (with-editor-async-shell-command "crontab -e"))