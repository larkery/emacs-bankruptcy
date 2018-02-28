;; -*- lexical-binding: t -*-
(initsplit-this-file bos (| "notmuch-"
                            "message-"
                            "mm-"
                            "mml2015-"
                            "sendmail-"
                            (seq "user-mail-address" eos)))

;; WAT?
(provide 'notmuch-fcc-initialization)

(req-package org-mime
  :config
  (setq org-mime-beautify-quoted-mail nil)
  )

(req-package notmuch
  :commands
  notmuch notmuch-mua-new-mail my-inbox
  :bind
  (("C-c i" . my-inbox)
   ("C-c m" . notmuch-mua-new-mail))
  :config
  (require 'notmuch-calendar-x)
  (require 'org-notmuch)
  (require 'ivy-attach-files)

  (diminish 'mml-mode)

  (bind-key "C-c RET f" #'mml-ivy-attach-files mml-mode-map)

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

  (defun notmuch-search-color-line-here ()
    (let ((face (plist-get (text-properties-at (point)) 'face)))
      (or (eq face 'notmuch-search-matching-authors)
          (eq face 'notmuch-search-subject)
          (eq face 'notmuch-search-date)
          (not face))))

  (defun notmuch-search-color-line-partially (o start end line-tag-list)
    (save-excursion
      (goto-char start)

      (let (npt (in (notmuch-search-color-line-here)) (last start))
        (while (and (setq npt (next-single-property-change (point) 'face nil end))
                    (< npt end))
          (goto-char npt)
          (let ((face (assoc 'face (text-properties-at (point)))))
            (if (notmuch-search-color-line-here)
                (unless in (setq in t last (point)))
              (when in
                (setq in nil)
                (funcall o last (point) line-tag-list)))))
        (when in
                (setq in nil)
                (funcall o last (point) line-tag-list)))))

  (advice-add 'notmuch-search-color-line :around #'notmuch-search-color-line-partially)
  (advice-add 'notmuch-search-insert-field :around #'notmuch-search-insert-extra-field)

  (bind-key "G"
            (lambda () (interactive)
              (let ((compilation-buffer-name-function (lambda (&rest _) "*notmuch new*")))
                (compile "notmuch new")))
            notmuch-search-mode-map)

  (defun dired-attach-advice (o &rest args)
    (let ((the-files (dired-get-marked-files))
          (result (apply o args)))
      (when the-files
        (dolist (the-file the-files)
          (mml-attach-file the-file)))
      result))

  (defun guess-address-advice (o &rest args)
    (if (not (at-work-p))
        (car (notmuch-user-other-email))
      (apply o args)))

  (advice-add 'notmuch-mua-new-mail :around 'dired-attach-advice)
  (advice-add 'notmuch-user-primary-email :around 'guess-address-advice)

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

  (defun my-inbox (arg)
    (interactive "P")

    (let ((default-directory (expand-file-name "~/")))
      (cond
       (arg (notmuch-search "tag:inbox OR tag:flagged OR tag:unread"))
       ((not (at-work-p))
        (notmuch-search "path:fastmail/** AND (tag:inbox OR tag:flagged OR tag:unread)"))
       (t
        (notmuch-search "path:cse/** AND (tag:inbox OR tag:flagged OR tag:unread)")))))

  ;; (advice-remove #'notmuch-search-tag #'my-notmuch-retrain-after-tagging)

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
                               "replied"
                               "untrained")
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
   ("S" . (lambda () (interactive) (notmuch-search-tag '("+spam" "-inbox" "-unread"))))
   (";" . (lambda () (interactive) (my-notmuch-flip-tags "M")))
   (":" . (lambda () (interactive) (notmuch-search-filter "tag:M")))
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
    (require 'w3m)
    (let ((inhibit-message t)
          (inhibit-redisplay t)
          (w3m-message-silent t)
          (text (mm-get-part handle))
          (b (point))
          (charset (or (mail-content-type-get (mm-handle-type handle) 'charset)
                       mail-parse-charset
                       "utf-8")))
      (mm-insert-inline
       handle
       (mm-with-multibyte-buffer
         (insert text)
         (apply 'mm-inline-wash-with-stdin nil
                "render-mail"
                (downcase charset)
                (list (format "%d" (- (window-width) 2))))
         (buffer-string)))
      (save-restriction
        (narrow-to-region b (point))
        (flet ((w3m-add-face-property
                (start end name &optional object)
                (let ((pos start)
                      next prop)
                  (while (< pos end)
                    (setq prop (get-text-property pos 'face object)
                          next (next-single-property-change pos 'face object end))
                    (w3m-add-text-properties pos next (list 'font-lock-face (cons name prop)) object)
                    (setq pos next)))))
          (let ((w3m-use-symbol t)
                (w3m-default-symbol
                 '("─┼" " ├" "─┬" " ┌" "─┤" " │" "─┐" ""
                   "─┴" " └" "──" ""   "─┘" ""   ""   ""
                   "─┼" " ┠" "━┯" " ┏" "─┨" " ┃" "━┓" ""
                   "━┷" " ┗" "━━" ""   "━┛" ""   ""   ""
                   " •" " □" " ☆" " ○" " ■" " ★" " ◎"
                   " ●" " △" " ●" " ○" " □" " ●" "≪ ↑ ↓ ")))
            (w3m-fontify))
          ))))

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

  (require 'fancy-mail)

  (defun org-mime-htmlize-body ()
    (interactive)

    (let ((inhibit-redisplay t))
      (save-excursion
        (goto-char (point-min))
        (search-forward mail-header-separator)
        (forward-char)
        (let ((end-of-message
               (or (save-excursion
                     (and (search-forward "<#" nil t) (- (point) 2)))
                   (point-max))))
          (set-mark end-of-message)
          (call-interactively #'org-mime-htmlize)
          ))))

  (add-hook 'org-mime-html-hook
            (lambda ()
              (org-mime-change-element-style
               "blockquote"
               "margin:0; padding:0; padding-left:1em; border-left:2px blue solid;")))

  (setq org-mime-preserve-breaks nil)

  (bind-key "C-c h" (lambda () (interactive)
                      (setq-local mail-is-fancy
                                  (or (case mail-is-fancy
                                        (auto 'yes)
                                        (yes 'no)
                                        (no 'auto))
                                      'auto))

                      (message "Rich text: %s" mail-is-fancy))

            notmuch-message-mode-map)

  (add-hook 'message-mode-hook 'orgstruct-mode)
  (add-hook 'message-mode-hook 'orgtbl-mode)
  (add-hook 'message-mode-hook 'use-hard-newlines)
  (add-hook 'message-mode-hook 'auto-fill-mode)

  (defun org-mime-html-automatically (&rest args)
    (if (mail-is-fancy)
        (progn
          (message "Creating rich-text part")
          (org-mime-htmlize-body))
      (message "No rich text part")))

  (add-hook 'message-send-hook #'org-mime-html-automatically)

  (defun notmuch-fcc-post-sync-maildirs (&rest args)
    (set-process-sentinel
     (start-process "*sync-sent-messages*" nil "mbsync" "cse:Sent Items" "fastmail:Sent Items")
     (lambda (_ c)
       (cond
        ((string-match-p "finished" c)
         (start-process "*notmuch-new-no-hooks*" nil "notmuch" "new" "--no-hooks" "--quiet"))))))

  (advice-add 'notmuch-fcc-handler :after #'notmuch-fcc-post-sync-maildirs)
  ;; this has the opposite of a race - we insert the message into
  ;; notmuch, but then we need to reindex it immediately because its
  ;; filename changes after the sync because of the UID storage. we
  ;; could do the sync between save & insert, but then the filename
  ;; would be wrong.

  (defvar message-quote-colors
    '("darkslategrey" "DeepSkyBlue4")
    )

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
     nil `(;; (,(rx bol (* blank) (group ">" (* (| blank ">"))))
           ;;  (0 (progn (add-text-properties (match-beginning 1) (match-end 1)
           ;;                                 `(display
           ;;                                   ,(replace-regexp-in-string ">" "│" (match-string 1))))
           ;;            nil)))


           (,(rx bol (* blank) (group ">" (* (| ">" blank))) (* any) eol)
            (0
             (list :foreground
                   (nth (mod (loop for x across (match-string 1)
                                   count (= ?> x))
                             (length message-quote-colors))
                        message-quote-colors))
             )))))

  (add-hook 'notmuch-show-mode-hook #'message-font-lock-fancy-quoting)
  (add-hook 'notmuch-message-mode-hook #'message-font-lock-fancy-quoting)
  ;; (add-hook 'notmuch-message-mode-hook #'visual-line-mode)

  (add-hook 'notmuch-message-mode-hook #'show-hard-newlines-mode)

  (defface notmuch-standard-tag-face '((t (:inherit notmuch-tag-face))) "face for boring tags"))

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
 '(message-fcc-externalize-attachments nil)
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
 '(notmuch-message-headers (quote ("Subject" "To" "Cc")))
 '(notmuch-message-headers-visible t)
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
     ("office-misc" :inherit not-interesting)
     ("low-importance" :inherit not-interesting))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-search-result-format
   (quote
    (("date" . "%12s ")
     ("count" . "%-7s ")
     ("authors" . "%-20s ")
     ("tags-subset" "%-3s " "low-importance" "attachment" "meeting"
      #("unread" 0 6
        (face
         (notmuch-tag-deleted notmuch-tag-deleted)))
      "high-importance" "replied")
     ("subject" . "%s ")
     ("tags-complement" "%s" "low-importance" "attachment" "meeting" "unread" "high-importance" "replied"))))
 '(notmuch-show-hook
   (quote
    (notmuch-show-turn-on-visual-line-mode goto-address-mode)))
 '(notmuch-show-indent-messages-width 2)
 '(notmuch-tag-formats
   (quote
    (("unread")
     ("flagged" "f"
      (propertize tag
                  (quote face)
                  (quote notmuch-tag-flagged)))
     ("meeting"
      (propertize "m"
                  (quote face)
                  (quote notmuch-standard-tag-face)))
     ("untrained"
      (propertize "+"
                  (quote face)
                  (quote notmuch-standard-tag-face)))
     ("normal-importance")
     ("low-importance"
      (propertize "↓"
                  (quote face)
                  (quote notmuch-standard-tag-face)))
     ("high-importance"
      (propertize "↑"
                  (quote face)
                  (quote notmuch-standard-tag-face)))
     ("attachment"
      (propertize "a"
                  (quote face)
                  (quote notmuch-standard-tag-face)))
     ("replied"
      (propertize "»"
                  (quote face)
                  (quote notmuch-standard-tag-face)))
     ("sent")
     ("inbox"
      (propertize "i"
                  (quote face)
                  (quote notmuch-standard-tag-face))))))
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
 '(notmuch-tag-added ((t (:foreground "green" :weight bold))))
 '(notmuch-tag-deleted ((t (:foreground "red" :weight bold))))
 '(notmuch-tag-face ((((background dark)) (:foreground "white" :weight bold)) (((background light)) (:foreground "black" :weight bold)))))
