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

(defun cwheel--operate (fn)
  (save-excursion
    (save-match-data
      (let* ((deactivate-mark nil)
             (start (if (region-active-p) (region-beginning)

                      (if (looking-at "#") (point)
                        (progn (re-search-backward "#")
                               (match-beginning 0)))))
             (end (if (region-active-p) (region-end) (+ start 7))))
        (goto-char start)
        (while (re-search-forward "#\\([a-fA-F[:digit:]]\\{6\\}\\)"
                                  end
                                  t)

          (let* ((s (match-string 1))
                 (r (/ (read (concat "#x" (substring s 0 2))) 255.0))
                 (g (/ (read (concat "#x" (substring s 2 4))) 255.0))
                 (b (/ (read (concat "#x" (substring s 4 6))) 255.0))
                 (c3 (apply #'color-hsl-to-rgb
                            (apply fn
                                   (color-rgb-to-hsl r g b)
                                   ))))
            (replace-match (apply #'format "%02x%02x%02x"
                                  (mapcar (lambda (x) (truncate (* x 255))) c3)) t t nil 1)))))))

(defun cwheel-lighten ()
  (interactive)
  (cwheel--operate (lambda (h s v) (list h s (min 1 (+ v 0.04))))))

(defun cwheel-darken ()
  (interactive)
  (cwheel--operate (lambda (h s v) (list h s (max 0 (- v 0.04))))))

(defun cwheel-saturate ()
  (interactive)
  (cwheel--operate (lambda (h s v) (list h (min 1 (+ s 0.04)) v))))

(defun chweel-desaturate ()
  (interactive)
  (cwheel--operate (lambda (h s v) (list h (max 0 (- s 0.04)) v))))

(defun cwheel-hue-up ()
  (interactive)
  (cwheel--operate (lambda (h s v) (list (min 1 (+ h 0.04)) s v))))

(defun cwheel-hue-down ()
  (interactive)
  (cwheel--operate (lambda (h s v) (list (max 0 (- h 0.04)) s v))))


(req-package hydra
  :config
  )

;; #8cfecb
;; #fe4735
