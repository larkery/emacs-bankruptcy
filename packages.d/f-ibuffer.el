(with-eval-after-load
    'ibuffer

  (defun ibuffer-recent-buffer (o &rest args) ()
       "Open ibuffer with cursor pointed to most recent buffer name"
       (let ((last-buffer (if (minibufferp) (buffer-name (minibuffer-selected-window))
                            (buffer-name))))
         (apply o args)
         (ibuffer-jump-to-buffer last-buffer)
         (let ((ln (save-excursion
                     (goto-char (point-max))
                     (line-number-at-pos))))
           (set-window-text-height (get-buffer-window)
                                   (min 15 ln)))))

  (advice-add #'ibuffer :around #'ibuffer-recent-buffer)

  (define-ibuffer-column display-time
    (:inline t :name "Seen")
    (let* ((delta (time-subtract (current-time) buffer-display-time))
           (lsec (nth 1 delta)))
      (cond
       ((< lsec 60) "now")
       ((< lsec 1800)
        (format "%dm" (/ lsec 60)))
       ((< lsec (* 3600 7))
        (format "%dh" (/ lsec 3600)))
       (t ".")
       ))))
