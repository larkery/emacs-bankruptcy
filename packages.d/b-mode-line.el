(defun mode-line-pad-right (rhs)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (let* ((the-rhs (format-mode-line rhs))
         (reserve (length the-rhs)))
    (list (propertize " " 'display `((space :align-to (- right ,reserve)))) rhs)))

(unless (fboundp 'anzu--update-mode-line)
  (defun anzu--update-mode-line (&rest _) ""))

(defvar mode-line-projectile-map (make-mode-line-mouse-map 'mouse-1 #'projectile-dired-other-window))
(defvar mode-line-buffer-name-map (make-mode-line-mouse-map 'mouse-1 #'dired-other-window))

(defun mode-line-get-buffer-name-face ()
  (let ((out '(mode-line-buffer-id)))
    (when buffer-read-only (setq out (cons 'mode-line-read-only out)))
    (when (buffer-modified-p) (setq out (cons 'mode-line-modified out)))
    out))

(defun mode-line-get-project ()
  (when (and (buffer-file-name)
             (featurep 'projectile)
             (not (file-remote-p (buffer-file-name)))
             (projectile-project-p))
    (let ((root (projectile-project-root)))
      (when (string-prefix-p root (buffer-file-name))
        (concat " (" (propertize (projectile-project-name)
                                 'face 'italic
                                 'mouse-face 'mode-line-highlight
                                 'local-map mode-line-projectile-map
                                 ) ")")))))

(defun mode-line-get-host ()
  (when (and (buffer-file-name)
             (file-remote-p (buffer-file-name)))
    (let ((parts (tramp-dissect-file-name (buffer-file-name))))
      (concat " "
              (tramp-file-name-user parts)
              "@"
              (tramp-file-name-host parts)
              ))))

(setq-default
 mode-line-format
 `("%5l "
   (:eval (propertize "%b"
                      'face (mode-line-get-buffer-name-face)
                      'mouse-face 'mode-line-highlight
                      'local-map mode-line-buffer-name-map))
   (:eval (mode-line-get-project))
   (:eval (mode-line-get-host))
   (vc-mode vc-mode)
   (:eval (mode-line-pad-right
           `((:propertize (:eval (anzu--update-mode-line)) face 'mode-line-emphasis)
             ,mode-line-misc-info
             " "
             ,mode-line-modes)))))

(setq-default
 mode-line-modes
 (let ((recursive-edit-help-echo "Recursive edit, type C-M-c to get out"))
   (list (propertize "%[" 'help-echo recursive-edit-help-echo)
         "("
         `(:propertize ("" mode-name)
                       help-echo "Major mode\n\
mouse-1: Display major mode menu\n\
mouse-2: Show help for major mode\n\
mouse-3: Toggle minor modes"
                       mouse-face mode-line-highlight
                       local-map ,mode-line-major-mode-keymap)
         '("" mode-line-process)
         `(:propertize ("" minor-mode-alist)
                       mouse-face mode-line-highlight
                       help-echo "Minor mode\n\
mouse-1: Display minor mode menu\n\
mouse-2: Show help for minor mode\n\
mouse-3: Toggle minor modes"
                       local-map ,mode-line-minor-mode-keymap)
         '(:eval
           (when (buffer-narrowed-p)
             (propertize " ><" 'help-echo "mouse-2: Remove narrowing from buffer"
                         'mouse-face 'mode-line-highlight
                         'local-map (make-mode-line-mouse-map
                                     'mouse-2 #'mode-line-widen))))

         ")"
         (propertize "%]" 'help-echo recursive-edit-help-echo)
         " ")))
