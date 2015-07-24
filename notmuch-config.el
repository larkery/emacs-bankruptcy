(req-package notmuch
  :config
  (defun h/notmuch/show-only-unread ()
    (interactive "")
    (notmuch-show-mapc
     (lambda ()
       (notmuch-show-message-visible
        (notmuch-show-get-message-properties)
        (member "unread" (notmuch-show-get-tags)))
       )))

  (defun h/notmuch/show-next-unread ()
    (interactive "")
    (let (r)
      (while (and (setq r (notmuch-show-goto-message-next))
                  (not (member "unread" (notmuch-show-get-tags))))))
    (recenter 1))
  

  (bind-key "u" #'h/notmuch/show-next-unread notmuch-show-mode-map)
  (bind-key "U" #'h/notmuch/show-only-unread notmuch-show-mode-map)

  (defun h/notmuch/goto-inbox ()
    (interactive)
    (notmuch-search "tag:inbox"))
  
  (defun h/notmuch/mark-deleted ()
    "Mark this email as deleted."
    (interactive)
    (notmuch-search-add-tag (list "+deleted"))
    (notmuch-search-next-thread))

  (defun h/notmuch/toggle-flagged ()
    "Toggle the flag on this email."
    (interactive)
    (if (member "flagged" (notmuch-search-get-tags))
        (notmuch-search-remove-tag (list "-flagged"))
      (notmuch-search-add-tag (list "+flagged"))))
  
  (bind-key "." 'h/notmuch/toggle-flagged notmuch-search-mode-map)
  (bind-key "d" 'h/notmuch/mark-deleted notmuch-search-mode-map)
  (bind-key "g" 'notmuch-refresh-this-buffer notmuch-search-mode-map)
  (bind-key "<tab>" 'notmuch-show-toggle-message notmuch-show-mode-map)

  (bind-key "C-c i" #'h/notmuch/goto-inbox)
  (bind-key "C-c m" #'notmuch-mua-new-mail))


(setq
 message-cite-function (quote message-cite-original-without-signature)
 message-citation-line-function (quote message-insert-formatted-citation-line)
 message-cite-reply-position (quote above)
 message-yank-prefix "> "
 message-cite-prefix-regexp "[[:space:]]*>[ >]*"
 message-yank-cited-prefix ">"
 message-yank-empty-prefix ""
 message-citation-line-format "
-----------------------
On %a, %b %d %Y, %N wrote:
"
 )


