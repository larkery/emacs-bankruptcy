(setq custom-file load-file-name)
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Linum-format "%7i ")
 '(ag-highlight-search t)
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#3c3836" "#fb4934" "#b8bb26" "#fabd2f" "#83a598" "#d3869b" "#8ec07c" "#ebdbb2"])
 '(ansi-term-color-vector
   [unspecified "#343d46" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#81a2be" "#dfe1e8"])
 '(anzu-cons-mode-line-p nil)
 '(auth-source-protocols
   (quote
    ((imap "imap" "imaps" "143" "993")
     (pop3 "pop3" "pop" "pop3s" "110" "995")
     (ssh "ssh" "22")
     (sftp "sftp" "115")
     (smtp "smtp" "25")
     (http "http" "80"))))
 '(auth-sources (quote ("~/.netrc")))
 '(avy-keys (quote (97 115 100 102 113 119 101 114 122)))
 '(avy-style (quote at))
 '(aw-scope (quote visible))
 '(beacon-color "#F8BBD0")
 '(bookmark-default-file "~/.emacs.d/state/bookmarks")
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-generic-program "~/.local/bin/xdg-open")
 '(calendar-date-style (quote european))
 '(calendar-intermonth-spacing 2)
 '(calendar-latitude 51.45)
 '(calendar-longitude -2.5833)
 '(calendar-week-start-day 1)
 '(colir-compose-method (quote colir-compose-overlay))
 '(column-number-mode t)
 '(custom-raised-buttons t)
 '(custom-safe-themes
   (quote
    ("3a69621a68c2d3550a4c777ffc000e1ea66f5bc2f61112814c591e1bda3f5704" "c9e42ede5d97db2dd849f5d0a8cfb6a857ec5f687413242b74f565af273404ed" "c3e6b52caa77cb09c049d3c973798bc64b5c43cc437d449eacf35b3e776bf85c" "e475cece13fc5c0ea84f554a4e9d41805b19a8fff54b26ce6c18cb1912133a9a" "fe1682ca8f7a255cf295e76b0361438a21bb657d8846a05d9904872aa2fb86f2" "ff91d59dc1b6c6dfa71048183d08637b55880cac12f9b38ba0b9309d6ffecff1" "39fe48be738ea23b0295cdf17c99054bb439a7d830248d7e6493c2110bfed6f8" "7beac4a68f03662b083c9c2d4f1d7f8e4be2b3d4b0d904350a9edf3cf7ce3d7f" "7f5837a7dbf54c2b7c41d94f5eb1373cf63274847d1971037faa24d7f2231eea" "2c3ea9579d95e43da42cadededcff45f9251525112bd87c390045bd7a7adbe1a" "df87edcf41dbdb2c5d49d53acdfc9d5c2087ef7259679ac50923f97e0b24fdfe" default)))
 '(custom-theme-allow-multiple-selections t)
 '(debug-on-error nil)
 '(delete-selection-mode t)
 '(diary-entry-marker (quote font-lock-variable-name-face))
 '(dired-auto-revert-buffer (quote dired-directory-changed-p))
 '(dired-dwim-target t)
 '(dired-enable-local-variables nil)
 '(dired-listing-switches "-alhv")
 '(dired-local-variables-file nil)
 '(dired-omit-files "^\\.?#\\|^\\.[^\\.].*$")
 '(display-buffer-alist nil)
 '(emms-mode-line-icon-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *note[] = {
/* width height num_colors chars_per_pixel */
\"    10   11        2            1\",
/* colors */
\". c #1fb3b3\",
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
 '(erc-fill-function (quote h/erc-fill-nicks-thing))
 '(erc-fill-mode t)
 '(erc-insert-away-timestamp-function (quote erc-insert-timestamp-right))
 '(erc-insert-timestamp-function (quote h/erc-insert-timestamp-at-end))
 '(erc-notifications-mode t)
 '(erc-text-matched-hook (quote (erc-log-matches erc-beep-on-match)))
 '(erc-timestamp-use-align-to nil)
 '(ess-S-underscore-when-last-character-is-a-space t)
 '(evil-emacs-state-cursor (quote ("#D50000" bar)))
 '(evil-insert-state-cursor (quote ("#D50000" hbar)))
 '(evil-normal-state-cursor (quote ("#F57F17" box)))
 '(evil-visual-state-cursor (quote ("#66BB6A" box)))
 '(fci-rule-color "#37474f" t)
 '(focus-follows-mouse t)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(geiser-default-implementation (quote guile))
 '(ggtags-oversize-limit 4000000)
 '(ggtags-use-sqlite3 t)
 '(global-auto-revert-mode t)
 '(gnus-logo-colors (quote ("#528d8d" "#c0c0c0")) t)
 '(gnus-mode-line-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *gnus-pointer[] = {
