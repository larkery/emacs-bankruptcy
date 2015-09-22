;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#424242" "#EF9A9A" "#C5E1A5" "#FFEE58" "#64B5F6" "#E1BEE7" "#80DEEA" "#E0E0E0"])
 '(ansi-term-color-vector
   [unspecified "#424242" "#EF9A9A" "#C5E1A5" "#FFEE58" "#64B5F6" "#E1BEE7" "#80DEEA" "#E0E0E0"])
 '(bookmark-default-file "~/.emacs.d/state/bookmarks")
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-generic-program "xdg-open")
 '(calendar-date-style (quote european))
 '(calendar-intermonth-spacing 2)
 '(calendar-latitude 51.45)
 '(calendar-longitude -2.5833)
 '(calendar-week-start-day 1)
 '(colir-compose-method (quote colir-compose-overlay))
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("108b3724e0d684027c713703f663358779cc6544075bc8fd16ae71470497304f" "d34d4f2e7464e8425ddd5964e78a598a6bda7aa6e541eace75a44cb1700e16ec" "62408b3adcd05f887b6357e5bd9221652984a389e9b015f87bbc596aba62ba48" "14225e826195202fbc17dcf333b94d91deb6e6f5ca3f5a75357009754666822a" "2bed8550c6f0a5ce635373176d5f0e079fb4fb5919005bfa743c71b5eed29d81" "3a9249d4c34f75776e130efd7e02c4a0a7c90ad7723b50acc5806112394ec2dd" "1fab355c4c92964546ab511838e3f9f5437f4e68d9d1d073ab8e36e51b26ca6a" "5a0eee1070a4fc64268f008a4c7abfda32d912118e080e18c3c865ef864d1bea" "cedd3b4295ac0a41ef48376e16b4745c25fa8e7b4f706173083f16d5792bb379" "2ef75a0b64c58767376c9e2c5f07027add146720e6fab6b196cb6a1c68ef3c3f" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "ac2b1fed9c0f0190045359327e963ddad250e131fbf332e80d371b2e1dbc1dc4" "7b4d9b8a6ada8e24ac9eecd057093b0572d7008dbd912328231d0cada776065a" "76626efc044daee1c402e50f185bd633d1a688c332bc15c8fd5db4cdf2966b79" "b4eb84cc1038d2e1d1bd10e92a92cadafc1545047f82c34ba3d196a703520baf" "9a770a3c16aa6dba6d44c6fcb1bdb4ba41b723f7e4ebecc1e3b59c6c614f444a" "70e24bd43f9fdd7054c058a15da9e81ca1038ed5fdaa7d4d9ea6186a1973d77b" "36495e7e8743d28d7d2a5ef2c24341fa228960dce8524810e4ced20328b62a72" "e04650cf2c56bf8333e407cbb6deb7405e23e9fdfbf750f5f9069b11d35bc0e5" "888324ef0c3f2934c2be0c907158a079f34f330ab384d6890f7784755129d9af" "8b7588be1d06e21d9ef6012fa3f3a44ec60673ee5735c36142122da1b3127249" "f51e26ed978cba6028f8e12a8740e449719cd8b1e9ed6ac533d24b47cd972ba5" "4b72696190fd8d56cdf4d844d170f6fc29bec9eda03f00f7b3885cf041de1f6a" "c54eff0a615b08fd4f96a8db424004e4899e169b10d406f80100ae650a592ccf" "ad821221352c6d1230d0bfa943033fdcd51b84e3f70dc3ca3a714a7a8a8d5b87" "002e7d7be423edd3fee94754b0020d8fe369d26787500baf5cdbdcffe905d1fc" "3f4b90670357c81619720f6f9e359dfaa7069387bbbd1bcc849e9f3857165b17" "f4dd2cafddd643731eaa769ca4a5f29ae24e387a24ec2940ee200172264ae60d" "ca49fae7dfed5c1087b865de335dccb11f7e295c15542e18d6fc3ecb5dc6309e" "660c4db355c186b9b5f3addb638102fcbbcd52c53a7df526b5b1e78e06aacc98" "0c3e3249a10dd5cf67fb771bd51669cbb7feed136b0531ac0a0ff09bbd9d99e1" "9baeb8af1fe479938de84991a1ba9b4c09b42bcdfe1a4715210fb0eb11099297" "65e67f8695bc2350dc07f2896d2de717b390da90ad056dd21509cf0fc0b7b61d" "d2f705c74e49a442fa809eb75ea542b86e7a396edc2ee4c54d80c5149fac7ac6" "c03c5e92796bb61083675b20776027956a1e807822713fdbb39beb8058d93132" "6788ab237920daa5c54a84f776de162e0832476197b2e4b75a108a32c7bdc935" "3ae16e4f56587951471b6c50e4cbaebd6b7b9816ab0a891f45e952b55de7442f" "8c14a6f576cd917f2ad6b5645ad6809d9bb2bfba10169ae740e3d736c88a6bc0" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "a19a2e1d1f24c94dda21e634d7eb862d9ec299c4d9686e1bbad23122581ab4e1" "23894f8c6c63984566138d9bb477052fc50ecc582109bd8e643d705ce5636c62" "ae8dc968203b988ba9857e1ade1ddf64509fc991f8a3476913241109a4aca95b" "3b8853220c7638030043a18dc9f12ddc6b94af5f595750c03d3ac9abba410660" "66fe30b317a670605748c0fd77d138f05056bb9f99d81b74d9e34a326c902c77" "61b6334a4d78937deb0c2269cc09266ebcd60e8177b2bfcd3e9d5cfebe833bea" "cef772009379a64c03560534dc2a70678c302edf2cf970757739feb4dca7f60d" "8a237a6c8340f8ac8acaa4a83b404e8e49fe4b93fbd11466620ecb494ba4cd43" "7d0ed8357a1cb8f7f8185dd90fb726159e64188b7ac92b6e49acd519c3bcf54f" "2801a60c5579743221dfccb061699d1fdd630df9278894b6a7a4393dafc6145c" "e82e4fad0cfd63883938ed94e55e71e617b13764b4f9f090a4841634baf52b26" "0bcaa2b4558a025ed5c3c524f294222cf4ad593cb5feea35b59a013a6c978def" "5f792743a8a1d11eaa708eb6173c200e6dfae42f352acb138b54eac47f6408db" "ce543173f4ab047ac3dc43ea03974d4850fca60e8e1a683619ec04c2a283b946" "e6aa87560a187c1d2ca98fca77adbc472b08327bcfe5a7f31d1b9e2adeaf3ad2" "f6da3137e748c4a802ed04aa9a1b28d0c9976a746be4ea601f4524ae4af65840" "cc3d68ed7256c87fa8330d7b9d9d039f09430d84a160abcc459c8bf257064fb5" "5eee9581a5cbba79f778f15653f47312460d7c4a266a0631bb7ac5a533f11a29" "8b9b49278db57280283942ee7a91ebeba2db18bbaae127cc81f35a06eb0bd407" "caa37eb4ae96b703b8cb270b668504762f50fc69b4c6643b3bc2eea5dcca6d59" "43d0d299a2c564d9cf16faba65adf48965be9286c60fd318ab6128ec80b87be8" "81c7f93de9afdaf9f1b7b5bc786d5f2bbff85254c6272018087d5e812e6fa422" "c31e8d18337f6c1e23140ed9a89bac52b6b63464d8990f324d9b6956af57918b" "61f38ab7e7bae447bc6312c453ceaf0c2ab03be038a1af42266f717ce7e0ee2e" "8cc182568dff62c77f842c73791173f5a240c33377e227e93b9caa319e15bcbb" "f84b85b2e53a43eda07871fbe2feaf35e5ff9fc021891f515d0edc867bb40b0b" "3ee934582304568291f8e7fa4a7b11b9b97407c1127e909b1910e74daf62fed3" "89f2382a4067cfaf41dd80d6f60408006714f120b6b2ce1a94e0e144d3b5da57" "1d58425e7e517f23bae78ce8be5ef7503fb817e6ac61536cb1aec267f709d581" "cb2354169518077b63aa4b43e69db77747c9bb09e59e02c1433b4ef693173b4b" "40bc0ac47a9bd5b8db7304f8ef628d71e2798135935eb450483db0dbbfff8b11" "d8f76414f8f2dcb045a37eb155bfaa2e1d17b6573ed43fb1d18b936febc7bbc2" "cc0dbb53a10215b696d391a90de635ba1699072745bf653b53774706999208e3" "39dd7106e6387e0c45dfce8ed44351078f6acd29a345d8b22e7b8e54ac25bac4" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "c5a044ba03d43a725bd79700087dea813abcb6beb6be08c7eb3303ed90782482" "603a9c7f3ca3253cb68584cb26c408afcf4e674d7db86badcfe649dd3c538656" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" default)))
 '(debug-on-error t)
 '(delete-selection-mode t)
 '(dired-dwim-target t)
 '(dired-enable-local-variables nil)
 '(dired-listing-switches "-alhv")
 '(dired-local-variables-file nil)
 '(dired-omit-files "^\\.?#\\|^\\.[^\\.].*$")
 '(display-time-default-load-average nil)
 '(display-time-mode t)
 '(evil-emacs-state-cursor (quote ("#E57373" bar)))
 '(evil-insert-state-cursor (quote ("#E57373" hbar)))
 '(evil-normal-state-cursor (quote ("#FFEE58" box)))
 '(evil-visual-state-cursor (quote ("#C5E1A5" box)))
 '(fci-rule-color "#232A2F" t)
 '(focus-follows-mouse t)
 '(global-auto-revert-mode t)
 '(global-highlight-parentheses-mode t)
 '(global-yascroll-bar-mode t)
 '(grep-find-template "find . <X> -type f <F> -exec grep <C> -nH -e <R> \\{\\} +")
 '(helm-display-header-line nil)
 '(helm-ff-skip-boring-files nil)
 '(helm-ff-smart-completion nil)
 '(helm-mode t)
 '(helm-mode-fuzzy-match nil)
 '(highlight-symbol-colors
   (quote
    ("#FFEE58" "#C5E1A5" "#80DEEA" "#64B5F6" "#E1BEE7" "#FFCC80")))
 '(highlight-symbol-foreground-color "#E0E0E0")
 '(highlight-tail-colors
   (if
       (eq
        (quote dark)
        (quote light))
       (quote
        (("#FFA726" . 0)
         ("#FFEE58" . 10)
         ("#FFF59D" . 30)
         ("#474747" . 60)
         ("#424242" . 80)))
     (quote
      (("#F8BBD0" . 0)
       ("#FF80AB" . 10)
       ("#9575CD" . 30)
       ("#474747" . 60)
       ("#424242" . 80)))))
 '(hippie-expand-try-functions-list
   (quote
    (try-complete-file-name-partially try-complete-file-name try-expand-all-abbrevs try-expand-list try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-lisp-symbol-partially try-complete-lisp-symbol try-expand-line)))
 '(ido-cannot-complete-command (quote ido-vertical-grid-right))
 '(ido-create-new-buffer (quote always))
 '(ido-max-prospects 10)
 '(ido-separator nil)
 '(ido-show-dot-for-dired nil)
 '(ido-use-virtual-buffers (quote auto))
 '(ido-vertical-columns 10)
 '(ido-vertical-define-keys (quote grid-movement))
 '(ido-vertical-disable-if-short nil)
 '(ido-vertical-mode t)
 '(ido-vertical-pad-list nil)
 '(ido-vertical-rows 4)
 '(ido-vertical-show-count t)
 '(indicate-buffer-boundaries (quote right))
 '(indicate-empty-lines nil)
 '(ispell-program-name "aspell")
 '(ivy-display-style (quote fancy))
 '(ivy-mode nil)
 '(jiralib-host "cseresearch")
 '(jiralib-url "http://cseresearch.atlassian.net/")
 '(jiralib-wsdl-descriptor-url
   "http://cseresearch.atlassian.net/rpc/soap/jirasoapservice-v2?wsdl")
 '(kill-ring-max 1000)
 '(mark-ring-max 1000)
 '(message-auto-save-directory "~/temp/messages/")
 '(message-cite-style (quote message-cite-style-gmail))
 '(message-fill-column nil)
 '(message-header-setup-hook (quote (notmuch-fcc-header-setup)))
 '(message-kill-buffer-on-exit t)
 '(message-send-mail-function (quote message-send-mail-with-sendmail))
 '(message-sendmail-envelope-from (quote header))
 '(message-signature nil)
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
 '(notmuch-fcc-dirs
   (quote
    (("tom.hinton@cse.org.uk" . "cse/Sent Items")
     ("larkery.com" . "fm/Sent Items"))))
 '(notmuch-hello-sections
   (quote
    (notmuch-hello-insert-search notmuch-hello-insert-alltags notmuch-hello-insert-inbox notmuch-hello-insert-saved-searches)))
 '(notmuch-mua-cite-function (quote message-cite-original-without-signature))
 '(notmuch-saved-searches
   (quote
    ((:name "work inbox" :query "tag:inbox AND path:cse/**" :key "iw")
     (:name "unread" :query "tag:unread" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "all mail" :query "*" :key "a")
     (:name "personal inbox" :query "tag:inbox and path:fm/**" :key "ip")
     (:name "all inbox" :query "tag:inbox" :key "ii"))))
 '(notmuch-search-line-faces
   (quote
    (("unread" :weight bold)
     ("flagged" :foreground "deep sky blue"))))
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
 '(notmuch-wash-signature-lines-max 30)
 '(notmuch-wash-signature-regexp "^\\(-- ?\\|_+\\|\\*\\*\\*\\*\\*+\\)$")
 '(nrepl-message-colors
   (quote
    ("#336c6c" "#205070" "#0f2050" "#806080" "#401440" "#6c1f1c" "#6b400c" "#23733c")))
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
 '(org-agenda-files nil)
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
      (file "~/org/work/nhm/nhm-support.org")
      "* %^{Ticket|%a}" :clock-in t :clock-resume t)
     ("i" "Clock in on task" entry
      (file "~/org/work/scratch.org")
      "* TODO %t %^{Caption}%?" :clock-in t :clock-resume t)
     ("c" "Future task" entry
      (file+headline "~/org/work/scratch.org" "Unfiled tasks")
      "** TODO %t %?%a"))))
 '(org-clock-clocked-in-display (quote mode-line))
 '(org-clock-history-length 100)
 '(org-clock-in-resume t)
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
 '(org-clock-persist-file "~/.emacs.d/state/org-clock-save.el")
 '(org-clock-persist-query-resume nil)
 '(org-clock-report-include-clocking-task t)
 '(org-clocktable-defaults
   (quote
    (:maxlevel 2 :lang "en" :scope file :block nil :wstart 1 :mstart 1 :tstart nil :tend nil :step nil :stepskip0 nil :fileskip0 nil :tags nil :emphasize nil :link nil :narrow 40! :indent t :formula nil :timestamp nil :level nil :tcolumns nil nil nil :effort-durations t)))
 '(org-completion-use-ido t)
 '(org-confirm-babel-evaluate (quote ignore))
 '(org-contacts-files (quote ("~/org/personal/contacts.org")))
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
     ("\\.pdf\\'" . default))))
 '(org-fontify-whole-heading-line t)
 '(org-goto-interface (quote outline-path-completion))
 '(org-journal-dir "~/org/journal/")
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
     "\\tolerance=1000")))
 '(org-latex-link-with-unknown-path-format "\\colorbox{red}{%s}")
 '(org-latex-listings (quote minted))
 '(org-latex-packages-alist nil)
 '(org-latex-pdf-process
   (quote
    ("latexmk -pdflatex='xelatex --shell-escape -interaction nonstopmode -output-directory %o' -pdf -f %f")))
 '(org-latex-to-pdf-process (quote ("latexmk -pdf -e '$pdflatex=q/xelatex %O %S/' %f")))
 '(org-odt-inline-image-rules (quote (("file" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\)\\'"))))
 '(org-odt-with-latex t)
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
 '(org-todo-keyword-faces (quote (("WAIT" . "DeepSkyBlue") ("CANCEL" . "magenta"))))
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t)" "WAIT(w)" "DONE(d)")
     (sequence "CANCEL(c)"))))
 '(org-todo-state-tags-triggers nil)
 '(org-use-property-inheritance (quote ("CODE")))
 '(org-use-speed-commands t)
 '(paradox-github-token t)
 '(pos-tip-background-color "#3a3a3a")
 '(pos-tip-foreground-color "#9E9E9E")
 '(projectile-cache-file "/home/hinton/.emacs.d/state/projectile.cache")
 '(projectile-known-projects-file "~/.emacs.d/state/projectile-bookmarks.eld")
 '(recentf-auto-cleanup (quote never))
 '(safe-local-variable-values
   (quote
    ((js2-additional-externs "calc" "describe" "it" "expect")
     (js2-additional-externs quote
                             ("calc" "describe" "it" "expect"))
     (js2-additional-externs quote
                             ("calc"))
     (js2-global-externs quote
                         ("calc"))
     (eval add-hook
           (quote after-save-hook)
           (lambda nil
             (shell-command "pandoc -f org -t docbook changelog.org --chapters | sed 's! id=\"\"!!g' | sed 's!<chapter>!<chapter xmlns=\"http://docbook.org/ns/docbook\">!g' | sed 's!<literal>\\(ref\\..\\+\\)</literal>!<xref linkend=\"\\1\"/>!g' > changelog.xml"))
           nil t))))
 '(sendmail-program "msmtp-enqueue")
 '(sp-show-pair-delay 0)
 '(tab-width 4)
 '(tabbar-background-color "#353535")
 '(tramp-persistency-file-name "~/.emacs.d/state/tramp")
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(url-configuration-directory "~/.emacs.d/state/url/")
 '(user-mail-address "tom.hinton@cse.org.uk")
 '(vc-annotate-background "#2B3B40")
 '(vc-annotate-color-map
   (quote
    ((20 . "#74CBC4")
     (40 . "#74CBC4")
     (60 . "#C2E982")
     (80 . "#FFC400")
     (100 . "#C792EA")
     (120 . "#C792EA")
     (140 . "#546D7A")
     (160 . "#546D7A")
     (180 . "#FF516D")
     (200 . "#9FC59F")
     (220 . "#859900")
     (240 . "#F77669")
     (260 . "#FF516D")
     (280 . "#82B1FF")
     (300 . "#82B1FF")
     (320 . "#82B1FF")
     (340 . "#D9F5DD")
     (360 . "#FFCB6B"))))
 '(vc-annotate-very-old-color "#FFCB6B")
 '(visual-line-fringe-indicators (quote (nil right-curly-arrow)))
 '(w3m-use-tab nil))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fringe ((t (:background "#161616" :foreground "white"))))
 '(ido-incomplete-regexp ((t (:foreground "red"))))
 '(ido-subdir ((t (:background "gray20"))))
 '(ido-virtual ((t (:slant italic))))
 '(isearch ((t (:background "DodgerBlue4" :foreground "#E8E8E8" :weight bold))))
 '(js2-error ((t (:foreground "#D9D9D9" :underline (:color "brown" :style wave) :weight bold))))
 '(js2-external-variable ((t (:strike-through t))))
 '(js2-warning ((t (:underline (:color "white" :style wave)))))
 '(notmuch-tag-face ((t (:foreground "orange")))))
