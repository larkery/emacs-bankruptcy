(define-minor-mode org-numbers-overlay-mode
  "Add overlays to org headings which number them"
  nil " *1." nil

  (let ((hooks '(after-save-hook
                 org-insert-heading-hook))
        (funcs '(org-promote
                 org-cycle-level
                 org-promote-subtree
                 org-demote
                 org-demote-subtree
                 org-move-subtree-up
                 org-move-subtree-down
                 org-move-item-down
                 org-move-item-up
                 org-cut-subtree
                 org-insert-todo-heading
                 org-insert-todo-subheading
                 org-meta-return
                 org-set-property
                 org-move)))
    (if org-numbers-overlay-mode
        (progn
          (org-numbers-overlay-update)
          (dolist (fn funcs)
            (advice-add fn :after #'org-numbers-overlay-update))
          (dolist (hook hooks)
            (add-hook hook #'org-numbers-overlay-update)))

      (progn
        (dolist (fn funcs)
          (advice-add fn :after #'org-numbers-overlay-update))
        (dolist (hook hooks)
          (remove-hook hook #'org-numbers-overlay-update))

        (loop for o in (overlays-in (point-min) (point-max))
              if (eq (overlay-get o 'type) 'org-number)
              do (delete-overlay o))))))

(defun org-numbers-overlay-update (&rest args)
  (when org-numbers-overlay-mode
    (let ((continue t)
          (levels (make-vector 10 0))
          (any-unnumbered (member "UNNUMBERED" (org-buffer-property-keys))))
      (save-excursion
        (widen)
        (goto-char (point-min))
        (or (outline-on-heading-p)
            (outline-next-heading))
        (overlay-recenter (point-max))
        (while continue
          (let* ((detail (org-heading-components))
                 (level (- (car detail) 1))
                 (existing-overlays (overlays-in (point)
                                                 (save-excursion (end-of-line) (point))
                                                 ;; (+ 1 (car detail) (point))
                                                 )))
            (if (and any-unnumbered
                     (org-entry-get (point) "UNNUMBERED" 'selective))
                ;; if it's unnumbered delete any overlays we have on it
                (loop for o in existing-overlays
                      if (eq (overlay-get o 'type) 'org-number)
                      do (delete-overlay o))
              ;; if it's not unnumbered add a number or update it
              (let* ((lcounter (1+ (aref levels level)))
                     (o (loop for o in existing-overlays
                              if (eq (overlay-get o 'type) 'org-number)
                              return o))
                     text)

                (aset levels level lcounter)

                (loop for i from (1+ level) to 9
                      do (aset levels i 0))

                (loop for i across levels
                      until (zerop i)
                      do (setf text (if text (format "%s.%d" text i)
                                      (format " %d" i))))
                (if o
                    (move-overlay o (point) (+ (point) (car detail)))
                  (progn
                    (setq o (make-overlay (point) (+ (point) (car detail)) nil t t))
                    (overlay-put o 'type 'org-number)
                    (overlay-put o 'evaporate t)))

                (overlay-put o 'after-string text))))
          (setq continue (outline-next-heading))

          )))))
(provide 'org-numbers-overlay)
