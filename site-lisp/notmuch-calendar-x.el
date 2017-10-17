;;; notmuch-calendar-x.el --- integrate notmuch with calendar

;;; Commentary:

;; A grim hack by tom hinton.
;; makes notmuch work with icalendar, including buttons; derived from notmuch-calendar-import.el by Vagn Johansen.

;;; Code:

;;;; Creating replies

(defun notmuch-calendar-email-link (email)
  ;; avoid double mailto
  (format "[[mailto:%s]]"
          (if (string-match (rx bos (| "mailto:" "MAILTO:") (group (* any))) email)
              (match-string 1 email)
            email)))

(defun notmuch-calendar-email-unlink (link)
  (when (and link (string-match (rx bos "[[mailto:" (group (* any)) "]]" eos) link))
    (match-string 1 link)))

(defun notmuch-calendar-respond (arg response)
  "Respond to the calendar request at point. RESPONSE is c, r, or t.
Prefix argument edits before sending"
  (interactive "P\nc[a]ccept, [r]eject, [t]entative")
  (require 'ox-icalendar)

  (notmuch-show-tag
   (list (cl-case response
           (?a "+accepted")
           (?r "+rejected")
           (?t "+tentative"))))

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
        handle-coding
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
         (mm-insert-part handle)
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

         (setq response (decode-coding-string
                         (string-make-unibyte
                          (buffer-substring-no-properties (point-min) (point-max)))
                         'utf-8))
         )))

    ;; TODO this is incorrect - the sender should be the ORGANIZER of the event
    ;; todo maybe offer reply?
    (notmuch-mua-mail organizer subject ())
    (goto-char (point-max))

    (make-variable-buffer-local 'message-syntax-checks)
    (push '(illegible-text . disabled) message-syntax-checks)

    (save-excursion
      (mml-insert-part "text/calendar; method=REPLY")
      (decode-coding-string (org-icalendar-fold-string response)
                            handle-coding
                            t (current-buffer))
      ;;   ;; (add-text-properties (point) (+ (point) p)
      ;;   ;;                      '(no-illegible-text t))
      ;;   ;; (add-text-properties (+ (point) p) (+ (point) p 1)
      ;;   ;;                      '(untranslated-utf-8 t))
      ))
  (if (zerop arg)
      (notmuch-mua-send-and-exit)))


;;;; modifying display in notmuch-show to be org-ish

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

(defun notmuch-calendar-event-insert-headline (c e)
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
    (insert (format  "  :ATTENDING: %s\n"
                     (mapconcat #'notmuch-calendar-email-link attendees " ")))
    (insert "  :END:\n ")
    ;; Make button to go to agenda. Alternatively could generate day agenda and insert
    (insert org-timestr "\n")))


(defun notmuch-calendar-event-insert-agenda (c e)
  (let* ((location (icalendar--get-event-property e 'LOCATION))
         (organizer (icalendar--get-event-property e 'ORGANIZER))
         (summary (icalendar--convert-string-for-import
                   (or (icalendar--get-event-property e 'SUMMARY) "")))
         (comment (icalendar--convert-string-for-import
                   (or (icalendar--get-event-property e 'COMMENT) "")))
         (attendees (icalendar--get-event-properties e 'ATTENDEE))
         (org-timestr (notmuch-calendar-ical->org-timestring e))
         (time-parts (org-parse-time-string org-timestr))
         (minutes (nth 1 time-parts))
         (hours (nth 2 time-parts))
         (day (nth 3 time-parts))
         (month (nth 4 time-parts))
         (year (nth 5 time-parts)))

    (unless (string-match-p (rx bos (* blank) eos) summary)
      (insert summary "\n"))
    (unless (string-match-p (rx bos (* blank) eos) comment)
      (insert comment "\n"))

    (insert-button org-timestr
                   :type 'notmuch-show-part-button-type
                   'action #'org-open-at-mouse)

    (insert "\n--------------\n")

    (let* ((wins (current-window-configuration))
           (org-agenda-sticky t)
           (inhibit-redisplay t)
           org-agenda-mail-buffer
           (org-agenda-custom-commands
            '(("q" "Mail agenda" ((agenda ""))))
            )
           )
      (org-eval-in-environment (org-make-parameter-alist
                                `(org-agenda-span
                                  'day
                                  ;;org-agenda-buffer-name " *notmuch-agenda-buffer*"
                                  org-agenda-start-day ,(format "%04d-%02d-%02d"
                                                                year month day)
                                  org-agenda-use-time-grid t
                                  org-agenda-remove-tags t
                                  org-agenda-window-setup 'nope))
        (progn
          ;; TODO for some reason this loses some text properties
          ;; for org-hd-marker that let it respond to clicks.
          (save-excursion
            (org-agenda nil "q")
            (org-agenda-redo)
            (setq org-agenda-mail-buffer (current-buffer)))
          (set-window-configuration wins)
          (let ((p (point)))

            (insert-buffer-substring org-agenda-mail-buffer)
            (save-restriction
              (narrow-to-region p (point))
              (let ((face-regions (gnus-find-text-property-region (point-min) (point-max) 'face)))
                (loop for range in face-regions
                      do
                      (let ((face (get-text-property (car range) 'face)))
                        (add-text-properties
                         (car range) (cadr range)
                         `(font-lock-face ,face)))


                      (set-marker (car range) nil)
                      (set-marker (cadr range) nil))))

            (kill-buffer org-agenda-mail-buffer)
            (put-text-property p (point) 'keymap
                               org-agenda-keymap)))
        ))))

(defun notmuch-calendar-event-insert-buttons (c e)
  (let* ((method (icalendar--get-event-property (car c) 'METHOD))
         (buttons
          (pcase method
            ('"REPLY"
             `(("Update" ,#'notmuch-calendar-update-reply))
             )
            ('"REQUEST"
             `(("Accept" ,#'notmuch-calendar-accept-and-capture)
               ("Decline" ,#'notmuch-calendar-decline)
               ("Capture" ,#'notmuch-calendar-capture)
               ))
            )))
    (if buttons
        (progn (dolist (button buttons)
                 (insert-button
                  (format "[ %s ]" (car button))
                  :type 'notmuch-show-part-button-type
                  'action (cadr button)
                  'calendar-event e
                  'calendar-object c)
                 (insert " "))
               (insert "\n"))
      (insert "Method: %s\n" method))))

(defun notmuch-calendar-icalendar-render (output-buffer fun)
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
                  (funcall fun ical-contents e))
                (list here (point))))
            )))))

(defvar notmuch-calendar-capture-target
  '(file "~/notes/calendar.org"))

(defun notmuch-calendar-capture (e)
  (let* ((appointment
          (notmuch-show-apply-to-current-part-handle
           (lambda (handle)
             (with-temp-buffer
               (let ((output-buffer (current-buffer)))
                 (with-temp-buffer
                   (mm-insert-part handle)
                   (delete-trailing-whitespace)
                   (notmuch-calendar-icalendar-render output-buffer #'notmuch-calendar-event-insert-headline)
                   ))
               (buffer-substring-no-properties (point-min) (point-max))
               ))))
         (org-capture-templates
          `(("a" "Calendar entry" entry ,notmuch-calendar-capture-target
             ;; template goes here - potentially risky?
             "%(format \"%s\" appointment) %?"
             ))))
    (org-capture nil "a")))

(defun notmuch-calendar--format-email (addr)
  (let ((addr (mail-extract-address-components addr)))
    (format "CN=%s:MAILTO:%s"
            (or (car addr)
                (cadr addr))
            (cadr addr))))

(defun notmuch-calendar-current-organizer ()
  (let* ((cur
          (notmuch-calendar-email-unlink (cdr (assoc "ORGANIZER" (org-entry-properties nil "ORGANIZER")))))
         (cur (and cur (regexp-quote cur))))
    (when cur
      (car (remove-if-not
            (lambda (x) (string-match-p cur x))
            notmuch-identities)))))

(defun notmuch-calendar-current-attendees ()
  (let ((cur (org-entry-get-multivalued-property (point) "ATTENDING")) out)
    (mapconcat #'identity (mapcar #'notmuch-calendar-email-unlink cur) ", ")))

(defun icalendar--get-event-attendees (e)
  (let ((props (car (cddr e))))
    (cl-loop for prop in props
             when (eq (car prop) 'ATTENDEE)
             collect (cdr prop))))


(defun notmuch-calendar-update-reply (e)
  ;; e is an overlay - probably the button?
  (let* ((props (overlay-properties e))
         (cal (car (plist-get props 'calendar-object)))
         (evt (plist-get props 'calendar-event))
         (uid (icalendar--get-event-property evt 'UID))
         (uid2 (progn (when
                          (string-match (rx bos (* alnum) "-" (group (* (| alnum "-"))) eos) uid)
                        (match-string 1 uid))))
         (entry (org-id-find uid2 t)))
    (unless entry (error (format "No entry for UID: %s" uid2)))
    (pop-to-buffer (marker-buffer entry))
    (goto-char (marker-position entry))
    (set-marker entry nil)
    ;; update properties for attending?
    (let ((existing-attendees (mapcar #'notmuch-calendar-email-unlink
                                      (org-entry-get-multivalued-property (point) "ATTENDING")))
          (new-attendees (icalendar--get-event-attendees evt)))
      (dolist (a new-attendees)
        (let* ((a-props (car a))
               (a-mail (cadr a))
               (state (plist-get a-props 'PARTSTAT))
               (addr (notmuch-calendar-email-unlink
                      (notmuch-calendar-email-link a-mail))))
          (message "%s" state)
          (cond
            ((equal state "ACCEPTED")
             (unless (member addr existing-attendees)
               (push addr existing-attendees)))
            (t (message "wat: %s" state))
            )))
      (message "%s" existing-attendees)
      (apply #'org-entry-put-multivalued-property (point) "ATTENDING"
             (mapcar #'notmuch-calendar-email-link existing-attendees)))
    ))

(defun notmuch-calendar-send-invitation-from-org (organizer attendees-list)
  ;; TODO insert identity, support sending information back again etc.
  (interactive
   (list (completing-read "Organizer: " notmuch-identities nil nil (notmuch-calendar-current-organizer))
         (completing-read-multiple "Invite: " (notmuch-address-options "")
                                   nil nil (notmuch-calendar-current-attendees))))

  (unless organizer (error "No organizer"))
  (unless attendees-list (error "No attendees"))

  (org-set-property "ORGANIZER" (notmuch-calendar-email-link organizer))
  (apply #'org-entry-put-multivalued-property (point) "ATTENDING"
         (mapcar #'notmuch-calendar-email-link attendees-list))

  (let ((sequence (+ 1 (string-to-number
                        (or (cdar (org-entry-properties (point) "SEQUENCE")) "-1"))))
        (uid (org-id-get-create))) ;; don't actually need UID?
    (org-set-property "SEQUENCE" (number-to-string sequence))
    (save-excursion
      (let ((headline (nth 4 (org-heading-components)))
            (entry-properties (org-entry-properties))
            (cal-file (save-restriction
                        (org-narrow-to-subtree)
                        (org-icalendar-export-to-ics nil nil nil)))
            cal-string)
        (with-temp-buffer
          (insert-file-contents cal-file nil)
          (with-current-buffer
              (icalendar--get-unfolded-buffer (current-buffer))
            (goto-char (point-min))
            (goto-char (point-min))

            (save-excursion
              (search-forward-regexp (rx bol "BEGIN:VCALENDAR" eol))
              (end-of-line)
              (insert "\nMETHOD:REQUEST"))

            (search-forward-regexp (rx bol "BEGIN:VEVENT" eol))
            (end-of-line)
            (insert
             "\n" "ORGANIZER;" (notmuch-calendar--format-email organizer))

            (dolist (attendee attendees-list)
              (insert "\n"
                      (mapconcat
                       #'identity
                       (list
                        "ATTENDEE"
                        "ROLE=REQ-PARTICIPANT"
                        "PARTSTAT=NEEDS-ACTION"
                        "RSVP=TRUE"
                        (notmuch-calendar--format-email attendee))
                       ";")))
            (insert "\n" "TRANSP:OPAQUE"
                    "\n" "CLASS:PUBLIC"
                    "\n" "STATUS:CONFIRMED"
                    "\n" (format "SEQUENCE:%d" sequence))
            (goto-char (point-min))
            (setq cal-string (org-icalendar-fold-string (buffer-string)))
            (kill-buffer))

          (notmuch-mua-new-mail)
          (message-goto-subject)
          (insert headline)
          (message-goto-from)
          (message-beginning-of-line)
          (insert organizer)
          (let ((here (point)))
            (end-of-line)
            (delete-region here (point)))

          (message-goto-to)
          (while attendees-list
            (insert (pop attendees-list))
            (when attendees-list (insert ", ")))

          (message-goto-body)
          (mml-insert-multipart "alternative")
          (save-excursion
            (let ((start (point)))
              (mml-insert-tag 'part
                              'type "text/calendar; charset=\"utf-8\"; method=REQUEST"
                              'encoding "base64"
                              'raw "t")
              (let ((here (point)))
                (insert (encode-coding-string cal-string 'us-ascii))
                (save-excursion
                  (goto-char here)
                  (while (search-forward "" nil t)
                    (replace-match ""))))

              (mml-insert-tag '/part)))

          (save-excursion
            (mml-insert-part "text/plain")

            (let* ((location (cdr (assoc "LOCATION" entry-properties)))
                   (timestamp (cdr (assoc "TIMESTAMP" entry-properties)))
                   (scheduled (cdr (assoc "SCHEDULED" entry-properties)))
                   (deadline (cdr (assoc "DEADLINE" entry-properties)))
                   (time (or timestamp scheduled deadline))
                   (attendees (cdr (assoc "ATTENDING" entry-properties)))
                   (organizer (cdr (assoc "ORGANIZER" entry-properties))))

              (insert "Invitation to " headline "\n\n")
              (when location (insert "Location: " location "\n"))
              (when time (insert "Time / date: " time "\n"))
              (when organizer (insert "Organizer: " (notmuch-calendar-email-unlink organizer) "\n"))
              (when attendees
                (let* ((attendees
                        (mapcar 'org-entry-restore-space
                                (org-split-string attendees "[ \t]"))))
                  (insert "Invited: \n")
                  (dolist (a attendees)
                    (insert "- " (notmuch-calendar-email-unlink a) "\n"))))))
          (add-text-properties (point-min) (point-max) '(no-illegible-text t))
          )))))


(defun notmuch-calendar-accept-and-capture (e)
  (save-current-buffer (notmuch-calendar-respond 0 ?a))
  (notmuch-calendar-capture e))

(defun notmuch-calendar-decline (e)
  (notmuch-calendar-respond 0 ?r))

(defun notmuch-calendar-show-insert-part-text/calendar (msg part content-type nth depth button)
  (let ((output-buffer (current-buffer)))
    (with-temp-buffer
      (insert (notmuch-get-bodypart-text msg part notmuch-show-process-crypto))
      ;; notmuch-get-bodypart-text does no newline conversion.
      ;; Replace CRLF with LF before icalendar can use it.
      (goto-char (point-min))
      (while (re-search-forward "\r\n" nil t)
        (replace-match "\n" nil nil))
      ;; insert buttons:
      (notmuch-calendar-icalendar-render output-buffer #'notmuch-calendar-event-insert-agenda)
      (with-current-buffer output-buffer (insert "--------------\n"))
      (notmuch-calendar-icalendar-render output-buffer #'notmuch-calendar-event-insert-buttons)
      ;; (notmuch-calendar-icalendar-render output-buffer (lambda (c e) (insert (format "%s" e))))

      )
    t))

(fset 'notmuch-show-insert-part-text/calendar
      #'notmuch-calendar-show-insert-part-text/calendar)

(provide 'notmuch-calendar-x)

;;; notmuch-calendar-2.el ends here
