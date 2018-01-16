(deftheme tweaks "small adjustments to theme")

(defface not-interesting nil "A face for things which just aren't that interesting")

(defface mode-line-read-only nil "Read only buffer name")
(defface mode-line-modified nil "Modified buffer name")

(custom-theme-set-faces
 'tweaks

 '(default ((((background light)) (:weight light  ;;:background "#fff6eb"
                                           ))))

 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))

 '(org-tag ((t (:inherit shadow))))
 '(org-todo ((t (:inverse-video nil :weight normal :inherit highlight))))
 '(org-done ((t (:inverse-video nil :weight normal :inherit shadow))))
 '(org-ellipsis ((t (:inherit shadow :underline nil :foreground nil :height 0.8))))
 '(org-mode-line-clock ((t (:background nil))))

 '(mode-line ((t (:background "#006699" :box nil :foreground "white"))))
 '(compilation-mode-line-run ((t (:foreground "cyan"))))
 '(compilation-mode-line-exit ((t (:foreground "chartreuse"))))
 '(compilation-mode-line-error ((t (:foreground "pink"))))
 '(cursor ((t (:background "#006699"))))

 '(mode-line-buffer-id ((t (:foreground "white"))))
 '(mode-line-inactive ((t (:background "grey40" :box nil :foreground "grey90"))))
 '(mode-line-read-only ((t (:foreground "pink"))))
 '(mode-line-modified ((t (:underline "orange"))))

 '(show-paren-match ((t (:weight bold :foreground "black"))))

 '(cfw:face-toolbar-button-off ((t (:weight normal :foreground nil))))
 '(cfw:face-toolbar-button-on ((t (:weight normal :foreground nil))))
 '(cfw:face-toolbar ((t (:foreground nil :background nil))))

 '(hl-line
   ((((background dark))  (:background "grey30"))
    (((background light)) (:background "grey90"))))

 '(ivy-remote ((t (:inherit default))))

 '(ivy-virtual ((t (:slant italic))))

 '(outline-1 ((t (:height 1.1 :weight bold))))
 '(outline-2 ((t (:height 1.1 :weight bold))))
 '(outline-3 ((t (:height 1.1 :weight bold))))
 '(outline-4 ((t (:height 1.1 :weight bold))))
 '(outline-5 ((t (:height 1.1 :weight bold))))
 '(outline-6 ((t (:height 1.1 :weight bold))))
 '(outline-7 ((t (:height 1.1 :weight bold))))
 '(outline-8 ((t (:height 1.1 :weight bold))))
 '(outline-9 ((t (:height 1.1 :weight bold))))

 '(org-level-1 ((t (:height 1.1 :weight bold :foreground "darkred"))))
 '(org-level-2 ((t (:height 1.1 :weight bold :foreground "darkcyan"))))
 '(org-level-3 ((t (:height 1.1 :weight bold :foreground "darkorange4"))))
 '(org-level-4 ((t (:height 1.1 :weight bold :foreground "springgreen4"))))
 '(org-level-5 ((t (:height 1.0 :weight bold))))
 '(org-level-6 ((t (:height 1.0 :weight bold))))
 '(org-level-7 ((t (:height 1.0 :weight bold))))
 '(org-level-8 ((t (:height 1.0 :weight bold))))
 '(org-level-9 ((t (:height 1.0 :weight bold))))

 '(not-interesting ((((background dark)) (:foreground "grey60"))))

 '(font-lock-comment-delimiter-face ((t (:weight bold))))

 '(highlight ((((background dark)) (:background "royalblue4"))
              ))

 '(region ((((background dark)) (:background "DarkSlateGray"))
           (((background light)) (:background "khaki"))
           ))

 '(message-cited-text ((t (:inherit nil))))

 '(message-header-name    ((t (:weight bold :family "Monospace"))))
 '(message-header-subject ((t (:family "Monospace"))))
 '(message-header-to      ((t (:family "Monospace"))))
 '(message-header-cc      ((t (:family "Monospace"))))
 '(message-header-other   ((t (:family "Monospace"))))
 '(message-header-xheader ((t (:family "Monospace"))))

 '(notmuch-wash-cited-text ((t (:inherit nil))))
 '(notmuch-search-flagged-face ((((background dark)) (:foreground "yellow"))))
 '(notmuch-search-unread-face ((((background dark)) (:foreground "white" :weight bold))))
 '(notmuch-standard-tag-face ((((background light)) (:foreground "tan4"))))
 '(notmuch-message-summary-face ((((background light)) (:background "grey90" :foreground "black"))))


 '(org-agenda-date ((t (:weight bold :height 1.1))))
 '(org-agenda-date-2 ((t (:inherit org-agenda-date))))
 '(org-agenda-date-today ((t (:inherit highlight))))
 '(org-agenda-date-weekend ((t (:slant italic))))

 '(pass-mode-directory-face ((t (:inherit dired-directory))))
 )

(provide-theme 'tweaks)