/* width height num_colors chars_per_pixel */
\"    18    13        2            1\",
/* colors */
\". c #1fb3b3\",
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
 '(highlight-symbol-colors
   (quote
    ("#F57F17" "#66BB6A" "#0097A7" "#42A5F5" "#7E57C2" "#D84315")))
 '(highlight-symbol-foreground-color "#546E7A")
 '(highlight-tail-colors (quote (("#F8BBD0" . 0) ("#FAFAFA" . 100))))
 '(hippie-expand-try-functions-list
   (quote
    (try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name)))
 '(hl-paren-background-colors (quote ("#2492db" "#95a5a6" nil)))
 '(hl-paren-colors (quote ("#ecf0f1" "#ecf0f1" "#c0392b")))
 '(hl-sexp-background-color "#1c1f26")
 '(ibuffer-filter-group-name-face (quote button))
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
 '(ido-auto-merge-delay-time 0.7)
 '(ido-create-new-buffer (quote always))
 '(ido-default-buffer-method (quote selected-window))
 '(ido-default-file-method (quote selected-window))
 '(ido-grid-special-commands
   (quote
    ((h/recentf-find-file 15 1 nil 1)
     (lacarte-execute-menu-command 10 1 nil 1)
     (h/ido-occur 0.25 1 nil 1))))
 '(ido-ignore-buffers (quote ("\\` " "*Help*" "*magit-process")))
 '(ido-ignore-files
   (quote
    ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "^\\.[^\\.]+")))
 '(ido-match-modes-list (quote (words substring regex)))
 '(ido-max-work-directory-list 100)
 '(ido-separator nil)
 '(ido-show-dot-for-dired nil)
 '(ido-use-virtual-buffers (quote auto))
 '(ido-work-directory-list-ignore-regexps (quote ("^/home/hinton/gvfs/")))
 '(indicate-buffer-boundaries (quote left))
 '(indicate-empty-lines t)
 '(initial-scratch-message
   ";; A novice was trying to fix a broken lisp machine by turning the
;; power off and on.  Knight, seeing what the student was doing spoke sternly,
;; \"You cannot fix a machine by just power-cycling it with no understanding
;; of what is going wrong.\"  Knight turned the machine off and on.  The
;; machine worked.

