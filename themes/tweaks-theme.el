(deftheme tweaks "small adjustments to theme")
(require 'highlight-symbol)

(defface not-interesting nil "A face for things which just aren't that interesting")

(custom-theme-set-faces
 'tweaks

 '(default ((((background light)) (:weight light
                                           ;; not sure about that one:
                                           :background "grey93"))))

 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))

 '(org-tag ((t (:inherit shadow))))
 '(org-todo ((t (:inverse-video t))))
 '(org-done ((t (:inverse-video t))))
 '(org-ellipsis ((t (:inherit shadow :underline nil :foreground nil :height 0.8))))
 '(org-mode-line-clock ((t (:background nil))))

 '(mode-line ((t (:box nil))
              (((background dark)) (:foreground "white"))))
 '(mode-line-inactive ((t (:box nil))
                       (((background dark)) (:box nil :foreground "grey50"))))

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

 '(org-level-1 ((t (:height 1.1 :weight bold))))
 '(org-level-2 ((t (:height 1.1 :weight bold))))
 '(org-level-3 ((t (:height 1.1 :weight bold))))
 '(org-level-4 ((t (:height 1.1 :weight bold))))
 '(org-level-5 ((t (:height 1.1 :weight bold))))
 '(org-level-6 ((t (:height 1.1 :weight bold))))
 '(org-level-7 ((t (:height 1.1 :weight bold))))
 '(org-level-8 ((t (:height 1.1 :weight bold))))
 '(org-level-9 ((t (:height 1.1 :weight bold))))

 '(not-interesting ((((background dark)) (:foreground "grey60"))))

 '(font-lock-comment-delimiter-face ((t (:weight bold))))

 '(highlight ((((background dark)) (:background "royalblue4"))
              (((background light)) (;; :inverse-video


                                     ;; t
                                     ))))

 '(region ((((background dark)) (:background "DarkSlateGray"))
           (((background light)) (:background "khaki"))
           ))

 '(message-cited-text ((t (:inherit nil))))
 '(notmuch-wash-cited-text ((t (:inherit nil))))
 '(notmuch-search-flagged-face ((((background dark)) (:foreground "yellow"))))
 '(notmuch-search-unread-face ((((background dark)) (:foreground "white" :weight bold))))
 '(notmuch-standard-tag-face ((((background light)) (:foreground "tan4"))))

 '(org-agenda-date ((t (:weight bold :height 1.1))))
 '(org-agenda-date-2 ((t (:inherit org-agenda-date))))
 '(org-agenda-date-today ((t (:height 1.1))))
 '(org-agenda-date-weekend ((t (:foreground "darkcyan"))))

 '(pass-mode-directory-face ((t (:inherit dired-directory))))
 )

(provide-theme 'tweaks)
