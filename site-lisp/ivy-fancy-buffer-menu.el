
(defun add-face (str prop)
  (if prop
      (propertize str 'face
                  (append (get-text-property 0 'face str) prop))
    str))

(defun ivy--fancy-buffer-mode (buffer-name)
  (if-let ((buffer (get-buffer buffer-name)))
      (with-current-buffer buffer
        mode-name)
    ""))

(defun ivy--fancy-buffer-project (buffer-name)
  (if-let ((buffer (get-buffer buffer-name)))
      (with-current-buffer buffer (projectile-project-name))
    ""))

(defun ivy--fancy-compress-path (path mlen)
  (let ((len (length path)))
    (when (> len mlen)

      (let ((parts (split-string (substring path 0 (- (length path) 1)) "/")))
        (setq path
              (loop for part in parts
                    unless (zerop (length part))

                    if (and (> len mlen)
                            (> (length part) 1))
                    concat (substring part 0 1) and
                    concat "…" and
                    do (setq len (- len (- (length part) 2)))
                    else concat part

                    concat "/")))))
  path)

(defun ivy--fancy-buffer-directory (buffer-name)
  (let ((full-name (abbreviate-file-name
                    (if-let ((buffer (get-buffer buffer-name)))
                        (with-current-buffer buffer default-directory)
                      (file-name-directory (cdr (assq buffer-name ivy--virtual-buffers)))))))
    (if (file-remote-p full-name)
        (let ((parts (tramp-dissect-file-name full-name)))
          (concat
           (add-face
            (concat
             (tramp-file-name-user parts)
             (when (> (length (tramp-file-name-user parts)) 0) "@")
             (car (split-string (tramp-file-name-host parts) "\\.")))
            '(:background "darkred"))
           ":"
           (ivy--fancy-compress-path (tramp-file-name-localname parts) 40)))
      (ivy--fancy-compress-path full-name 50))))

(defun ivy--fancy-buffer-host (buffer-name)
  (or (let* ((file-name
           (if-let ((buffer (get-buffer buffer-name)))
               (with-current-buffer buffer default-directory)
             (cdr (assq buffer-name ivy--virtual-buffers)))))
     (if (file-remote-p file-name)
         (if-let ((parts (tramp-dissect-file-name file-name)))
             (car (split-string (tramp-file-name-host parts) "\\.")))))
      ""))


(defvar ivy--fancy-buffer-columns
  `((identity "%-40.45s")

    (ivy--fancy-buffer-mode " %9.9s  " (:foreground "darkorange"))
    (ivy--fancy-buffer-project " %-8.8s  " (:foreground "darkcyan"))
    (ivy--fancy-buffer-directory " %s")))

(defun ivy--fancy-switch-buffer ()
  (let* ((buffers (ivy--buffer-list "" ivy-use-virtual-buffers))
         (default (buffer-name (other-buffer (current-buffer))))
         (buffers (delete-duplicates (cons default buffers)
                                     :from-end t
                                     :test #'string=))
         (choices (mapcar (lambda (buffer)
                            (cons (mapconcat
                                   (lambda (column)
                                     (add-face
                                      (funcall #'format (cadr column) (funcall (car column) buffer))
                                      (caddr column)))
                                   ivy--fancy-buffer-columns "")

                                   buffer))
                         buffers))
         )

    (ivy-read "Switch to buffer: "
              choices
              :action
              (lambda (x)
                (ivy--switch-buffer-action (if (stringp x) x (cdr x))))
              :keymap ivy-switch-buffer-map
              :sort nil)
    ))

(defun ivy-switch-buffer ()
  "Switch to another buffer."
  (interactive)
  (progn
    (if (not ivy-mode)
	(call-interactively 'switch-to-buffer)
      (let ((this-command 'ivy-switch-buffer))
	(ivy--fancy-switch-buffer)))))

(provide 'ivy-fancy-buffer-menu)
