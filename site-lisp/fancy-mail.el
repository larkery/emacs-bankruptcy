(require 'org-mime)

(defvar mail-is-fancy 'auto)
(make-variable-buffer-local 'mail-is-fancy)

(defun mail-is-fancy ()
    (and (not (eq 'no mail-is-fancy))
         (or (eq 'yes mail-is-fancy)
             (save-excursion
               (goto-char (point-min))
               (search-forward mail-header-separator)
               (search-forward-regexp
                (rx (| (seq ;; this is line start constructs
                        bol
                        (| (+ "*") ;; heading
                           (seq (* blank) (| "| " ;; table
                                             "- " ;; lists
                                             "+ "
                                             (seq (* digit) ".")))
                           ))
                       ;; this is style stuff

                       (seq bol
                            (* space)
                            (not (any ">"))
                            (seq (group-n 1 (any "_/*"))
                                 (* (any alpha " " digit))
                                 (backref 1)))
                       ))
                (point-max) t)))))



(defun org-mime-htmlize (arg)
  "Export a portion of an email to html using `org-mode'.
If called with an active region only export that region, otherwise entire body.
If ARG is not nil, use `org-mime-fixedwith-wrap' to wrap the exported text."
  (interactive "P")
  (if org-mime-debug (message "org-mime-htmlize called"))
  (let* ((region-p (org-region-active-p))
         (html-start (funcall org-mime-find-html-start
                              (or (and region-p (region-beginning))
                                  (save-excursion
                                    (goto-char (point-min))
                                    (search-forward mail-header-separator)
                                    (+ (point) 1)))))
         (html-end (or (and region-p (region-end))
                       ;; TODO: should catch signature...
                       (point-max)))
         (orig-body (buffer-substring html-start html-end))
         (using-hard-newlines use-hard-newlines)
         (body (with-temp-buffer
                 (setq-local use-hard-newlines using-hard-newlines)
                 (insert orig-body)
                 (goto-char (point-min))
                 (run-hooks 'org-mime-pre-html-hook)
                 (buffer-string)))
         (header-body (concat org-mime-default-header body))
         (tmp-file (make-temp-name (expand-file-name
                                    "mail" temporary-file-directory)))
         ;; because we probably don't want to export a huge style file
         (org-export-htmlize-output-type 'inline-css)
         ;; makes the replies with ">"s look nicer
         (org-export-preserve-breaks org-mime-preserve-breaks)
         ;; dvipng for inline latex because MathJax doesn't work in mail
         ;; Also @see https://github.com/org-mime/org-mime/issues/16
         ;; (setq org-html-with-latex nil) sometimes useful
         (org-html-with-latex org-mime-org-html-with-latex-default)
         ;; to hold attachments for inline html images
         (html-and-images
          (org-mime-replace-images
           (org-mime--export-string header-body
                                    'html
                                    (if (fboundp 'org-export--get-inbuffer-options)
                                        (org-export--get-inbuffer-options)))
           tmp-file))
         (html-images (unless arg (cdr html-and-images)))
         (html (org-mime-apply-html-hook
                (if arg
                    (format org-mime-fixedwith-wrap header-body)
                  (car html-and-images)))))
    (delete-region html-start html-end)
    (save-excursion
      (goto-char html-start)
      (insert (org-mime-multipart
               orig-body html (mapconcat 'identity html-images "\n"))))))

(defun org-mime-blockify-quotes ()
  (let ((block-start "#+BEGIN_QUOTE html\n")
        (block-end "\n#+END_QUOTE")
        (changed t))
    (while changed
      (goto-char (point-min))
      (setq changed nil)
      (while (and (< (point) (point-max))
                  (search-forward-regexp "^>" nil t))
        (setq changed t)
        (let* ((first-quote (match-beginning 0))
               (last-quote first-quote))
          (goto-char first-quote)
          (while (and (< (point) (point-max))
                      (looking-at (rx bol (| ">" eol))))
            (when (looking-at (rx bol ">"))
              (end-of-line)
              (setq last-quote (point)))
            (forward-line))

          (save-restriction
            (narrow-to-region first-quote last-quote)
            (goto-char (point-min))
            (replace-regexp "^>" "")
            (goto-char (point-min))
            (insert block-start)
            (goto-char (point-max))
            (insert block-end))))
      )))

(defun mail-add-hard-newlines ()
  (when use-hard-newlines
    (save-excursion
      (goto-char (point-min))
      (while (search-forward "\n" nil t)
        (let ((pos (point)))
          (move-to-left-margin)
          (when (looking-at paragraph-start)
            (set-hard-newline-properties (1- pos) pos))
          ;; If paragraph-separate, newline after it is hard too.
          (when (looking-at paragraph-separate)
            (set-hard-newline-properties (1- pos) pos)
            (end-of-line)
            (unless (eobp)
              (set-hard-newline-properties (point) (1+ (point))))))))

    (save-excursion
      (goto-char (point-min))
      (search-forward mail-header-separator)

      (while (search-forward "\n" (point-max) t)
        (when (or (get-text-property (1- (point)) 'quoted-reply)
                  (org-context-p 'headline 'table))
          (add-text-properties (1- (point)) (point) (list 'hard t)))))))

(defun org-mime-clean-newlines ()
  (when use-hard-newlines
    (while (search-forward "\n" (point-max) t)
      (unless (or (get-text-property (1- (point)) 'quoted-reply)
                  (get-text-property (1- (point)) 'hard)
                  (looking-at (rx bol (* space) eol))
                  (org-context-p 'item 'headline 'table))
        (delete-char -1)
        (unless (looking-at "[[:space:]]") (insert " "))))))

(add-hook 'message-send-hook 'mail-add-hard-newlines)
(add-hook 'org-mime-pre-html-hook #'org-mime-blockify-quotes)
(add-hook 'org-mime-pre-html-hook #'org-mime-clean-newlines)

(provide 'fancy-mail)
