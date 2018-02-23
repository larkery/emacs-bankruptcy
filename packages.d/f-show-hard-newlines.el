(define-minor-mode show-hard-newlines-mode
  "Display hard newlines differently"
  nil " ¶" nil
  (if show-hard-newlines-mode
      (save-restriction
        (widen)
        (show-hard-newlines (point-min) (point-max))
        (add-hook 'after-change-functions 'show-hard-newlines nil t))
    (save-restriction
      (widen)
      (remove-hook 'after-change-functions
                   'show-hard-newlines
                   t)
      (hide-hard-newlines (point-min) (point-max)))))

(defun hide-hard-newlines (from to)
  (goto-char from)
  (while (search-forward "\n" to t)
    (let ((pos (1- (point))))
      (when (get-text-property pos 'hard)
        (remove-text-properties pos (1+ pos) '(display nil))))))

(defun show-hard-newlines (from to &rest _ignore)
  (save-excursion
    (when use-hard-newlines
      (goto-char from)
      (while (search-forward "\n" to t)
        (let ((pos (1- (point))))
          (if (get-text-property pos 'hard)
              ;; Use `copy-sequence', because display property values must not be `eq'!
              (add-text-properties pos (1+ pos) (list 'display (copy-sequence " ¶\n")
                                                      'font-lock-face 'shadow))
            (remove-text-properties pos (1+ pos) '(display nil))))
        ))))
