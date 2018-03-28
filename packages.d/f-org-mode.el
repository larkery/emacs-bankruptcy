;; -*- lexical-binding: t -*-
;; settings for org mode

(initsplit-this-file bos (| "org-" "holiday-" "calendar-"))

(req-package org-log :ensure nil)

(req-package org
  :defer t
  :require org-capture-pop-frame hydra org-log
  :bind (("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c j" . org-log-goto)
         )
  :init

  :config

  ;; YES or NO
  (bind-key "C-M-u" 'org-up-element org-mode-map)
  (bind-key "C-M-d" 'org-down-element org-mode-map)
  (bind-key "C-M-f" 'org-forward-element org-mode-map)
  (bind-key "C-M-b" 'org-backward-element org-mode-map)

  ;; (require 'org-capture-pop-frame)
  (require 'org-agenda-notify)
  (require 'org-log)

  (diminish 'orgtbl-mode " ◫")
  (diminish 'orgstruct-mode " ⫢")

  (org-clock-persistence-insinuate)

  (add-hook 'org-mode-hook
            'auto-revert-mode)

  (add-hook 'org-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t)))

  (defun org-entry-time-indicator ()
    (let ((d (org-entry-get nil "DEADLINE"))
          (s (org-entry-get nil "SCHEDULED")))
      (concat
       (if s (format "S%d" (org-time-stamp-to-now s)) "")
       (if d (format "D%d" (org-time-stamp-to-now d)) ""))
      ))

  (defun org-entry-location ()
    (let ((loc (org-entry-get (point) "LOCATION")))
      (if (and loc (> (length loc) 0))
          (format "{%s} " (replace-regexp-in-string
                           "[Mm]eeting [Rr]oom"
                           "MR"
                           loc))
        "")))

  (defun tidy-clock (s)
    (string-match (rx " [" (group (* any)) "] (" (group (* any)) ")") s)
    (format "[%s %s]" (match-string 2 s) (match-string 1 s)))

  (defun org-relevant-agenda (&optional p)
    (interactive "P")
    (org-agenda p (if (at-work-p) "w" "h")))

  (defun org-agenda-upd-notify (&rest _) (org-agenda-notify))
  (advice-add 'org-time-stamp :after 'org-agenda-upd-notify)
  (advice-add 'org-timestamp-up :after 'org-agenda-upd-notify)
  (advice-add 'org-timestamp-down :after 'org-agenda-upd-notify)
  (advice-add 'org-timestamp-up-day :after 'org-agenda-upd-notify)
  (advice-add 'org-timestamp-down-day :after 'org-agenda-upd-notify)

  (advice-add 'org-clock-get-clock-string
              :filter-return
              #'tidy-clock)

  (defun org-email-subtree ()
    (interactive)
    (let* ((here (save-excursion (beginning-of-line) (point)))
           (there (save-excursion (org-end-of-subtree)
                                  (point)))
           (header (org-get-heading t t t t))
           (content (buffer-substring-no-properties here there)))
      (notmuch-mua-new-mail)
      (message-goto-subject)
      (insert header)
      (message-goto-body)
      (save-excursion
        (insert content))
      (orgstruct-mode)
      (orgtbl-mode)

      (while (> (org-outline-level) 1)
        (orgstruct-hijacker-org-promote-subtree nil))
      (delete-region (point)
                     (save-excursion (forward-line) (point)))
      (message-goto-to)))

  (defface org-agenda-date-2 '((t (:inherit org-agenda-date))) "Alternate days")
  (defun org-day-colour (date)
    (let* ((day (calendar-day-of-week date))
           (weekend (member day org-agenda-weekend-days))
           (today (org-agenda-todayp date))
           (even (zerop (% day 2)))
           faces
           )
      (when today (push 'org-agenda-date-today faces))
      (when weekend (push 'org-agenda-date-weekend faces))
      (push (if even 'org-agenda-date 'org-agenda-date-2) faces)

      (if (cdr faces)
          `(:inherit ,(nreverse faces))
        (car faces))))


  (setq org-agenda-day-face-function 'org-day-colour)

  (defun my-time-to-minutes (str)
    (require 'calc)
    (require 'calc-units)
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

  (defun org-agenda-toggle-empty ()
    (interactive)
    (setq org-agenda-show-all-dates (not org-agenda-show-all-dates))
    (call-interactively 'org-agenda-redo))

  (add-hook 'org-agenda-mode-hook
            (lambda ()
              (bind-key "Y" 'org-agenda-toggle-empty org-agenda-mode-map)))


  )


(req-package org-caldav
  :commands org-caldav-sync
  :config
  (setq org-caldav-url
        "https://caldav.fastmail.com/dav/calendars/user/larkery@fastmail.fm"

        org-caldav-calendar-id "calendar~Ytc0GVEQhRpkeUZSVkj_zw1"

        org-caldav-inbox '(id "488ca023-fb86-4edf-a10e-26e3e0297034")
        org-caldav-files '("~/notes/calendar.org")

        org-icalendar-timezone "Europe/London"

        org-caldav-save-directory "~/notes/.metadata/"
        org-caldav-backup-file nil
        )

  )

;; fix holidays for the UK

;;N.B. It is assumed that 1 January is defined with holiday-fixed -
;;this function only returns any extra bank holiday that is allocated
;;(if any) to compensate for New Year's Day falling on a weekend.
;;
;;Where 1 January falls on a weekend, the following Monday is a bank
;;holiday.
(defun holiday-new-year-bank-holiday ()
  (let ((m displayed-month)
	(y displayed-year))
    (calendar-increment-month m y 1)
    (when (<= m 3)
      (let ((d (calendar-day-of-week (list 1 1 y))))
	(cond ((= d 6)
	       (list (list (list 1 3 y)
			   "New Year's Day Bank Holiday")))
	      ((= d 0)
	       (list (list (list 1 2 y)
			   "New Year's Day Bank Holiday"))))))))

(defun holiday-christmas-bank-holidays ()
  (let ((m displayed-month)
	(y displayed-year))
    (calendar-increment-month m y -1)
    (when (>= m 10)
      (let ((d (calendar-day-of-week (list 12 25 y))))
	(cond ((= d 5)
	       (list (list (list 12 28 y)
			   "Boxing Day Bank Holiday")))
	      ((= d 6)
	       (list (list (list 12 27 y)
			   "Boxing Day Bank Holiday")
		     (list (list 12 28 y)
			   "Christmas Day Bank Holiday")))
	      ((= d 0)
	       (list (list (list 12 27 y)
			   "Christmas Day Bank Holiday"))))))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(calendar-date-style (quote european))
 '(calendar-week-start-day 1)
 '(holiday-christian-holidays
   (quote
    ((if calendar-christian-all-holidays-flag
         (append
          (holiday-easter-etc)
          (holiday-fixed 12 25 "Christmas")
          (holiday-fixed 1 6 "Epiphany")
          (holiday-julian 12 25 "Christmas (Julian calendar)")
          (holiday-greek-orthodox-easter)
          (holiday-fixed 8 15 "Assumption")
          (holiday-advent 0 "Advent"))))))
 '(holiday-general-holidays
   (quote
    ((holiday-fixed 1 1 "New Year's Day")
     (holiday-new-year-bank-holiday)
     (holiday-fixed 2 14 "Valentine's Day")
     (holiday-fixed 3 17 "St. Patrick's Day")
     (holiday-fixed 4 1 "April Fools' Day")
     (holiday-easter-etc -47 "Shrove Tuesday")
     (holiday-easter-etc -21 "Mother's Day")
     (holiday-easter-etc -2 "Good Friday")
     (holiday-easter-etc 0 "Easter Sunday")
     (holiday-easter-etc 1 "Easter Monday")
     (holiday-float 5 1 1 "Early May Bank Holiday")
     (holiday-float 5 1 -1 "Spring Bank Holiday")
     (holiday-float 6 0 3 "Father's Day")
     (holiday-float 8 1 -1 "Summer Bank Holiday")
     (holiday-fixed 10 31 "Halloween")
     (holiday-fixed 12 24 "Christmas Eve")
     (holiday-fixed 12 25 "Christmas Day")
     (holiday-fixed 12 26 "Boxing Day")
     (holiday-christmas-bank-holidays)
     (holiday-fixed 12 31 "New Year's Eve"))))
 '(org-adapt-indentation nil)
 '(org-agenda-custom-commands
   (quote
    (("w" "Work agenda / todo"
      ((agenda ""
               ((org-agenda-span
                 (quote week))))
       (alltodo "" nil))
      ((org-agenda-tag-filter-preset
        (quote
         ("-habit" "-personal")))))
     ("h" "Home agenda/todo"
      ((agenda ""
               ((org-agenda-span
                 (quote week))))
       (alltodo "" nil))
      ((org-agenda-tag-filter-preset
        (quote
         ("-work"))))
      nil))))
 '(org-agenda-diary-file "~/notes/calendar.org")
 '(org-agenda-files (quote ("~/notes/work" "~/notes/home" "~/notes")))
 '(org-agenda-include-diary nil)
 '(org-agenda-prefix-format "%-12:c %t %s %(org-entry-location)")
 '(org-agenda-property-list (quote ("LOCATION")))
 '(org-agenda-remove-tags (quote prefix))
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-sorting-strategy
   (quote
    ((agenda habit-down time-up priority-down category-keep)
     (todo priority-down deadline-up)
     (tags priority-down category-keep)
     (search category-keep))))
 '(org-agenda-span (quote week))
 '(org-agenda-tags-column -80)
 '(org-agenda-window-setup (quote reorganize-frame))
 '(org-archive-default-command (quote org-archive-set-tag))
 '(org-babel-load-languages (quote ((emacs-lisp . t) (dot . t))))
 '(org-capture-templates
   (quote
    (("c" "Task" entry
      (file "~/notes/inbox.org")
      "* TODO %?%a
%u")
     ("e" "Calendar" entry
      (file "~/notes/calendar.org")
      "* %?
%^T")
     ("L" "Protocol Link" entry
      (file "~/notes/links.org")
      "* %? [[%:link][%:description]]
 %U")
     ("p" "Protocol Selection" entry
      (file "~/notes/inbox.org")
      "* %^{Title}
Source: %u, %c
#+BEGIN_QUOTE
%i
#+END_QUOTE
%?"))))
 '(org-clock-clocked-in-display (quote mode-line))
 '(org-clock-mode-line-total (quote today))
 '(org-clock-out-remove-zero-time-clocks t)
 '(org-clock-report-include-clocking-task t)
 '(org-confirm-babel-evaluate nil)
 '(org-contacts-files (quote ("~/notes/contacts.org")))
 '(org-default-priority 68)
 '(org-ellipsis "…")
 '(org-export-with-smart-quotes t)
 '(org-fontify-whole-heading-line t)
 '(org-id-locations-file "~/notes/.metadata/org-id-locations")
 '(org-latex-compiler "xelatex")
 '(org-log-done (quote time))
 '(org-lowest-priority 68)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-info org-irc org-mhe org-protocol org-rmail org-w3m)))
 '(org-outline-path-complete-in-steps nil)
 '(org-priority-start-cycle-with-default t)
 '(org-refile-allow-creating-parent-nodes t)
 '(org-refile-targets
   (quote
    ((org-agenda-files :maxlevel . 1)
     (nil :maxlevel . 3))))
 '(org-refile-use-outline-path (quote file))
 '(org-speed-commands-user
   (quote
    (("M" . notmuch-calendar-send-invitation-from-org)
     ("m" . org-email-subtree)
     ("k" . org-cut-subtree)
     ("N" . narrow-dwim))))
 '(org-tags-column 0)
 '(org-tags-exclude-from-inheritance (quote ("swam")))
 '(org-time-clocksum-format
   (quote
    (:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t)))
 '(org-use-speed-commands t))
