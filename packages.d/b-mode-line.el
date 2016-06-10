(defun my-mode-line-pad-right (rhs)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (let* ((the-rhs (format-mode-line rhs))
         (reserve (length the-rhs)))
    (when (and window-system (eq 'right (get-scroll-bar-mode)))
      (setq reserve (- reserve 3)))

    (list
     (propertize " "
                 'display `((space :align-to (- (+ right right-fringe right-margin) ,reserve)))
                 )
     rhs)))

(setq-default
 mode-line-format
 `("%4l"

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
           (concat (if (buffer-modified-p) "M" "") (if buffer-read-only "R" "W"))
           'face
           (if (buffer-modified-p) 'mode-line-emphasis nil)
           'help-echo
           (concat (if (buffer-modified-p) "" "un")
                   "modified, "
                   (if buffer-read-only "r/o" "r/w"))
           ))
   " "


   (:eval (propertize "%b"
                      'face 'mode-line-buffer-id
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
      mode-line-modes
      global-mode-string

      '(:propertize (:eval (anzu--update-mode-line))
                    face 'mode-line-emphasis)
      "  ")
     ))

   )
 )
