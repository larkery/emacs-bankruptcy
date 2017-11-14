(require 'org)

(defun org-find-create-path (path &optional in-buffer)
  (save-excursion
    (with-current-buffer
        (if in-buffer
            (current-buffer)
          (find-file-noselect (pop path)))
      (org-with-wide-buffer
       (goto-char (point-min))

       (let (end found flevel (lmin 1) (lmax 1) (level 1))
         (dolist (heading path)
           (let ((re (format org-complex-heading-regexp-format
                             (regexp-quote heading)))
                 (cnt 0))
             (while (re-search-forward re end t)
               (setq level (- (match-end 1) (match-beginning 1)))
               (when (and (>= level lmin) (<= level lmax))
                 (setq found (match-beginning 0) flevel level cnt (1+ cnt))))
             (cond
              ((= cnt 0)
               (if (org-before-first-heading-p)
                   (org-insert-heading)
                 (org-insert-heading-after-current)
                 (org-demote))
               (insert heading)
               (setq flevel level)
               (org-back-to-heading))
              ((> cnt 1)
               (error "Heading not unique on level %d: %s" lmax heading))
              (t (goto-char found)))
             (setq lmin (1+ flevel) lmax (+ lmin (if org-odd-levels-only 1 0)))
             (setq end (save-excursion (org-end-of-subtree t t))))
           ))
       (when (org-at-heading-p)
         (point-marker))))))

(provide 'org-misc)
