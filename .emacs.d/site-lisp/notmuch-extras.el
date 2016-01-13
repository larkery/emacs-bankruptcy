;;; notmuch-extras.el --- some things to make notmuch better

;;; Commentary:

;;;; S drive wrangling

(defun h/mangle-url (url)
  "If the url starts with file:// then fiddle it to point to ~/net/CSE instead"
  ;; TODO call gvfs mount also
  (let* ((parsed (url-generic-parse-url url))
         (type (url-type parsed))
         (fn (url-filename parsed)))

    (if (equal "file" type)
        (let ((unix-path
               (replace-regexp-in-string
                "^/+" "/"
                (replace-regexp-in-string "\\\\" "/" (url-unhex-string fn)))))

          (dolist (map '( ("/CSE-BS3-FILE/[Dd][Aa][Tt][Aa]/" . "~/net/S/") ))
            (setq unix-path (replace-regexp-in-string (car map) (cdr map) unix-path)))
          (progn (message "%s" (format "file: %s" unix-path)))
          (cons t (expand-file-name unix-path)))
      (progn
        (message "%s" (format "url: %s" url))
        (cons nil url)))))

(defun h/open-mail-link (url file-fn url-fn)
  (message "%s" url)
  (let ((parse (h/mangle-url url)))
    (funcall (if (car parse) file-fn url-fn)
             (cdr parse))))

(defun h/open-mail-here ()
  (interactive)
  (h/open-mail-link (w3m-anchor)
                    (lambda (path) (find-file path))
                    #'browse-url))

(defun h/open-mail-there ()
  (interactive)
  (h/open-mail-link (w3m-anchor)
                    (lambda (path) (h/run-ignoring-results "xdg-open" path))
                    #'browse-url))

(defun h/open-mail-dired ()
  (interactive)
  (h/open-mail-link (w3m-anchor)
                    (lambda (path)
                      (message (format "dired %s" path))
                      (dired (file-name-directory path)))
                    #'browse-url))

(defun h/run-ignoring-results (&rest command-and-arguments)
  "Run a command in an external process and ignore the stdout/err"
  (let ((process-connection-type nil))
    (apply #'start-process (cons "" (cons nil command-and-arguments)))))

(defvar h/notmuch-mouse-map (make-sparse-keymap))

(define-key h/notmuch-mouse-map [mouse-1] #'h/open-mail-here)
(define-key h/notmuch-mouse-map [mouse-2] #'h/open-mail-there)
(define-key h/notmuch-mouse-map [mouse-3] #'h/open-mail-dired)

(defun h/hack-file-links ()
  "when in a buffer with w3m anchors, find the anchors and change them so clicking file:// paths uses h/open-windows-mail-link"
  (interactive)

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
