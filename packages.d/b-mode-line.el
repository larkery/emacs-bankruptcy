(defun my-mode-line-pad-right (rhs)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (let* ((the-rhs (format-mode-line rhs))
         (reserve (length the-rhs)))
    (list
     (propertize " "
                 'display `((space :align-to (- right
                                                ,reserve))))
     rhs)))

(setq-default
 mode-line-format
 `("%5l"

   (:eval
    (when (or (< (point-min) (window-start))
              (> (point-max) (window-end)))
      (concat " ["
              (format "%3d%%%%"
                      (/ (* 100 (- (point) (point-min)))
                         (- (point-max) (point-min))))
              "]"
              )))

   " "

   (:eval (propertize
           (if buffer-read-only "! " "")
           'face
           'error))

   (:eval (propertize (concat "%b" ;; (if (buffer-modified-p) "*")
                              )
                      'face (if (buffer-modified-p)
                                'error
                              'mode-line-buffer-id)
                      'help-echo (buffer-file-name)
                      'mouse-face 'mode-line-highlight
                      ))

   (:eval (if (and (buffer-file-name) (file-remote-p (buffer-file-name)))
              (let ((parts (tramp-dissect-file-name (buffer-file-name))))
                (concat " " (propertize (concat (tramp-file-name-user parts) "@" (tramp-file-name-host parts))
                                        'face 'mode-line-emphasis)))
            ))

   (vc-mode vc-mode)

   ""

   (:eval
    (my-mode-line-pad-right
     (list
      global-mode-string
      " "
      mode-line-modes
      '(:propertize (:eval (anzu--update-mode-line)) face 'mode-line-emphasis))

     ))))
