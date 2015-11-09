(message "load org")

(req-package appt
  :config
  (require 'notifications)
  
  (defun h/appt-notify (mins new-time msg)
    (notifications-notify
     :body (format "In %s minutes" mins)
     :title (format "%s" msg)))

  (setq appt-message-warning-time 60
        appt-display-mode-line t
        appt-disp-window-function #'h/appt-notify
        appt-delete-window-function (lambda ())
        appt-display-interval 10
        appt-display-format 'window)
  
  (appt-activate t))

(req-package org
  :defer nil
  :bind (("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture))
  
  :config
  (require 'appt)
  (org-clock-persistence-insinuate)
  (add-hook 'org-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (setq mode-name "OM")
              (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t)))

  (add-hook 'org-agenda-finalize-hook 'org-agenda-to-appt)
  (run-at-time "24:01" 3600 'org-agenda-to-appt)

  (bind-key "C-M-i" #'completion-at-point org-mode-map)

  (require 'org-contacts)
  (require 'org-notmuch)

  ;; hack things which use org-clock-into-drawer wrongly
  (defun h/advise-clock-hack (o &rest a)
    (let ((org-clock-into-drawer nil))
      (apply o a)))

  (defun h/advise-clock-string (o &rest args) (concat " " (apply o args)))
  (advice-add 'org-clock-get-clock-string :around #'h/advise-clock-string)
  (advice-add 'org-clock-jump-to-current-clock :around #'h/advise-clock-hack))

(req-package org-journal
  :require org
  :config (setq org-journal-dir "~/org/journal/"))

(req-package org-caldav
  :commands org-caldav-sync
  :init
  (setq org-caldav-url "http://horde.lrkry.com/rpc.php/calendars/tom/"
        org-caldav-calendar-id "calendar~Ytc0GVEQhRpkeUZSVkj_zw1"
        org-caldav-inbox (expand-file-name "~/org/horde.org"))
  (setq org-caldav-files `(,org-caldav-inbox)))
