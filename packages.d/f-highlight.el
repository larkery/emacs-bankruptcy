(defun highlight-region (u p m)
  (interactive "P\nr")

  (if u
      (hi-lock-unface-buffer t)
      (progn (unless (region-active-p)
               (let ((bounds (bounds-of-thing-at-point 'line)))
                 (setq p (car bounds)
                       m (cdr bounds))))


             (highlight-regexp
              (regexp-quote (buffer-substring-no-properties p m))
              (nth
               (mod (length hi-lock-interactive-patterns)
                    (length hi-lock-face-defaults))
               hi-lock-face-defaults)))
      )
  )

(bind-key "M-s h RET" #'highlight-region)
(bind-key "C-'" #'highlight-region)
