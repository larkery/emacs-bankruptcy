(defun math-eval-line ()
    (interactive)

    (save-excursion
      (save-restriction
        (let ((bounds (bounds-of-thing-at-point 'line)))
          (narrow-to-region (car bounds) (cdr bounds))
          (goto-char (point-min))

          (let* ((eqlsign (search-forward "=" nil t))
                 (result (condition-case nil
                             (calc-eval
                              (buffer-substring-no-properties
                               (point-min)
                               (- (or eqlsign (1+ (point-max))) 1)))
                           (error "error"))))
            (when eqlsign
              (delete-region (- eqlsign 1) (point-max)))
            (goto-char (point-max))
            (unless (looking-at " ") (insert " "))
            (insert (format "= %s" result)))
          ))))

(bind-key "<C-return>" #'math-eval-line)
