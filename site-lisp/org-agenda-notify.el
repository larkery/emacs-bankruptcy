(defvar org-agenda-notify-timers nil)
(defvar org-agenda-notify-queue nil)
(defvar org-agenda-notify-next nil)

(require 'notifications)
(require 'diary-lib)
(require 'org-agenda)

(defun my-notifications-bus-adv (o &rest args)
  (let ((bus (with-temp-buffer (insert-file-contents "~/.dbus_session_bus_address")
                               (string-trim (buffer-string)))))
    (dbus-init-bus bus)
    (apply o (append (list :bus bus) args))))

(advice-add 'notifications-notify :around #'my-notifications-bus-adv)

(defun org-agenda-notify--set-next ()
  (setq org-agenda-notify-next (cdr (pop org-agenda-notify-queue)))
  (message "%s" org-agenda-notify-next)
  (when org-agenda-notify-next
    (setq org-agenda-notify-next
          (string-trim (substring-no-properties
                        org-agenda-notify-next
                        (+ 1 (or (seq-position org-agenda-notify-next ?:)
                                 -1))))))

  (with-temp-buffer (insert (or org-agenda-notify-next
                                "nothing") "\n")
                    (write-region (point-min) (point-max)
                                  "~/.xmonad/xmobar-pipe" t)))

(defun org-agenda-notify--trigger (msg wrn)
  (let ((final (zerop wrn)))
    (when final (org-agenda-notify--set-next))

    (notifications-notify
    :title "appt"
    :body msg
    :urgency (if final 'critical 'normal))))

(defun org-agenda-notify ()
  "Setup a timer to notify you about your appointments in the next 24h"
  (interactive)

  (dolist (timer org-agenda-notify-timers)
    (cancel-timer timer))

  (setq org-agenda-notify-timers ()
        org-agenda-notify-queue ())

  (let* ((scope '(:deadline* :scheduled* :timestamp))
         (org-agenda-new-buffers nil)
         (org-deadline-warning-days 0)
         ;; Do not use `org-today' here because appt only takes
         ;; time and without date as argument, so it may pass wrong
         ;; information otherwise
         (today (org-date-to-gregorian
                 (time-to-days (current-time))))
         (org-agenda-restrict nil)
         (files (org-agenda-files 'unrestricted)) entries file
         (org-agenda-buffer nil))
    ;; Get all entries which may contain an appt
    (org-agenda-prepare-buffers files)
    (while (setq file (pop files))
      (setq entries
            (delq nil
                  (append entries
                          (apply 'org-agenda-get-day-entries
                                 file today scope)))))
    ;; Map thru entries and find if we should filter them out

    (mapc
     (lambda (x)
       (let* ((evt (org-trim
                    (replace-regexp-in-string
                     org-bracket-link-regexp "\\3"
                     (or (get-text-property 1 'txt x) ""))))
              (cat (get-text-property (1- (length x)) 'org-category x))
              (tod (get-text-property 1 'time-of-day x))
              (wrn (get-text-property 1 'warntime x)))
         (when (and tod (not (string-match "\\`DONE\\|CANCELLED" evt)))
           (setq tod (concat "00" (number-to-string tod)))
           (setq tod (when (string-match
                            "\\([0-9]\\{1,2\\}\\)\\([0-9]\\{2\\}\\)\\'" tod)
                       (concat (match-string 1 tod) ":"
                               (match-string 2 tod))))

           (let* ((hhmm (diary-entry-time tod))
                  (mm (% hhmm 100))
                  (hh (/ hhmm 100))
                  (now (current-time))
                  (nowd (decode-time))
                  (then (encode-time 0 mm hh (nth 3 nowd) (nth 4 nowd) (nth 5 nowd)))
                  (deltat (- (time-to-seconds then)
                             (time-to-seconds now)))
                  (warn-times (list 0 5 10)))
             (when wrn (push wrn warn-times))
             (when (> deltat 0)
               (push (cons deltat x) org-agenda-notify-queue)
               (dolist (wrn warn-times)
                 (let ((wt (- deltat (* 60 wrn))))
                   (when (> wt 0)
                     (push (run-at-time wt nil #'org-agenda-notify--trigger x wrn)
                           org-agenda-notify-timers)
                     ))))))))
     entries)
    (org-release-buffers org-agenda-new-buffers))

  (setq org-agenda-notify-queue
        (sort org-agenda-notify-queue (lambda (a b) (< (car a) (car b)))))

  (org-agenda-notify--set-next))

(org-agenda-notify)
(run-at-time "00:00" (* 4 60 60) 'org-agenda-notify)

(provide 'org-agenda-notify)
