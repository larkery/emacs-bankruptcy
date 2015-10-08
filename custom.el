;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Linum-format "%7i ")
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#424242" "#EF9A9A" "#C5E1A5" "#FFEE58" "#64B5F6" "#E1BEE7" "#80DEEA" "#E0E0E0"])
 '(ansi-term-color-vector
   [unspecified "#424242" "#EF9A9A" "#C5E1A5" "#FFEE58" "#64B5F6" "#E1BEE7" "#80DEEA" "#E0E0E0"])
 '(background-color "#202020")
 '(background-mode dark)
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
    ("1fab355c4c92964546ab511838e3f9f5437f4e68d9d1d073ab8e36e51b26ca6a" "1db337246ebc9c083be0d728f8d20913a0f46edc0a00277746ba411c149d7fe5" "4f5bb895d88b6fe6a983e63429f154b8d939b4a8c581956493783b2515e22d6d" "12b4427ae6e0eef8b870b450e59e75122d5080016a9061c9696959e50d578057" "ad950f1b1bf65682e390f3547d479fd35d8c66cafa2b8aa28179d78122faa947" "f0d8af755039aa25cd0792ace9002ba885fd14ac8e8807388ab00ec84c9497d7" "5999e12c8070b9090a2a1bbcd02ec28906e150bb2cdce5ace4f965c76cf30476" "0c311fb22e6197daba9123f43da98f273d2bfaeeaeb653007ad1ee77f0003037" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "afc220610bee26945b7c750b0cca03775a8b73c27fdca81a586a0a62d45bbce2" "419637b7a8c9cb43f273980f0c9879c0cbadace6b38efac0281e031772c84eb2" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "ab04c00a7e48ad784b52f34aa6bfa1e80d0c3fcacc50e1189af3651013eb0d58" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "7b4d9b8a6ada8e24ac9eecd057093b0572d7008dbd912328231d0cada776065a" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(delete-selection-mode t)
 '(diary-entry-marker (quote font-lock-variable-name-face))
 '(dired-dwim-target t)
 '(dired-enable-local-variables nil)
 '(dired-listing-switches "-alhv")
 '(dired-local-variables-file nil)
 '(dired-omit-files "^\\.?#\\|^\\.[^\\.].*$")
 '(display-time-default-load-average nil)
 '(display-time-mode t)
 '(emms-mode-line-icon-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *note[] = {
/* width height num_colors chars_per_pixel */
\"    10   11        2            1\",
/* colors */
\". c #1ba1a1\",
\"# c None s None\",
/* pixels */
\"###...####\",
\"###.#...##\",
\"###.###...\",
\"###.#####.\",
\"###.#####.\",
\"#...#####.\",
\"....#####.\",
\"#..######.\",
\"#######...\",
\"######....\",
\"#######..#\" };")))
 '(fci-rule-character-color "#202020")
 '(fci-rule-color "#232A2F" t)
 '(focus-follows-mouse t)
 '(foreground-color "#cccccc")
 '(fringe-mode (quote (0)) nil (fringe))
 '(ggtags-oversize-limit 4000000)
 '(ggtags-use-sqlite3 t)
 '(global-auto-revert-mode t)
 '(global-highlight-parentheses-mode t)
 '(global-yascroll-bar-mode t)
 '(gnus-logo-colors (quote ("#4c8383" "#bababa")) t)
 '(gnus-mode-line-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *gnus-pointer[] = {
