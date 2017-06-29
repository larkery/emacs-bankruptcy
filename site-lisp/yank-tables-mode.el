(defun yank-table (in-separator)
  (interactive)
  (message "formatting table!")
  (let ((col (current-column))
        (sep yank-table-replace-separator))
    (insert
     (with-temp-buffer
       (let ((indent-tabs-mode nil)) ;; stop align-regexp breaking things
         (yank)
         (goto-char (point-min))
         (when sep
           (if (search-forward sep nil t)
               (progn (message "Output separator already exists! Not changing separator!")
                      (setq sep nil))
             (goto-char (point-min))
             (while (search-forward in-separator nil t)
               (delete-char -1)
               (insert sep))))

         (align-regexp (point-min) (point-max)
                       (rx-to-string `(seq (group (* white)) ,(or sep in-separator)) t)
                       1 1 t)
         (goto-char (point-min))
         (forward-line)
         (indent-rigidly (point) (point-max) col)
         (buffer-string)))
     )))

(defun yank-table-guess-tabular (str)
  (let ((lines (split-string str "\n")))
    (when (> (length lines) 1)
        (loop for sep in '("\t" "," "|")
           when (let (line-cells best-cells)
                  (loop for line in lines
                        unless (string= line "")
                        do (setq line-cells (length (split-string line sep)))
                        if (or (<= line-cells 1)
                               (and best-cells (not (= line-cells best-cells))))
                        return nil
                        else
                        do (setq best-cells line-cells)
                        return line-cells))
           return sep))))

(defun yank-table-or-yank (arg)
  (interactive "*P")
  (when (equal arg '(16)) ;; this is C-u C-u C-u
    (setq yank-table-replace-separator
          (completing-read "Separator: "
                           '("<TAB>" ", " "|" "<ORIGINAL>")))
    (when (string= yank-table-replace-separator "<TAB>")
      (setq yank-table-replace-separator "	"))
    (when (string= yank-table-replace-separator "<ORIGINAL>")
      (setq yank-table-replace-separator nil))
    (setq arg nil))

  (if-let ((separator (and (not arg) (yank-table-guess-tabular (current-kill 0)))))
      (yank-table separator)
    (yank arg)))

(defvar yank-table-replace-separator nil
  "What separator to use after pasting a table")

(make-variable-buffer-local 'yank-table-replace-separator)

(define-minor-mode yank-tables-mode
  "When pasting, check for what looks like tabular data and align it"
  nil " Yank-Table"
  `(([remap yank] . yank-table-or-yank)))

(provide 'yank-tables-mode)
