(defun h/marker-to-clock-candidate (marker)
  (with-temp-buffer
    (let ((cm (org-clock-insert-selection-line 0 marker)))
      (goto-char (marker-position marker))
      (cons (replace-regexp-in-string
             "\n" ""
             (buffer-substring 4 (point-at-eol)))
            marker
            ;(cdr cm)
            ))))

(defun h/clock-history ()
  (let (och)
    ;; Remove successive dups from the clock history to consider
    (mapc (lambda (c) (if (not (equal c (car och))) (push c och)))
          org-clock-history)
    (setq och (reverse och) chl (length och))
    (mapcar (lambda (m)
              (when (marker-buffer m)
                (h/marker-to-clock-candidate m)))
            och)))

(defun h/org-clock-in (marker)
  (message (format "clock in to %s" marker))
  (switch-to-buffer (marker-buffer marker))
  (goto-char (marker-position marker))
  (org-show-context)
  (org-show-entry)
  (beginning-of-line)
  (call-interactively #'org-clock-in))

(defvar h/helm-clock-actions
  (helm-make-actions
   "Clock in" #'h/org-clock-in
   "Go to entry" #'helm-org-goto-marker))

(defvar h/clock-history-helm-source
  (helm-build-sync-source "Recently clocked tasks"
    :action h/helm-clock-actions
    :candidates 'h/clock-history))

(defvar h/low-agenda-helm-source
  (helm-build-sync-source "Org agenda headings"
    :action h/helm-clock-actions
    :candidates (helm-org-get-candidates (org-agenda-files) 1 4)))

(defun h/helm-org-clock ()
  (interactive)
  (helm
   :buffer "*helm-org-clock-in*"
   :sources (list 'h/clock-history-helm-source
                  'h/low-agenda-helm-source
                  (helm-source-org-capture-templates))))

