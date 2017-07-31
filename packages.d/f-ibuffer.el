(with-eval-after-load
    'ibuffer

  (defun ibuffer-recent-buffer (o &rest args) ()
       "Open ibuffer with cursor pointed to most recent buffer name"
       (let ((last-buffer (if (minibufferp) (buffer-name (minibuffer-selected-window))
                            (buffer-name))))
         (apply o args)
         (ibuffer-jump-to-buffer last-buffer)
         (let* ((ln (save-excursion
                     (goto-char (point-max))
                     (line-number-at-pos)))
                (ht (min (- (frame-text-lines) 10) (max 15 ln))))
           (set-window-text-height (get-buffer-window) ht))))

  (advice-add #'ibuffer :around #'ibuffer-recent-buffer)
  (require 'ibuf-ext)
  )

(with-eval-after-load
    'ibuf-ext
  (define-ibuffer-filter tramp-host
      "Filter based on the remote host"
    (:description
     "remote host"
     :reader
     (completing-read "Host: "
                      (delete-duplicates
                       (loop for b being the buffers
                             if (and (buffer-file-name b) (file-remote-p (buffer-file-name b)))
                             collect (tramp-file-name-host
                                      (tramp-dissect-file-name
                                       (buffer-file-name b))))
                       :test #'string=)))

    (let* ((fn (buffer-file-name buf)))
      (when (and fn (file-remote-p fn))
        (let* ((pts (tramp-dissect-file-name fn))
               (host (tramp-file-name-host pts)))
          (string-match-p (regexp-quote qualifier) host)))))
  (bind-key "/ h" #'ibuffer-filter-by-tramp-host ibuffer-mode-map)
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
