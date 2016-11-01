(req-package notmuch
  :commands
  notmuch notmuch-mua-new-mail my-inbox
  :bind
  (("C-c i" . my-inbox)
   ("C-c m" . notmuch-mua-new-mail))
  :config

  (defun my-mml-attach-dired ()
    (interactive)

    (lexical-let ((mail-buffer (current-buffer)))
      (my-split-window)
      (dired default-directory)
      (local-set-key (kbd "q")
                     (lambda ()
                       (interactive)

                       (let ((marked-files
                              (delq nil
                                    (mapcar
                                     ;; don't attach directories
                                     (lambda (f) (if (file-directory-p f) nil f))
                                     (nreverse
                                      (let ((arg nil)) ;; Silence XEmacs 21.5 when compiling.
                                        (dired-map-over-marks (dired-get-filename) arg)))))
                              ))

                         (with-current-buffer mail-buffer
                           (save-excursion
                             (goto-char (point-max))
                             (dolist (f marked-files)
                               (mml-attach-file f (or (mm-default-file-encoding f)
                                                      "application/octet-stream") nil)

                               )))
                         )

                       (kill-this-buffer)
                       (delete-window)
                       )
                     ))
    )

  (bind-key "C-c C-m C-a" 'my-mml-attach-dired message-mode-map)

  (defun my-notmuch-adjust-name (args)
    (let ((a (car args))
          (authors (cadr args)))
      (list a (and authors (replace-regexp-in-string "Tom Hinton" "Me" authors)))))

  (advice-add 'notmuch-search-insert-authors :filter-args #'my-notmuch-adjust-name)

  (defun my-inbox ()
    (interactive)
    (notmuch-search "tag:inbox OR tag:flagged OR tag:unread"))

  (defun my-notmuch-flip-tags (&rest tags)
    "Given some tags, add those which are missing and remove those which are present"
    (notmuch-search-tag
     (let ((existing-tags (notmuch-search-get-tags)) (amendments nil))
       (dolist (tag tags)
         (push
          (concat
           (if (member tag existing-tags) "-" "+")
           tag)
          amendments))
       amendments))
    (notmuch-search-next-thread))

  (bind-keys
   :map notmuch-search-mode-map
   ("." . (lambda () (interactive) (my-notmuch-flip-tags "flagged")))
   ("d" . (lambda () (interactive) (my-notmuch-flip-tags "deleted")))
   ("u" . (lambda () (interactive) (my-notmuch-flip-tags "unread")))
   ("g" . notmuch-refresh-this-buffer))

  (setq user-mail-address "tom.hinton@cse.org.uk"

        message-auto-save-directory "~/temp/messages/"
        message-fill-column nil
        message-header-setup-hook '(notmuch-fcc-header-setup)
        message-default-headers "X-Clacks-Overhead: GNU Terry Pratchett\n"
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
                          (("tom\\.hinton@cse\\.org\\.uk" . "\"cse/Sent Items\" +sent")
                           ("larkery\\.com" . "\"fastmail/Sent Items\" +sent")))
        notmuch-hello-sections '(notmuch-hello-insert-search
                                 notmuch-hello-insert-alltags
                                 notmuch-hello-insert-inbox
                                 notmuch-hello-insert-saved-searches)

        notmuch-mua-cite-function 'message-cite-original-without-signature

        notmuch-saved-searches '((:name "all mail" :query "*" :key "a")
                                 (:name "all inbox" :query "tag:inbox" :key "i")
                                 (:name "work inbox" :query "tag:inbox AND path:cse/**" :key "w")
                                 (:name "live" :query "tag:unread or tag:flagged" :key "u")
                                 (:name "flagged" :query "tag:flagged" :key "f")
                                 (:name "sent" :query "tag:sent" :key "t")
                                 (:name "personal inbox" :query "tag:inbox and path:fm/**" :key "p")
                                 (:name "jira" :query "from:jira@cseresearch.atlassian.net" :key "j" :count-query "J"))

        notmuch-search-line-faces '(("unread" :weight bold)
                                    ("flagged" :background "darkgreen"))

        notmuch-search-oldest-first nil

        notmuch-show-hook '(notmuch-show-turn-on-visual-line-mode
                            goto-address-mode)

        notmuch-show-indent-messages-width 2

        notmuch-tag-formats '(("unread" "U" (notmuch-apply-face tag '(:foreground "green")))
                              ("inbox" "I" (notmuch-apply-face tag '(:foreground "white")))
                              ("EXS" "J")
                              ("replied" "r")
                              ("flagged" "F" (notmuch-apply-face tag '(:weight bold)))
                              ("attachment" "A" (notmuch-apply-face tag '(:foreground "white"))))

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

        notmuch-address-selection-function
        (lambda (prompt collection initial-input)
          (ido-completing-read prompt collection nil nil nil 'notmuch-address-history)))

  (setq mailcap-mime-data
        (mapcar
         (lambda (entry)

           (cons (car entry)
                 (cons
                  ;; todo these may want to be at the end rather than the start?
                  `(".*"
                    (viewer . "xdg-open %s")
                    (type . ,(format "%s/*" (car entry))))
                  (remove-if-not #'identity
                                 (mapcar
                                  (lambda (subtype)
                                    (unless (stringp (cdr (assoc 'viewer subtype)))
                                      subtype))
                                  (cdr entry))))))
         mailcap-mime-data))
  )
