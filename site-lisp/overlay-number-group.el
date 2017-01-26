(defun make-numbers-readable ()
  (interactive)

  (unless
      (let (deleted)
        (loop for o in (overlays-in (point-min) (point-max))
              when (eq (overlay-get o 'type) 'thousands-separator)
              do (delete-overlay o)
              do (setq deleted t))
        deleted)
      (save-match-data
        (save-excursion
          (goto-char (point-min))

          (let ((comma ","))
            (add-face-text-property 0 1 'shadow nil comma)
            (while (re-search-forward
                   (rx (one-or-more digit) (group (optional "." (one-or-more digit))))
                   nil t)
             (let* ((num-start (match-beginning 0))
                    (num-end (match-end 0))
                    (dot (or (match-beginning 1) num-end))
                    )
               (goto-char dot)
               (while (> (point) num-start)
                 (backward-char 3)
                 (when (> (point) num-start)
                   (let ((o (make-overlay (point) (point))))
                     (overlay-put o 'type 'thousands-separator)
                     (overlay-put o 'after-string comma))))
               (goto-char num-end))))))))

(provide 'overlay-number-group)
