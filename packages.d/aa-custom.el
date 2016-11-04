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
   [unspecified "#343d46" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#81a2be" "#dfe1e8"] t)
 '(anzu-cons-mode-line-p nil)
 '(auth-source-cache-expiry nil)
 '(auth-source-protocols
   (quote
    ((imap "imap" "imaps" "143" "993")
     (pop3 "pop3" "pop" "pop3s" "110" "995")
     (ssh "ssh" "22")
     (sftp "sftp" "115")
     (smtp "smtp" "25")
     (http "http" "80"))))
 '(bbdb-file-remote "/ssh:lrkry.com:~/bbdb")
 '(beacon-color "#F8BBD0")
 '(bookmark-default-file "~/.emacs.d/state/bookmarks")
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-generic-args (quote ("-bg")))
 '(browse-url-generic-program "/home/hinton/bin/xdg-open")
 '(calendar-date-style (quote european))
 '(calendar-intermonth-spacing 2)
 '(calendar-latitude 51.45)
 '(calendar-longitude -2.5833)
 '(calendar-week-start-day 1)
 '(colir-compose-method (quote colir-compose-overlay))
 '(column-number-mode t)
 '(custom-raised-buttons t)
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
 '(dired-subtree-line-prefix "    ┃")
 '(dired-subtree-use-backgrounds nil)
 '(display-battery-mode t)
 '(display-buffer-alist nil)
 '(display-time-mail-file (quote none))
 '(display-time-mode t)
 '(eldoc-idle-delay 0.2)
 '(emms-mode-line-icon-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *note[] = {
/* width height num_colors chars_per_pixel */
\"    10   11        2            1\",
/* colors */
\". c #358d8d\",
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
 '(ess-S-underscore-when-last-character-is-a-space t)
 '(evil-emacs-state-cursor (quote ("#E57373" bar)))
 '(evil-insert-state-cursor (quote ("#E57373" hbar)))
 '(evil-normal-state-cursor (quote ("#FFEE58" box)))
 '(evil-visual-state-cursor (quote ("#C5E1A5" box)))
 '(excorporate-configuration
   (quote
    ("tomh" . "https://webmail.cse.org.uk/ews/exchange.asmx")))
 '(fci-rule-character-color "#192028")
 '(fci-rule-color "#f8fce8" t)
 '(focus-follows-mouse t)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(geiser-default-implementation (quote guile))
 '(global-auto-revert-mode t)
 '(gnus-logo-colors (quote ("#0d7b72" "#adadad")) t)
 '(gnus-mode-line-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *gnus-pointer[] = {
