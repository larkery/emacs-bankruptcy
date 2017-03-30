(initsplit-this-file bos (| "notmuch-"
                            "message-"
                            "mm-"
                            "mml2015-"
                            "sendmail-"
                            (seq "user-mail-address" eos)))

;; WAT?
(provide 'notmuch-fcc-initialization)

(req-package notmuch
  :commands
  notmuch notmuch-mua-new-mail my-inbox
  :bind
  (("C-c i" . my-inbox)
   ("C-c m" . notmuch-mua-new-mail))
  :config
  (require 'notmuch-calendar-x)

  (defun notmuch-new-async-sentinel (process event)
    (unless (process-live-p process)
      (if (zerop (process-exit-status process))
          (notmuch-refresh-all-buffers)
        (let ((buf (process-buffer process)))
          (if buf
              (pop-to-buffer buf)
            (message "Error checking mail, and process buffer has gone missing!"))))))

  (defun notmuch-poll-and-refresh-async ()
    (interactive)
    (with-current-buffer (get-buffer-create "*notmuch new*")
      (erase-buffer))
    (let ((proc (start-process "notmuch new" "*notmuch new*" "notmuch" "new")))
      (set-process-sentinel proc 'notmuch-new-async-sentinel)))

  (bind-key "G" #'notmuch-poll-and-refresh-async notmuch-search-mode-map)

  (defun dired-attach-advice (o &rest args)
    (let ((the-files (dired-get-marked-files))
          (result (apply o args)))
      (when the-files
        (dolist (the-file the-files)
          (mml-attach-file the-file)))
      result))

  (advice-add 'notmuch-mua-new-mail :around 'dired-attach-advice)

  (defun dired-compose-attach ()
    (interactive)

    (let ((the-files (dired-get-marked-files)))
      (notmuch-mua-new-mail)

      (save-excursion
        (goto-char (point-max))
        (dolist (f the-files)
          (mml-attach-file f)))))

  (defun my-notmuch-fix-fcc ()
    (interactive)
    (save-excursion
      (message-goto-fcc)
      (let ((bounds (bounds-of-thing-at-point 'line)))
        (delete-region (car bounds) (cdr bounds)))
      (notmuch-fcc-header-setup)))

  (defun my-notmuch-change-from ()
    (interactive)
    (save-excursion
      (message-goto-from)
      (let* ((from-end (point))
             (from-start (progn
                           (message-beginning-of-line)
                           (point)))
             (from-text (buffer-substring from-start from-end))
             (mails notmuch-identities))
        (while (and mails (not (string= from-text (car mails))))
          (setq mails (cdr mails)))

        (let ((new-from (or (cadr mails)
                            (car notmuch-identities))))
          (delete-region from-start from-end)
          (insert new-from)
          (my-notmuch-fix-fcc)))))

  (bind-key "C-c m" 'my-notmuch-change-from notmuch-message-mode-map)

  (defun my-notmuch-show-unsubscribe ()
    "When in a notmuch show mail, try to find an unsubscribe link and click it..

This will be the link nearest the end of the message which either contains or follows the word unsubscribe."
    (interactive)
    (notmuch-show-move-to-message-bottom)
    (when (search-backward "unsubscribe" (notmuch-show-message-top))
      (if (ffap-url-at-point)
          (goto-char (car ffap-string-at-point-region)))

      (ffap-next-url)))

  (defun my-notmuch-show-unread ()
    (interactive)
    (while (and (notmuch-show-goto-message-next)
                (not (member "unread" (notmuch-show-get-tags)))))
    (notmuch-show-message-visible (notmuch-show-get-message-properties) t)
    (recenter-top-bottom 0))

  (bind-key "U" #'my-notmuch-show-unsubscribe 'notmuch-show-mode-map)
  (bind-key "u" #'my-notmuch-show-unread 'notmuch-show-mode-map)

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

  ;;(advice-add 'notmuch-search-insert-authors :filter-args #'my-notmuch-adjust-name)
;;  (advice-remove 'notmuch-search-insert-authors #'my-notmuch-adjust-name)

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


  (defvar my-notmuch-random-tag nil)
  (make-variable-buffer-local 'my-notmuch-random-tag)

  (bind-keys
   :map notmuch-search-mode-map
   ("." . (lambda () (interactive) (my-notmuch-flip-tags "flagged")))
   ("d" . (lambda () (interactive) (my-notmuch-flip-tags "deleted")))
   ("u" . (lambda () (interactive) (my-notmuch-flip-tags "unread")))
   ("," . (lambda (arg) (interactive "P")
            (when (or arg (not my-notmuch-random-tag))
              (setq my-notmuch-random-tag
                    (completing-read "toggle tag: " '())))
            (when my-notmuch-random-tag
              (my-notmuch-flip-tags my-notmuch-random-tag))))
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

  (bind-key "r" 'my-notmuch-reply-sender-qs 'notmuch-show-mode-map)
  (bind-key "R" 'my-notmuch-reply-qs 'notmuch-show-mode-map)

  (defun minimally-indent (p m)
    (interactive "r")
    (save-excursion
      (save-restriction
        (goto-char p)
        (let ((mindent (progn (back-to-indentation)
                              (current-column))))
          (while (< (point) m)
            (forward-line)
            (back-to-indentation)
            (unless (looking-at "^$")
              (setq mindent (min mindent (current-column))))
            (end-of-line))
          (forward-line -1)
          (move-to-column mindent)
          (delete-rectangle p (point))))))

  (defun message-insert-outlook-citation ()
    (eval-when-compile (require 'nnheader))
    (insert "

-----Original Message-----
From: " (mail-header-from message-reply-headers) "
Sent: " (mail-header-date message-reply-headers) "
To: " my-reply-to "
Subject: " my-reply-subject "

")
    )

  (defvar message-cite-styles
    '(("Roger\\.Lampert" .
       ((message-cite-function 'message-cite-original)
        (message-citation-line-function 'message-insert-outlook-citation)
        (message-cite-reply-position 'above)
        (message-yank-prefix "")
        (message-yank-cited-prefix "")
        (message-yank-empty-prefix "")
        ))))

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

  )

(setq notmuch-tag-formats
      (quote
       (("flagged")
        ("inbox"
         "I"
         (notmuch-apply-face tag
                             (quote
                              (:weight bold))))
        ("replied"
         "R"
         (notmuch-apply-face tag
                             (quote
                              (:weight bold))))
        ("sent")
        ("unread" "U" (notmuch-apply-face tag (quote (:background "purple"))))
        ("attachment"
         "A"
         (notmuch-apply-face tag
                             (quote
                              (:weight bold)))))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(message-auto-save-directory "~/temp/messages/")
 '(message-citation-line-format "")
 '(message-citation-line-function (quote message-insert-formatted-citation-line))
 '(message-cite-function
   (quote message-cite-original-without-signature-or-selection))
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
 '(mm-inline-large-images (quote resize))
 '(mm-inline-large-images-proportion 0.75)
 '(mm-inline-text-html-with-images t)
 '(mm-inlined-types
   (quote
    ("image/.*" "text/.*" "message/delivery-status" "message/rfc822" "message/partial" "message/external-body" "application/emacs-lisp" "application/x-emacs-lisp" "application/pgp-signature" "application/x-pkcs7-signature" "application/pkcs7-signature" "application/x-pkcs7-mime" "application/pkcs7-mime" "application/pgp")))
 '(mm-sign-option (quote guided))
 '(mm-text-html-renderer (quote shr))
 '(notmuch-address-selection-function
   (lambda
     (prompt collection initial-input)
     (completing-read prompt collection nil nil nil
                      (quote notmuch-address-history))))
 '(notmuch-archive-tags (quote ("-inbox" "-unread")))
 '(notmuch-crypto-process-mime t)
 '(notmuch-fcc-dirs
   (quote
    (("tom\\.hinton@cse\\.org\\.uk" . "\"cse/Sent Items\" +sent -inbox")
     ("larkery\\.com" . "\"fastmail/Sent Items\" +sent -inbox"))) nil (notmuch-fcc-initialization))
 '(notmuch-hello-sections
   (quote
    (notmuch-hello-insert-search notmuch-hello-insert-alltags notmuch-hello-insert-inbox notmuch-hello-insert-saved-searches)))
 '(notmuch-identities
   (quote
    ("Tom Hinton <tom.hinton@cse.org.uk>" "Tom Hinton <t@larkery.com>")))
 '(notmuch-message-headers-visible nil)
 '(notmuch-mua-cite-function
   (quote message-cite-original-without-signature-or-selection))
 '(notmuch-mua-send-hook (quote (my-notmuch-fix-fcc notmuch-mua-message-send-hook)))
 '(notmuch-saved-searches
   (quote
    ((:name "all mail" :query "*" :key "a")
     (:name "all inbox" :query "tag:inbox" :key "i")
     (:name "work inbox" :query "tag:inbox AND path:cse/**" :key "w")
     (:name "live" :query "tag:unread or tag:flagged" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "personal inbox" :query "tag:inbox and path:fastmail/**" :key "p"))))
 '(notmuch-search-line-faces
   (quote
    (("unread" . notmuch-search-unread-face)
     ("flagged" . notmuch-search-flagged-face)
     ("deleted" :strike-through "red"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-search-result-format
   (quote
    (("date" . "%12s ")
     ("count" . "%-7s ")
     ("authors" . "%-20s ")
     ("subject" . "%s ")
     ("tags" . "%s"))))
 '(notmuch-show-hook
   (quote
    (notmuch-show-turn-on-visual-line-mode goto-address-mode)))
 '(notmuch-show-indent-messages-width 2)
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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(notmuch-message-summary-face ((t (:inherit mode-line))))
 '(notmuch-tag-face ((t (:foreground "white" :box (:line-width 1 :color "white" :style pressed-button) :height 0.8)))))
