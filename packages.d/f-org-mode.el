;; settings for org mode

(initsplit-this-file bos "org-")

(req-package org
  :defer t
  :require orgit org-capture-pop-frame org-agenda-property
  :bind (("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c j" . org-log-goto))

  :init

  (defun org-goto-log ()
    (interactive)
    (with-current-buffer (find-file "~/notes/journal.org")
      (org-insert-datetree-entry)))


  :config
  (require 'org-notmuch)
  (require 'org-capture-pop-frame)
  (require 'org-agenda-notify)
  (require 'org-log)

  (org-clock-persistence-insinuate)

  (add-hook 'org-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t)))

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

  ;; (defun org-insert-datetree-entry ()
  ;;   (interactive)
  ;;   (org-cycle '(8))
  ;;   (org-datetree-find-date-create (calendar-current-date))
  ;;   (org-show-entry)
  ;;   (org-end-of-subtree))


  (defun org-agenda-toggle-empty ()
    (interactive)
    (setq org-agenda-show-all-dates (not org-agenda-show-all-dates))
    (call-interactively 'org-agenda-redo))

  (add-hook 'org-agenda-mode-hook
            (lambda ()
              (bind-key "Y" 'org-agenda-toggle-empty org-agenda-mode-map)))

  ;; (define-minor-mode org-log-mode
  ;;   :lighter " org-log"
  ;;   :keymap (let ((map (make-sparse-keymap)))
  ;;             (define-key map (kbd "C-c j") 'org-goto-log)

  ;;             (define-key map (kbd "C-c e") 'org-insert-datetree-entry)
  ;;             map))


  (defun org-refile-to-datetree ()
    "Refile a subtree to a datetree corresponding to it's timestamp."
    (interactive)
    (let* ((datetree-date (org-entry-get nil "TIMESTAMP" t))
           (date (org-date-to-gregorian datetree-date)))
      (when date
        (save-excursion
          (save-restriction
            (org-save-outline-visibility t
              (save-excursion
                (outline-show-all)
                (setq last-command nil) ; prevent kill appending
                (org-cut-subtree)

                (org-datetree-find-date-create date)
                (org-narrow-to-subtree)
                (show-subtree)
                (org-end-of-subtree t)

                (goto-char (point-max))
                (org-paste-subtree 4)
                )))))))
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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-adapt-indentation nil)
 '(org-agenda-custom-commands
   (quote
    (("n" "Agenda and unscheduled TODOs"
      ((agenda "" nil)
       (alltodo "" nil))
      ((org-agenda-todo-ignore-scheduled t))))))
 '(org-agenda-diary-file "~/notes/calendar.org")
 '(org-agenda-files
   (quote
    ("/home/hinton/notes/personal.org" "/home/hinton/notes/calendar.org" "/home/hinton/notes/idle.org" "/home/hinton/notes/inbox.org" "/home/hinton/notes/journal.org" "/home/hinton/notes/links.org" "/home/hinton/notes/home/brewing.org" "/home/hinton/notes/home/cooking.org" "/home/hinton/notes/home/media.org" "/home/hinton/notes/home/technical.org" "/home/hinton/notes/work/cse-crm.org" "/home/hinton/notes/work/fedman.org" "/home/hinton/notes/work/mangling-tables-R.org" "/home/hinton/notes/work/nhm.org" "/home/hinton/notes/work/solar-method.org" "/home/hinton/notes/work/thermos.org" "/home/hinton/notes/work/timesheet.org")))
 '(org-agenda-prefix-format
   (quote
    ((agenda . " %i %-12:c%?-12t% s")
     (timeline . "  % s")
     (todo . " %i %-12:c %t")
     (tags . " %i %-12:c")
     (search . " %i %-12:c"))))
 '(org-agenda-property-list (quote ("LOCATION")))
 '(org-agenda-property-position (quote same-line))
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-window-setup (quote other-frame))
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
%^T"))))
 '(org-confirm-babel-evaluate nil)
 '(org-habit-show-habits-only-for-today nil)
 '(org-hide-emphasis-markers t)
 '(org-highlight-latex-and-related (quote (latex script entities)))
 '(org-id-locations-file "~/notes/.metadata/org-id-locations")
 '(org-log-done (quote time))
 '(org-outline-path-complete-in-steps nil)
 '(org-refile-allow-creating-parent-nodes t)
 '(org-refile-targets
   (quote
    ((org-agenda-files :maxlevel . 1)
     (nil :maxlevel . 3))))
 '(org-refile-use-outline-path (quote file))
 '(org-use-speed-commands t))