/* width height num_colors chars_per_pixel */
\"    18    13        2            1\",
/* colors */
\". c #358d8d\",
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
 '(gnutls-verify-error nil)
 '(highlight-symbol-colors
   (quote
    ("#F57F17" "#66BB6A" "#0097A7" "#42A5F5" "#7E57C2" "#D84315")))
 '(highlight-symbol-foreground-color "#546E7A")
 '(highlight-tail-colors (quote (("#F8BBD0" . 0) ("#FAFAFA" . 100))))
 '(hippie-expand-try-functions-list
   (quote
    (yas-hippie-try-expand try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name try-expand-line)))
 '(hl-paren-background-colors (quote ("#e8fce8" "#c1e7f8" "#f8e8e8")))
 '(hl-paren-colors (quote ("#40883f" "#0287c8" "#b85c57")))
 '(ibuffer-filter-group-name-face (quote warning))
 '(ibuffer-formats
   (quote
    ((mark modified read-only " "
           (name 40 40 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 16 -1)
           " " filename))))
 '(ibuffer-marked-face (quote highlight))
 '(ibuffer-title-face (quote bold))
 '(ibuffer-truncate-lines nil)
 '(indicate-buffer-boundaries (quote left))
 '(indicate-empty-lines t)
 '(inhibit-startup-echo-area-message "hinton")
 '(isearch-allow-scroll t)
 '(ispell-extra-args (quote ("--dict-dir=/home/hinton/.nix-profile/lib/aspell")))
 '(ispell-program-name "aspell")
 '(kill-ring-max 1000)
 '(magit-completing-read-function (quote magit-ido-completing-read))
 '(mark-ring-max 1000)
 '(mc/mode-line
   (quote
    (" mc:"
     (:eval
      (format
       #("%d" 0 2
         (face mode-line-emphasis))
       (mc/num-cursors))))))
 '(mouse-autoselect-window t)
 '(mouse-wheel-progressive-speed nil)
 '(netrc-file "~/.netrc")
 '(nix-sandbox-interpreter-mode-alist
   (quote
    ((clojure-mode nil cider-lein-command nil)
     (python-mode t python-shell-interpreter nil))))
 '(notmuch-fcc-dirs
   (quote
    (("tom\\.hinton@cse\\.org\\.uk" . "\"cse/Sent Items\"")
     ("larkery\\.com" . "\"fastmail/Sent Items\""))))
 '(nxml-slash-auto-complete-flag t)
 '(org-adapt-indentation nil)
 '(org-agenda-custom-commands
   (quote
    (("n" "Agenda and all TODO's"
      ((agenda ""
               ((org-agenda-clockreport-parameter-plist
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
 '(org-agenda-diary-file "~/notes/calendar.org")
 '(org-agenda-files
   (quote
    ("~/notes/calendar.org" "~/notes/inbox.org" "~/notes/work/" "~/notes/home")))
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
      (file "~/notes/calendar.org")
      "* %?
%^T")
     ("l" "Interesting link" entry
      (file "~/notes/links.org")
      "* %a %u"))))
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
 '(org-icalendar-use-scheduled (quote (event-if-not-todo event-if-todo todo-start)))
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
 '(org-refile-targets
   (quote
    ((nil :maxlevel . 2)
     (org-agenda-files :maxlevel . 2))))
 '(org-refile-use-outline-path (quote file))
 '(org-show-notification-handler "notify-send")
 '(org-speed-commands-user
   (quote
    (("d" . org-refile-to-datetree)
     ("k" . org-cut-subtree))))
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
 '(org-todo-keyword-faces (quote (("WAIT" . "DeepSkyBlue") ("CANCEL" . "Black"))))
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t)" "WAIT(w)" "DONE(d)")
     (sequence "CANCEL(c)")
     (sequence "IDEA(i)"))))
 '(org-todo-state-tags-triggers nil)
 '(org-use-property-inheritance (quote ("CODE")))
 '(org-use-speed-commands t)
 '(package-selected-packages
   (quote
    (org-bullets csv-mode yasnippet ivy projectile bbdb org undo-tree ws-butler which-key wgrep weechat w3m ucs-utils twilight-anti-bright-theme tao-theme tangotango-theme stekene-theme sr-speedbar spacemacs-theme spacegray-theme smex smartrep smartparens smart-tab request req-package rainbow-mode project-explorer pdf-tools pcre2el pass paren-face org-journal org-caldav notmuch nix-mode multiple-cursors minimal-theme majapahit-theme magit lua-mode js2-mode jira-markup-mode java-snippets java-imports ido-ubiquitous ido-at-point ibuffer-projectile highlight-symbol hexrgb haskell-mode graphviz-dot-mode git-timemachine fringe-current-line font-utils flimenu expand-region eno emojify elfeed el-get eclim dired-subtree dired-ranger darktooth-theme counsel composable comment-dwim-2 clojure-snippets cider browse-kill-ring+ bbdb-vcard bbdb-handy bbdb-ext base16-theme avy auto-capitalize auth-password-store apropospriate-theme anzu anaconda-mode alect-themes ag adaptive-wrap)))
 '(paradox-github-token t)
 '(pe/follow-current t)
 '(pos-tip-background-color "#EEDFCC")
 '(pos-tip-foreground-color "#FFFFC8")
 '(projectile-cache-file "/home/hinton/.emacs.d/state/projectile.cache")
 '(projectile-known-projects-file "~/.emacs.d/state/projectile-bookmarks.eld")
 '(python-shell-interpreter "ipython3")
 '(python-shell-interpreter-args "-i --matplotlib=qt4")
 '(rainbow-identifiers-cie-l*a*b*-lightness 25)
 '(rainbow-identifiers-cie-l*a*b*-saturation 40)
 '(rcirc-fill-flag nil)
 '(recentf-auto-cleanup (quote never))
 '(safe-local-variable-values
   (quote
    ((eval add-hook
           (quote after-save-hook)
           (lambda nil
             (shell-command "pandoc -f org -t docbook changelog.org --chapters | sed 's! id=\"\"!!g' | sed 's!<chapter>!<chapter xmlns=\"http://docbook.org/ns/docbook\">!g' | sed 's!<literal>\\(ref\\..\\+\\)</literal>!<xref linkend=\"\\1\"/>!g' > changelog.xml"))
           nil t))))
 '(save-interprogram-paste-before-kill t)
 '(sendmail-program "msmtpq-quiet")
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(sml/active-background-color "#98ece8")
 '(sml/active-foreground-color "#424242")
 '(sml/inactive-background-color "#4fa8a8")
 '(sml/inactive-foreground-color "#424242")
 '(sp-show-pair-delay 0)
 '(speedbar-show-unknown-files t)
 '(speedbar-update-flag t)
 '(speedbar-use-images nil)
 '(speedbar-verbosity-level 0)
 '(split-width-threshold 200)
 '(sr-speedbar-right-side t)
 '(tab-width 4)
 '(tabbar-background-color "#353535")
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
 '(w3m-bookmark-file-coding-system (quote utf-8))
 '(w3m-coding-system (quote utf-8))
 '(w3m-file-coding-system (quote utf-8))
 '(w3m-file-name-coding-system (quote utf-8))
 '(w3m-mode-hook (quote (w3m-lnum-mode bookmark-w3m-prepare)))
 '(w3m-search-default-engine "ddg")
 '(w3m-search-engine-alist
   (quote
    (("yahoo" "http://search.yahoo.com/bin/search?p=%s" nil)
     ("yahoo-ja" "http://search.yahoo.co.jp/bin/search?p=%s" euc-japan)
     ("alc" "http://eow.alc.co.jp/%s/UTF-8/" utf-8)
     ("blog" "http://blogsearch.google.com/blogsearch?q=%s&oe=utf-8&ie=utf-8" utf-8)
     ("blog-en" "http://blogsearch.google.com/blogsearch?q=%s&hl=en&oe=utf-8&ie=utf-8" utf-8)
     ("google" "http://www.google.com/search?q=%s&ie=utf-8&oe=utf-8" utf-8)
     ("google-en" "http://www.google.com/search?q=%s&hl=en&ie=utf-8&oe=utf-8" utf-8)
     ("google news" "http://news.google.com/news?q=%s&ie=utf-8&oe=utf-8" utf-8)
     ("google news-en" "http://news.google.com/news?q=%s&hl=en&ie=utf-8&oe=utf-8" nil)
     ("google groups" "http://groups.google.com/groups?q=%s" nil)
     ("All the Web" "http://www.alltheweb.com/search?q=%s&web&_sb_lang=en" nil)
     ("All the Web-ja" "http://www.alltheweb.com/search?q=%s&web&_sb_lang=ja&cs=euc-jp" euc-japan)
     ("technorati" "http://www.technorati.com/search/%s" utf-8)
     ("technorati-ja" "http://www.technorati.jp/search/search.html?query=%s&language=ja" utf-8)
     ("technorati-tag" "http://www.technorati.com/tag/%s" utf-8)
     ("goo-ja" "http://search.goo.ne.jp/web.jsp?MT=%s" euc-japan)
     ("excite-ja" "http://www.excite.co.jp/search.gw?target=combined&look=excite_jp&lang=jp&tsug=-1&csug=-1&search=%s" shift_jis)
     ("altavista" "http://altavista.com/sites/search/web?q=\"%s\"&kl=ja&search=Search" nil)
     ("rpmfind" "http://rpmfind.net/linux/rpm2html/search.php?query=%s" nil)
     ("debian-pkg" "http://packages.debian.org/cgi-bin/search_contents.pl?directories=yes&arch=i386&version=unstable&case=insensitive&word=%s" nil)
     ("debian-bts" "http://bugs.debian.org/cgi-bin/pkgreport.cgi?archive=yes&pkg=%s" nil)
     ("freebsd-users-jp" "http://home.jp.FreeBSD.org/cgi-bin/namazu.cgi?key=\"%s\"&whence=0&max=50&format=long&sort=score&dbname=FreeBSD-users-jp" euc-japan)
     ("iij-archie" "http://www.iij.ad.jp/cgi-bin/archieplexform?query=%s&type=Case+Insensitive+Substring+Match&order=host&server=archie1.iij.ad.jp&hits=95&nice=Nice" nil)
     ("waei" "http://dictionary.goo.ne.jp/search.php?MT=%s&kind=je" euc-japan)
     ("eiwa" "http://dictionary.goo.ne.jp/search.php?MT=%s&kind=ej" nil)
     ("kokugo" "http://dictionary.goo.ne.jp/search.php?MT=%s&kind=jn" euc-japan)
     ("eiei" "http://www.dictionary.com/cgi-bin/dict.pl?term=%s&r=67" nil)
     ("amazon" "http://www.amazon.com/exec/obidos/search-handle-form/250-7496892-7797857" iso-8859-1 "url=index=blended&field-keywords=%s")
     ("amazon-ja" "http://www.amazon.co.jp/gp/search?__mk_ja_JP=%%83J%%83%%5E%%83J%%83i&url=search-alias%%3Daps&field-keywords=%s" shift_jis)
     ("emacswiki" "http://www.emacswiki.org/cgi-bin/wiki?search=%s" nil)
     ("en.wikipedia" "http://en.wikipedia.org/wiki/Special:Search?search=%s" nil)
     ("de.wikipedia" "http://de.wikipedia.org/wiki/Spezial:Search?search=%s" utf-8)
     ("ja.wikipedia" "http://ja.wikipedia.org/wiki/Special:Search?search=%s" utf-8)
     ("msdn" "http://search.msdn.microsoft.com/search/default.aspx?query=%s" nil)
     ("freshmeat" "http://freshmeat.net/search/?q=%s&section=projects" nil)
     ("ddg" "http://duckduckgo.com/?q=%s" nil))))
 '(w3m-use-tab nil)
 '(weechat-color-list
   (quote
    (unspecified "black" "dark gray" "dark red" "red" "green" "light green" "brown" "yellow" "deepskyblue" "light blue" "dark magenta" "magenta" "dark cyan" "light cyan" "gray" "white")))
 '(weechat-notification-mode t)
 '(weechat-notification-types (quote (:highlight :disconnect :query)))
 '(xterm-color-names
   ["#EEDFCC" "#A33555" "#AE6A56" "#666E4D" "#375E54" "#5B5040" "#6F756E" "#444444"])
 '(xterm-color-names-bright
   ["#E5D5C1" "#DB4764" "#D7875F" "#6C9889" "#848F86" "#84745C" "#444444"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(outline-1 ((t (:height 1.3 :font-family "Sans-serif"))))
 '(pass-mode-directory-face ((t (:inherit highlight)))))
