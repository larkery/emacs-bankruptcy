;; settings for org mode

(req-package org
  :bind (("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("<f6>"  . my-journal-entry))
  :config

  (require 'org-contacts)
  (require 'org-notmuch)

  (org-clock-persistence-insinuate)
  
  (add-hook 'org-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t)))

  (defun my-org-journal-goto ()
    (interactive)
    (let* ((the-path (format-time-string "~/notes/journal/%Y/%b.org"))
           (the-words (format-time-string "* %A %d")))
      
      (with-current-buffer (find-file the-path)
        (goto-char (point-min))
        (if (search-forward-regexp (rx-to-string `(and bol ,the-words eol)) nil t)
            (next-line)
          (progn
            (goto-char (point-max))
            (insert "\n" the-words "\n\n")))
        )))

  (defun my-journal-entry ()
    "journal and agenda"
    (interactive)           
    (my-org-journal-goto)           
    (org-agenda nil "n")           
    (call-interactively #'other-window))

  )
