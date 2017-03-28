(defcustom org-timesheets-file
  "~/notes/work/timesheet.org"
  "The org-mode file to put timesheet logging in"
  :type 'string)

(defcustom org-timesheets-misc-task
  "Miscellaneous"
  "The heading for miscellaneous time"
  :type 'string)

(defvar org-timesheets-clocked-in nil)

(defun org-timesheets-maybe-lose-time ()
  (when (and org-timesheets-clocked-in
             (not (org-clock-is-active))
             (not org-clock-clocking-in))
    (save-excursion
      (save-match-data
        (let ((org-clock-continuously t))
          (with-current-buffer
              (find-file-noselect org-timesheets-file)
            (goto-char (point-min))
            (or (search-forward-regexp (rx-to-string `(seq line-start "* "
                                                           ,org-timesheets-misc-task
                                                           line-end))
                                       nil t)
                (progn (goto-char (point-max))
                       (insert "* " org-timesheets-misc-task "\n")))
            (org-clock-in)))))))

(add-hook 'org-clock-out-hook 'org-timesheets-maybe-lose-time)

(defun org-timesheets-punch-clock ()
  "Punch that clock. Wham."
  (interactive)

  (let ((org-clock-continuously t))
    (if org-timesheets-clocked-in
        (progn (org-timesheets-maybe-lose-time)
               (setq org-timesheets-clocked-in nil)
               (org-clock-out))

      (org-timesheets-switch-task))))

(defun org-refile--get-location-toplevel (o &rest args)
  (let ((ores (apply o args)))
    (or ores
        (when org-refile-top-level-target
          (org-refile-new-child org-refile-top-level-target (car args))))))

(advice-add 'org-refile--get-location
            :around
            'org-refile--get-location-toplevel)

(defun org-timesheets-switch-task ()
  "Clock into a different task in the timesheet using a magical menu."
  (interactive)

  (let ((org-clock-continuously t))
    (org-timesheets-maybe-lose-time)
    ;; TODO clock into something, maybe creating it


    (let* ((org-refile-targets `(((,org-timesheets-file) .
                                  (:maxlevel . 2))))
           (org-refile-top-level-target (list org-timesheets-file
                                              org-timesheets-file))
           (org-refile-use-outline-path 't)
           (org-refile-history nil)
           (loc (org-refile-get-location "Clock into" nil t))

           (filename (nth 1 loc))
           (pos (nth 3 loc)))

      ;; loc is where we are clocking into?
      (save-excursion
        (with-current-buffer
            (find-file-noselect filename)
          (goto-char pos)
          (org-clock-in))))

    (setq org-timesheets-clocked-in t)))

(provide 'org-timesheets)
