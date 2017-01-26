(defun org-numbers-overlay-toggle ()
  (interactive)

  (let ((levels (make-vector 10 0))
        (existing (loop for o in (overlays-in (point-min) (point-max))
                        if (eq (overlay-get o 'type) 'org-number)
                        collect o)))

    (if existing
        (dolist (o existing)
          (delete-overlay o))
      (save-excursion
        (widen)
        (goto-char (point-min))
        (while (outline-next-heading)
          (let* ((detail (org-heading-components))
                 (level (- (car detail) 1))
                 (lcounter (1+ (aref levels level)))
                 (o (make-overlay (point) (+ (point) (car detail))))
                 )
            ;; we need to increment the counter at this level
            ;; and zero the counter at subsequent levels
            (aset levels level lcounter)
            (loop for i from (1+ level) to 9
                  do (aset levels i 0))
            (overlay-put o 'type 'org-number)
            (overlay-put o 'after-string
                         (let (s)
                           (loop for i across levels
                                 until (zerop i)
                                 do (setf s (if s (format "%s.%d" s i)
                                              (format " %d" i))
                                          ))
                           s))))))))
