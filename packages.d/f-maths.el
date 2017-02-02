(defun math-eval-line ()
    (interactive)

    (save-match-data
      (save-excursion
       (save-restriction
         (let ((bounds (bounds-of-thing-at-point 'line))
               equal-sign)
           (narrow-to-region (car bounds) (cdr bounds))
           (goto-char (point-min))

           (when (setq equal-sign (search-forward-regexp "\\([[:space:]]*=\\)\\|\\([[:space:]]+$\\)" nil t))
             (delete-region (match-beginning 0) (point-max)))

           (goto-char (point-max))
           (insert (format " = %s" (calc-eval
                                    (buffer-substring-no-properties
                                     (point-min) (point-max))))))
         ))))

(bind-key "<C-return>" #'math-eval-line)
