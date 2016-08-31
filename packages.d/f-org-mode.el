;; settings for org mode

(req-package org
  :bind (("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("<f6>"  . my-org-journal-goto))
  :config

  (require 'org-notmuch)

  (setq org-ellipsis "…")

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

        (let ((prefix-arg '(4)))
          (call-interactively 'org-global-cycle))

        (if (search-forward-regexp (rx-to-string `(and bol ,the-words eol)) nil t)
            (progn (org-reveal)
                   (org-cycle)
                   (next-line))
          (progn
            (goto-char (point-max))
            (insert "\n" the-words "\n")))
        ))))

(req-package org-journal
  :bind ("<f6>" . org-journal-new-entry)
  :init (global-unset-key (kbd "C-c C-j"))
  :commands org-journal-new-entry
  :config
  (setq org-journal-dir "~/notes/j/")
  )

(req-package org-caldav
  :config
  (setq org-caldav-url
        "https://caldav.fastmail.com/dav/calendars/user/larkery@fastmail.fm"

        org-caldav-calendar-id "calendar~Ytc0GVEQhRpkeUZSVkj_zw1"

        org-caldav-inbox "~/notes/calendar.org"
        org-caldav-files '("~/notes/calendar.org")

        org-icalendar-timezone "Europe/London"

        ))
