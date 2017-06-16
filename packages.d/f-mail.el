(initsplit-this-file bos (| "notmuch-"
                            "message-"
                            "mm-"
                            "mml2015-"
                            "sendmail-"
                            (seq "user-mail-address" eos)))

;; WAT?
(provide 'notmuch-fcc-initialization)

(req-package artbollocks-mode
  :commands artbollocks-mode
  :config
  (setq artbollocks-weasel-words-regex
        (concat "\\b" (regexp-opt
                       '("one of the"
                         "should"
                         "just"
                         "sort of"
                         "a lot"
                         "probably"
                         "maybe"
                         "perhaps"
                         "i think"
                         "really"
                         "pretty"
                         "maybe"
                         "nice"
                         "action"
                         "utilize"
                         "leverage") t) "\\b")
        artbollocks-lexical-illusions-regex
        "\\b\\(\\w+\\)\\W+\\(\\1\\)\\b"
        artbollocks-jargon-regex
        (concat "\\b"
                (regexp-opt
                 '("use case"
                   "use-case"
                   "spin up"
                   "virtualize"
                   "virtualise")))
        artbollocks-passive-voice nil
        artbollocks-lexical-illusions nil
        )

  (defadvice artbollocks-search-for-keyword (around casefold activate)
    (let ((case-fold-search t)) ad-do-it)))


