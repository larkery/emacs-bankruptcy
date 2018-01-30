(defun org-goto-path (path &optional ff-command)
    "Find / create an org heading. PATH is a list of strings.
First string is a filename, subsequent strings are heading names, each being
a subheading of the last. Return the buffer, which will be positioned at the heading."
    (let ((ff-command (or ff-command #'find-file))
          (start (car path))
          (path (cdr path)))
      (with-current-buffer
          (funcall ff-command start)
        (save-restriction
          (widen)
          (goto-char (point-min))
          (cl-loop for part in path
                   for ix from 1
                   do
                   (setq part (format "%s %s" (make-string ix ?*) part))
                   (unless (search-forward-regexp (rx-to-string `(seq bol ,part)) nil t)
                     (goto-char (point-max))
                     (insert "\n" part)
                     (unless (looking-at "\n")
                       (save-excursion (insert "\n"))))
                   (beginning-of-line)
                   (org-narrow-to-element)))
        (current-buffer))))

(provide 'org-util)
