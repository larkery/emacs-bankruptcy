;;; notmuch-extras.el --- some things to make notmuch better

;;; Commentary:

;;;; S drive wrangling

(defvar h/notmuch-mouse-map (make-sparse-keymap))
(define-key h/notmuch-mouse-map [mouse-1]
  (lambda ()
    (interactive)
    (browse-url (w3m-anchor))))

(defun h/hack-w3m-links ()
  "modify all w3m anchors in this buffer to open with browse-url"
  (let ((was-read-only buffer-read-only))
    (when was-read-only
      (read-only-mode -1))
    (save-restriction
      (widen)
      (save-excursion
        (let ((last nil)
              (end (point-max))
              (pos (point-min)))

          (while (and pos (< pos end))
            (setq pos (next-single-property-change pos 'w3m-anchor-sequence))
            (when pos
              (if (get-text-property pos 'w3m-anchor-sequence)
                  (setq last pos)
                (put-text-property last pos 'keymap h/notmuch-mouse-map)))))))

    (when was-read-only
      (read-only-mode 1))))

;;;; Polling without blocking

(defvar h/notmuch-already-polling nil)
(defun h/notmuch-poll-and-refresh (p)
  (interactive "p")
  "Asynchronously poll for mail, and when done refresh all notmuch search buffers that are open"
  (interactive)
  (if h/notmuch-already-polling
      (message "Already checking mail!")
    (progn
      (message "Checking mail...")
      (setf h/notmuch-already-polling t)
      (with-current-buffer (get-buffer-create " *notmuch-poll*")
        (erase-buffer))

      (let* ((process-environment
              (if (= 1 p) process-environment
                (cons (format "FULL=%s" p) process-environment)))
             (the-process
              (if (and notmuch-poll-script (not (= "" notmuch-poll-script)))
                  (start-process "notmuch-poll" " *notmuch-poll*" notmuch-poll-script)
                (start-process "notmuch-poll" " *notmuch-poll*" notmuch-command "new")))
             (buf (process-buffer the-process)))

        (set-process-sentinel
         the-process
         (lambda (process e)
           (when (eq (process-status process) 'exit)
             (save-excursion
               (let ((last-line
                      (with-current-buffer (process-buffer process)
                        (goto-char (point-max))
                        (previous-line)
                        (thing-at-point 'line t))))
                 (message (format "notmuch: %s" (substring last-line 0 (- (length last-line) 1))))))
                                        ;(kill-buffer (process-buffer process))
             (dolist (b (buffer-list))
               (when (eq major-mode 'notmuch-search-mode)
                 (if (get-buffer-window b)
                     (call-interactively #'notmuch-refresh-this-buffer)
                   ;; todo mark window for later refresh
                   ;; needs set local variable,
                   ;; dolist visible buffers: refresh this buffer if var; clear var

                   )))

             (setf h/notmuch-already-polling nil))
           ))))))


(bind-key "G" #'h/notmuch-poll-and-refresh notmuch-search-mode-map)

(provide 'notmuch-extras)

;;; notmuch-extras.el ends here
