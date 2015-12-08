;;; notmuch-calendar.el --- integrate notmuch with calendar

;;; Commentary:

;; makes notmuch work with icalendar, including buttons; derived from notmuch-calendar-import.el
;; by Vagn Johansen

;;; Code:

;;;; Creating replies

(defun notmuch-calendar-respond (arg response)
  "Respond to the calendar request at point. RESPONSE is c, r, or t.
Prefix argument edits before sending"
  (interactive "P\nc[a]ccept, [r]eject, [t]entative")
  (require 'ox-icalendar)
  ;; get hold of current part
  (let ((mm-inlined-types nil)
        (to (notmuch-show-get-to))

        (partstat (cl-case response
                    (?a "PARTSTAT=ACCEPTED")
                    (?r "PARTSTAT=REJECTED")
                    (?t "PARTSTAT=TENTATIVE")
                    (t (error "Cancelling reply"))))

        (subject (concat (cl-case response
                           (?a "Accepted: ")
                           (?r "Rejected: ")
                           (?t "Tentative: "))
                         (notmuch-show-get-subject)))
        to-re
        response
        organizer)

    ;; find mail addresses we have which may relate to the to: header
    ;; TODO what about cc: header?
    ;; TODO what if fccdirs header is too general

    (dolist (fcc notmuch-fcc-dirs)
      (let ((re (car fcc)))
        (if (string-match re to)
            (progn (push re to-re)))))

    (notmuch-show-apply-to-current-part-handle
     (lambda (handle)
       (with-temp-buffer
         (insert (mm-get-part handle))
         ;; now we need to edit some lines, and then fold them?
         (set-buffer (icalendar--get-unfolded-buffer (current-buffer)))
         (goto-char (point-min))
         (delete-trailing-whitespace)
         ;; we need to fix DTSTAMP and our ATTENDEE lines?
         ;; ATTENDEE lines - foreach RE that we know, try mangling lines
         (dolist (re to-re)
           (goto-char (point-min))
           (while (re-search-forward
                   (rx-to-string
                    `(and bol
                          "ATTENDEE;"
                          (zero-or-more anything)
                          "PARTSTAT=NEEDS-ACTION"
                          (zero-or-more nonl)
                          (regexp ,re)) t) nil t)
             (goto-char (match-beginning 0))
             (if (re-search-forward "PARTSTAT=NEEDS-ACTION"
                                    nil t)
                 (replace-match partstat))))

         (goto-char (point-min))
         (if (re-search-forward (rx bol (group "PRODID:" (one-or-more nonl)) eol) nil t)
             (replace-match "PRODID:Emacs, of course"))
         ;; do method
         (goto-char (point-min))
         (if (re-search-forward (rx bol (group "METHOD:" (one-or-more nonl)) eol) nil t)
             (replace-match "METHOD:REPLY"))
         ;; now do DTSTAMP DTSTAMP:20151006T125408Z
         (goto-char (point-min))
         (if (re-search-forward (rx bol (group "DTSTAMP:" (one-or-more nonl)) eol) nil t)
             (replace-match (org-icalendar-dtstamp)))

         ;; find the organizer line to reply to
         (goto-char (point-min))
         (if (re-search-forward (rx bol "ORGANIZER;"
                                    (one-or-more nonl)
                                    ":MAILTO:"
                                    (group (one-or-more nonl)) eol) nil t)
             (setq organizer (match-string-no-properties 1)))

         (setq response (buffer-substring-no-properties (point-min) (point-max)))
         )))

    ;; TODO this is incorrect - the sender should be the ORGANIZER of the event
    ;; todo maybe offer reply?
    (notmuch-mua-mail organizer subject ())
    (goto-char (point-max))

    (save-excursion
     (mml-insert-part "text/calendar; method=REPLY; charset=UTF8")
     (insert (org-icalendar-fold-string response))))

  (if (zerop arg)
      (notmuch-mua-send-and-exit)))

;;;; Modifying display in notmuch-show to be org-ish

(defun notmuch-calendar-datetime->iso (datetime)
  "Convert a date retrieved via `icalendar--get-event-property' to ISO format."
  (if datetime
    (format "%04d-%02d-%02d"
      (nth 5 datetime)                  ; Year
      (nth 4 datetime)                  ; Month
      (nth 3 datetime))))               ; Day

(defun notmuch-calendar-ical->org-timestring (ical-element)
  ""
  (let* ((dtstart (icalendar--get-event-property e 'DTSTART))
          (dtstart-zone (icalendar--find-time-zone
                          (icalendar--get-event-property-attributes e 'DTSTART)
                          zone-map))
          (dtstart-dec (icalendar--decode-isodatetime dtstart nil dtstart-zone))
          (start-d (notmuch-calendar-datetime->iso dtstart-dec))
          (start-t (icalendar--datetime-to-colontime dtstart-dec))
          (dtend (icalendar--get-event-property e 'DTEND))
          (dtend-zone (icalendar--find-time-zone
                        (icalendar--get-event-property-attributes e 'DTEND)
                        zone-map))
          (dtend-dec (icalendar--decode-isodatetime dtend nil dtend-zone))
          end-d end-t

          (rrule (icalendar--get-event-property e 'RRULE))
          (rdate (icalendar--get-event-property e 'RDATE))
          (duration (icalendar--get-event-property e 'DURATION)))

    (setq end-d (if dtend-dec
                  (notmuch-calendar-datetime->iso dtend-dec)
                  start-d))
    (setq end-t (if (and
                      dtend-dec
                      (not (string=
                             (cadr
                               (icalendar--get-event-property-attributes
                                 e 'DTEND))
                             "DATE")))
                  (icalendar--datetime-to-colontime dtend-dec)
                  start-t))
    ;; Store in kill-ring
      (if (equal start-d end-d)
        (format "<%s %s-%s>" start-d start-t end-t)
        ;; else
        (format "<%s %s>--<%s %s>" start-d start-t end-d end-t))))


(defun notmuch-calendar-event->org (e)
  "Format E as an org headline"
  (let* ((location (icalendar--get-event-property e 'LOCATION))
          (organizer (icalendar--get-event-property e 'ORGANIZER))
          (summary (icalendar--convert-string-for-import
                     (or (icalendar--get-event-property e 'SUMMARY)
                       "No summary")))
          (attendees (icalendar--get-event-properties e 'ATTENDEE))
          (org-timestr (notmuch-calendar-ical->org-timestring e)))

    (insert "* " summary "\n")
    (insert "  :PROPERTIES:\n")
    (if location  (insert "  :LOCATION: " location "\n"))
    (if organizer (insert "  :ORGANIZER: [[" organizer "]]\n" ))
    (dolist (a attendees)
      (insert (format  "  :ATTENDING: [[%s]]\n" a)))
    (insert "  :END:\n ")
    ;; make button to go to agenda
    (insert-button org-timestr
                   :type 'notmuch-show-part-button-type
                   'action #'org-open-at-mouse)
    (insert "\n")))

(defun notmuch-calendar-icalendar->org (output-buffer)
  "Transform icalendar events in the current buffer into org headlines and insert them into the output-buffer."
  (save-current-buffer
    (set-buffer (icalendar--get-unfolded-buffer (current-buffer)))
    (goto-char (point-min))
    (if (re-search-forward "^BEGIN:VCALENDAR\\s-*$" nil t)
        (progn
          (beginning-of-line)
          (let* ((ical-contents (icalendar--read-element nil nil))
                 (ical-events (icalendar--all-events ical-contents))
                 (zone-map (icalendar--convert-all-timezones ical-events)))
            (with-current-buffer output-buffer
              (let ((here (point)))
                (dolist (e ical-events)
                  (notmuch-calendar-event->org e))

                (list here (point))))
            )))))

(defvar notmuch-calendar-capture-target
  '(file "~/org/work/calendar.org"))

(defun notmuch-calendar-capture (e)
  (let* ((appointment
          (notmuch-show-apply-to-current-part-handle
           (lambda (handle)
             (with-temp-buffer
               (let ((output-buffer (current-buffer)))
                 (with-temp-buffer
                   (mm-insert-part handle)
                   (delete-trailing-whitespace)
                   (notmuch-calendar-icalendar->org output-buffer)
                   ))
               (buffer-substring-no-properties (point-min) (point-max))
               ))))
         (org-capture-templates
          `(("a" "Calendar entry" entry ,notmuch-calendar-capture-target
             ;; template goes here - potentially risky?
             "%(format \"%s\" appointment)\n  From: %a\n  %?"
             ))
          ))
    (org-capture nil "a"))
  )

(defun notmuch-calendar-accept-and-capture (e)
  (save-current-buffer (notmuch-calendar-respond 0 ?a))
  (notmuch-calendar-capture e))

(defun notmuch-calendar-decline (e) (notmuch-calendar-respond 0 ?r))

(defun notmuch-calendar-show-insert-part-text/calendar (msg part content-type nth depth button)
  (let ((output-buffer (current-buffer)))
    (insert-button
     "[ Accept ]"
     :type 'notmuch-show-part-button-type
     'action #'notmuch-calendar-accept-and-capture)

    (insert " ")
    (insert-button
     "[ Decline ]"
     :type 'notmuch-show-part-button-type
     'action #'notmuch-calendar-decline)

    (insert " ")
    (insert-button
     "[ Capture ]"
     :type 'notmuch-show-part-button-type
     'action #'notmuch-calendar-capture)

    (insert "\n")
    (with-temp-buffer
      (insert (notmuch-get-bodypart-text msg part notmuch-show-process-crypto))
      ;; notmuch-get-bodypart-text does no newline conversion.
      ;; Replace CRLF with LF before icalendar can use it.
      (goto-char (point-min))
      (while (re-search-forward "\r\n" nil t)
        (replace-match "\n" nil nil))
      ;; insert buttons:

      (notmuch-calendar-icalendar->org output-buffer))
    t))

(fset 'notmuch-show-insert-part-text/calendar
      #'notmuch-calendar-show-insert-part-text/calendar)

(provide 'notmuch-calendar)

;;; notmuch-calendar.el ends here
