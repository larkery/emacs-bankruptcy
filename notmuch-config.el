(defun h/open-windows-path (url)
  (let* ((parsed (url-generic-parse-url url))
         (type (url-type parsed))
         (fn (url-filename parsed)))

    (when (equal "file" type)
      (let ((unix-path
             (replace-regexp-in-string
              "^/+" "/"
              (replace-regexp-in-string "\\\\" "/" (url-unhex-string fn)))))
        (h/run-ignoring-results "xdg-open" (expand-file-name (concat "~/net/CSE" unix-path)))))))

(defun h/open-windows-mail-link ()
  (interactive)
  (h/open-windows-path (w3m-anchor)))

(defun h/run-ignoring-results (&rest command-and-arguments)
  (let ((process-connection-type nil))
    (apply #'start-process (cons "" (cons nil command-and-arguments)))))

(defun h/hack-file-links ()
  (interactive)
  
  (let ((was-read-only buffer-read-only))
    (when was-read-only
      (read-only-mode -1))
    
    (let ((map (make-sparse-keymap))
          (last nil)
          (end (point-max))
          (pos (point-min)))

      (define-key map [mouse-1] #'h/open-windows-mail-link)
      
      (while (and pos (< pos end))
        (setq pos (next-single-property-change pos 'w3m-anchor-sequence))
        (when pos
          (if (get-text-property pos 'w3m-anchor-sequence)
              (setq last pos)
            (put-text-property last pos 'keymap map))))
      
      )
    (when was-read-only
      (read-only-mode 1))))


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

  (defun h/notmuch/capture ()
    "make an email go into an org capture template"
    (interactive)
    (require 'org-notmuch)
    ;(org-store-link 0)
    (org-capture t "c"))

  (bind-key "k" #'h/notmuch/capture notmuch-show-mode-map)
  
  (bind-key "." 'h/notmuch/toggle-flagged notmuch-search-mode-map)
  (bind-key "d" 'h/notmuch/mark-deleted notmuch-search-mode-map)
  (bind-key "g" 'notmuch-refresh-this-buffer notmuch-search-mode-map)
  (bind-key "<tab>" 'notmuch-show-toggle-message notmuch-show-mode-map)
  
  
  (bind-key "C-c i" #'h/notmuch/goto-inbox)
  (bind-key "C-c m" #'notmuch-mua-new-mail)
  (add-hook 'notmuch-show-hook #'h/hack-file-links)
  )


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