")
 '(iplayer-download-directory "~/music/iplayer/")
 '(isearch-allow-scroll t)
 '(ispell-program-name "aspell")
 '(ivy-display-style (quote fancy))
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
    (("unread" :weight bold)
     ("flagged" :inherit
      (isearch)))))
 '(nrepl-message-colors
   (quote
    ("#336c6c" "#205070" "#0f2050" "#806080" "#401440" "#6c1f1c" "#6b400c" "#23733c")))
 '(org-adapt-indentation nil)
 '(org-agenda-custom-commands
   (quote
    (("n" "Agenda and all TODO's"
      ((agenda ""
               ((org-agenda-span 1)
                (org-agenda-clockreport-parameter-plist
                 (quote
                  (:step day :fileskip0 t :stepskip0)))
                (org-agenda-log-mode-items
                 (quote
                  (closed clock)))))
       (alltodo "" nil))
      nil)
     ("w" "Weekly clock report" agenda ""
      ((org-agenda-clockreport-parameter-plist
        (quote
         (:link t :maxlevel 3 :step day :fileskip0 t :stepskip0 t :tcolumns 0 :properties
                ("code")))))))))
 '(org-agenda-files
   (quote
    ("~/notes/" "~/notes/work/" "~/notes/home/" "~/notes/calendar/")))
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
    (("c" "Future task" entry
      (file "~/notes/inbox.org")
      "** TODO %?%a
%u")
     ("e" "calendar event" entry
      (file "~/notes/work/calendar.org")
      "* %?
%^T"))))
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
 '(org-clock-into-drawer t)
 '(org-clock-mode-line-total (quote today))
 '(org-clock-out-remove-zero-time-clocks nil)
 '(org-clock-persist t)
 '(org-clock-persist-file "~/.emacs.d/state/org-clock-save.el")
 '(org-clock-persist-query-resume nil)
 '(org-clock-report-include-clocking-task t)
 '(org-clocktable-defaults
   (quote
    (:maxlevel 2 :lang "en" :scope file :block nil :wstart 1 :mstart 1 :tstart nil :tend nil :step nil :stepskip0 nil :fileskip0 nil :tags nil :emphasize nil :link nil :narrow 40! :indent t :formula nil :timestamp nil :level nil :tcolumns nil nil nil :effort-durations t)))
 '(org-completion-use-ido t)
 '(org-confirm-babel-evaluate (quote ignore))
 '(org-contacts-files (quote ("~/notes/exclude/contacts.org")))
 '(org-custom-properties (quote ("code")))
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
 '(org-format-latex-options
   (quote
    (:foreground default :background default :scale 1.5 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\["))))
 '(org-goto-interface (quote outline-path-completion))
 '(org-journal-date-prefix "#+TITLE: ")
 '(org-journal-dir "~/notes/journal/")
 '(org-journal-file-format "journal-%Y-%m-%d")
 '(org-journal-hide-entries-p nil)
 '(org-journal-time-format "")
 '(org-journal-time-prefix "")
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
     "\\tolerance=1000"
     ("" "fullpage" nil)
     ("" "parskip" nil))))
 '(org-latex-link-with-unknown-path-format "\\colorbox{red}{%s}")
 '(org-latex-listings (quote minted))
 '(org-latex-packages-alist nil)
 '(org-latex-pdf-process
   (quote
    ("latexmk -pdflatex='pdflatex --shell-escape -interaction nonstopmode -output-directory %o' -pdf -f %f")))
 '(org-latex-to-pdf-process (quote ("latexmk -pdf -e '$pdflatex=q/xelatex %O %S/' %f")))
 '(org-log-done (quote time))
 '(org-log-into-drawer t)
 '(org-odt-inline-image-rules (quote (("file" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\)\\'"))))
 '(org-odt-with-latex (quote dvipng))
 '(org-outline-path-complete-in-steps nil)
 '(org-publish-project-alist
   (quote
    (("lrkry" :base-directory "~/projects/website/" :publishing-directory "/ssh:lrkry.com:~/website/" :publishing-function org-html-publish-to-html))))
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
 '(org-time-clocksum-format
   (quote
    (:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t)))
 '(org-time-clocksum-fractional-format (quote (:hours "%.2f h")))
 '(org-time-clocksum-use-effort-durations t)
 '(org-time-clocksum-use-fractional nil)
 '(org-todo-keyword-faces (quote (("WAIT" . "DeepSkyBlue") ("CANCEL" . "magenta"))))
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t)" "WAIT(w)" "DONE(d)")
     (sequence "CANCEL(c)")
     (sequence "IDEA(i)"))))
 '(org-todo-state-tags-triggers nil)
 '(org-use-property-inheritance (quote ("CODE")))
 '(org-use-speed-commands t)
 '(paradox-github-token t)
 '(pe/follow-current t)
 '(pos-tip-background-color "#3a3a3a")
 '(pos-tip-foreground-color "#9E9E9E")
 '(projectile-cache-file "/home/hinton/.emacs.d/state/projectile.cache")
 '(projectile-known-projects-file "~/.emacs.d/state/projectile-bookmarks.eld")
 '(python-shell-interpreter "ipython3")
 '(python-shell-interpreter-args "-i --matplotlib=qt4")
 '(rcirc-fill-flag nil)
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
 '(sentence-end-double-space nil)
 '(sml/active-background-color "#34495e")
 '(sml/active-foreground-color "#ecf0f1")
 '(sml/inactive-background-color "#dfe4ea")
 '(sml/inactive-foreground-color "#34495e")
 '(sp-show-pair-delay 0)
 '(split-width-threshold 200)
 '(tab-width 4)
 '(tabbar-background-color "#ffffff")
 '(tramp-persistency-file-name "~/.emacs.d/state/tramp")
 '(tramp-verbose 2)
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
 '(button ((t (:background "#444444" :foreground "#FFFFFF" :box (:line-width 2 :color "grey75" :style released-button) :underline nil)))))
