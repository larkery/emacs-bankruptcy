(defun highlight-region (p m)
  (interactive "r")
  (when (region-active-p)
    (highlight-regexp
    (regexp-quote (buffer-substring-no-properties p m))
    (nth
     (mod (length hi-lock-interactive-patterns)
          (length hi-lock-face-defaults))
     hi-lock-face-defaults))))

(bind-key "M-s h RET" #'highlight-region)
(bind-key "C-'" #'highlight-region)
