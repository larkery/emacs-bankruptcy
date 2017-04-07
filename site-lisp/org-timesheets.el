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

(defun org-timesheets-clock-out (p)
  "Punch that clock. Wham."
  (interactive "P")

  (when org-timesheets-clocked-in
    (org-timesheets-maybe-lose-time)
    (setq org-timesheets-clocked-in nil)
    (org-clock-out nil nil
                   (when p
                     (org-read-date t t)))
    (force-mode-line-update t)))


(defun org-refile--get-location-toplevel (o refloc tbl)
  (let ((ores (funcall o refloc tbl)))
    (or ores
        (when (and (not (string-match "\\`\\(.*\\)/\\([^/]+\\)\\'" refloc))
                   org-refile-top-level-target)
          (org-refile-new-child org-refile-top-level-target refloc)))))

(advice-add 'org-refile--get-location
            :around
            'org-refile--get-location-toplevel)

(defun org-timesheets-switch-task (p)
  "Clock into a different task in the timesheet using a magical menu."
  (interactive "P")

  ;; if we are meant to be clocked in, then we should clock continuously
  ;; but otherwise it is a new day today

  (org-timesheets-maybe-lose-time)

  (let* ((org-refile-targets `(((,org-timesheets-file) .
                                (:maxlevel . 3))))
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
        (let ((org-clock-continuously (if p nil
                                        org-timesheets-clocked-in)))
          (org-clock-in nil (when p (org-read-date t t))))))

    (setq org-timesheets-clocked-in t)))

(defun org-timesheets-resize ()
  (condition-case nil
      (let ((ln (save-excursion
                  (goto-char (point-max))
                  (line-number-at-pos))))
        (set-window-text-height (get-buffer-window)
                                (+ 0 ln)))
    (error)))


(defun org-timesheets-toggle-day-step ()
  (interactive)
  (read-only-mode 0)
  (save-excursion (goto-char (point-min))
                  (if (search-forward " :step " nil t)
                      (progn (backward-word)
                             (backward-char 2)
                             (let (kill-ring)
                               (kill-word 2)))
                    (progn (search-forward "clocktable")
                           (end-of-line)
                           (insert " :step day"))))
  (org-clock-report)
  (org-timesheets-resize)
  (read-only-mode 1))

(defun org-timesheets-report-move (delta)
  (read-only-mode 0)
  (save-excursion
    (goto-char (point-min))
    (search-forward ":block")
    (forward-word)

    (let* ((kill-ring nil)
           (value

            (+ delta (or (when (looking-at (rx "-" (one-or-more digit)))
                           (kill-word nil)
                           (string-to-number (car kill-ring)))
                         0))))

      (when (< value 0) (insert (format "%d" value)))))
  (org-clock-report)
  (org-timesheets-resize)
  (read-only-mode 1))

(defun org-timesheets-report-forward ()
  (interactive)
  (org-timesheets-report-move 1))

(defun org-timesheets-report-back ()
  (interactive)
  (org-timesheets-report-move -1))

(defun org-timesheets-report (&rest params)
  (with-current-buffer (get-buffer-create "*Org-Timesheets*")
    (pop-to-buffer (current-buffer))
    (read-only-mode 0)
    (org-mode)
    (erase-buffer)
    (org-clock-report)
    (search-forward ":")
    (search-forward ":")
    (backward-char)
    (kill-line)
    (dolist (param params)
      (insert " " (prin1-to-string param))
      )

    (org-clock-report)
    (org-timesheets-resize)
    (read-only-mode 1)
    (org-timesheets-minor-mode 1)))

(defun org-timesheets-report-today ()
  (interactive)
  (org-timesheets-report
   :link t
   :scope (list org-timesheets-file)
   :block 'today
   :compact t
   :properties '("CODE")
   :fileskip0 t
   :stepskip0 t
   ))

(defun org-timesheets-report-this-week ()
  (interactive)
  (org-timesheets-report
   :link t
   :scope (list org-timesheets-file)
   :block 'thisweek
   :compact t
   :properties '("CODE")
   :fileskip0 t
   :stepskip0 t
   :step 'day))

(define-minor-mode org-timesheets-minor-mode
  "Some keys for the timesheet popup"
  nil ""
  '(("q" . quit-window)
    ("n" . forward-paragraph)
    ("p" . backward-paragraph)
    ("b" . org-timesheets-report-back)
    ("f" . org-timesheets-report-forward)
    ("w" . org-timesheets-report-this-week)
    ("d" . org-timesheets-report-today)
    ("s" . org-timesheets-toggle-day-step)))

(provide 'org-timesheets)
