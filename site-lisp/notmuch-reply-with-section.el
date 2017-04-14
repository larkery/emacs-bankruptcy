(defvar my-selection-to-quote nil)
(defvar my-reply-subject nil)
(defvar my-reply-to nil)

(defun my-notmuch-reply-someone-qs (headers tocall)
  (let* ((nm-headers (plist-get (notmuch-show-get-message-properties)
                                :headers))

         (my-reply-subject (plist-get nm-headers :Subject))
         (my-reply-to (plist-get nm-headers :To))

         (message-cite-style
          (loop for style in message-cite-styles
                for hdr in headers

                when (let ((h (plist-get nm-headers hdr)))
                       (when h (string-match-p (car style) h)))
                return (cdr style)

                finally return message-cite-style))

         (my-selection-to-quote
          (when (use-region-p)
            (buffer-substring-no-properties (point) (mark)))))

    (eval `(let ,(if (symbolp message-cite-style)
                     (symbol-value message-cite-style)
                   message-cite-style)
             (call-interactively ,(quote tocall))))))

(defun my-notmuch-reply-sender-qs ()
  (interactive "")
  (my-notmuch-reply-someone-qs '(:From) 'notmuch-show-reply-sender))

(defun my-notmuch-reply-qs ()
  (interactive "")
  (my-notmuch-reply-someone-qs '(:From :Cc :To) 'notmuch-show-reply))

(defun message-cite-original-without-signature-or-selection ()
    (if my-selection-to-quote
        (save-excursion
          (let* ((here (point))
                 after-header)
            (forward-line 3)
            (delete-region (point) (mark))
            (setq after-header (point))
            (insert my-selection-to-quote)
            (set-mark (point))
            (goto-char after-header)
            (minimally-indent (point) (mark))
            (goto-char here)
            )))
    (message-cite-original-without-signature))

(provide 'notmuch-reply-with-selection)
