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
        )))

  (defun my-time-to-minutes (str)

    (string-to-number
     (calc-eval (math-remove-units (math-convert-units (calc-eval str 'raw) (calc-eval "min" 'raw))))))

  (defun my-org-icalendar--valarm (entry timestamp summary)
  "Create a VALARM component.

ENTRY is the calendar entry triggering the alarm.  TIMESTAMP is
the start date-time of the entry.  SUMMARY defines a short
summary or subject for the task.

Return VALARM component as a string, or nil if it isn't allowed."
  ;; Create a VALARM entry if the entry is timed.  This is not very
  ;; general in that:
  ;; (a) only one alarm per entry is defined,
  ;; (b) only minutes are allowed for the trigger period ahead of the
  ;;     start time,
  ;; (c) only a DISPLAY action is defined.                       [ESF]
  (let ((alarm-time
     (let ((warntime
        (org-element-property :APPT_WARNTIME entry)))
       (if warntime (my-time-to-minutes warntime) 0))))
    (and (or (> alarm-time 0) (> org-icalendar-alarm-time 0))
     (org-element-property :hour-start timestamp)
     (format "BEGIN:VALARM
ACTION:DISPLAY
DESCRIPTION:%s
TRIGGER:-P0DT0H%dM0S
END:VALARM\n"
         summary
         (if (zerop alarm-time) org-icalendar-alarm-time alarm-time)))))

  (advice-add 'org-icalendar--valarm :override 'my-org-icalendar--valarm)

  )

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

        org-caldav-inbox '(file+headline "~/notes/calendar.org" "New appointments")
        org-caldav-files '("~/notes/calendar.org")

        org-icalendar-timezone "Europe/London"))
