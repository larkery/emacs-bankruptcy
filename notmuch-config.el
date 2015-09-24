(require 'cl)


(req-package notmuch
  :config

  (defun h/open-windows-path (url)
    "If the url starts with file:// then fiddle it to point to ~/net/CSE instead"
    (let* ((parsed (url-generic-parse-url url))
           (type (url-type parsed))
           (fn (url-filename parsed)))

      (if (equal "file" type)
          (let ((unix-path
                 (replace-regexp-in-string
                  "^/+" "/"
                  (replace-regexp-in-string "\\\\" "/" (url-unhex-string fn)))))
            (h/run-ignoring-results "xdg-open" (expand-file-name (concat "~/net/CSE" unix-path))))

        (browse-url url))))

  (defun h/open-windows-mail-link ()
    "An interactive version for h/open-windows-path from the current anchor"
    (interactive)
    (h/open-windows-path (w3m-anchor)))

  (defun h/run-ignoring-results (&rest command-and-arguments)
    "Run a command in an external process and ignore the stdout/err"
    (let ((process-connection-type nil))
      (apply #'start-process (cons "" (cons nil command-and-arguments)))))

  (defun h/hack-file-links ()
    "when in a buffer with w3m anchors, find the anchors and change them so clicking file:// paths uses h/open-windows-mail-link"
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

  (defun h/notmuch/show-only-unread ()
    "In a notmuch show view, collapse all the read messages"
    (interactive "")
    (notmuch-show-mapc
     (lambda ()
       (notmuch-show-message-visible
        (notmuch-show-get-message-properties)
        (member "unread" (notmuch-show-get-tags)))
       )))

  (defun h/notmuch/show-next-unread ()
    "in notmuch show, goto the next unread message"
    (interactive "")
    (let (r)
      (while (and (setq r (notmuch-show-goto-message-next))
                  (not (member "unread" (notmuch-show-get-tags))))))
    (recenter 1))


  (defun h/notmuch/goto-inbox ()
    "convenience to go to the inbbox search"
    (interactive)
    (if (string-equal (system-name) "turnpike.cse.org.uk")
        (notmuch-search "tag:inbox AND path:cse/**")
      (notmuch-search "tag:inbox AND path:fm/**")))

  (defun h/notmuch/flip-tags (&rest tags)
    "Given some tags, add those which are missing and remove those which are present"
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
    "Define a command to toggle the given tags"
    `(lambda ()
       (interactive)
       (h/notmuch/flip-tags ,tag)
       (notmuch-search-next-thread)))

  (defun h/notmuch/sleep ()
    "Tag a particular message as asleep for the next 4 days"
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
  (bind-key "u" #'h/notmuch/show-next-unread notmuch-show-mode-map)
  (bind-key "U" #'h/notmuch/show-only-unread notmuch-show-mode-map)

  (bind-key "." (h/notmuch-toggler "flagged") notmuch-search-mode-map)
  (bind-key "d" (h/notmuch-toggler "deleted") notmuch-search-mode-map)
  (bind-key "u" (h/notmuch-toggler "unread") notmuch-search-mode-map)
  (bind-key "," #'h/notmuch/sleep notmuch-search-mode-map)
  (bind-key "g" 'notmuch-refresh-this-buffer notmuch-search-mode-map)
  (bind-key "<tab>" 'notmuch-show-toggle-message notmuch-show-mode-map)

  (bind-key
   "U"
   (lambda () (interactive) (notmuch-search-filter "tag:unread"))
   notmuch-search-mode-map)

  (bind-key
   "S"
   (lambda () (interactive) (notmuch-search-filter "tag:flagged"))
   notmuch-search-mode-map)

  (bind-key "C-c i" #'h/notmuch/goto-inbox)
  (bind-key "C-c m" #'notmuch-mua-new-mail)

  (add-hook 'notmuch-show-hook #'h/hack-file-links)

  ;; other message stuff

  (setf user-mail-address "tom.hinton@cse.org.uk"

        message-auto-save-directory "~/temp/messages/"
        message-fill-column nil
        message-header-setup-hook '(notmuch-fcc-header-setup)
        message-kill-buffer-on-exit t
        message-send-mail-function 'message-send-mail-with-sendmail
        message-sendmail-envelope-from 'header
        message-signature nil

        mm-inline-text-html-with-images t
        mm-inlined-types '("image/.*"
                           "text/.*"
                           "message/delivery-status"
                           "message/rfc822"
                           "message/partial"
                           "message/external-body"
                           "application/emacs-lisp"
                           "application/x-emacs-lisp"
                           "application/pgp-signature"
                           "application/x-pkcs7-signature"
                           "application/pkcs7-signature"
                           "application/x-pkcs7-mime"
                           "application/pkcs7-mime"
                           "application/pgp")
        mm-sign-option 'guided
        mm-text-html-renderer 'w3m
        mml2015-encrypt-to-self t

        ;; notmuch configuration
        notmuch-archive-tags (quote ("-inbox" "-unread"))
        notmuch-crypto-process-mime t
        notmuch-fcc-dirs (quote
                          (("tom.hinton@cse.org.uk" . "cse/Sent Items")
                           ("larkery.com" . "fm/Sent Items")))
        notmuch-hello-sections '(notmuch-hello-insert-search
                                 notmuch-hello-insert-alltags
                                 notmuch-hello-insert-inbox
                                 notmuch-hello-insert-saved-searches)

        notmuch-mua-cite-function 'message-cite-original-without-signature

        notmuch-saved-searches '((:name "work inbox" :query "tag:inbox AND path:cse/**" :key "w")
                                 (:name "unread" :query "tag:unread" :key "u")
                                 (:name "flagged" :query "tag:flagged" :key "f")
                                 (:name "sent" :query "tag:sent" :key "t")
                                 (:name "all mail" :query "*" :key "a")
                                 (:name "personal inbox" :query "tag:inbox and path:fm/**" :key "p")
                                 (:name "all inbox" :query "tag:inbox" :key "i")
                                 (:name "jira" :query "from:jira@cseresearch.atlassian.net" :key "j" :count-query "J"))

        notmuch-search-line-faces '(("unread" :weight bold)
                                    ("flagged" :foreground "deep sky blue"))

        notmuch-search-oldest-first nil

        notmuch-show-hook '(notmuch-show-turn-on-visual-line-mode goto-address-mode)

        notmuch-show-indent-messages-width 1

        notmuch-tag-formats '(("unread"
                               (propertize tag
                                           (quote face)
                                           (quote
                                            (:foreground "red"))))
                              ("flagged"
                               (notmuch-tag-format-image-data tag
                                                              (notmuch-tag-star-icon))
                               (propertize tag
                                           (quote face)
                                           (quote
                                            (:foreground "orange")))))

        notmuch-wash-original-regexp "^\\(--+ ?[oO]riginal [mM]essage ?--+\\)\\|\\(____+\\)$"
        notmuch-wash-signature-lines-max 30
        notmuch-wash-signature-regexp "^\\(-- ?\\|_+\\|\\*\\*\\*\\*\\*+\\)$"

        ;; citation stuff
        message-cite-style 'message-cite-style-gmail
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
        ))