/* width height num_colors chars_per_pixel */
\"    18    13        2            1\",
/* colors */
\". c #1ba1a1\",
\"# c None s None\",
/* pixels */
\"##################\",
\"######..##..######\",
\"#####........#####\",
\"#.##.##..##...####\",
\"#...####.###...##.\",
\"#..###.######.....\",
\"#####.########...#\",
\"###########.######\",
\"####.###.#..######\",
\"######..###.######\",
\"###....####.######\",
\"###..######.######\",
\"###########.######\" };")) t)
 '(grep-find-template "find . <X> -type f <F> -exec grep <C> -nH -e <R> \\{\\} +")
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
    (try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name)))
 '(hl-paren-colors
   (quote
    ("#B9F" "#B8D" "#B7B" "#B69" "#B57" "#B45" "#B33" "#B11")))
 '(ibuffer-saved-filter-groups
   (quote
    (("default"
      ("custom"
       (used-mode . Custom-mode))
      ("org-mode"
       (used-mode . org-mode))))))
 '(ibuffer-saved-filters
   (quote
    (("gnus"
      ((or
        (mode . message-mode)
        (mode . mail-mode)
        (mode . gnus-group-mode)
        (mode . gnus-summary-mode)
        (mode . gnus-article-mode))))
     ("programming"
      ((or
        (mode . emacs-lisp-mode)
        (mode . cperl-mode)
        (mode . c-mode)
        (mode . java-mode)
        (mode . idl-mode)
        (mode . lisp-mode)))))))
 '(ido-create-new-buffer (quote always))
 '(ido-ignore-buffers (quote ("\\` " "*Help*")))
 '(ido-ignore-files
   (quote
    ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "^\\.[^\\.]+")))
 '(ido-match-modes-list (quote (words substring regex)))
 '(ido-max-prospects 10)
 '(ido-separator nil)
 '(ido-show-dot-for-dired nil)
 '(ido-use-virtual-buffers (quote auto))
 '(ido-vertical-arrow "? ")
 '(ido-vertical-columns 20)
 '(ido-vertical-common-match-format "%s")
 '(ido-vertical-define-keys (quote grid-movement-with-tabs))
 '(ido-vertical-fixed-rows nil)
 '(ido-vertical-mode t)
 '(ido-vertical-only-match-format "> %s")
 '(ido-vertical-rows 5)
 '(ido-vertical-show-count t)
 '(ido-vertical-truncate-wide-column t)
 '(indicate-buffer-boundaries (quote right))
 '(indicate-empty-lines nil)
 '(ispell-program-name "aspell")
 '(ivy-display-style (quote fancy))
 '(ivy-mode nil)
 '(kill-ring-max 1000)
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style (quote chamfer))
 '(mark-ring-max 1000)
 '(mouse-autoselect-window t)
 '(notmuch-saved-searches
   (quote
    ((:name "all inbox" :query "tag:inbox" :key "i")
     (:name "work inbox" :query "tag:inbox AND path:cse/**" :key "w")
     (:name "unread" :query "tag:unread" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "all mail" :query "*" :key "a")
     (:name "personal inbox" :query "tag:inbox and path:fm/**" :key "p")
     (:name "jira" :query "from:jira@cseresearch.atlassian.net" :key "j" :count-query "J"))))
 '(notmuch-search-line-faces
   (quote
    (("unread" :weight bold :foreground "white")
     ("flagged" :foreground "deep sky blue"))))
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
 '(org-log-into-drawer t)
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
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(projectile-cache-file "/home/hinton/.emacs.d/state/projectile.cache")
 '(projectile-known-projects-file "~/.emacs.d/state/projectile-bookmarks.eld")
 '(recentf-auto-cleanup (quote never))
 '(safe-local-variable-values
   (quote
    ((js2-additional-externs "calc" "describe" "it" "expect" "extend" "ncopies")
     (js2-additional-externs "calc" "describe" "it" "expect")
     (js2-additional-externs quote
                             ("calc" "describe" "it" "expect"))
     (eval add-hook
           (quote after-save-hook)
           (lambda nil
             (shell-command "pandoc -f org -t docbook changelog.org --chapters | sed 's! id=\"\"!!g' | sed 's!<chapter>!<chapter xmlns=\"http://docbook.org/ns/docbook\">!g' | sed 's!<literal>\\(ref\\..\\+\\)</literal>!<xref linkend=\"\\1\"/>!g' > changelog.xml"))
           nil t))))
 '(sendmail-program "msmtp-enqueue")
 '(sp-show-pair-delay 0)
 '(split-width-threshold 200)
 '(tab-width 4)
 '(tramp-persistency-file-name "~/.emacs.d/state/tramp")
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(url-configuration-directory "~/.emacs.d/state/url/")
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
 )
