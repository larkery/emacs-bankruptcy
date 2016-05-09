(req-package notmuch
  :commands notmuch h/notmuch/goto-inbox notmuch-mua-new-mail

  :bind (("C-c i" . h/notmuch/goto-inbox)
         ("H-i" . h/notmuch/goto-inbox)
         ("C-c m" . notmuch-mua-new-mail)
         ("H-m" . notmuch-mua-new-mail))

  :config

  (require 'notmuch-calendar)
  (require 'notmuch-extras)

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


  (defun h/notmuch/goto-inbox (prefix)
    "convenience to go to the inbbox search"
    (interactive "P")
    (if prefix
        (if (equal (system-name) "keats")
          (notmuch-search "tag:inbox AND path:cse/**")
        (notmuch-search "tag:inbox AND path:fastmail/**"))
      (notmuch-search "tag:unread")))

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

  (set-mode-name notmuch-search "nm-search")
  (set-mode-name notmuch-show "nm-show")
  (set-mode-name notmuch-message-mode "mail")

  ;;(bind-key "C" #'notmuch-reply-to-calendar notmuch-show-mode-map)
  (bind-key "u" #'h/notmuch/show-next-unread notmuch-show-mode-map)
  (bind-key "U" #'h/notmuch/show-only-unread notmuch-show-mode-map)

  (bind-key "." (h/notmuch-toggler "flagged") notmuch-search-mode-map)
  (bind-key "d" (h/notmuch-toggler "deleted") notmuch-search-mode-map)
  (bind-key "u" (h/notmuch-toggler "unread") notmuch-search-mode-map)
  (bind-key "," #'h/notmuch/sleep notmuch-search-mode-map)
  (bind-key "g" 'notmuch-refresh-this-buffer notmuch-search-mode-map)

  (bind-key
   "U"
   (lambda () (interactive) (notmuch-search-filter "tag:unread"))
   notmuch-search-mode-map)

  (bind-key
   "S"
   (lambda () (interactive) (notmuch-search-filter "tag:flagged"))
   notmuch-search-mode-map)

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
                          (("tom\\.hinton@cse\\.org\\.uk" . "cse/Sent Items")
                           ("larkery\\.com" . "fastmail/Sent Items")))
        notmuch-hello-sections '(notmuch-hello-insert-search
                                 notmuch-hello-insert-alltags
                                 notmuch-hello-insert-inbox
                                 notmuch-hello-insert-saved-searches)

        notmuch-mua-cite-function 'message-cite-original-without-signature

        notmuch-saved-searches '((:name "all mail" :query "*" :key "a")
                                 (:name "all inbox" :query "tag:inbox" :key "i")
                                 (:name "work inbox" :query "tag:inbox AND path:cse/**" :key "w")
                                 (:name "unread" :query "tag:unread" :key "u")
                                 (:name "flagged" :query "tag:flagged" :key "f")
                                 (:name "sent" :query "tag:sent" :key "t")
                                 (:name "personal inbox" :query "tag:inbox and path:fm/**" :key "p")
                                 (:name "jira" :query "from:jira@cseresearch.atlassian.net" :key "j" :count-query "J"))

        notmuch-search-line-faces '(("unread" :weight bold)
                                    ("flagged" :foreground "deep sky blue"))

        notmuch-search-oldest-first nil

        notmuch-show-hook '(notmuch-show-turn-on-visual-line-mode
                            goto-address-mode
                            h/hack-w3m-links
                            )

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

        notmuch-wash-original-regexp "^\\(--+ ?[oO]riginal [mM]essage ?--+\\)\\|\\(____+\\)\\(writes:\\)writes$"
        notmuch-wash-signature-lines-max 30
        notmuch-wash-signature-regexp (rx
                                       bol

                                       (or
                                        (seq (* nonl) "not the intended recipient" (* nonl))
                                        (seq "The original of this email was scanned for viruses" (* nonl))
                                        (seq "__" (* "_"))
                                        (seq "****" (* "*"))
                                        (seq "--" (** 0 5 "-") (* " ")))

                                       eol)

        ;; citation stuff
        message-cite-style nil
        message-cite-function (quote message-cite-original-without-signature)
        message-citation-line-function (quote message-insert-formatted-citation-line)
        message-cite-reply-position 'traditional
        message-yank-prefix "> "
        message-cite-prefix-regexp "[[:space:]]*>[ >]*"
        message-yank-cited-prefix ">"
        message-yank-empty-prefix ""
        message-citation-line-format ""
        )
  )
