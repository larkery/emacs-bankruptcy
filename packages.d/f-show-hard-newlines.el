;; -*- lexical-binding: t -*-

(defface hard-newline-face '((t (:foreground "grey80")))
  "Face for showing where hard newlines are")

(define-minor-mode show-hard-newlines-mode
  "Display hard newlines differently"
  nil " ¶" nil
  (if show-hard-newlines-mode
      (save-excursion
        (save-restriction
          (widen)
          (show-hard-newlines (point-min) (point-max))
          (add-hook 'after-change-functions 'show-hard-newlines nil t)))
    (save-excursion
      (save-restriction
        (widen)
        (remove-hook 'after-change-functions
                     'show-hard-newlines
                     t)
        (hide-hard-newlines (point-min) (point-max))))))

(defun hide-hard-newlines (from to)
  (save-excursion
    (goto-char from)
    (while (search-forward "\n" to t)
      (let ((pos (1- (point))))
        (when (get-text-property pos 'hard)
          (remove-text-properties pos (1+ pos) '(display nil)))))))

(defun show-hard-newlines (from to &rest _ignore)
  (save-excursion
    (when use-hard-newlines
      (goto-char from)
      (while (search-forward "\n" to t)
        (let ((pos (1- (point))))
          (if (and (get-text-property pos 'hard)
                   (not
                    (save-excursion
                      (forward-char -2)
                      (looking-at "\n"))
                    ))
              ;; Use `copy-sequence', because display property values must not be `eq'!
              (add-text-properties pos (1+ pos)
                                   (list 'display
                                         (propertize
                                          "¶\n"
                                          'font-lock-face 'hard-newline-face)))
            (remove-text-properties pos (1+ pos) '(display nil))))
        ))))
