(require 'cl)

(defun h/open-windows-path (url)
  (let* ((parsed (url-generic-parse-url url))
         (type (url-type parsed))
         (fn (url-filename parsed)))

    (if (equal "file" type)
      (let ((unix-path
             (replace-regexp-in-string
              "^/+" "/"
              (replace-regexp-in-string "\\\\" "/" (url-unhex-string fn)))))
        (h/run-ignoring-results "xdg-open" (expand-file-name (concat "~/net/CSE" unix-path))))

      (browse-url url)
      )))

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
    (notmuch-search "tag:inbox AND path:cse/**"))

  (defun h/notmuch/flip-tags (&rest tags)
    (notmuch-search-tag
     (let ((existing-tags (notmuch-search-get-tags)) (amendments nil))
       (dolist (tag tags)
         (push
          (concat
           (if (member tag existing-tags) "-" "+")
           tag)
          amendments))
       amendments)
     ))
  
  (defmacro h/notmuch-toggler (tag)
    `(lambda ()
       (interactive)
       (h/notmuch/flip-tags ,tag)
       (notmuch-search-next-thread)))

  ;; todo: glue in refiler for this
  (defun h/notmuch/sleep ()
    (interactive)
    (if (member "asleep" (notmuch-search-get-tags))
        (notmuch-search-tag (loop
                             for tag in (notmuch-search-get-tags)
                             if (string-prefix-p "asleep" tag)
                             collect (concat "-" tag)))

      (notmuch-search-tag (list "-inbox"
                                "+asleep"
                                (concat "+asleep-until-"
                                        (format-time-string
                                         "%Y-%m-%d"
                                         (time-add (current-time)
                                                   (days-to-time 4))))))))
  
  (defun h/notmuch/capture ()
    "make an email go into an org capture template"
    (interactive)
    (require 'org-notmuch)
    ;(org-store-link 0)
    (org-capture t "c"))

  (bind-key "k" #'h/notmuch/capture notmuch-show-mode-map)
  
  (bind-key "." (h/notmuch-toggler "flagged")
            notmuch-search-mode-map)

  (bind-key "d" (h/notmuch-toggler "deleted")
            notmuch-search-mode-map)

  (bind-key "u" (h/notmuch-toggler "unread")
            notmuch-search-mode-map)

  (bind-key "," #'h/notmuch/sleep
            notmuch-search-mode-map)
  
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

