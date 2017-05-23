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
      (interactive)

      (when org-numbers-overlaymode
            (let ((levels (make-vector 10 0)))
              (save-excursion
                (widen)
                (goto-char (point-min))
                (while (outline-next-heading)
                  (let* ((detail (org-heading-components))
                         (level (- (car detail) 1))
                         (lcounter (1+ (aref levels level)))
                         (o (or (loop for o in (overlays-in (point)
                                                            (save-excursion (end-of-line) (point)))
                                      if (eq (overlay-get o 'type) 'org-number)
                                      return o)
                                (make-overlay (point) (+ (point) (car detail))))))
                    (aset levels level lcounter)
                    (loop for i from (1+ level) to 9
                          do (aset levels i 0))
                    (overlay-put o 'type 'org-number)
                    (overlay-put o 'evaporate t)
                    (overlay-put o 'after-string
                                 (let (s)
                                   (loop for i across levels
                                         until (zerop i)
                                         do (setf s (if s (format "%s.%d" s i)
                                                      (format " %d" i))
                                                  ))
                                   s))))))))
(provide 'org-numbers-overlay)
