(defun my-mode-line-pad-right (rhs)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (let* ((the-rhs (format-mode-line rhs))
         (reserve (length the-rhs)))
    (list (propertize " " 'display `((space :align-to (- right ,reserve)))) rhs)))

(setq-default
 mode-line-format
 `("%5l "
   (:eval (propertize "%b" 'face
                      (remove-if-not
                       #'identity
                       (list
                        (when buffer-read-only    'error)
                        (when (buffer-modified-p) 'underline)
                        'mode-line-buffer-id))))

   (:eval (if (and (buffer-file-name) (file-remote-p (buffer-file-name)))
              (let ((parts (tramp-dissect-file-name (buffer-file-name))))
                (concat " " (propertize (concat (tramp-file-name-user parts) "@"
                                                (car (split-string (tramp-file-name-host parts) "\\.")))
                                        'face 'mode-line-emphasis)))))

   (vc-mode vc-mode)

   (:eval
    (my-mode-line-pad-right
     (list
      '(:propertize (:eval (anzu--update-mode-line)) face 'mode-line-emphasis)
      mode-line-misc-info " " mode-line-modes)
     ))))


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
