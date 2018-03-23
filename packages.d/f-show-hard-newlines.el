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

(defun harden-paragraph-breaks ()
  (interactive)
  (let ((start (if (region-active-p (region-beginning) (point-min))))
        (end (if (region-active-p (region-end) (point-max)))))
    (save-mark-and-excursion
     (goto-char start)
     (while (search-forward "\n" end t)
       (let ((pos (point)))
         (move-to-left-margin)
         (when (looking-at paragraph-start)
           (set-hard-newline-properties (1- pos) pos))
         ;; If paragraph-separate, newline after it is hard too.
         (when (looking-at paragraph-separate)
           (set-hard-newline-properties (1- pos) pos)
           (end-of-line)
           (unless (eobp)
             (set-hard-newline-properties (point) (1+ (point))))))))))

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
                   ;; (not
                   ;;  (save-excursion
                   ;;    (forward-char -2)
                   ;;    (looking-at "\n"))
                   ;;  )
                   )
              ;; Use `copy-sequence', because display property values must not be `eq'!
              (add-text-properties pos (1+ pos)
                                   (list 'display
                                         (propertize
                                          "¶\n"
                                          'font-lock-face 'hard-newline-face)))
            (remove-text-properties pos (1+ pos) '(display nil))))
        ))))