(req-package notmuch
  :commands
  notmuch notmuch-mua-new-mail my-inbox
  :bind
  (("C-c i" . my-inbox)
   ("C-c m" . notmuch-mua-new-mail))
  :config
  (require 'notmuch-calendar-x)
  (require 'org-notmuch)
  (defun notmuch-search-insert-extra-field (o field format-string result)
    (cond ((string-equal field "tags-subset")
           (let* ((keep (cdr format-string))
                  (fmt (car format-string))
                  (tags (intersection (plist-get result :tags) keep :test #'string-equal))
                  (orig-tags (intersection (plist-get result :orig-tags) keep :test #'string-equal)))

             (insert (format fmt (notmuch-tag-format-tags tags orig-tags)))))
          ((string-equal field "tags-complement")
           (let* ((keep (cdr format-string))
                  (fmt (car format-string))
                  (tags (set-difference (plist-get result :tags) keep :test #'string-equal))
                  (orig-tags (set-difference (plist-get result :orig-tags) keep :test #'string-equal)))

             (insert (format fmt (notmuch-tag-format-tags tags orig-tags)))))
          (t
           (funcall o field format-string result))))

  (advice-add 'notmuch-search-insert-field :around #'notmuch-search-insert-extra-field)

  (bind-key "G"
            (lambda () (interactive) (compile "notmuch new"))
            notmuch-search-mode-map)

  (defun dired-attach-advice (o &rest args)
    (let ((the-files (dired-get-marked-files))
          (result (apply o args)))
      (when the-files
        (dolist (the-file the-files)
          (mml-attach-file the-file)))
      result))

  (advice-add 'notmuch-mua-new-mail :around 'dired-attach-advice)

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

  (defun my-inbox ()
    (interactive)
    (notmuch-search "tag:inbox OR tag:flagged OR tag:unread"))

  (defun my-notmuch-retrain-after-tagging (tag-changes &optional beg end)
    (when (loop for tag in tag-changes
                if (not
                    (member (substring tag 1)
                            '("deleted" "inbox" "sent" "attachment" "unread" "replied"
                              "sent" "flagged" "meeting" "accepted" "rejected" "tentative"
                              "low-importance" "normal-importance" "high-importance")))
                return t)

        (unless (and beg end)
          (setq beg (car (notmuch-search-interactive-region))
                end (cadr (notmuch-search-interactive-region))))
      (let ((search-string (notmuch-search-find-stable-query-region
                            beg end nil)))
        (apply #'start-process
               "classify" nil
               (expand-file-name "~/.mail/.notmuch/hooks/classify")
               "--retrain"
               search-string
               tag-changes))))

  (advice-add #'notmuch-search-tag :after #'my-notmuch-retrain-after-tagging)

  (defun my-notmuch-flip-tags (&rest tags)
    "Given some tags, add those which are missing and remove those which are present"
    (setq tags (delete-if-not #'stringp tags))
    (let (amendments
          (existing-tags (notmuch-search-get-tags)))
      (dolist (tag tags)
        (push (concat (if (member tag existing-tags) "-" "+") tag) amendments))
      (notmuch-search-tag amendments))
    (notmuch-search-next-thread))

  (defun my-notmuch-find-related-authors ()
    (interactive)
    (let ((authors (plist-get (notmuch-search-get-result (point)) :authors))
          authors-list
          selection-list
          query)

      (dolist (author (split-string authors "[,|]+"))
        (let ((author (s-trim author)))
          (when (not (string= author "Tom Hinton"))
            (push author authors-list))))

      (if (cdr authors-list)

          (ivy-read "authors: " authors-list
                    :action (lambda (x) (unless (member x selection-list)
                                          (push x selection-list))))

        (push (car authors-list) selection-list))

      (when selection-list
        (dolist (s selection-list)
          (push (format "from:\"%s\" OR to:\"%s\"" s s) query)
          (push "OR" query))
        (pop query)
        (notmuch-search (mapconcat #'identity query " ")))))

  (defun my-notmuch-find-related-tags ()
    (interactive)

    (let ((interesting-tags (cl-set-difference
                             (notmuch-search-get-tags)
                             '("inbox"
                               "attachment"
                               "meeting"
                               "unread"
                               "new"
                               "sent"
                               "flagged"
                               "deleted"
                               "replied")
                             :test #'string=))
          terms)

      (when interesting-tags
        (dolist (tag interesting-tags)
          (push (format "tag:\"%s\"" tag) terms)
          (push "OR" terms))

        (pop terms)

        (notmuch-search (mapconcat #'identity terms " ")))))


  (bind-keys
   :map notmuch-search-mode-map
   ("." . (lambda () (interactive) (my-notmuch-flip-tags "flagged")))
   ("d" . (lambda () (interactive) (my-notmuch-flip-tags "deleted")))
   ("u" . (lambda () (interactive) (my-notmuch-flip-tags "unread")))
   ("S".  (lambda () (interactive) (my-notmuch-flip-tags "spam" :retrain t)))
   ("'" . my-notmuch-find-related-tags)
   ("@" . my-notmuch-find-related-authors)
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

  (require 'notmuch-reply-with-selection)
  (bind-key "r" 'my-notmuch-reply-sender-qs 'notmuch-show-mode-map)
  (bind-key "R" 'my-notmuch-reply-qs 'notmuch-show-mode-map)

  (defun my-notmuch-cycle-renderer ()
    (interactive)
    (let* ((vals (mapcar #'car mm-text-html-renderer-alist))
           (nextval (loop for cell on vals
                          if (eq (car cell) mm-text-html-renderer)
                          return (cadr cell)))
           (nextval (or nextval (car vals))))
      (message "mm-text-html-renderer: %s" (setq mm-text-html-renderer nextval))
      (notmuch-refresh-this-buffer)))

  (bind-key "H" 'my-notmuch-cycle-renderer 'notmuch-show-mode-map)

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

  (defun mm-inline-render-with-render-mail (handle)
    (let ((source (mm-get-part handle)))
      (mm-insert-inline
       handle
       (mm-with-multibyte-buffer
         (insert source)
         (apply 'mm-inline-wash-with-stdin nil
                "render-mail" (list (format "%d" (- (window-width) 2))))
         (buffer-string)))))

  (push (cons 'outlook #'mm-inline-render-with-render-mail)
        mm-text-html-renderer-alist)

  (defun notmuch-elide-citations-in-html (o msg part content-type nth depth button)
    (let ((start (if button
                     (button-start button)
                   (point)))
          (result (apply o (list msg part content-type nth depth button))))
      (save-excursion
        (save-restriction
          (narrow-to-region start (point-max))
          (goto-char (point-min))
          (notmuch-wash-excerpt-citations msg depth)))
      result))

  (advice-add 'notmuch-show-insert-part-text/html :around #'notmuch-elide-citations-in-html)

  (defun convert-quotes-to-blocks (&optional block-start block-end)
    (let ((block-start (or block-start "#+BEGIN_QUOTE\n"))
          (block-end (or block-end "\n#+END_QUOTE"))
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
              (insert block-end)))))))

  (defun org-mime-htmlize-nicely ()
    (interactive)
    (require 'org-mime)

    ;; replace quoted regions with blockquote tags
    ;; TODO in general, replies get the notmuch wash stuff inserted into them!

    (save-excursion
      (let* ((region-p (org-region-active-p))
             (html-start (set-marker
                          (make-marker)
                          (or (and region-p (region-beginning))
                              (save-excursion
                                (goto-char (point-min))
                                (search-forward mail-header-separator)
                                (+ (point) 1)))))
             (html-end (set-marker
                        (make-marker)
                        (or (and region-p (region-end))
                            (point-max))))
             (original-text (buffer-substring html-start html-end)))

        (save-restriction
          (narrow-to-region html-start html-end)
          (convert-quotes-to-blocks))

        ;; htmlize
        (call-interactively #'org-mime-htmlize)
        (goto-char (point-min))
        (when (search-forward "<#multipart type=alternative><#part type=text/plain>" nil t)
          (let ((start (point)))
            (when (search-forward "<#multipart type=related>" nil t)
              (goto-char (match-beginning 0))
              (delete-region start (point))
              (insert original-text)))))))

  (add-hook 'org-mime-html-hook
            (lambda ()
              (org-mime-change-element-style
               "blockquote"
               "margin:0; padding:0; padding-left:1em; border-left:2px blue solid;")))

  (bind-key "C-c h" (lambda () (interactive)
                      (orgstruct-mode)
                      (orgtbl-mode))
            notmuch-message-mode-map)

  (defun org-mime-html-automatically (&rest args)
    (when (or (and (boundp 'orgstruct-mode)
                   orgstruct-mode)
              (and (boundp 'orgtbl-mode)
                   orgtbl-mode))
      (org-mime-htmlize-nicely)))

  (advice-add 'notmuch-mua-send-and-exit :before #'org-mime-html-automatically)

  (defun message-font-lock-fancy-quoting ()
    "Use font-lock to make quotes fancier.

Overlays unicode box drawing lines for quote markers, and cycles
colours from highlight symbol"
    (interactive)
    (require 'highlight-symbol)
    (require 'font-lock)
    (setq-local font-lock-defaults
                (cons (car font-lock-defaults)
                      (cons t (cddr font-lock-defaults))))

    (font-lock-add-keywords
     nil `((,(rx bol (* blank) (group ">" (* (| blank ">"))))
            (0 (progn (add-text-properties (match-beginning 1) (match-end 1)
                                           `(display
                                             ,(replace-regexp-in-string ">" "│" (match-string 1))))
                      nil)))

           (,(rx bol (* blank) (group ">" (* (| ">" blank))) (* any) eol)
            (0 (list :foreground
                     (nth (mod (loop for x across (match-string 1)
                                     count (= ?> x))
                               (length highlight-symbol-colors))
                          highlight-symbol-colors)))))))

  (add-hook 'notmuch-show-mode-hook #'message-font-lock-fancy-quoting)
  (add-hook 'notmuch-message-mode-hook #'message-font-lock-fancy-quoting)
  (add-hook 'notmuch-message-mode-hook #'visual-line-mode)
  (add-hook 'notmuch-message-mode-hook #'artbollocks-mode)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(message-auto-save-directory "~/temp/messages/")
 '(message-citation-line-format "On %a, %b %d %Y, %N wrote:
")
 '(message-citation-line-function (quote message-insert-formatted-citation-line))
 '(message-cite-function
   (quote message-cite-original-without-signature-or-selection))
 '(message-cite-prefix-regexp "[[:space:]]*>[ >]*")
 '(message-cite-reply-position (quote traditional))
 '(message-cite-style nil)
 '(message-default-charset (quote utf-8))
 '(message-fill-column nil)
 '(message-kill-buffer-on-exit t)
 '(message-send-mail-function (quote message-send-mail-with-sendmail))
 '(message-sendmail-envelope-from (quote header))
 '(message-signature nil)
 '(message-yank-cited-prefix ">")
 '(message-yank-empty-prefix "")
 '(message-yank-prefix "> ")
 '(mm-coding-system-priorities (quote (utf-8)))
 '(mm-inline-large-images (quote resize))
 '(mm-inline-large-images-proportion 0.75)
 '(mm-inline-text-html-with-images t)
 '(mm-inlined-types
   (quote
    ("image/.*" "text/.*" "message/delivery-status" "message/rfc822" "message/partial" "message/external-body" "application/emacs-lisp" "application/x-emacs-lisp" "application/pgp-signature" "application/x-pkcs7-signature" "application/pkcs7-signature" "application/x-pkcs7-mime" "application/pkcs7-mime" "application/pgp")))
 '(mm-sign-option (quote guided))
 '(mm-text-html-renderer (quote outlook))
 '(notmuch-address-command (quote internal))
 '(notmuch-address-internal-completion (quote (sent "date:1y..")))
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
     (:name "i/f/r" :query "tag:inbox OR tag:flagged OR tag:unread" :key "i")
     (:name "wi" :query "path:cse/** AND (tag:inbox OR tag:flagged OR tag:unread)" :key "w")
     (:name "hi" :query "path:fastmail/** AND (tag:inbox OR tag:flagged OR tag:unread)" :key "h")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t"))))
 '(notmuch-search-line-faces
   (quote
    (("unread" . notmuch-search-unread-face)
     ("flagged" . notmuch-search-flagged-face)
     ("deleted" :strike-through "red")
     ("low-importance" :inherit shadow))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-search-result-format
   (quote
    (("date" . "%12s ")
     ("count" . "%-7s ")
     ("authors" . "%-20s ")
     ("tags-subset" "%-3s " "low-importance" "attachment" "meeting" "unread" "high-importance" "replied")
     ("subject" . "%s ")
     ("tags-complement" "%s" "low-importance" "attachment" "meeting" "unread" "high-importance" "replied"))))
 '(notmuch-show-hook
   (quote
    (notmuch-show-turn-on-visual-line-mode goto-address-mode)))
 '(notmuch-show-indent-messages-width 2)
 '(notmuch-tag-formats
   (quote
    (("unread"
      (propertize "•"
                  (quote face)
                  (quote notmuch-tag-unread)))
     ("flagged" "🟌"
      (propertize tag
                  (quote face)
                  (quote notmuch-tag-flagged)))
     ("meeting" "m")
     ("normal-importance" "")
     ("low-importance" "↓")
     ("high-importance" "↑")
     ("attachment" "a")
     ("replied" "»")
     ("sent")
     ("inbox" "i"))))
 '(notmuch-wash-original-regexp
   "^\\(--+ ?[oO]riginal [mM]essage ?--+\\)\\|\\(____+\\)\\(writes:\\)writes\\|\\(From: .+\\)$")
 '(notmuch-wash-signature-lines-max 300)
 '(notmuch-wash-signature-regexp
   (rx bol
       (or "Centre for Sustainable Energy" "Head of Development" "Energy advisor"
           (seq "Best wishes"
                (* nonl))
           (seq
            (* nonl)
            "not the intended recipient"
            (* nonl))
           (seq
            (* nonl)
            "confidential"
            (* nonl)
            "intended"
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
 '(message-cited-text ((t (:inherit font-lock-comment-face))))
 '(notmuch-message-summary-face ((t (:inherit mode-line))))
 '(notmuch-tag-face ((((background dark)) (:foreground "gold")))))
