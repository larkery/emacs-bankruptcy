(defvar ivy--fancy-spare-space 0)

(defun add-face (str prop)
  (if prop (propertize str 'face prop) str))

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
                    do (setq len (+ 2 (- len (length part))))
                    else concat part

                    concat "/")))))
  path)

(defun ivy--fancy-buffer-directory (buffer-name)
  (let ((full-name (abbreviate-file-name
                    (if-let ((buffer (get-buffer buffer-name)))
                        (with-current-buffer buffer default-directory)
                      (file-name-directory (cdr (assq buffer-name ivy--virtual-buffers)))))))
    (if (file-remote-p full-name)
        (let* ((parts (tramp-dissect-file-name full-name))
              (hostpart (add-face
                         (concat
                          (tramp-file-name-user parts)
                          (when (> (length (tramp-file-name-user parts)) 0) "@")
                          (car (split-string (tramp-file-name-host parts) "\\.")))
                         '(:background "darkred"))))
          (concat
           hostpart
           ":"
           (ivy--fancy-compress-path (tramp-file-name-localname parts)
                                     (- ivy--fancy-spare-space (length hostpart) 1))))
      (ivy--fancy-compress-path full-name ivy--fancy-spare-space))))

(defun ivy--fancy-buffer-host (buffer-name)
  (or (let* ((file-name
           (if-let ((buffer (get-buffer buffer-name)))
               (with-current-buffer buffer default-directory)
             (cdr (assq buffer-name ivy--virtual-buffers)))))
     (if (file-remote-p file-name)
         (if-let ((parts (tramp-dissect-file-name file-name)))
             (car (split-string (tramp-file-name-host parts) "\\.")))))
      ""))

(defun ivy--fancy-buffer-name (buffer-name)
  (add-face
   buffer-name
   (if-let ((buffer (get-buffer buffer-name)))
       (let ((cmm major-mode))
         (with-current-buffer buffer
           (or (cdr (assoc major-mode ivy-switch-buffer-faces-alist))
               (unless buffer-file-name 'shadow)
               (when (eq cmm major-mode) 'mode-line-buffer-id))))
     'ivy-virtual)))

(setq ivy-switch-buffer-faces-alist '((dired-mode . ivy-subdir)
                                      (notmuch-show-mode . (:underline t))
                                      (notmuch-search-mode . (:underline t))
                                      (notmuch-message-mode . (:underline t))
                                      ))

(defvar ivy--fancy-buffer-columns
  `((ivy--fancy-buffer-name "%-40.45s")
    (ivy--fancy-buffer-mode " %9.9s  " (:foreground "darkorange"))
    (ivy--fancy-buffer-project " %-8.8s  " (:foreground "darkcyan"))
    (ivy--fancy-buffer-directory " %s")))

(defmacro ivy--fancy-buffer-action (x &rest args)
  `(let ((,x (if (stringp ,x) ,x (cdr ,x))))
     ,@args))

(defun ivy--fancy-switch-buffer ()
  (let* ((buffers (ivy--buffer-list "" ivy-use-virtual-buffers))
         (default (buffer-name (other-buffer (current-buffer))))
         (buffers (delete-duplicates (cons default buffers)
                                     :from-end t
                                     :test #'string=))
         (choices (mapcar (lambda (buffer)
                            (cons (let ((ivy--fancy-spare-space (- (window-width) 4)))
                                    (mapconcat
                                     (lambda (column)
                                       (let ((text (add-face
                                                    (funcall #'format (cadr column) (funcall (car column) buffer))
                                                    (caddr column))))
                                         (setq ivy--fancy-spare-space (- ivy--fancy-spare-space (length text)))
                                         text))
                                     ivy--fancy-buffer-columns ""))

                                   buffer))
                         buffers))
         )

    (ivy-read "Switch to buffer: "
              choices
              :action (lambda (x)
                        (ivy--fancy-buffer-action x (ivy--switch-buffer-action x)))
              :keymap ivy-switch-buffer-map
              :sort nil)
    ))

(ivy-set-actions
 'ivy-switch-buffer
 '(("k"
    (lambda (x)
      (ivy--fancy-buffer-action x (kill-buffer x))
      (ivy--reset-state ivy-last))
    "kill")
   ("j"
    (lambda (x)
      (ivy--fancy-buffer-action x (ivy--switch-buffer-other-window-action x)))
    "other window")
   ("r"
    (lambda (x) (ivy--fancy-buffer-action x (ivy--rename-buffer-action x)))
    "rename")))

(defun ivy-switch-buffer ()
  "Switch to another buffer."
  (interactive)
  (progn
    (if (not ivy-mode)
	(call-interactively 'switch-to-buffer)
      (let ((this-command 'ivy-switch-buffer))
	(ivy--fancy-switch-buffer)))))

(provide 'ivy-fancy-buffer-menu)
