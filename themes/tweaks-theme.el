(deftheme tweaks "small adjustments to theme")
(require 'highlight-symbol)

(defface not-interesting nil "A face for things which just aren't that interesting")

(custom-theme-set-faces
 'tweaks

 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))

 '(org-tag ((t (:inherit shadow))))
 '(org-todo ((t (:inverse-video t))))
 '(org-done ((t (:inverse-video t))))
 '(org-ellipsis ((t (:inherit shadow :underline nil :foreground nil :height 0.8))))
 '(org-mode-line-clock ((t (:background nil))))

 '(mode-line ((t (:foreground "white"))))
 '(mode-line-inactive ((t (:foreground "grey50"))))

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

 '(not-interesting ((t (:slant italic))))

 '(font-lock-comment-delimiter-face ((t (:weight bold))))

 '(highlight ((((background dark)) (:background "royalblue4"))
              (((background light)) (:background "black"))))

 '(region ((((background dark)) (:background "DarkSlateGray"))
           (((background light)) (:background "khaki"))
           ))

 '(message-cited-text ((t (:inherit nil))))
 '(notmuch-wash-cited-text ((t (:inherit nil))))

 '(pass-mode-directory-face ((t (:inherit dired-directory))))
 )

(provide-theme 'tweaks)
