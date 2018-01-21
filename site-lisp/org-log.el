(require 'org-util)

(defcustom org-log-location
  '("~/notes/journal/%Y/%B.org"
    "[%Y-%m-%d %a]")
  "A list of strings, each of which will be used with `format-time-string'.
The first will find a file, and the rest headings and subheadings and so on.")

(defun org-log-goto (&optional date)
  (interactive)

  (when (eq major-mode 'calendar-mode)
    (let ((dt (calendar-cursor-to-date)))
      (when dt
        (setq date (encode-time 0 0 0 (nth 1 dt) (nth 0 dt) (nth 2 dt))))))

  (with-current-buffer
      (org-goto-path (mapcar (lambda (x) (format-time-string x date))
                             org-log-location))
    (outline-show-subtree)
    (org-narrow-to-subtree)
    (let ((here (point))
          (end (point-max)))
      (widen)
      (outline-hide-sublevels 1)
      (goto-char here)
      (outline-show-subtree)
      (goto-char end))))


(provide 'org-log)
