(require 'org-misc)

(defcustom org-log-location
  '("~/notes/journal/%Y/Week %W.org"
    "* [%Y-%m-%d %a]")
  "A list of strings, each of which will be used with `format-time-string'.
The first will find a file, and the rest headings and subheadings and so on.")

(defun org-log-goto (&optional date)
  (interactive)

  (let ((ff-command #'find-file))

    (when (eq major-mode 'calendar-mode)
      (let ((dt (calendar-cursor-to-date)))
        (when dt
          (setq date (encode-time 0 0 0 (nth 1 dt) (nth 0 dt) (nth 2 dt))
                ff-command #'find-file-other-window))))

    (cl-loop for part in org-log-location
             for ix from 0
             do (setq part (format-time-string part date))
             do (if (zerop ix)
                    (progn (funcall ff-command part)
                           (goto-char (point-min)))
                  (unless (search-forward-regexp (rx-to-string `(seq bol ,part)) nil t)
                    (goto-char (point-max))
                    (insert part "\n"))
                  (org-narrow-to-element)))
    (goto-char (point-max))
    (widen)
    (org-cycle '(4))
    (org-show-context 'ancestors)))



(provide 'org-log)
