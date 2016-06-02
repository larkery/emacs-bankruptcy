
(req-package org-agenda-property)


(req-package graphviz-dot-mode
  :commands graphviz-dot-mode
  :require org)

(req-package appt
  :config
  (require 'notifications)

  (defun h/appt-notify (mins _ msg)
    (let ((mins (if (listp mins) mins (list mins)))
          (msg (if (listp msg) msg (list msg))))
      (cl-mapcar
       (lambda (mins msg)
         (let ((soon (<= (string-to-number mins) 10))
               (now (zerop (string-to-number mins))))
           (notifications-notify
            :body msg
            :urgency (if soon 'critical 'normal)
            :timeout (if now 0 -1)
            :title (if soon
                       "NOW" (format "In %s min" mins)))))
       mins msg)))

  (defun h/appt-notify-now ()
    (interactive)
    (let ((appt-display-interval 1)) (appt-check)))

  (setq appt-message-warning-time 60
        appt-display-mode-line t
        appt-disp-window-function #'h/appt-notify
        appt-delete-window-function (lambda ())
        appt-display-interval 10
        appt-display-format 'window)

  (appt-activate t))

(req-package org
  :bind (("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture))
  :config
  (defun org-goto-agenda ()
    (interactive "")
    (let* ((org-refile-targets `((org-agenda-files . (:maxlevel . ,org-goto-max-level))))
           (org-refile-use-outline-path t)
           (org-refile-target-verify-function nil)
           (interface org-goto-interface)
           (org-goto-start-pos (point))
           (selected-point (setq *goto* (org-refile-get-location "Goto" nil nil t))))

      (when selected-point
        (set-mark (point))
        (let ((filename (nth 0 (cdr selected-point)))
              (position (nth 2 (cdr selected-point))))
          (find-file filename)
          (goto-char position)
          (org-reveal)))))

  (require 'appt)
  (org-clock-persistence-insinuate)

  (set-mode-name org-mode "o")

  (add-hook 'org-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t)))

  (add-hook 'org-agenda-finalize-hook 'org-agenda-to-appt)
  (run-at-time "24:01" 3600 'org-agenda-to-appt)

  (bind-key "C-M-i" #'completion-at-point org-mode-map)
  (bind-key "C-#" nil org-mode-map)
  (bind-key "C-M-<return>"
            (lambda () (interactive)
              (org-insert-heading-respect-content)
              (org-metaright))
            org-mode-map)


  (require 'org-contacts)
  (require 'org-notmuch)

  ;; hack things which use org-clock-into-drawer wrongly
  (defun h/advise-clock-hack (o &rest a)
    (let ((org-clock-into-drawer nil))
      (apply o a)))

  (defun h/advise-clock-string (o &rest args) (concat " " (apply o args)))
  (advice-add 'org-clock-get-clock-string :around #'h/advise-clock-string)
  (advice-add 'org-clock-jump-to-current-clock :around #'h/advise-clock-hack))


;; (req-package org-journal
;;   :require org
;;   :config (setq org-journal-dir "~/notes/journal/"))

(bind-key "<f6>"
          (lambda ()
            (interactive)
            (my-org-journal-goto)
            (org-agenda nil "n")
            (call-interactively #'other-window)))

(req-package org-caldav
  :commands org-caldav-sync
  :init

  ;; davmail gets upset if you hammer it.
  (defun org-caldav-sync-slower (o &rest args)
    (sleep-for 0.05)
    (apply o args))

  (advice-add 'org-caldav-get-event-etag-list :around #'org-caldav-sync-slower)

  (setq org-caldav-calendars
        '((:url
           "http://horde.lrkry.com/rpc.php/calendars/tom/"
           :calendar-id
           "calendar~Ytc0GVEQhRpkeUZSVkj_zw1"
           :files
           ("~/notes/calendar/horde.org")
           :inbox
           "~/notes/calendar/horde-in.org"
           :caldav-uuid-extension
           ".ics")

          (:url
           "https://lrkry.com:1080/users/"
           :calendar-id
           "tom.hinton@cse.org.uk/calendar"
           :caldav-uuid-extension
           ".EML"
           :files
           ("~/notes/calendar/cse.org")
           :inbox
           "~/notes/calendar/cse-in.org")

          ))
  )
