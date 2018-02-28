(deftheme tweaks "small adjustments to theme")

(defface not-interesting nil "A face for things which just aren't that interesting")

(defface mode-line-read-only nil "Read only buffer name")
(defface mode-line-modified nil "Modified buffer name")

(custom-theme-set-faces
 'tweaks

 '(default ( (((background light)) (:weight light))
             (((background dark)) (:weight light)))
    )

 '(mode-line-read-only ((t (:foreground "darkred"))))
 '(mode-line-modified ((t (:underline "orange"))))

 '(hl-line
   ((((background dark))  (:background "grey30"))
    (((background light)) (:background "grey90"))))

 '(ivy-remote ((t (:inherit default))))
 '(ivy-virtual ((t (:slant italic))))

 '(outline-1 ((t (:family "Sans" :height 1.2 :weight bold))))
 '(outline-2 ((t (:family "Sans" :height 1.2 :weight bold))))
 '(outline-3 ((t (:family "Sans" :height 1.2 :weight bold))))
 '(outline-4 ((t (:family "Sans" :height 1.2 :weight bold))))
 '(outline-5 ((t (:family "Sans" :height 1.2 :weight bold))))
 '(outline-6 ((t (:family "Sans" :height 1.2 :weight bold))))
 '(outline-7 ((t (:family "Sans" :height 1.2 :weight bold))))
 '(outline-8 ((t (:family "Sans" :height 1.2 :weight bold))))
 '(outline-9 ((t (:family "Sans" :height 1.2 :weight bold))))

 '(org-level-1 ((t (:height 1.0 :inherit outline-1))))
 '(org-level-2 ((t (:height 1.0 :inherit outline-2))))
 '(org-level-3 ((t (:height 1.0 :inherit outline-3))))
 '(org-level-4 ((t (:height 1.0 :inherit outline-4))))
 '(org-level-5 ((t (:height 1.0 :inherit outline-5))))
 '(org-level-6 ((t (:height 1.0 :inherit outline-6))))
 '(org-level-7 ((t (:height 1.0 :inherit outline-7))))
 '(org-level-8 ((t (:height 1.0 :inherit outline-8))))
 '(org-level-9 ((t (:height 1.0 :inherit outline-9))))

 '(not-interesting ((((background dark)) (:foreground "grey60"))))

 '(message-cited-text ((t (:inherit nil))))

 '(org-agenda-date ((t (:weight bold :height 1.1))))
 '(org-agenda-date-2 ((t (:inherit org-agenda-date))))
 '(org-agenda-date-today ((t (:weight bold :inherit highlight))))
 '(org-agenda-date-weekend ((t (:slant italic :inherit org-agenda-date))))

 '(pass-mode-directory-face ((t (:inherit dired-directory))))
 )

(provide-theme 'tweaks)
