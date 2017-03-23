(defcustom org-log-location
  '("~/notes/journal/%Y.org"
    "* %B"
    "** %A %e %B, %Y")
  "A list of strings, each of which will be used with `format-time-string'.
The first will find a file, and the rest headings and subheadings and so on.")

(defun org-log-goto (&optional date)
  (interactive)

  (cl-loop for part in org-log-location
           for ix from 0
           do (setq part (format-time-string part date))
           do (if (zerop ix)
                  (progn (find-file part)
                         (goto-char (point-min)))
                (unless (search-forward-regexp (rx-to-string `(seq bol ,part)) nil t)
                  (goto-char (point-max))
                  (insert part "\n"))
                (org-narrow-to-element)))
  (goto-char (point-max))
  (widen)
  (org-cycle '(4))
  (org-reveal))


(provide 'org-log)
