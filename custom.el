;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(calendar-intermonth-spacing 2)
 '(calendar-latitude 51.45)
 '(calendar-longitude -2.5833)
 '(calendar-week-start-day 1)
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "c5a044ba03d43a725bd79700087dea813abcb6beb6be08c7eb3303ed90782482" "603a9c7f3ca3253cb68584cb26c408afcf4e674d7db86badcfe649dd3c538656" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" default)))
 '(delete-selection-mode t)
 '(dired-enable-local-variables nil)
 '(dired-listing-switches "-alhv")
 '(dired-local-variables-file nil)
 '(display-time-default-load-average nil)
 '(display-time-mode t)
 '(focus-follows-mouse t)
 '(global-auto-revert-mode t)
 '(global-highlight-parentheses-mode t)
 '(grep-find-template "find . <X> -type f <F> -exec grep <C> -nH -e <R> \\{\\} +")
 '(helm-display-header-line nil)
 '(helm-ff-skip-boring-files nil)
 '(helm-ff-smart-completion nil)
 '(hippie-expand-try-functions-list
   (quote
    (try-complete-file-name-partially try-complete-file-name try-expand-all-abbrevs try-expand-list try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-lisp-symbol-partially try-complete-lisp-symbol try-expand-line)))
 '(ido-create-new-buffer (quote always))
 '(ispell-program-name "aspell")
 '(kill-ring-max 1000)
 '(mark-ring-max 1000)
 '(message-auto-save-directory "~/temp/messages/")
 '(message-cite-style (quote message-cite-style-gmail))
 '(message-fill-column nil)
 '(message-header-setup-hook (quote (notmuch-fcc-header-setup)))
 '(message-kill-buffer-on-exit t)
 '(message-send-mail-function (quote message-send-mail-with-sendmail))
 '(message-sendmail-envelope-from (quote header))
 '(mm-inline-text-html-with-images t)
 '(mm-inlined-types
   (quote
    ("image/.*" "text/.*" "message/delivery-status" "message/rfc822" "message/partial" "message/external-body" "application/emacs-lisp" "application/x-emacs-lisp" "application/pgp-signature" "application/x-pkcs7-signature" "application/pkcs7-signature" "application/x-pkcs7-mime" "application/pkcs7-mime" "application/pgp")))
 '(mm-sign-option (quote guided))
 '(mm-text-html-renderer (quote w3m))
 '(mml2015-encrypt-to-self t)
 '(mouse-autoselect-window t)
 '(notmuch-archive-tags (quote ("-inbox" "-unread")))
 '(notmuch-crypto-process-mime t)
 '(notmuch-fcc-dirs (quote (("tom.hinton@cse.org.uk" . "cse/Sent Items"))))
 '(notmuch-hello-sections
   (quote
    (notmuch-hello-insert-search notmuch-hello-insert-alltags notmuch-hello-insert-inbox)))
 '(notmuch-mua-cite-function (quote message-cite-original-without-signature))
 '(notmuch-search-line-faces
   (quote
    (("unread" :weight bold)
     ("flagged" :foreground "orange"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-show-hook
   (quote
    (notmuch-show-turn-on-visual-line-mode goto-address-mode)))
 '(notmuch-show-indent-messages-width 1)
 '(notmuch-tag-formats
   (quote
    (("unread"
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
                   (:foreground "orange")))))))
 '(notmuch-wash-original-regexp "^\\(--+ ?[oO]riginal [mM]essage ?--+\\)\\|\\(____+\\)$")
 '(org-agenda-custom-commands
   (quote
    (("n" "Agenda and all TODO's"
      ((agenda ""
               ((org-agenda-ndays 1)))
       (alltodo "" nil))
      nil)
     ("w" "Weekly clock report" agenda ""
      ((org-agenda-clockreport-parameter-plist
        (quote
         (:link t :maxlevel 2 :step day :fileskip0 t :stepskip0 t :tcolumns 0 :properties
                ("code")))))))))
 '(org-agenda-files
   (quote
    ("~/work/nhm/ccc/carbon-budget/carbon-budget.org" "~/work/misc.org" "~/work/nhm/ccc/ccc.org" "~/work/chariot/chariot.org" "~/work/referral-app/referral-app.org" "~/work/nhm/nhm.org" "~/work/heat-networks/heat-networks.org" "~/work/nhm/stock/stock.org" "~/work/development.org" "~/work/scratch.org" "~/work/nhm/training/training.org" "~/work/nhm/support.org" "~/work/exchange.org" "~/work/nhm/hideem/hideem.org" "~/work/lim/lim.org" "~/work/nhm/rhi/rhi.org")))
 '(org-archive-default-command (quote org-archive-set-tag))
 '(org-archive-location "%s.archive::")
 '(org-babel-js-cmd "nodejs")
 '(org-babel-load-languages
   (quote
    ((emacs-lisp . t)
     (dot . t)
     (awk . t)
     (R . t)
     (latex . t))))
 '(org-capture-templates
   (quote
    (("s" "NHM Support" entry
      (file "~/work/nhm/support.org")
      "* %^{Ticket|%a}" :clock-in t :clock-resume t)
     ("t" "Miscellaneous task" entry
      (file "~/work/scratch.org")
      "* %^{Caption}" :clock-in t :clock-resume t))))
 '(org-clock-clocked-in-display (quote mode-line))
 '(org-clock-history-length 8)
 '(org-clock-in-switch-to-state
   (lambda
     (todo)
     (when
         (member todo
                 (quote
                  ("TODO" "WAIT" "DONE")))
       "TODO")))
 '(org-clock-into-drawer 4)
 '(org-clock-mode-line-total (quote today))
 '(org-clock-out-remove-zero-time-clocks t)
 '(org-clock-persist t)
 '(org-clock-persist-query-resume nil)
 '(org-clock-report-include-clocking-task t)
 '(org-clocktable-defaults
   (quote
    (:maxlevel 2 :lang "en" :scope file :block nil :wstart 1 :mstart 1 :tstart nil :tend nil :step nil :stepskip0 nil :fileskip0 nil :tags nil :emphasize nil :link nil :narrow 40! :indent t :formula nil :timestamp nil :level nil :tcolumns nil nil nil :effort-durations t)))
 '(org-completion-use-ido t)
 '(org-confirm-babel-evaluate (quote ignore))
 '(org-contacts-files (quote ("~/work/contacts.org")))
 '(org-custom-properties (quote ("code")))
 '(org-ditaa-jar-path "/home/hinton/.nix-profile/lib/ditaa.jar")
 '(org-effort-durations
   (quote
    (("h" . 60)
     ("d" . 450)
     ("w" . 2250)
     ("m" . 9000)
     ("y" . 96000))))
 '(org-export-allow-bind-keywords t)
 '(org-export-backends (quote (ascii beamer html icalendar latex odt texinfo)))
 '(org-export-copy-to-kill-ring (quote if-interactive))
 '(org-export-date-timestamp-format nil)
 '(org-export-latex-low-levels "\\subparagraph{%s}")
 '(org-export-with-drawers (quote (not "LOGBOOK")))
 '(org-export-with-tags t)
 '(org-file-apps
   (quote
    ((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . emacs))))
 '(org-fontify-whole-heading-line t)
 '(org-goto-interface (quote outline-path-completion))
 '(org-latex-classes
   (quote
    (("beamer" "\\documentclass[presentation]{beamer}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("article" "\\documentclass[11pt]{article}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("report" "\\documentclass[11pt]{report}
        \\usepackage{parskip}\\usepackage{fullpage}\\usepackage{tabulary}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("book" "\\documentclass[11pt]{book}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))))
 '(org-latex-default-packages-alist
   (quote
    (("AUTO" "inputenc" t)
     ("T1" "fontenc" t)
     ("" "fixltx2e" nil)
     ("" "graphicx" t)
     ("" "longtable" nil)
     ("" "float" nil)
     ("" "wrapfig" nil)
     ("" "rotating" nil)
     ("normalem" "ulem" t)
     ("" "amsmath" t)
     ("" "textcomp" t)
     ("" "marvosym" t)
     ("" "wasysym" t)
     ("" "amssymb" t)
     ("" "hyperref" nil)
     ("" "fullpage" nil)
     ("" "parskip" nil)
     "\\tolerance=1000"
     ("" "minted" nil))))
 '(org-latex-link-with-unknown-path-format "\\colorbox{red}{%s}")
 '(org-latex-listings (quote minted))
 '(org-latex-packages-alist nil)
 '(org-latex-pdf-process
   (quote
    ("latexmk -pdflatex='xelatex --shell-escape -interaction nonstopmode -output-directory %o' -pdf -f %f")))
 '(org-latex-to-pdf-process (quote ("latexmk -pdf -e '$pdflatex=q/xelatex %O %S/' %f")))
 '(org-odt-inline-image-rules (quote (("file" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\)\\'"))))
 '(org-outline-path-complete-in-steps nil)
 '(org-refile-targets
   (quote
    ((nil :maxlevel . 2)
     (org-agenda-files :maxlevel . 2))))
 '(org-refile-use-outline-path (quote file))
 '(org-show-notification-handler "notify-send")
 '(org-speed-commands-user (quote (("k" . org-cut-subtree))))
 '(org-src-lang-modes
   (quote
    (("ocaml" . tuareg)
     ("elisp" . emacs-lisp)
     ("ditaa" . artist)
     ("asymptote" . asy)
     ("dot" . graphviz-dot)
     ("sqlite" . sql)
     ("calc" . fundamental)
     ("C" . c)
     ("cpp" . c++)
     ("C++" . c++)
     ("screen" . shell-script))))
 '(org-tab-follows-link nil)
 '(org-tags-column 0)
 '(org-time-clocksum-use-effort-durations t)
 '(org-time-clocksum-use-fractional nil)
 '(org-todo-keyword-faces (quote (("CANCEL" . "magenta"))))
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t)" "WAIT(w)" "DONE(d)")
     (sequence "CANCEL(c)"))))
 '(org-todo-state-tags-triggers nil)
 '(org-use-property-inheritance (quote ("CODE")))
 '(org-use-speed-commands t)
 '(sendmail-program "/usr/share/doc/msmtp/examples/msmtpqueue/msmtp-enqueue.sh")
 '(tab-width 4)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(user-mail-address "tom.hinton@cse.org.uk")
 '(visual-line-fringe-indicators (quote (nil right-curly-arrow))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 110 :family "terminus"))))
 '(mode-line ((t (:height 86 :family "Terminus"))))
 '(mode-line-inactive ((t (:height 86 :family "Terminus")))))

