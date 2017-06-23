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
                (concat " " (propertize (concat (tramp-file-name-user parts) "@" (tramp-file-name-host parts))
                                        'face 'mode-line-emphasis)))))

   (vc-mode vc-mode)

   (:eval
    (my-mode-line-pad-right
     (list
      '(:propertize (:eval (anzu--update-mode-line)) face 'mode-line-emphasis)
      mode-line-misc-info " " mode-line-modes)
     ))))
