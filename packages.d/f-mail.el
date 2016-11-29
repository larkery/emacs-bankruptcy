(initsplit-this-file bos (| "notmuch-"
                            "message-"
                            "mm-"
                            "mml2015-"
                            "sendmail-"
                            (seq "user-mail-address" eos)))

(req-package notmuch
  :commands
  notmuch notmuch-mua-new-mail my-inbox
  :bind
  (("C-c i" . my-inbox)
   ("C-c m" . notmuch-mua-new-mail))
  :config
  (require 'notmuch-calendar-x)

  (defun my-notmuch-fix-fcc ()
    (interactive)
    (save-excursion
      (message-goto-fcc)
      (let ((bounds (bounds-of-thing-at-point 'line)))
        (delete-region (car bounds) (cdr bounds)))
      (notmuch-fcc-header-setup)))

  (defun my-notmuch-show-unsubscribe ()
    "When in a notmuch show mail, try to find an unsubscribe link and click it..

This will be the link nearest the end of the message which either contains or follows the word unsubscribe."
    (interactive)
    (notmuch-show-move-to-message-bottom)
    (when (search-backward "unsubscribe" (notmuch-show-message-top))
      (if (ffap-url-at-point)
          (goto-char (car ffap-string-at-point-region)))

      (ffap-next-url)))

  (bind-key "U" #'my-notmuch-show-unsubscribe 'notmuch-show-mode-map)

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

;;        '(message-header-setup-hook '(notmuch-fcc-header-setup))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(message-auto-save-directory "~/temp/messages/")
 '(message-citation-line-format "")
 '(message-citation-line-function (quote message-insert-formatted-citation-line))
 '(message-cite-function (quote message-cite-original-without-signature))
 '(message-cite-prefix-regexp "[[:space:]]*>[ >]*")
 '(message-cite-reply-position (quote traditional))
 '(message-cite-style nil)
 '(message-fill-column nil)
 '(message-kill-buffer-on-exit t)
 '(message-send-mail-function (quote message-send-mail-with-sendmail))
 '(message-sendmail-envelope-from (quote header))
 '(message-signature nil)
 '(message-yank-cited-prefix ">")
 '(message-yank-empty-prefix "")
 '(message-yank-prefix "> ")
 '(mm-inline-text-html-with-images t)
 '(mm-inlined-types
   (quote
    ("image/.*" "text/.*" "message/delivery-status" "message/rfc822" "message/partial" "message/external-body" "application/emacs-lisp" "application/x-emacs-lisp" "application/pgp-signature" "application/x-pkcs7-signature" "application/pkcs7-signature" "application/x-pkcs7-mime" "application/pkcs7-mime" "application/pgp")))
 '(mm-sign-option (quote guided))
 '(mm-text-html-renderer (quote w3m))
 '(mml2015-encrypt-to-self t)
 '(notmuch-address-selection-function
   (lambda
     (prompt collection initial-input)
     (ido-completing-read prompt collection nil nil nil
                          (quote notmuch-address-history))))
 '(notmuch-archive-tags (quote ("-inbox" "-unread")))
 '(notmuch-crypto-process-mime t)
 '(notmuch-fcc-dirs
   (quote
    (("tom\\.hinton@cse\\.org\\.uk" . "\"cse/Sent Items\" +sent -inbox")
     ("larkery\\.com" . "\"fastmail/Sent Items\" +sent -inbox"))))
 '(notmuch-hello-sections
   (quote
    (notmuch-hello-insert-search notmuch-hello-insert-alltags notmuch-hello-insert-inbox notmuch-hello-insert-saved-searches)))
 '(notmuch-mua-cite-function (quote message-cite-original-without-signature))
 '(notmuch-mua-send-hook (quote (my-notmuch-fix-fcc notmuch-mua-message-send-hook)))
 '(notmuch-saved-searches
   (quote
    ((:name "all mail" :query "*" :key "a")
     (:name "all inbox" :query "tag:inbox" :key "i")
     (:name "work inbox" :query "tag:inbox AND path:cse/**" :key "w")
     (:name "live" :query "tag:unread or tag:flagged" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "personal inbox" :query "tag:inbox and path:fm/**" :key "p")
     (:name "jira" :query "from:jira@cseresearch.atlassian.net" :key "j" :count-query "J"))))
 '(notmuch-search-line-faces
   (quote
    (("unread" :weight bold)
     ("flagged" :background "#555"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-show-hook
   (quote
    (notmuch-show-turn-on-visual-line-mode goto-address-mode)))
 '(notmuch-show-indent-messages-width 2)
 '(notmuch-tag-formats
   (quote
    (("unread"
      #("U" 0 1
        (face
         ((:foreground "green")
          (:foreground "green")
          (:foreground "green")
          (:foreground "green")
          (:foreground "green")
          (:foreground "green")
          (:foreground "green")
          (:foreground "green")
          (:foreground "green")
          (:foreground "green")
          (:foreground "green")
          (:foreground "green"))))
      (notmuch-apply-face tag
                          (quote
                           (:foreground "green"))))
     ("inbox"
      #("I" 0 1
        (face
         ((:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white"))))
      (notmuch-apply-face tag
                          (quote
                           (:foreground "white"))))
     ("EXS" "J")
     ("replied" "r")
     ("flagged"
      #("F" 0 1
        (face
         ((:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold)
          (:foreground "cyan" :weight bold))))
      (notmuch-apply-face tag
                          (quote
                           (:foreground "cyan" :weight bold))))
     ("attachment"
      #("A" 0 1
        (face
         ((:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white")
          (:foreground "white"))))
      (notmuch-apply-face tag
                          (quote
                           (:foreground "white")))))))
 '(notmuch-wash-original-regexp
   "^\\(--+ ?[oO]riginal [mM]essage ?--+\\)\\|\\(____+\\)\\(writes:\\)writes$")
 '(notmuch-wash-signature-lines-max 30)
 '(notmuch-wash-signature-regexp
   (rx bol
       (or
        (seq
         (* nonl)
         "not the intended recipient"
         (* nonl))
        (seq "The original of this email was scanned for viruses"
             (* nonl))
        (seq "__"
             (* "_"))
        (seq "****"
             (* "*"))
        (seq "--"
             (** 0 5 "-")
             (* " ")))
       eol))
 '(sendmail-program "msmtpq-quiet")
 '(user-mail-address "tom.hinton@cse.org.uk"))
